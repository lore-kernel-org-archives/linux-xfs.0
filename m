Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B6BC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A49061369
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhFROgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234482AbhFROgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624026842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ikOHaQatIE/5BnwkrpwG8S7ZASJZYJaCuBlbwVDgEo=;
        b=btiuyMOBgbCaiMBqGlYrAKhId+kRgcr3yzaFwhzSPibmF0ecCnq3eMnHUslpPWwF4i0bM2
        P4ueyjMY4oMynm0UKL7AsSxAwrR0ciRxrSndffu3ISSOpJDctT8UjxO5hnPj0SR5kWGVy2
        nkOpiqVj8unW8WmzPflGQFoMWg7sxhs=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-a0jx3znFPZSJNpZwT4Cflg-1; Fri, 18 Jun 2021 10:34:01 -0400
X-MC-Unique: a0jx3znFPZSJNpZwT4Cflg-1
Received: by mail-oi1-f199.google.com with SMTP id v142-20020acaac940000b02901f80189ca30so4919020oie.22
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:34:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ikOHaQatIE/5BnwkrpwG8S7ZASJZYJaCuBlbwVDgEo=;
        b=C6bED9pBySfvJEIdvp/qhx+d6sz0M3Dgtw5l8Aa3ruvp6VtkOs0KCfyBVI0Arg3PDW
         aS+ZZ1czcDYP3f0LXtZxnszRC/H+QlYzaSiWDxmr8DTyMAwa+Lqs8gLrCDIQ0/jN3Ygl
         2Qv9kE5zziRCIrULo9Zu7quIXp9st6b4DePCd61rjdiVGRPtQoFde9W4BXBCWTMGYwaL
         DOCFWBLUzoFHv4ZCY0bwOUH16jvvGKdpBS1F5qacAHM6sWxaKM2qX9eqNovf1q2ASeoP
         MR61O17NGtKZHZhoEwgJKs1VN1qYlAe5+s2IEsxAKLxepKdTwAfJz4Mnj2dfHWWnWTql
         YLuQ==
X-Gm-Message-State: AOAM533DW01FlxSHznQYUkc6HgodRJkcbxn/wPLy96LvMhhURL2J5a6c
        GwgijMF4TswElNiP3MolQzt56r8q6j3dhJDjYo8q4EQCDyDjYiEa5KyobtheiFmoVys1dRVV9V1
        M9c6Q2rwRvjX/+qsUqjA2
X-Received: by 2002:a05:6830:2415:: with SMTP id j21mr9284116ots.224.1624026840554;
        Fri, 18 Jun 2021 07:34:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgnc+gxqRQwzBuV0knA3BB3peFIQmS0WHWEy88j/Cfd34SxEt/ZB/8MhUg8HKIxpCnmPDPng==
X-Received: by 2002:a05:6830:2415:: with SMTP id j21mr9284099ots.224.1624026840334;
        Fri, 18 Jun 2021 07:34:00 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id n11sm2027510otq.63.2021.06.18.07.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:34:00 -0700 (PDT)
Date:   Fri, 18 Jun 2021 10:33:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix type mismatches in the inode reclaim
 functions
Message-ID: <YMyu1tN6kphOlN46@bfoster>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773053.3427063.16153257434224756166.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388773053.3427063.16153257434224756166.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:55:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's currently unlikely that we will ever end up with more than 4
> billion inodes waiting for reclamation, but the fs object code uses long
> int for object counts and we're certainly capable of generating that
> many.  Instead of truncating the internal counters, widen them and
> report the object counts correctly.
> 
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

Does this intend to assign LONG_MAX if nr_to_scan might be smaller?

Brian

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
> 

