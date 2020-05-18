Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591F9C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BBF2065F
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EDnMb2kQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgERN2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 09:28:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726775AbgERN2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 09:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589808496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A4zOy/dDN7sqyl6VFFLrTMvZtXvBvlq+/aOZOgJZd+A=;
        b=EDnMb2kQFU86SR4BU/ZsEUPIepv/gr/PEEwaidG/b+vaI91BMBpIr2RU3dtZdw59oCPZTk
        ykJpqLF4GWB023/q5I8O5Zi3Otka9KJp+auhnYahO+ocUnJA/Mk3gnMJSyXMA8MysqDsoN
        gxuEk2FNuxanK+u7OlkZvHQlhqsyEdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-9UMfscbxM7SGN1DgOVDX7w-1; Mon, 18 May 2020 09:28:12 -0400
X-MC-Unique: 9UMfscbxM7SGN1DgOVDX7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656BA1B2C983;
        Mon, 18 May 2020 13:28:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D148260BF3;
        Mon, 18 May 2020 13:28:10 +0000 (UTC)
Date:   Mon, 18 May 2020 09:28:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] xfs: clean up xchk_bmap_check_rmaps usage of
 XFS_IFORK_Q
Message-ID: <20200518132808.GD10938@bfoster>
References: <20200518073358.760214-1-hch@lst.de>
 <20200518073358.760214-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518073358.760214-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 09:33:53AM +0200, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> XFS_IFORK_Q is supposed to be a predicate, not a function returning a
> value.  Its usage is in xchk_bmap_check_rmaps is incorrect, but that
> function only cares about whether or not the "size" of the data is zero
> or not.  Convert that logic to use a proper boolean, and teach the
> caller to skip the call entirely if the end result would be that we'd do
> nothing anyway.  This avoids a crash later in this series.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: generalized the NULL ifor check]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

I'm still rather confused about the i_size logic, but this seems like a
good cleanup regardless:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/bmap.c | 35 +++++++++++++----------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index add8598eacd5d..d0daf3de9fde5 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -566,8 +566,8 @@ xchk_bmap_check_rmaps(
>  	struct xfs_scrub	*sc,
>  	int			whichfork)
>  {
> -	loff_t			size;
>  	xfs_agnumber_t		agno;
> +	bool			zero_size;
>  	int			error;
>  
>  	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
> @@ -579,6 +579,8 @@ xchk_bmap_check_rmaps(
>  	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
>  		return 0;
>  
> +	ASSERT(XFS_IFORK_PTR(sc->ip, whichfork) != NULL);
> +
>  	/*
>  	 * Only do this for complex maps that are in btree format, or for
>  	 * situations where we would seem to have a size but zero extents.
> @@ -586,19 +588,13 @@ xchk_bmap_check_rmaps(
>  	 * to flag this bmap as corrupt if there are rmaps that need to be
>  	 * reattached.
>  	 */
> -	switch (whichfork) {
> -	case XFS_DATA_FORK:
> -		size = i_size_read(VFS_I(sc->ip));
> -		break;
> -	case XFS_ATTR_FORK:
> -		size = XFS_IFORK_Q(sc->ip);
> -		break;
> -	default:
> -		size = 0;
> -		break;
> -	}
> +	if (whichfork == XFS_DATA_FORK)
> +		zero_size = i_size_read(VFS_I(sc->ip)) == 0;
> +	else
> +		zero_size = false;
> +
>  	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> -	    (size == 0 || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
> +	    (zero_size || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
>  		return 0;
>  
>  	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
> @@ -627,12 +623,14 @@ xchk_bmap(
>  	struct xchk_bmap_info	info = { NULL };
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_inode	*ip = sc->ip;
> -	struct xfs_ifork	*ifp;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t		endoff;
>  	struct xfs_iext_cursor	icur;
>  	int			error = 0;
>  
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	/* Non-existent forks can be ignored. */
> +	if (!ifp)
> +		goto out;
>  
>  	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
>  	info.whichfork = whichfork;
> @@ -641,9 +639,6 @@ xchk_bmap(
>  
>  	switch (whichfork) {
>  	case XFS_COW_FORK:
> -		/* Non-existent CoW forks are ignorable. */
> -		if (!ifp)
> -			goto out;
>  		/* No CoW forks on non-reflink inodes/filesystems. */
>  		if (!xfs_is_reflink_inode(ip)) {
>  			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> @@ -651,8 +646,6 @@ xchk_bmap(
>  		}
>  		break;
>  	case XFS_ATTR_FORK:
> -		if (!ifp)
> -			goto out_check_rmap;
>  		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
>  		    !xfs_sb_version_hasattr2(&mp->m_sb))
>  			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
> @@ -700,7 +693,6 @@ xchk_bmap(
>  
>  	/* Scrub extent records. */
>  	info.lastoff = 0;
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xchk_should_terminate(sc, &error) ||
>  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> @@ -717,7 +709,6 @@ xchk_bmap(
>  			goto out;
>  	}
>  
> -out_check_rmap:
>  	error = xchk_bmap_check_rmaps(sc, whichfork);
>  	if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
>  		goto out;
> -- 
> 2.26.2
> 

