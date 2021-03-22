Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D74BC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 15:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FD361990
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 15:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCVPHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230053AbhCVPHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 11:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616425634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=de/B4XFYg7WwSX0WDAKh2z9DeqJ2t8Rm8d3MMeJej4Y=;
        b=CMoS9tTnsN8qOLqWgUTt10T/ZnE+L01GMAhNsCUieCpet26Wzk+/PYbQaSwWdmxk6Ipm3p
        +pxVJs6dX/9yA26Xvy6RrJmA6pEss+dZ1kbqxMN+SZLq+WvJTFcsB2k76HNDQguuYcTuWo
        UnUqQw2EsFGgMKXaTv18eZG1dXLpvTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-DWmtNEa6NhaAunf6VjBmJA-1; Mon, 22 Mar 2021 11:07:12 -0400
X-MC-Unique: DWmtNEa6NhaAunf6VjBmJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3D5D8143FE;
        Mon, 22 Mar 2021 15:07:11 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 461691A353;
        Mon, 22 Mar 2021 15:07:11 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:07:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <YFiyneMtdTccoe+N@bfoster>
References: <20210320164007.GX22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320164007.GX22100@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 20, 2021 at 09:40:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running some fuzz tests on inode metadata, I noticed that the
> filesystem health report (as provided by xfs_spaceman) failed to report
> the file corruption even when spaceman was run immediately after running
> xfs_scrub to detect the corruption.  That isn't the intended behavior;
> one ought to be able to run scrub to detect errors in the ondisk
> metadata and be able to access to those reports for some time after the
> scrub.
> 
> After running the same sequence through an instrumented kernel, I
> discovered the reason why -- scrub igets the file, scans it, marks it
> sick, and ireleases the inode.  When the VFS lets go of the incore
> inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> inode before it moves to RECLAIM state, iget reinitializes the VFS
> state, clears the sick and checked masks, and hands back the inode.  At
> this point, the caller has the exact same incore inode, but with all the
> health state erased.
> 

So this requires some degree of cache pressure to reproduce, right?
I.e., the inode likely does not immediately go to reclaimable state on
release, but rather the vfs eventually decides to evict and we
inactivate from there. If we grab the inode after that point, it
effectively behaves as if the inode structure was freed and we re-read
from disk because we cleared health state earlier than necessary.

If I'm following that correctly, do you observe a noticeable impact in
terms of health state lifetime? The change seems reasonable, I'm just
wondering how much longer we'd expect to have this information available
after vfs eviction occurs and if/how that impacts userspace scrub
behavior.

Brian

> In other words, we're erasing the incore inode's health state flags when
> we've decided NOT to sever the link between the incore inode and the
> ondisk inode.  This is wrong, so we need to remove the lines that zero
> the fields from xfs_iget_cache_hit.
> 
> As a precaution, we add the same lines into xfs_reclaim_inode just after
> we sever the link between incore and ondisk inode.  Strictly speaking
> this isn't necessary because once an inode has gone through reclaim it
> must go through xfs_inode_alloc (which also zeroes the state) and
> xfs_iget is careful to check for mismatches between the inode it pulls
> out of the radix tree and the one it wants.
> 
> Fixes: 6772c1f11206 ("xfs: track metadata health status")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 595bda69b18d..5325fa28d099 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -587,8 +587,6 @@ xfs_iget_cache_hit(
>  		ip->i_flags |= XFS_INEW;
>  		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
>  		inode->i_state = I_NEW;
> -		ip->i_sick = 0;
> -		ip->i_checked = 0;
>  
>  		spin_unlock(&ip->i_flags_lock);
>  		spin_unlock(&pag->pag_ici_lock);
> @@ -1205,6 +1203,8 @@ xfs_reclaim_inode(
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags = XFS_IRECLAIM;
>  	ip->i_ino = 0;
> +	ip->i_sick = 0;
> +	ip->i_checked = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 

