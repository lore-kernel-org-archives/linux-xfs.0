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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A45C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 09:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B916F64E02
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 09:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBJJub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 04:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBJJtM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 04:49:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0018C0613D6
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 01:48:31 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nm1so806312pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 01:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QvShEvKKvyf/xvra8Wgmbysam4FYNOmffc4DlrcOl6o=;
        b=PxkX4OZZNQI2mZ/0A+hqQ8WYmtevO32Li9RCyA9g0o3DXGUooscEOw8pxDH1N5akNP
         75USk/OJYrKWGaIV/A6IoTogxvKEn4pU9oKohEbhFq2w01H6uQNrU3w7o6vnP/isrITF
         hithn3CJtv8r/ZMPwsoC+tZEbFhlvA34pAYHHRhdfSlkJSdBAwE4iQ1IItu/p7LOs+/T
         hEmZUmzrZ5aP5urARSXWoKp/BuHP2k9NSdF5ygvhcvNbbwjibstREMHjbIVh3S5dyM8V
         176+l01TW+VJL7SurDtZiAXHCd29kr4z/FdA4g6FkkM87cDTXR2WPdOAyxRggcgObLSP
         nxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QvShEvKKvyf/xvra8Wgmbysam4FYNOmffc4DlrcOl6o=;
        b=FVMzLAMTgaICKCsda7KnnqESSnTL8ib40A1La9BlqZ5BbnOcB+ooQZgYqIGFbGurpe
         HtdUTzJcN9Fb14zWfUJo47FCl7JwyiUlo8veu9N9Q2i0xbV1kv0l4gHSYa1uXufAJB29
         GHdx/16V4E41t0WbYFCwlKg7UQ/+wyj52P+diyT6oWSF/RG+WDT8vA+hjfvU+ijK0RtR
         +j4AAdGFPzCS7j9Xu4npJh7mQU3usZzRCeyUZwYxGav/oOg5bnOcjL2VQdTRCcq9yEwS
         bqTGvAXTbFgkUYQjPuWKJ3mz9DpIR6T1illLKe1FKgeLbcE/SWYgrp/reAco9lEqemXF
         ldNg==
X-Gm-Message-State: AOAM533SWgcsgK9v3YJn3onZVk4Y3Tr9FpErRkfiHlEJLXufHSDGVjh+
        l09ci9RB+x4wLSn6qohiZ+k=
X-Google-Smtp-Source: ABdhPJy2mrUNIWhSMzRrjTrucz1Bs9q1TLXUfF9jANkr7Vt3DN06vCAWpLJYCoLD2ksYwMv70EJsoQ==
X-Received: by 2002:a17:902:eccf:b029:de:72a2:f1f8 with SMTP id a15-20020a170902eccfb02900de72a2f1f8mr2465977plh.17.1612950511514;
        Wed, 10 Feb 2021 01:48:31 -0800 (PST)
Received: from garuda ([122.182.225.93])
        by smtp.gmail.com with ESMTPSA id 9sm1790537pgw.61.2021.02.10.01.48.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Feb 2021 01:48:31 -0800 (PST)
References: <161284387610.3058224.6236053293202575597.stgit@magnolia> <161284390433.3058224.6853671538193339438.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 5/6] xfs_repair: check dquot id and type
In-reply-to: <161284390433.3058224.6853671538193339438.stgit@magnolia>
Date:   Wed, 10 Feb 2021 15:18:28 +0530
Message-ID: <877dngp82b.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Feb 2021 at 09:41, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that we actually check the type and id of an ondisk dquot.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/quotacheck.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
>
>
> diff --git a/repair/quotacheck.c b/repair/quotacheck.c
> index 55bcc048..0ea2deb5 100644
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
> +	if (xfs_sb_version_hascrc(&mp->m_sb) || type == XFS_DQTYPE_USER || !id)

The above check should have been "id" instead of "!id".

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
