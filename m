Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F607C352A4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 23:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F064F20578
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 23:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgBLXfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 18:35:45 -0500
Received: from sandeen.net ([63.231.237.45]:49722 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgBLXfp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 18:35:45 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 79CDA78D4;
        Wed, 12 Feb 2020 17:35:38 -0600 (CST)
Subject: Re: [PATCH 02/14] xfs: preserve default grace interval during
 quotacheck
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784107520.1364230.49128863919644273.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <1157c1cd-31d0-cb8a-90ae-c37d85c70835@sandeen.net>
Date:   Wed, 12 Feb 2020 17:35:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <157784107520.1364230.49128863919644273.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When quotacheck runs, it zeroes all the timer fields in every dquot.
> Unfortunately, it also does this to the root dquot, which erases any
> preconfigured grace interval that the administrator may have set.  Worse
> yet, the incore copies of those variables remain set.  This cache
> coherence problem manifests itself as the grace interval mysteriously
> being reset back to the defaults at the /next/ mount.

woot that's kind of a theme in xfs quota code :/

Is it my turn to ask for a testcase?

so: "quotacheck" on xfs means "mount with quota accounting enabled" I think,
just for clarity...

> Fix it by resetting the root disk dquot's timer fields to the incore
> values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_qm.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 0ce334c51d73..d4a9765c9502 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -842,6 +842,23 @@ xfs_qm_qino_alloc(
>  	return error;
>  }
>  
> +/* Save the grace period intervals when zeroing dquots for quotacheck. */
> +static inline void
> +xfs_qm_reset_dqintervals(
> +	struct xfs_mount	*mp,
> +	struct xfs_disk_dquot	*ddq)
> +{
> +	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
> +
> +	if (qinf->qi_btimelimit != XFS_QM_BTIMELIMIT)
> +		ddq->d_btimer = cpu_to_be32(qinf->qi_btimelimit);
> +
> +	if (qinf->qi_itimelimit != XFS_QM_ITIMELIMIT)
> +		ddq->d_itimer = cpu_to_be32(qinf->qi_itimelimit);
> +
> +	if (qinf->qi_rtbtimelimit != XFS_QM_RTBTIMELIMIT)
> +		ddq->d_rtbtimer = cpu_to_be32(qinf->qi_rtbtimelimit);

Probably need to handle warning counters here too, but ...

> +}
>  
>  STATIC void
>  xfs_qm_reset_dqcounts(
> @@ -895,6 +912,8 @@ 	(
>  		ddq->d_bwarns = 0;
>  		ddq->d_iwarns = 0;
>  		ddq->d_rtbwarns = 0;

a comment about why !ddq->d_id (i.e. it's the default quota)
would probably be good here.

> +		if (!ddq->d_id)
> +			xfs_qm_reset_dqintervals(mp, ddq);

Isn't it a little weird to clear it for ID 0, then immediately reset it?

Let's see, quotacheck only happens when we do a fresh mount where quota accounting
was not on during the previous mount.

The point of quotacheck is to get all of the block counters in sync with actual
block usage.

The timers (and warnings) for normal users are zero until they exceed soft limits,
then reflect the time at which EDQUOT will appear.

<aside: does quotacheck set timers for users who are already over soft limits
at quotacheck time...?  Yes: see xfs_qm_quotacheck_dqadjust()>

The timers (and warnings) for ID 0 (root/default) are where we store the default
grace times & warning limits, there is no need for quotacheck to change them;
they serve a different purpose.

So quotacheck really should never be touching the default timers or warn limits
on ID 0.  I'd suggest simply skipping them for id 0, as it is treated specially
in several other places as well, i.e.

-               ddq->d_btimer = 0;
-               ddq->d_itimer = 0;
-               ddq->d_rtbtimer = 0;
-               ddq->d_bwarns = 0;
-               ddq->d_iwarns = 0;
-               ddq->d_rtbwarns = 0;
+               /* Don't reset default quota timers & counters in root dquot */
+               if (ddq->d_id) {
+                       ddq->d_btimer = 0;
+                       ddq->d_itimer = 0;
+                       ddq->d_rtbtimer = 0;
+                       ddq->d_bwarns = 0;
+                       ddq->d_iwarns = 0;
+                       ddq->d_rtbwarns = 0;
+               }

>  
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  			xfs_update_cksum((char *)&dqb[j],
> 
