Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92112C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 17:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343619AbiCPRmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244998AbiCPRmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 13:42:24 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A1386BDE6
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:41:10 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 04554490A;
        Wed, 16 Mar 2022 12:39:46 -0500 (CDT)
Message-ID: <fe974dac-bd1d-f3e7-6bd7-bc3f3cb56dd1@sandeen.net>
Date:   Wed, 16 Mar 2022 12:41:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20220314180914.GN8224@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: make quota default to no warning limit at all
In-Reply-To: <20220314180914.GN8224@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/14/22 1:09 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Historically, the quota warning counter was never incremented on a
> softlimit violation, and hence was never enforced.  Now that the counter
> works, the default of 5 warnings is getting enforced, which is a
> breakage that people aren't used to.  In the interest of not introducing
> new fail to things that used to work, make the default warning limit of
> zero, and make zero mean there is no limit.
> 
> Sorta-fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings")
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Darrick and I talked about this offline a bit yesterday, and I think
we reached an understanding/agreement on this .... 

While this patch will solve the problem of low warning thresholds
rendering timer thresholds useless, I'm still of the opinion that
this is not a feature to fix, but an inadvertent/broken behavior to
remove.

The concept of a warning limit in xfs quota has been documented as
unimplemented for about 20+ years. Digging through ancient IRIX docs,
the intent may have been to warn once per login session
(which would make more sense with the current limit of 5.) However,
nothing can be found in code archives to indicate that the warning
counter was ever bumped by anything (until the semi-recent change in
Linux.)

This feature is still documented as unimplemented in the xfs_quota
man page.

And although there are skeletal functions to manipulate warning limits
in xfs_quota, they cannot be disabled, and the interface differs from
timer limits, so is barely usable.

There is no concept of a "warning limit" in non-xfs quota tools, either.

There is no documentation on what constitutes a warning event, or when
it should be incremented.

tl;dr: While the warning counter bump has been upstream for some time
now, I think we can argue that that does not constitute a feature that
needs fixing or careful deprecation; TBH it looks more like a bug that
should be fixed by removing the increment altogether.

And then I think we can agree that if warning limits hae been documented
as unimplemented for 20+ years, we can also just remove any other code
that is related to this unimplemented feature.

I /think/ that's more or less where Darrick and I ended up on this one.

If I misremembered or misrepresented anything, Darrick, please correct me :)

Thanks,
-Eric

> ---
>  fs/xfs/xfs_qm.h          |   11 ++++++++---
>  fs/xfs/xfs_trans_dquot.c |    3 ++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 5bb12717ea28..2013f6100067 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -134,9 +134,14 @@ struct xfs_dquot_acct {
>  #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  
> -#define XFS_QM_BWARNLIMIT	5
> -#define XFS_QM_IWARNLIMIT	5
> -#define XFS_QM_RTBWARNLIMIT	5
> +/*
> + * Histerically, the quota warning counter never incremented and hence was
> + * never enforced.  Now that the counter works, we set a default warning limit
> + * of zero, which means there is no limit.
> + */
> +#define XFS_QM_BWARNLIMIT	0
> +#define XFS_QM_IWARNLIMIT	0
> +#define XFS_QM_RTBWARNLIMIT	0
>  
>  extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 9ba7e6b9bed3..32da74cf0768 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -598,7 +598,8 @@ xfs_dqresv_check(
>  		time64_t	now = ktime_get_real_seconds();
>  
>  		if ((res->timer != 0 && now > res->timer) ||
> -		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
> +		    (res->warnings != 0 && qlim->warn != 0 &&
> +		     res->warnings >= qlim->warn)) {
>  			*fatal = true;
>  			return QUOTA_NL_ISOFTLONGWARN;
>  		}
> 
