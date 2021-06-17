Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B20EC49361
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0793B61411
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhFQPQP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhFQPQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 11:16:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BCEC061574
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 08:14:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso4021632pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=3BHd6vTTLUADiPufyVv7/M1teGQ7qwZxcJa6d639znk=;
        b=SNk6Rmf37KoE7lOsIzaV2VEdrLpBoTcyCMLMz7kv0dpQcPJ14InfCHfzqOPSU30Jt/
         WthhK8DQzqpGFgDAZdw/LofS4eZPy+Mptb7mlXYIXxYlr5zGH5fO0Td1fCeKy/wKOMpL
         sbjipTnhsr3qJqXXTjvlhwEAcHXO00r1m1x4HJo3zj4N1ecewIppkDEQOT9Y+DhfzRyU
         Q4iuPuApMDBdvzG/zfN2/zadA1bbvl2kRsUW7MbhpUzOSzoqFK1qZxwVXVqScoiTMG0H
         qP7XbPheR2nmTSPbBVZxSdpFwLfR4V8snVwNkQ8vE3qDTQKE6qqIaTYVTGLrjSi6glAS
         QWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=3BHd6vTTLUADiPufyVv7/M1teGQ7qwZxcJa6d639znk=;
        b=gyRvlHohs0LeXVokhcIGP7u8sJiZnux9w1jcvJ9qSyqhTpECkHyQTX7ohCWvROTa2W
         8ThQCf0M/rqi0a6pDp14+AxGd4PYtSCdLk708/WEQnEx452ICA1kQwxqS/kumjNm6cm0
         dC5elW+LJ0zLaA0MHKBhzNLyL0Mw1FkuQ/bhJ1Eom0awOEDfE576B38QNhTkgWR/NBUo
         CcBfuI9l/z4PyQMcAD7mYiOGmRD7q3wO81haAC7bEemqk5vIpes+NOZ/zLrhtoTsxec6
         TOX6lC+LHxXNwNzR0ftfUx+uoLtaV3Kvg+7K0JzcZtiqa6BL2hDBfDFPdyTLdgNSHTeJ
         GrVw==
X-Gm-Message-State: AOAM532px5oM7ctMtYp5g+jSRc8VBa2R97V6WhUDsm62/12by9JouwzE
        eA0fgbosjSjsAyKL2Xwz2sS9RFCFbQZjiQ==
X-Google-Smtp-Source: ABdhPJw/lFOe+fua4MX4j2klp+QRsks6skC4kUVxKmS11A5jaMe29TE9e1w5gHX3dTDnLCcZ8noV5g==
X-Received: by 2002:a17:902:b210:b029:11a:bf7b:1a83 with SMTP id t16-20020a170902b210b029011abf7b1a83mr363156plr.84.1623942845548;
        Thu, 17 Jun 2021 08:14:05 -0700 (PDT)
Received: from garuda ([122.167.159.50])
        by smtp.gmail.com with ESMTPSA id z24sm5709669pfk.149.2021.06.17.08.14.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jun 2021 08:14:05 -0700 (PDT)
References: <162388772484.3427063.6225456710511333443.stgit@locust> <162388773053.3427063.16153257434224756166.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix type mismatches in the inode reclaim functions
In-reply-to: <162388773053.3427063.16153257434224756166.stgit@locust>
Date:   Thu, 17 Jun 2021 20:44:02 +0530
Message-ID: <874kdwr0at.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17 Jun 2021 at 05:25, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> It's currently unlikely that we will ever end up with more than 4
> billion inodes waiting for reclamation, but the fs object code uses long
> int for object counts and we're certainly capable of generating that
> many.  Instead of truncating the internal counters, widen them and
> report the object counts correctly.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    8 ++++----
>  fs/xfs/xfs_icache.h |    6 +++---
>  fs/xfs/xfs_trace.h  |    4 ++--
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6b44fc734cb5..18dae6d3d69a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1084,11 +1084,11 @@ xfs_reclaim_inodes(
>  long
>  xfs_reclaim_inodes_nr(
>  	struct xfs_mount	*mp,
> -	int			nr_to_scan)
> +	unsigned long		nr_to_scan)
>  {
>  	struct xfs_icwalk	icw = {
>  		.icw_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
> -		.icw_scan_limit	= nr_to_scan,
> +		.icw_scan_limit	= max_t(unsigned long, LONG_MAX, nr_to_scan),
>  	};
>  
>  	if (xfs_want_reclaim_sick(mp))
> @@ -1106,13 +1106,13 @@ xfs_reclaim_inodes_nr(
>   * Return the number of reclaimable inodes in the filesystem for
>   * the shrinker to determine how much to reclaim.
>   */
> -int
> +long
>  xfs_reclaim_inodes_count(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		ag = 0;
> -	int			reclaimable = 0;
> +	long			reclaimable = 0;
>  
>  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
>  		ag = pag->pag_agno + 1;
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 00dc98a92835..c751cc32dc46 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -15,7 +15,7 @@ struct xfs_icwalk {
>  	kgid_t		icw_gid;
>  	prid_t		icw_prid;
>  	__u64		icw_min_file_size;
> -	int		icw_scan_limit;
> +	long		icw_scan_limit;
>  };
>  
>  /* Flags that reflect xfs_fs_eofblocks functionality. */
> @@ -49,8 +49,8 @@ void xfs_inode_free(struct xfs_inode *ip);
>  void xfs_reclaim_worker(struct work_struct *work);
>  
>  void xfs_reclaim_inodes(struct xfs_mount *mp);
> -int xfs_reclaim_inodes_count(struct xfs_mount *mp);
> -long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
> +long xfs_reclaim_inodes_count(struct xfs_mount *mp);
> +long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
>  
>  void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 428dc71f7f8b..85fa864f8e2f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3894,7 +3894,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
>  		__field(uint32_t, gid)
>  		__field(prid_t, prid)
>  		__field(__u64, min_file_size)
> -		__field(int, scan_limit)
> +		__field(long, scan_limit)
>  		__field(unsigned long, caller_ip)
>  	),
>  	TP_fast_assign(
> @@ -3909,7 +3909,7 @@ DECLARE_EVENT_CLASS(xfs_icwalk_class,
>  		__entry->scan_limit = icw ? icw->icw_scan_limit : 0;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
> +	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %ld caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->flags,
>  		  __entry->uid,


-- 
chandan
