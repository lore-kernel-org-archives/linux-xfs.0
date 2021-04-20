Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F128C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F8B6613CD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhDTQml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhDTQml (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 12:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD58F613AB;
        Tue, 20 Apr 2021 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618936929;
        bh=brH95ZvpRx7I0kHATlChsExIh1PGuSF+UN4APo+3BPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouDUYO+3grLXGlF3qIGhregtpulPh7RdrWO4yB/i/s1Bbnv8hz9XOpS484h259TZx
         +4k8mDqLIQ0LbAshZA/pAQbOhof3RA5Ys+Vlkj11BQEIsVaSgWfkKGmQs6pmyA9WRt
         D8NyQNPIH/7KI1PPuacH8RCmUjPVmNynR7FSuZfCSwuxJUYwcUJ2nuJITLxqRojRjd
         cohYUr4aN9t7ZPGYXNE07/H3ZkxaYwRriX/yW1sq7R07uuRGnQ8mnq1Xb6I+wUVzQY
         ZheOijXmVZlYCLZ25Bo13qL0R2uw0lQEwy6H1gFCFbvejf62ChKGRFIh/DRQ2my1pG
         whHzrY1JwkG0Q==
Date:   Tue, 20 Apr 2021 09:42:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: rename xfs_ictimestamp_t
Message-ID: <20210420164209.GG3122264@magnolia>
References: <20210420162603.4057289-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420162603.4057289-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 06:26:03PM +0200, Christoph Hellwig wrote:
> Rename xfs_ictimestamp_t to xfs_log_timestamp_t as it is a type used
> for logging timestamps with no relationship to the in-core inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_log_format.h  | 10 +++++-----
>  fs/xfs/xfs_inode_item.c         |  4 ++--
>  fs/xfs/xfs_inode_item_recover.c |  2 +-
>  fs/xfs/xfs_ondisk.h             |  2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8bd00da6d2a40f..5900772d678a90 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -368,7 +368,7 @@ static inline int xfs_ilog_fdata(int w)
>   * directly mirrors the xfs_dinode structure as it must contain all the same
>   * information.
>   */
> -typedef uint64_t xfs_ictimestamp_t;
> +typedef uint64_t xfs_log_timestamp_t;
>  
>  /* Legacy timestamp encoding format. */
>  struct xfs_legacy_ictimestamp {

Shouldn't you ^^^^^^^^^^^^^^^^^^ convert this one too?

--D

> @@ -393,9 +393,9 @@ struct xfs_log_dinode {
>  	uint16_t	di_projid_hi;	/* higher part of owner's project id */
>  	uint8_t		di_pad[6];	/* unused, zeroed space */
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	xfs_ictimestamp_t di_atime;	/* time last accessed */
> -	xfs_ictimestamp_t di_mtime;	/* time last modified */
> -	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
> +	xfs_log_timestamp_t di_atime;	/* time last accessed */
> +	xfs_log_timestamp_t di_mtime;	/* time last modified */
> +	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> @@ -420,7 +420,7 @@ struct xfs_log_dinode {
>  	uint8_t		di_pad2[12];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
> -	xfs_ictimestamp_t di_crtime;	/* time created */
> +	xfs_log_timestamp_t di_crtime;	/* time created */
>  	xfs_ino_t	di_ino;		/* inode number */
>  	uuid_t		di_uuid;	/* UUID of the filesystem */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index c1b32680f71c73..6cc4ca15209ce5 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -299,13 +299,13 @@ xfs_inode_item_format_attr_fork(
>   * Convert an incore timestamp to a log timestamp.  Note that the log format
>   * specifies host endian format!
>   */
> -static inline xfs_ictimestamp_t
> +static inline xfs_log_timestamp_t
>  xfs_inode_to_log_dinode_ts(
>  	struct xfs_inode		*ip,
>  	const struct timespec64		tv)
>  {
>  	struct xfs_legacy_ictimestamp	*lits;
> -	xfs_ictimestamp_t		its;
> +	xfs_log_timestamp_t		its;
>  
>  	if (xfs_inode_has_bigtime(ip))
>  		return xfs_inode_encode_bigtime(tv);
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index cb44f7653f03bb..9b877de2ce5e3d 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -125,7 +125,7 @@ static inline bool xfs_log_dinode_has_bigtime(const struct xfs_log_dinode *ld)
>  static inline xfs_timestamp_t
>  xfs_log_dinode_to_disk_ts(
>  	struct xfs_log_dinode		*from,
> -	const xfs_ictimestamp_t		its)
> +	const xfs_log_timestamp_t	its)
>  {
>  	struct xfs_legacy_timestamp	*lts;
>  	struct xfs_legacy_ictimestamp	*lits;
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 0aa87c2101049c..66b541b7bb643d 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -126,7 +126,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
> -	XFS_CHECK_STRUCT_SIZE(xfs_ictimestamp_t,		8);
> +	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_ictimestamp,	8);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
> -- 
> 2.30.1
> 
