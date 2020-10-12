Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFC6C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BE12087E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icNZDqQT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390201AbgJLQDY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389555AbgJLQDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 12:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602518603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Uu2rFrVC/GtIz8TS3wI28EJbHNWzM1mEhJtEc4CvEA=;
        b=icNZDqQTFkgSyY1UQIdBV8Z/rFSa6qhPywBTBTR41ytoey8UH5Y2JTVipvbOrHWRhyijFW
        yk5g0RDpNEnDrMlSPf/AOiyGBoAktXYw/jn7aQLg1kn4WejSUwMMWaf2/aQXO06r46BOnq
        C6ykKTZLyZSj+KuRE0ITmpnFr338/yA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-cmLRdbWQMfeUHytZOm9qXw-1; Mon, 12 Oct 2020 12:03:21 -0400
X-MC-Unique: cmLRdbWQMfeUHytZOm9qXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8303864087
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 16:03:20 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31D9073663;
        Mon, 12 Oct 2020 16:03:20 +0000 (UTC)
Date:   Mon, 12 Oct 2020 12:03:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 2/4] xfs: clean up whitespace in xfs_isilocked() calls
Message-ID: <20201012160318.GI917726@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-3-preichl@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 09:55:13PM +0200, Pavel Reichl wrote:
> Make whitespace follow the same pattern in all xfs_isilocked() calls.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/xfs_file.c        | 3 ++-
>  fs/xfs/xfs_inode.c       | 4 ++--
>  fs/xfs/xfs_qm.c          | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1b0a01b06a05..ced3b996cd8a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3883,7 +3883,7 @@ xfs_bmapi_read(
>  
>  	ASSERT(*nmap >= 1);
>  	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
>  
>  	if (WARN_ON_ONCE(!ifp))
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a29f78a663ca..c8b1d4e4199a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -763,7 +763,8 @@ xfs_break_layouts(
>  	bool			retry;
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(XFS_I(inode),
> +			XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
>  
>  	do {
>  		retry = false;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7c1ceb4df4ec..a3baec1c5bcf 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2781,7 +2781,7 @@ static void
>  xfs_iunpin(
>  	struct xfs_inode	*ip)
>  {
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  
>  	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
>  
> @@ -3474,7 +3474,7 @@ xfs_iflush(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(xfs_isiflocked(ip));
>  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index be67570badf8..57bfa5266c47 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1803,7 +1803,7 @@ xfs_qm_vop_chown_reserve(
>  	int			error;
>  
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
>  	delblks = ip->i_delayed_blks;
> -- 
> 2.26.2
> 

