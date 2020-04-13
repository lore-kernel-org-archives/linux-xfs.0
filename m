Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076DCC2BA19
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB4B2073E
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 12:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZ1XLNIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgDMMbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 08:31:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728392AbgDMMbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 08:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586781082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2kOo/LUXfbty25eBTr+N4DMGt84Pmk/LQpzkC0fDqI=;
        b=eZ1XLNIxOVdC9mHv+avYEtvXzsdxQ147oca/jc1EjwFxXAG9bsJQICUuj/4f9Fqoc9Xiqj
        W+DdRunzQg+/lFTEl0aOP7OQ72NJ/w0Vz25P7UQlpb8/CCpe+ZtCVomi9+zj2rZklx7+2c
        RmGT/LUFdi7jfEPUP2selTA+R+RZzE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-avtOejv2NhW-rjHWY9BOYg-1; Mon, 13 Apr 2020 08:31:20 -0400
X-MC-Unique: avtOejv2NhW-rjHWY9BOYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFBE21088380;
        Mon, 13 Apr 2020 12:31:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 520C360BE2;
        Mon, 13 Apr 2020 12:31:19 +0000 (UTC)
Date:   Mon, 13 Apr 2020 08:31:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix partially uninitialized structure in
 xfs_reflink_remap_extent
Message-ID: <20200413123117.GC57285@bfoster>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
 <158674022396.3253017.2093178484820838524.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158674022396.3253017.2093178484820838524.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 12, 2020 at 06:10:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the reflink extent remap function, it turns out that uirec (the block
> mapping corresponding only to the part of the passed-in mapping that got
> unmapped) was not fully initialized.  Specifically, br_state was not
> being copied from the passed-in struct to the uirec.  This could lead to
> unpredictable results such as the reflinked mapping being marked
> unwritten in the destination file.
> 
> Fixes: 862bb360ef569 ("xfs: reflink extents from one file to another")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index b0ce04ffd3cd..107bf2a2f344 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1051,6 +1051,7 @@ xfs_reflink_remap_extent(
>  		uirec.br_startblock = irec->br_startblock + rlen;
>  		uirec.br_startoff = irec->br_startoff + rlen;
>  		uirec.br_blockcount = unmap_len - rlen;
> +		uirec.br_state = irec->br_state;
>  		unmap_len = rlen;
>  
>  		/* If this isn't a real mapping, we're done. */
> 

