Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDB2C433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 07:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEDE96113D
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Apr 2021 07:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDHHvQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhDHHvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Apr 2021 03:51:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D73C061760
        for <linux-xfs@vger.kernel.org>; Thu,  8 Apr 2021 00:51:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t7so587267plg.9
        for <linux-xfs@vger.kernel.org>; Thu, 08 Apr 2021 00:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=4WdLxJ1mrkhXU32GFCxnOSU3J9QTKB2T72rJmjzQh58=;
        b=UWt7i+5B4HpPhoGxairI5Ai0Lu8IsetsYnE+i8011XUuvpP+58s3b3IV3dgqoq1Sqn
         H1b0ktXMWf0x2JJAN7K/nRuDZkZezYFXjqXi4FsXZY8IWm6bl1MrPCR4b8ZDC8tFx88F
         puvTGyuKSMzaepPTbmxitIMx0LsTGmch+42zPxCUZzYxhjf7fGT8kXTzcCGLGY1zCPyg
         KUBYuJlO6Wm+58Z1grrkJv7orDA3rrpCua1wDMSEgy/mQ+l+qNAB2qmdHDBOqqRC/UN+
         RjStocM24rtsCgb/VSUwc0wu8q+ROZSQn3PVl/vGdubXZskN1y5S/s/UTRvNJVrP+Uyz
         fiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4WdLxJ1mrkhXU32GFCxnOSU3J9QTKB2T72rJmjzQh58=;
        b=h8vhiNST2j4D+f/LDNllpdeG2fwjVI5FuU6dQgzLLOwF4lXMZVO3oF9LYUm+393zt0
         8GFZnknoE+Juy9WRKi2E6jg/f0meXgc1YTqUFYFQpDT/4OWdrWCNMECyDF1QOHtKQxsV
         sUUgRw1zUJTq0Pct3rajdTTUNli8Mj3SBeKndgElRPKmHxPuIeFX3n6YUCLn6HEccbRU
         fn8+dIoOoWZC3GIpsdJyxup5bYL4QQQITq4rRhvpZ5m/xLSuuAtwDaAXBE1JxnisFbnd
         VV2pufpdvIMdZLmBygxhFIzgE6Myix9Bz+ST0fp4/2quwojMWMDBfhlaTRdw1/8pMPZT
         IlTQ==
X-Gm-Message-State: AOAM530mNaD22/GgktEheW1hI6fsQbWq3Zp3zaPFfV6gUCH5Hk9xfLUT
        T8EMMn2YMZMIQxBRxhdKNXMVYh40OOk=
X-Google-Smtp-Source: ABdhPJzYKuvSVXmVDSY3aEXRWxHfzxoeZFCreHb4X3LXhTqg586oQPKb+J7kYiF3oZULoC2ShP6M2Q==
X-Received: by 2002:a17:90a:b292:: with SMTP id c18mr1023698pjr.179.1617868263511;
        Thu, 08 Apr 2021 00:51:03 -0700 (PDT)
Received: from garuda ([122.179.88.135])
        by smtp.gmail.com with ESMTPSA id r1sm7519073pjo.26.2021.04.08.00.51.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Apr 2021 00:51:03 -0700 (PDT)
References: <20210408010114.GT3957620@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: get rid of the ip parameter to xchk_setup_*
In-reply-to: <20210408010114.GT3957620@magnolia>
Date:   Thu, 08 Apr 2021 13:20:59 +0530
Message-ID: <875z0xgqos.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Apr 2021 at 06:31, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Now that the scrub context stores a pointer to the file that was used to
> invoke the scrub call, the struct xfs_inode pointer that we passed to
> all the setup functions is no longer necessary.  This is only ever used
> if the caller wants us to scrub the metadata of the open file.
>

The changes made are straightforward.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/alloc.c      |    5 ++--
>  fs/xfs/scrub/attr.c       |    5 ++--
>  fs/xfs/scrub/bmap.c       |    5 ++--
>  fs/xfs/scrub/common.c     |   13 ++++-------
>  fs/xfs/scrub/common.h     |   53 +++++++++++++++++----------------------------
>  fs/xfs/scrub/dir.c        |    5 ++--
>  fs/xfs/scrub/fscounters.c |    3 +--
>  fs/xfs/scrub/ialloc.c     |    5 ++--
>  fs/xfs/scrub/inode.c      |    5 ++--
>  fs/xfs/scrub/parent.c     |    5 ++--
>  fs/xfs/scrub/quota.c      |    5 ++--
>  fs/xfs/scrub/refcount.c   |    5 ++--
>  fs/xfs/scrub/repair.c     |    5 ++--
>  fs/xfs/scrub/repair.h     |    6 +++--
>  fs/xfs/scrub/rmap.c       |    5 ++--
>  fs/xfs/scrub/rtbitmap.c   |    5 ++--
>  fs/xfs/scrub/scrub.c      |   11 ++++-----
>  fs/xfs/scrub/scrub.h      |    3 +--
>  fs/xfs/scrub/symlink.c    |    5 ++--
>  19 files changed, 61 insertions(+), 93 deletions(-)
>
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 73d924e47565..2720bd7fe53b 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -21,10 +21,9 @@
>   */
>  int
>  xchk_setup_ag_allocbt(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_ag_btree(sc, ip, false);
> +	return xchk_setup_ag_btree(sc, false);
>  }
>  
>  /* Free space btree scrubber. */
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 9faddb334a2c..552af0cf8482 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -69,8 +69,7 @@ xchk_setup_xattr_buf(
>  /* Set us up to scrub an inode's extended attributes. */
>  int
>  xchk_setup_xattr(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	int			error;
>  
> @@ -85,7 +84,7 @@ xchk_setup_xattr(
>  			return error;
>  	}
>  
> -	return xchk_setup_inode_contents(sc, ip, 0);
> +	return xchk_setup_inode_contents(sc, 0);
>  }
>  
>  /* Extended Attributes */
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 33559c3a4bc3..613e2aa7e4e7 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -26,12 +26,11 @@
>  /* Set us up with an inode's bmap. */
>  int
>  xchk_setup_inode_bmap(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	int			error;
>  
> -	error = xchk_get_inode(sc, ip);
> +	error = xchk_get_inode(sc);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index d8da0ea772bc..6457a6d7e867 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -593,8 +593,7 @@ xchk_trans_alloc(
>  /* Set us up with a transaction and an empty context. */
>  int
>  xchk_setup_fs(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	uint			resblks;
>  
> @@ -606,7 +605,6 @@ xchk_setup_fs(
>  int
>  xchk_setup_ag_btree(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip,
>  	bool			force_log)
>  {
>  	struct xfs_mount	*mp = sc->mp;
> @@ -624,7 +622,7 @@ xchk_setup_ag_btree(
>  			return error;
>  	}
>  
> -	error = xchk_setup_fs(sc, ip);
> +	error = xchk_setup_fs(sc);
>  	if (error)
>  		return error;
>  
> @@ -652,11 +650,11 @@ xchk_checkpoint_log(
>   */
>  int
>  xchk_get_inode(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip_in)
> +	struct xfs_scrub	*sc)
>  {
>  	struct xfs_imap		imap;
>  	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_inode	*ip_in = XFS_I(file_inode(sc->filp));
>  	struct xfs_inode	*ip = NULL;
>  	int			error;
>  
> @@ -717,12 +715,11 @@ xchk_get_inode(
>  int
>  xchk_setup_inode_contents(
>  	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip,
>  	unsigned int		resblks)
>  {
>  	int			error;
>  
> -	error = xchk_get_inode(sc, ip);
> +	error = xchk_get_inode(sc);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 5e2c6f693503..0410faf7d735 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -72,48 +72,37 @@ bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
>  			   struct xfs_btree_cur **curpp);
>  
>  /* Setup functions */
> -int xchk_setup_fs(struct xfs_scrub *sc, struct xfs_inode *ip);
> -int xchk_setup_ag_allocbt(struct xfs_scrub *sc,
> -			       struct xfs_inode *ip);
> -int xchk_setup_ag_iallocbt(struct xfs_scrub *sc,
> -				struct xfs_inode *ip);
> -int xchk_setup_ag_rmapbt(struct xfs_scrub *sc,
> -			      struct xfs_inode *ip);
> -int xchk_setup_ag_refcountbt(struct xfs_scrub *sc,
> -				  struct xfs_inode *ip);
> -int xchk_setup_inode(struct xfs_scrub *sc,
> -			  struct xfs_inode *ip);
> -int xchk_setup_inode_bmap(struct xfs_scrub *sc,
> -			       struct xfs_inode *ip);
> -int xchk_setup_inode_bmap_data(struct xfs_scrub *sc,
> -				    struct xfs_inode *ip);
> -int xchk_setup_directory(struct xfs_scrub *sc,
> -			      struct xfs_inode *ip);
> -int xchk_setup_xattr(struct xfs_scrub *sc,
> -			  struct xfs_inode *ip);
> -int xchk_setup_symlink(struct xfs_scrub *sc,
> -			    struct xfs_inode *ip);
> -int xchk_setup_parent(struct xfs_scrub *sc,
> -			   struct xfs_inode *ip);
> +int xchk_setup_fs(struct xfs_scrub *sc);
> +int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
> +int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
> +int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
> +int xchk_setup_ag_refcountbt(struct xfs_scrub *sc);
> +int xchk_setup_inode(struct xfs_scrub *sc);
> +int xchk_setup_inode_bmap(struct xfs_scrub *sc);
> +int xchk_setup_inode_bmap_data(struct xfs_scrub *sc);
> +int xchk_setup_directory(struct xfs_scrub *sc);
> +int xchk_setup_xattr(struct xfs_scrub *sc);
> +int xchk_setup_symlink(struct xfs_scrub *sc);
> +int xchk_setup_parent(struct xfs_scrub *sc);
>  #ifdef CONFIG_XFS_RT
> -int xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip);
> +int xchk_setup_rt(struct xfs_scrub *sc);
>  #else
>  static inline int
> -xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip)
> +xchk_setup_rt(struct xfs_scrub *sc)
>  {
>  	return -ENOENT;
>  }
>  #endif
>  #ifdef CONFIG_XFS_QUOTA
> -int xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip);
> +int xchk_setup_quota(struct xfs_scrub *sc);
>  #else
>  static inline int
> -xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
> +xchk_setup_quota(struct xfs_scrub *sc)
>  {
>  	return -ENOENT;
>  }
>  #endif
> -int xchk_setup_fscounters(struct xfs_scrub *sc, struct xfs_inode *ip);
> +int xchk_setup_fscounters(struct xfs_scrub *sc);
>  
>  void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
>  int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
> @@ -126,11 +115,9 @@ void xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
>  int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
>  		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
>  
> -int xchk_setup_ag_btree(struct xfs_scrub *sc, struct xfs_inode *ip,
> -		bool force_log);
> -int xchk_get_inode(struct xfs_scrub *sc, struct xfs_inode *ip_in);
> -int xchk_setup_inode_contents(struct xfs_scrub *sc, struct xfs_inode *ip,
> -		unsigned int resblks);
> +int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
> +int xchk_get_inode(struct xfs_scrub *sc);
> +int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
>  void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
>  
>  /*
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e7cc04b7454b..28dda391d5df 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -22,10 +22,9 @@
>  /* Set us up to scrub directories. */
>  int
>  xchk_setup_directory(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_inode_contents(sc, ip, 0);
> +	return xchk_setup_inode_contents(sc, 0);
>  }
>  
>  /* Directories */
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index ec2064ed3c30..7b4386c78fbf 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -116,8 +116,7 @@ xchk_fscount_warmup(
>  
>  int
>  xchk_setup_fscounters(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	struct xchk_fscounters	*fsc;
>  	int			error;
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 1644199c29a8..8d9f3fb0cd22 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -29,10 +29,9 @@
>   */
>  int
>  xchk_setup_ag_iallocbt(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_ag_btree(sc, ip, sc->flags & XCHK_TRY_HARDER);
> +	return xchk_setup_ag_btree(sc, sc->flags & XCHK_TRY_HARDER);
>  }
>  
>  /* Inode btree scrubber. */
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index faf65eb5bd31..61f90b2c9430 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -28,8 +28,7 @@
>   */
>  int
>  xchk_setup_inode(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	int			error;
>  
> @@ -37,7 +36,7 @@ xchk_setup_inode(
>  	 * Try to get the inode.  If the verifiers fail, we try again
>  	 * in raw mode.
>  	 */
> -	error = xchk_get_inode(sc, ip);
> +	error = xchk_get_inode(sc);
>  	switch (error) {
>  	case 0:
>  		break;
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 076c812ed18d..ab182a5cd0c0 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -20,10 +20,9 @@
>  /* Set us up to scrub parents. */
>  int
>  xchk_setup_parent(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_inode_contents(sc, ip, 0);
> +	return xchk_setup_inode_contents(sc, 0);
>  }
>  
>  /* Parent pointers */
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 343f96f48b82..acbb9839d42f 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -37,8 +37,7 @@ xchk_quota_to_dqtype(
>  /* Set us up to scrub a quota. */
>  int
>  xchk_setup_quota(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	xfs_dqtype_t		dqtype;
>  	int			error;
> @@ -53,7 +52,7 @@ xchk_setup_quota(
>  	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
>  	if (!xfs_this_quota_on(sc->mp, dqtype))
>  		return -ENOENT;
> -	error = xchk_setup_fs(sc, ip);
> +	error = xchk_setup_fs(sc);
>  	if (error)
>  		return error;
>  	sc->ip = xfs_quota_inode(sc->mp, dqtype);
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index dd672e6bbc75..744530a66c0c 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -19,10 +19,9 @@
>   */
>  int
>  xchk_setup_ag_refcountbt(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_ag_btree(sc, ip, false);
> +	return xchk_setup_ag_btree(sc, false);
>  }
>  
>  /* Reference count btree scrubber. */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 61bc43418a2a..952c8eae16cb 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -37,19 +37,18 @@
>   */
>  int
>  xrep_attempt(
> -	struct xfs_inode	*ip,
>  	struct xfs_scrub	*sc)
>  {
>  	int			error = 0;
>  
> -	trace_xrep_attempt(ip, sc->sm, error);
> +	trace_xrep_attempt(XFS_I(file_inode(sc->filp)), sc->sm, error);
>  
>  	xchk_ag_btcur_free(&sc->sa);
>  
>  	/* Repair whatever's broken. */
>  	ASSERT(sc->ops->repair);
>  	error = sc->ops->repair(sc);
> -	trace_xrep_done(ip, sc->sm, error);
> +	trace_xrep_done(XFS_I(file_inode(sc->filp)), sc->sm, error);
>  	switch (error) {
>  	case 0:
>  		/*
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index fe77de01abe0..3bb152d52a07 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -17,7 +17,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
>  
>  /* Repair helpers */
>  
> -int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc);
> +int xrep_attempt(struct xfs_scrub *sc);
>  void xrep_failure(struct xfs_mount *mp);
>  int xrep_roll_ag_trans(struct xfs_scrub *sc);
>  bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
> @@ -64,8 +64,8 @@ int xrep_agi(struct xfs_scrub *sc);
>  
>  #else
>  
> -static inline int xrep_attempt(
> -	struct xfs_inode	*ip,
> +static inline int
> +xrep_attempt(
>  	struct xfs_scrub	*sc)
>  {
>  	return -EOPNOTSUPP;
> diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
> index f4fcb4719f41..a4f17477c5d1 100644
> --- a/fs/xfs/scrub/rmap.c
> +++ b/fs/xfs/scrub/rmap.c
> @@ -21,10 +21,9 @@
>   */
>  int
>  xchk_setup_ag_rmapbt(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
> -	return xchk_setup_ag_btree(sc, ip, false);
> +	return xchk_setup_ag_btree(sc, false);
>  }
>  
>  /* Reverse-mapping scrubber. */
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 1fb12928d8ef..37c0e2266c85 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -20,12 +20,11 @@
>  /* Set us up with the realtime metadata locked. */
>  int
>  xchk_setup_rt(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	int			error;
>  
> -	error = xchk_setup_fs(sc, ip);
> +	error = xchk_setup_fs(sc);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9f8be81baf16..3c893a2c9ac8 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -468,8 +468,7 @@ xfs_scrub_metadata(
>  			.agno		= NULLAGNUMBER,
>  		},
>  	};
> -	struct xfs_inode		*ip = XFS_I(file_inode(filp));
> -	struct xfs_mount		*mp = ip->i_mount;
> +	struct xfs_mount		*mp = XFS_I(file_inode(filp))->i_mount;
>  	int				error = 0;
>  
>  	sc.mp = mp;
> @@ -477,7 +476,7 @@ xfs_scrub_metadata(
>  	BUILD_BUG_ON(sizeof(meta_scrub_ops) !=
>  		(sizeof(struct xchk_meta_ops) * XFS_SCRUB_TYPE_NR));
>  
> -	trace_xchk_start(ip, sm, error);
> +	trace_xchk_start(XFS_I(file_inode(filp)), sm, error);
>  
>  	/* Forbidden if we are shut down or mounted norecovery. */
>  	error = -ESHUTDOWN;
> @@ -507,7 +506,7 @@ xfs_scrub_metadata(
>  	}
>  
>  	/* Set up for the operation. */
> -	error = sc.ops->setup(&sc, ip);
> +	error = sc.ops->setup(&sc);
>  	if (error)
>  		goto out_teardown;
>  
> @@ -553,7 +552,7 @@ xfs_scrub_metadata(
>  		 * If it's broken, userspace wants us to fix it, and we haven't
>  		 * already tried to fix it, then attempt a repair.
>  		 */
> -		error = xrep_attempt(ip, &sc);
> +		error = xrep_attempt(&sc);
>  		if (error == -EAGAIN) {
>  			/*
>  			 * Either the repair function succeeded or it couldn't
> @@ -574,7 +573,7 @@ xfs_scrub_metadata(
>  out_teardown:
>  	error = xchk_teardown(&sc, error);
>  out:
> -	trace_xchk_done(ip, sm, error);
> +	trace_xchk_done(XFS_I(file_inode(filp)), sm, error);
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
>  		sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
>  		error = 0;
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 2a90642bac1a..389eb5217459 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -18,8 +18,7 @@ enum xchk_type {
>  
>  struct xchk_meta_ops {
>  	/* Acquire whatever resources are needed for the operation. */
> -	int		(*setup)(struct xfs_scrub *,
> -				 struct xfs_inode *);
> +	int		(*setup)(struct xfs_scrub *sc);
>  
>  	/* Examine metadata for errors. */
>  	int		(*scrub)(struct xfs_scrub *);
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 8c1c3875b31d..ad7b85e248c7 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -18,15 +18,14 @@
>  /* Set us up to scrub a symbolic link. */
>  int
>  xchk_setup_symlink(
> -	struct xfs_scrub	*sc,
> -	struct xfs_inode	*ip)
> +	struct xfs_scrub	*sc)
>  {
>  	/* Allocate the buffer without the inode lock held. */
>  	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
> -	return xchk_setup_inode_contents(sc, ip, 0);
> +	return xchk_setup_inode_contents(sc, 0);
>  }
>  
>  /* Symbolic links. */


-- 
chandan
