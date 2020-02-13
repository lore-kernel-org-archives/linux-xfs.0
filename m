Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B53C352A4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 00:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DEAB206DB
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 00:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgBMAPV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 19:15:21 -0500
Received: from sandeen.net ([63.231.237.45]:51806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgBMAPU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 19:15:20 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DBFE222C5;
        Wed, 12 Feb 2020 18:15:13 -0600 (CST)
Subject: Re: [PATCH 06/14] xfs: refactor default quota grace period setting
 code
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784110016.1364230.5024129406313355261.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2fde1e65-7ede-3c47-81bd-d39906a8dc77@sandeen.net>
Date:   Wed, 12 Feb 2020 18:15:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <157784110016.1364230.5024129406313355261.stgit@magnolia>
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
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    8 ++++++++
>  fs/xfs/xfs_ondisk.h        |    2 ++
>  fs/xfs/xfs_qm_syscalls.c   |   35 +++++++++++++++++++++++------------
>  fs/xfs/xfs_trans_dquot.c   |   16 ++++++++++++----
>  4 files changed, 45 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 95761b38fe86..557db5e51eec 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1188,6 +1188,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
>   * of zero means that the quota limit has not been reached, and therefore no
>   * expiration has been set.
> + *
> + * The length of quota grace periods are unsigned 32-bit quantities in units of
> + * seconds (which are stored in the root dquot).  A value of zero means to use
> + * the default period.

Doesn't a value of zero mean that the soft limit has not been exceeded, and no
timer is in force?  And when soft limit is exceeded, the timer starts ticking
based on the value in the root dquot?

i.e. you can't set a custom per-user grace period, can you?

Perhaps:

* The length of quota grace periods are unsigned 32-bit quantities in units of
* seconds.  The grace period for each quota type is stored in the root dquot
* and is applied/transferred to a user quota when it exceeds a soft limit.

>   */
>  
>  /*
> @@ -1202,6 +1206,10 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   */
>  #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
>  
> +/* Quota grace periods, ranging from zero (use the defaults) to ~136 years. */

same thing.  The default can be set between 0 and ~136 years, that gets transferred
to any user who exceeds soft quota, and it counts down from there.

> +#define XFS_DQ_GRACE_MIN	((int64_t)0)
> +#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
> +
>  /*
>   * This is the main portion of the on-disk representation of quota
>   * information for a user. This is the q_core of the struct xfs_dquot that
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 52dc5326b7bf..b8811f927a3c 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -27,6 +27,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
>  	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MIN,			1LL);
>  	XFS_CHECK_VALUE(XFS_DQ_TIMEOUT_MAX,			4294967295LL);
> +	XFS_CHECK_VALUE(XFS_DQ_GRACE_MIN,			0LL);
> +	XFS_CHECK_VALUE(XFS_DQ_GRACE_MAX,			4294967295LL);

*cough* notondisk *cough*

>  
>  	/* ag/file structures */
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 74220948a360..20a6d304d1be 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -438,6 +438,20 @@ xfs_qm_scall_quotaon(
>  	return 0;
>  }
>  
> +/* Set a new quota grace period. */
> +static inline void
> +xfs_qm_set_grace(
> +	time_t			*qi_limit,
                                 ^ doesn't get used?
> +	__be32			*dtimer,
> +	const s64		grace)
> +{
> +	time64_t		new_grace;
> +
> +	new_grace = clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN,
> +					     XFS_DQ_GRACE_MAX);
> +	*dtimer = cpu_to_be32(new_grace);

You've lost setting the qi_limit here (q->qi_btimelimit etc)

> +}
> +
>  #define XFS_QC_MASK \
>  	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
>  
> @@ -567,18 +581,15 @@ xfs_qm_scall_setqlim(
>  		 * soft and hard limit values (already done, above), and
>  		 * for warnings.
>  		 */
> -		if (newlim->d_fieldmask & QC_SPC_TIMER) {
> -			q->qi_btimelimit = newlim->d_spc_timer;

i.e. qi_btimelimit never gets set now, which is what actually controls
the timers when a uid/gid/pid goes over softlimit.

> -			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> -		}
> -		if (newlim->d_fieldmask & QC_INO_TIMER) {
> -			q->qi_itimelimit = newlim->d_ino_timer;
> -			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> -		}
> -		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> -			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
> -			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> -		}
> +		if (newlim->d_fieldmask & QC_SPC_TIMER)
> +			xfs_qm_set_grace(&q->qi_btimelimit, &ddq->d_btimer,
> +					newlim->d_spc_timer);
> +		if (newlim->d_fieldmask & QC_INO_TIMER)
> +			xfs_qm_set_grace(&q->qi_itimelimit, &ddq->d_itimer,
> +					newlim->d_ino_timer);
> +		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> +			xfs_qm_set_grace(&q->qi_rtbtimelimit, &ddq->d_rtbtimer,
> +					newlim->d_rt_spc_timer);
>  		if (newlim->d_fieldmask & QC_SPC_WARNS)
>  			q->qi_bwarnlimit = newlim->d_spc_warns;
>  		if (newlim->d_fieldmask & QC_INO_WARNS)
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 248cfc369efc..7a2a3bd11db9 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -563,6 +563,14 @@ xfs_quota_warn(
>  			   mp->m_super->s_dev, type);
>  }
>  
> +/* Has a quota grace period expired? */

seems like this is not part of "quota grace period setting code"
- needs to be in a separate patch?

> +static inline bool
> +xfs_quota_timer_exceeded(
> +	time64_t		timer)
> +{
> +	return timer != 0 && get_seconds() > timer;
> +}
> +
>  /*
>   * This reserves disk blocks and inodes against a dquot.
>   * Flags indicate if the dquot is to be locked here and also
> @@ -580,7 +588,7 @@ xfs_trans_dqresv(
>  {
>  	xfs_qcnt_t		hardlimit;
>  	xfs_qcnt_t		softlimit;
> -	time_t			timer;
> +	time64_t		timer;

<this needs rebasing I guess, after b8a0880a37e2f43aa3bcd147182e95a4ebd82279>

>  	xfs_qwarncnt_t		warns;
>  	xfs_qwarncnt_t		warnlimit;
>  	xfs_qcnt_t		total_count;
> @@ -635,7 +643,7 @@ xfs_trans_dqresv(
>  				goto error_return;
>  			}
>  			if (softlimit && total_count > softlimit) {
> -				if ((timer != 0 && get_seconds() > timer) ||
> +				if (xfs_quota_timer_exceeded(timer) ||
>  				    (warns != 0 && warns >= warnlimit)) {
>  					xfs_quota_warn(mp, dqp,
>  						       QUOTA_NL_BSOFTLONGWARN);
> @@ -662,8 +670,8 @@ xfs_trans_dqresv(
>  				goto error_return;
>  			}
>  			if (softlimit && total_count > softlimit) {
> -				if  ((timer != 0 && get_seconds() > timer) ||
> -				     (warns != 0 && warns >= warnlimit)) {
> +				if (xfs_quota_timer_exceeded(timer) ||
> +				    (warns != 0 && warns >= warnlimit)) {

TBH don't really see the point of this refactoring/helper, especially if not
done for warns.  I think open coding is fine.

>  					xfs_quota_warn(mp, dqp,
>  						       QUOTA_NL_ISOFTLONGWARN);
>  					goto error_return;
> 
