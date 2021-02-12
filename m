Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD62C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 12:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D6AC64DD7
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 12:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBLMJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 07:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhBLMJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 07:09:03 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A717C061574
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 04:08:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z9so317154pjl.5
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 04:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jYYsIzElbdhwT6URHgflKTibqyS2bX8K4NLqf1UldaU=;
        b=VA/H77szhkaDrFVHpemOB40+XyXSaxiP0DKk3INspN30n/WKTP+fKuBbCb+2N52hBF
         bNBXmtbmNMN00j5YoLJptsLiD8yplOOtaUdxGO88prfqhRlQaWRXICcJxfe3eJkesUoI
         Hv9iOVcUrwBydtaS4Ks6HmktR3No3JwU9DccqT3x51hIcrqAcl52w3CBdN6JCRwPJdJh
         Wpnxfq9s5T1LI7gbZBgXmnBMdTMXbnWbQi1Nwomaknp+zD4QAihytf92DtMM0/+ZIOyW
         o86EXwJENYwhW4UwqBCNYHNTHw7hoO2FD1HaZn8FEJaNJ6mjTRHJhp5BfFo9e7DrjjzX
         2tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jYYsIzElbdhwT6URHgflKTibqyS2bX8K4NLqf1UldaU=;
        b=gpGL8DzcaK2DOPv0SwjUpusHFvvt5lbaJUZxX2Qo4qo76Qlf/yYXHlDJM5stbsqQN+
         pBvYJcZ7Vddce2p33qy+3z0ppGkik93e4GN3lZ8iBSYAOW98Hh9/uyufHujUctJApVkC
         PG45mmVavWa+dvNoSlO+zt1lC3qLYkPvyJwTk+TFOzxwUsiEl09mZplocPbfcuBVcMPi
         +pkeh8oojFACRyUiPtf1aBDkUpr/3QTXs+SgIO9k/D2wlGTQCz7dArdpFsecIv984yzR
         KlNSZhkAzX9HGfvJl4kISTHfwp1EQdJebNrO5Z67atC+JCmCpofpMMFn3FU72fTI4T18
         xk4w==
X-Gm-Message-State: AOAM5302Kk1esalk4EuHAoVr0oqcsfeA0uT2+ZDEQ3WCQ3dHXGLUtlTa
        2/R9TuUaRHGGSSVoS0hVhhJZdy5XMfU=
X-Google-Smtp-Source: ABdhPJxccgqGHUKKWSaBpPgVKkbg1QIOoel0zdy+uYfR4gzb0E2ATrh/7Fa7K5GevOKTDAnckj3dyg==
X-Received: by 2002:a17:90a:fb96:: with SMTP id cp22mr2388495pjb.131.1613131701733;
        Fri, 12 Feb 2021 04:08:21 -0800 (PST)
Received: from garuda ([122.172.204.81])
        by smtp.gmail.com with ESMTPSA id c77sm9849331pfb.138.2021.02.12.04.08.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Feb 2021 04:08:21 -0800 (PST)
References: <161284387610.3058224.6236053293202575597.stgit@magnolia> <161284390433.3058224.6853671538193339438.stgit@magnolia> <20210211170611.GD7193@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH v4.1 5/6] xfs_repair: check dquot id and type
In-reply-to: <20210211170611.GD7193@magnolia>
Date:   Fri, 12 Feb 2021 17:38:17 +0530
Message-ID: <874kihij4e.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Feb 2021 at 22:36, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that we actually check the type and id of an ondisk dquot.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v4.1: fix backwards logic pointed out by Chaitanya
> ---
>  repair/quotacheck.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/repair/quotacheck.c b/repair/quotacheck.c
> index 55bcc048..0a505c9c 100644
> --- a/repair/quotacheck.c
> +++ b/repair/quotacheck.c
> @@ -234,12 +234,48 @@ quotacheck_adjust(
>  	libxfs_irele(ip);
>  }
>  
> +/* Check the ondisk dquot's id and type match what the incore dquot expects. */
> +static bool
> +qc_dquot_check_type(
> +	struct xfs_mount	*mp,
> +	xfs_dqtype_t		type,
> +	xfs_dqid_t		id,
> +	struct xfs_disk_dquot	*ddq)
> +{
> +	uint8_t			ddq_type;
> +
> +	ddq_type = ddq->d_type & XFS_DQTYPE_REC_MASK;
> +
> +	if (be32_to_cpu(ddq->d_id) != id)
> +		return false;
> +
> +	/*
> +	 * V5 filesystems always expect an exact type match.  V4 filesystems
> +	 * expect an exact match for user dquots and for non-root group and
> +	 * project dquots.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb) || type == XFS_DQTYPE_USER || id)
> +		return ddq_type == type;
> +
> +	/*
> +	 * V4 filesystems support either group or project quotas, but not both
> +	 * at the same time.  The non-user quota file can be switched between
> +	 * group and project quota uses depending on the mount options, which
> +	 * means that we can encounter the other type when we try to load quota
> +	 * defaults.  Quotacheck will soon reset the the entire quota file
> +	 * (including the root dquot) anyway, but don't log scary corruption
> +	 * reports to dmesg.
> +	 */
> +	return ddq_type == XFS_DQTYPE_GROUP || ddq_type == XFS_DQTYPE_PROJ;
> +}
> +
>  /* Compare this on-disk dquot against whatever we observed. */
>  static void
>  qc_check_dquot(
>  	struct xfs_mount	*mp,
>  	struct xfs_disk_dquot	*ddq,
> -	struct qc_dquots	*dquots)
> +	struct qc_dquots	*dquots,
> +	xfs_dqid_t		dqid)
>  {
>  	struct qc_rec		*qrec;
>  	struct qc_rec		empty = {
> @@ -253,6 +289,22 @@ qc_check_dquot(
>  	if (!qrec)
>  		qrec = &empty;
>  
> +	if (!qc_dquot_check_type(mp, dquots->type, dqid, ddq)) {
> +		const char	*dqtypestr;
> +
> +		dqtypestr = qflags_typestr(ddq->d_type & XFS_DQTYPE_REC_MASK);
> +		if (dqtypestr)
> +			do_warn(_("%s id %u saw type %s id %u\n"),
> +					qflags_typestr(dquots->type), dqid,
> +					dqtypestr, be32_to_cpu(ddq->d_id));
> +		else
> +			do_warn(_("%s id %u saw type %x id %u\n"),
> +					qflags_typestr(dquots->type), dqid,
> +					ddq->d_type & XFS_DQTYPE_REC_MASK,
> +					be32_to_cpu(ddq->d_id));
> +		chkd_flags = 0;
> +	}
> +
>  	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
>  		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
>  				qflags_typestr(dquots->type), id,
> @@ -327,11 +379,11 @@ _("cannot read %s inode %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d
>  		}
>  
>  		dqb = bp->b_addr;
> -		dqid = map->br_startoff * dqperchunk;
> +		dqid = (map->br_startoff + bno) * dqperchunk;
>  		for (dqnr = 0;
>  		     dqnr < dqperchunk && dqid <= UINT_MAX;
>  		     dqnr++, dqb++, dqid++)
> -			qc_check_dquot(mp, &dqb->dd_diskdq, dquots);
> +			qc_check_dquot(mp, &dqb->dd_diskdq, dquots, dqid);
>  		libxfs_buf_relse(bp);
>  	}
>  


-- 
chandan
