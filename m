Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4531C8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F06E2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvKGO14s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgD3LDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:03:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726520AbgD3LDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=em/5cRCbLVU51I+pNSAoK7wJmoI8ZZeNZV5y6wsWRvA=;
        b=BvKGO14sfVsw3GHZSC1XxU5yeEGG/SL5JHwGmlm0DC/fGuhcBDGni8bPjltgAN+CBNJh6Z
        yKB3iPVMuds8OsjywD2LfQ//+yr4KS/LLErDSpLD5BatMrH1OLT4Exh8GgbOpKQ3xIlfZe
        tJSJkYqjFFKoovlneN7Et/7y5rWb0ck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-zY52AGKjM1m7IsCZnUOylw-1; Thu, 30 Apr 2020 07:03:11 -0400
X-MC-Unique: zY52AGKjM1m7IsCZnUOylw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF166805738;
        Thu, 30 Apr 2020 11:03:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7760F5D780;
        Thu, 30 Apr 2020 11:03:10 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:03:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: remove the xfs_inode_log_item_t typedef
Message-ID: <20200430110308.GC5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:03PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_fork.c  | 2 +-
>  fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
>  fs/xfs/xfs_inode.c              | 4 ++--
>  fs/xfs/xfs_inode_item.c         | 2 +-
>  fs/xfs/xfs_inode_item.h         | 4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 518c6f0ec3a61..3e9a42f1e23b9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -592,7 +592,7 @@ void
>  xfs_iflush_fork(
>  	xfs_inode_t		*ip,
>  	xfs_dinode_t		*dip,
> -	xfs_inode_log_item_t	*iip,
> +	struct xfs_inode_log_item *iip,
>  	int			whichfork)
>  {
>  	char			*cp;
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 2b8ccb5b975df..b5dfb66548422 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -27,7 +27,7 @@ xfs_trans_ijoin(
>  	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
> -	xfs_inode_log_item_t	*iip;
> +	struct xfs_inode_log_item *iip;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	if (ip->i_itemp == NULL)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1772786af29d..0e2ef3f56be41 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2602,7 +2602,7 @@ xfs_ifree_cluster(
>  	xfs_daddr_t		blkno;
>  	xfs_buf_t		*bp;
>  	xfs_inode_t		*ip;
> -	xfs_inode_log_item_t	*iip;
> +	struct xfs_inode_log_item *iip;
>  	struct xfs_log_item	*lip;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> @@ -2662,7 +2662,7 @@ xfs_ifree_cluster(
>  		 */
>  		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
>  			if (lip->li_type == XFS_LI_INODE) {
> -				iip = (xfs_inode_log_item_t *)lip;
> +				iip = (struct xfs_inode_log_item *)lip;
>  				ASSERT(iip->ili_logged == 1);
>  				lip->li_cb = xfs_istale_done;
>  				xfs_trans_ail_copy_lsn(mp->m_ail,
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f779cca2346f3..75b74bbe38e43 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -780,7 +780,7 @@ xfs_iflush_abort(
>  	xfs_inode_t		*ip,
>  	bool			stale)
>  {
> -	xfs_inode_log_item_t	*iip = ip->i_itemp;
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  
>  	if (iip) {
>  		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 07a60e74c39c8..ad667fd4ae622 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -13,7 +13,7 @@ struct xfs_bmbt_rec;
>  struct xfs_inode;
>  struct xfs_mount;
>  
> -typedef struct xfs_inode_log_item {
> +struct xfs_inode_log_item {
>  	struct xfs_log_item	ili_item;	   /* common portion */
>  	struct xfs_inode	*ili_inode;	   /* inode ptr */
>  	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> @@ -23,7 +23,7 @@ typedef struct xfs_inode_log_item {
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
>  	unsigned int		ili_fsync_fields;  /* logged since last fsync */
> -} xfs_inode_log_item_t;
> +};
>  
>  static inline int xfs_inode_clean(xfs_inode_t *ip)
>  {
> -- 
> 2.26.2
> 

