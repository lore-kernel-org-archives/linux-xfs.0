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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C9DC4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09ACD60EE5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhHMLFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 07:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHMLFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 07:05:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76EEC061756
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:05:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so14692566pjv.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=15Ai7nZWlrwn29Aitp8BZGxTwqw1gwqijvLqzZsQjuk=;
        b=Rs8XalG3FiMYMFNu+WgWKvacOje3bBkIyq+TEpgm3BElMmwvBP2fhBJz0dZvlH2X6D
         lWiK2ak9qrL93P7OPQA56SRPKvk5YoMIe9EYC6d+2ji/sHEZ7Mh0wKbDFAwKr1h/JPLm
         9NKCzpoGMCDGmXSbm2+SPVp05Fu642GHlo2Mx+xcr2fvOcKRu8cS0FA9zJzXGhiWqqFs
         WVRxRJl0+jtiScU1QxpfyoVc8IH9v8QrWBqPAFY34eh5iDVyQAWJmzI+J7cI8MuCFY57
         p4vYHXrKYa4QVHAMP+cYJPZhW1ssy9GPTeEaY/YBxk+piR0QtVp9eTQ3ttN7z+gbzKVF
         cfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=15Ai7nZWlrwn29Aitp8BZGxTwqw1gwqijvLqzZsQjuk=;
        b=m29u2WtesIX9EoZtLMm/5WS9xP5a2fU99odxVNpUNIVcvSBnl6WB39qsxh0oHGyj93
         RXkGq7q4YEJ/R+n1ZSxralTprXgvkv0JVsE+a3pAk6AetkYISb3uVwMIgpasyVQRyWid
         r/QQIxoeq5OhynZX92kYkASCrSTe5LoxULhLwB14pGRg84oLxcwgjInZMNEtYW1BKqv0
         ch+Eu84eWQmNWkCRLNHhkWRudCCSCG9maSFSkNmh0Fj3XrfYmZKzJbJO5loN8U2N4YCP
         Ch62WfozPDQpXQtkfyVRVPYe+rUzH7cVoZue2/JFgl2xXz1UesZqe+to1uZrciBShBXI
         G0Ww==
X-Gm-Message-State: AOAM532QEm4a8Jf8C69cb6cyEpwteEwTu5bYl03iI9x0LvAz531a1cOt
        EnQ6+qGL+lgnI2I8VKmPUPesKymjFeXN9g==
X-Google-Smtp-Source: ABdhPJyLTCAbClFIJn1uXlVKZBD00R7ailFs9zjh33PTE66YK6ZbXpepNJny44NwvGNnUd/phtHidw==
X-Received: by 2002:a62:1c84:0:b029:39a:87b9:91e with SMTP id c126-20020a621c840000b029039a87b9091emr1901744pfc.7.1628852703131;
        Fri, 13 Aug 2021 04:05:03 -0700 (PDT)
Received: from garuda ([122.167.186.107])
        by smtp.gmail.com with ESMTPSA id i6sm1924933pfa.44.2021.08.13.04.05.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Aug 2021 04:05:02 -0700 (PDT)
References: <162872991654.1220643.136984377220187940.stgit@magnolia> <162872993322.1220643.17973810836146274147.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make fsmap backend function key parameters const
Date:   Fri, 13 Aug 2021 16:33:07 +0530
Message-ID: <87eeaxli7d.fsf@garuda>
In-reply-to: <162872993322.1220643.17973810836146274147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Aug 2021 at 17:58, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> There are several GETFSMAP backend functions for XFS to cover the three
> devices and various feature support.  Each of these functions are passed
> pointers to the low and high keys for the dataset that userspace
> requested, and a pointer to scratchpad variables that are used to
> control the iteration and fill out records.  The scratchpad data can be
> changed arbitrarily, but the keys are supposed to remain unchanged (and
> under the control of the outermost loop in xfs_getfsmap).
>
> Unfortunately, the data and rt backends modify the keys that are passed
> in from the main control loop, which causes subsequent calls to return
> incorrect query results.  Specifically, each of those two functions set
> the block number in the high key to the size of their respective device.
> Since fsmap results are sorted in device number order, if the lower
> numbered device is smaller than the higher numbered device, the first
> function will set the high key to the small size, and the key remains
> unchanged as it is passed into the function for the higher numbered
> device.  The second function will then fail to return all of the results
> for the dataset that userspace is asking for because the keyspace is
> incorrectly constrained.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsmap.c |   30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index a0e8ab58124b..7bcc2ab68b8d 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -61,7 +61,7 @@ xfs_fsmap_to_internal(
>  static int
>  xfs_fsmap_owner_to_rmap(
>  	struct xfs_rmap_irec	*dest,
> -	struct xfs_fsmap	*src)
> +	const struct xfs_fsmap	*src)
>  {
>  	if (!(src->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
>  		dest->rm_owner = src->fmr_owner;
> @@ -171,7 +171,7 @@ struct xfs_getfsmap_info {
>  struct xfs_getfsmap_dev {
>  	u32			dev;
>  	int			(*fn)(struct xfs_trans *tp,
> -				      struct xfs_fsmap *keys,
> +				      const struct xfs_fsmap *keys,
>  				      struct xfs_getfsmap_info *info);
>  };
>  
> @@ -389,7 +389,7 @@ xfs_getfsmap_datadev_bnobt_helper(
>  static void
>  xfs_getfsmap_set_irec_flags(
>  	struct xfs_rmap_irec	*irec,
> -	struct xfs_fsmap	*fmr)
> +	const struct xfs_fsmap	*fmr)
>  {
>  	irec->rm_flags = 0;
>  	if (fmr->fmr_flags & FMR_OF_ATTR_FORK)
> @@ -404,7 +404,7 @@ xfs_getfsmap_set_irec_flags(
>  STATIC int
>  xfs_getfsmap_logdev(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	struct xfs_getfsmap_info	*info)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> @@ -473,7 +473,7 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
>  STATIC int
>  __xfs_getfsmap_rtdev(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	int				(*query_fn)(struct xfs_trans *,
>  						    struct xfs_getfsmap_info *),
>  	struct xfs_getfsmap_info	*info)
> @@ -481,16 +481,14 @@ __xfs_getfsmap_rtdev(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	xfs_fsblock_t			start_fsb;
>  	xfs_fsblock_t			end_fsb;
> -	xfs_daddr_t			eofs;
> +	uint64_t			eofs;
>  	int				error = 0;
>  
>  	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
>  	if (keys[0].fmr_physical >= eofs)
>  		return 0;
> -	if (keys[1].fmr_physical >= eofs)
> -		keys[1].fmr_physical = eofs - 1;
>  	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
> -	end_fsb = XFS_BB_TO_FSB(mp, keys[1].fmr_physical);
> +	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
>  
>  	/* Set up search keys */
>  	info->low.rm_startblock = start_fsb;
> @@ -563,7 +561,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
>  STATIC int
>  xfs_getfsmap_rtdev_rtbitmap(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	struct xfs_getfsmap_info	*info)
>  {
>  	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
> @@ -576,7 +574,7 @@ xfs_getfsmap_rtdev_rtbitmap(
>  STATIC int
>  __xfs_getfsmap_datadev(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	struct xfs_getfsmap_info	*info,
>  	int				(*query_fn)(struct xfs_trans *,
>  						    struct xfs_getfsmap_info *,
> @@ -591,16 +589,14 @@ __xfs_getfsmap_datadev(
>  	xfs_fsblock_t			end_fsb;
>  	xfs_agnumber_t			start_ag;
>  	xfs_agnumber_t			end_ag;
> -	xfs_daddr_t			eofs;
> +	uint64_t			eofs;
>  	int				error = 0;
>  
>  	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  	if (keys[0].fmr_physical >= eofs)
>  		return 0;
> -	if (keys[1].fmr_physical >= eofs)
> -		keys[1].fmr_physical = eofs - 1;
>  	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
> -	end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
> +	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
>  
>  	/*
>  	 * Convert the fsmap low/high keys to AG based keys.  Initialize
> @@ -728,7 +724,7 @@ xfs_getfsmap_datadev_rmapbt_query(
>  STATIC int
>  xfs_getfsmap_datadev_rmapbt(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	struct xfs_getfsmap_info	*info)
>  {
>  	info->missing_owner = XFS_FMR_OWN_FREE;
> @@ -763,7 +759,7 @@ xfs_getfsmap_datadev_bnobt_query(
>  STATIC int
>  xfs_getfsmap_datadev_bnobt(
>  	struct xfs_trans		*tp,
> -	struct xfs_fsmap		*keys,
> +	const struct xfs_fsmap		*keys,
>  	struct xfs_getfsmap_info	*info)
>  {
>  	struct xfs_alloc_rec_incore	akeys[2];


-- 
chandan
