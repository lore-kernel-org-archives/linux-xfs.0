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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59986C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E8264F48
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhBDJZ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbhBDJZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:25:26 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10D0C061573
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 01:24:43 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e9so1448058plh.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 01:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=i80LkPWmZ9WYA4wsea7YHQ951Qp4tChQwD9X4TvzHQQ=;
        b=PbBYP/NtmLEzpSW0s5BPPBc0sf6PlcrDoiDrn6rXMBwm+VbeKLfIqmn+NcxUpPrWvF
         qaEf1ZuefdZR9NW+OlaL5h4SJ0cr9dnNFZbi6brRoZ5ldaWM9afITLV5m9pJ+MLDBgQ4
         aKp3z+l9aNHrXR8fhWlMW59hRB08gaoDBZsDY0sFlQPXMv7HoC4mDe0nSdlE9NUGASsB
         CgwaxKWlCE06L3g2rXQm4Wz6/hRNdJGfTNY5qzZIY+1KBfjTyqwbQw4GAanCIDqRgih+
         pHLUy89Not9kIzJMmBc8qUVuHYFxruC+4LAzHvnsf7zvYhr3DK/x4FmaXvVlePLfrJnd
         FOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=i80LkPWmZ9WYA4wsea7YHQ951Qp4tChQwD9X4TvzHQQ=;
        b=tx5k+p+33NIqxvYIEYCbMjj8lGiLWivpvsMIgb3M7aEsg2EaVqSo1U0hUqA/yRXtc7
         Z7DosJACaHqazxuZ+4PACtZt88fib6+Mv9Wm+6jIy+NAJGPhF4FFDHocFwBggdLPwVJ/
         aSqj/AdD1/BoF0Ccc+iYJIx73VbB2LhodGDP4gXzQQlU34M8USGKxLiTUvNjX66uRA3V
         bpkGNHIAdffjnnXw7tjSTOR2vMhmDGdEOw7BCwpzlW/aO5WJOUee4Nk4yKhoDEY6u6d6
         oeB/MLXUQRt6Om6AYLeQQRWrM9u5AN4ZTuDBxmU613cqf3svJBvYpneJAx4/6EhxxHm2
         Tujg==
X-Gm-Message-State: AOAM5336kxSj1Zc85m8kJqYpU6mBsVfeAZ7VFCTTMcOcIVg3YrQ/hrav
        VGCgKwPfDYM9RE6IroGray9L2vOCeGQ=
X-Google-Smtp-Source: ABdhPJwqjkGBfv7okGWCLQiTeEqESV46iU7wNCFeCJeH1chEYplaeB6sEyUKsDbFAx+KCNAmw8tbXQ==
X-Received: by 2002:a17:90a:1542:: with SMTP id y2mr7882550pja.123.1612430683495;
        Thu, 04 Feb 2021 01:24:43 -0800 (PST)
Received: from garuda ([122.167.153.206])
        by smtp.gmail.com with ESMTPSA id p19sm4725691pjo.7.2021.02.04.01.24.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 01:24:42 -0800 (PST)
References: <20210202193945.GP7193@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, chandanrlinux@gmail.com
Subject: Re: [PATCH] xfs: fix incorrect root dquot corruption error when switching group/project quota types
In-reply-to: <20210202193945.GP7193@magnolia>
Date:   Thu, 04 Feb 2021 14:54:39 +0530
Message-ID: <87tuqsw5go.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Feb 2021 at 01:09, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> While writing up a regression test for broken behavior when a chprojid
> request fails, I noticed that we were logging corruption notices about
> the root dquot of the group/project quota file at mount time when
> testing V4 filesystems.
>
> In commit afeda6000b0c, I was trying to improve ondisk dquot validation
> by making sure that when we load an ondisk dquot into memory on behalf
> of an incore dquot, the dquot id and type matches.  Unfortunately, I
> forgot that V4 filesystems only have two quota files, and can switch
> that file between group and project quota types at mount time.  When we
> perform that switch, we'll try to load the default quota limits from the
> root dquot prior to running quotacheck and log a corruption error when
> the types don't match.
>
> This is inconsequential because quotacheck will reset the second quota
> file as part of doing the switch, but we shouldn't leave scary messages
> in the kernel log.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dquot.c |   39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 175f544f7c45..bd8379b98374 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -506,6 +506,42 @@ xfs_dquot_alloc(
>  	return dqp;
>  }
>  
> +/* Check the ondisk dquot's id and type match what the incore dquot expects. */
> +static bool
> +xfs_dquot_check_type(
> +	struct xfs_dquot	*dqp,
> +	struct xfs_disk_dquot	*ddqp)
> +{
> +	uint8_t			ddqp_type;
> +	uint8_t			dqp_type;
> +
> +	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
> +	dqp_type = xfs_dquot_type(dqp);
> +
> +	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
> +		return false;
> +
> +	/*
> +	 * V5 filesystems always expect an exact type match.  V4 filesystems
> +	 * expect an exact match for user dquots and for non-root group and
> +	 * project dquots.
> +	 */
> +	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
> +	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
> +		return ddqp_type == dqp_type;
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
> +	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
> +}
> +
>  /* Copy the in-core quota fields in from the on-disk buffer. */
>  STATIC int
>  xfs_dquot_from_disk(
> @@ -518,8 +554,7 @@ xfs_dquot_from_disk(
>  	 * Ensure that we got the type and ID we were looking for.
>  	 * Everything else was checked by the dquot buffer verifier.
>  	 */
> -	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
> -	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
> +	if (!xfs_dquot_check_type(dqp, ddqp)) {
>  		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
>  			  "Metadata corruption detected at %pS, quota %u",
>  			  __this_address, dqp->q_id);


-- 
chandan
