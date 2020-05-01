Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C07C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9D42051A
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ih+wre88"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgEANfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:35:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20404 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729342AbgEANfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BNBn2SG/7HF+21RIUYGqzKpfbIaOMR3hG3flG+DDMcs=;
        b=ih+wre88t7gkV5Sjwo02NUfAdGkjgvncwcAu2/TKEMkiBMo6HeS661OQS78nln+9Zrd78h
        HEebUgeQD50ozWaR1UGbvEnMuYo51C+26Rqa90uj9c5Y3dwR0Jfzz9FsqCbo14vc2GHB8K
        Oq3f1NBpkcL7la5X9fBCWMnyxf+NmLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-YET6kS47PbuwnvCBYmF0BA-1; Fri, 01 May 2020 09:35:05 -0400
X-MC-Unique: YET6kS47PbuwnvCBYmF0BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6498E19200C0;
        Fri,  1 May 2020 13:35:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E83165EE11;
        Fri,  1 May 2020 13:35:01 +0000 (UTC)
Date:   Fri, 1 May 2020 09:34:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: don't reset i_delayed_blks in xfs_iread
Message-ID: <20200501133459.GM40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:18AM +0200, Christoph Hellwig wrote:
> i_delayed_blks is set to 0 in xfs_inode_alloc and can't have anything
> assigned to it until the inode is visible to the VFS.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a00001a2336ef..0357dc4b29481 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -673,8 +673,6 @@ xfs_iread(
>  	if (error)
>  		goto out_brelse;
>  
> -	ip->i_delayed_blks = 0;
> -
>  	/*
>  	 * Mark the buffer containing the inode as something to keep
>  	 * around for a while.  This helps to keep recently accessed
> -- 
> 2.26.2
> 

