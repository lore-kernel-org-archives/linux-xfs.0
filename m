Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB31C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BAC2077D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGAXaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:30:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54330 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbgGAXaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:30:07 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 07BE3821DEB;
        Thu,  2 Jul 2020 09:30:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqmAz-0001Dc-Ph; Thu, 02 Jul 2020 09:30:01 +1000
Date:   Thu, 2 Jul 2020 09:30:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: refactor default quota limits by resource
Message-ID: <20200701233001.GD2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353178739.2864738.11605071453935920102.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353178739.2864738.11605071453935920102.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=I9xlTH3lSbpoeRWiWA0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've split up the dquot resource fields into separate structs,
> do the same for the default limits to enable further refactoring.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c       |   30 +++++++++++++++---------------
>  fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++------------------
>  fs/xfs/xfs_qm.h          |   22 ++++++++++------------
>  fs/xfs/xfs_qm_syscalls.c |   24 ++++++++++++------------
>  fs/xfs/xfs_quotaops.c    |   12 ++++++------
>  fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
>  6 files changed, 70 insertions(+), 72 deletions(-)

A few things here, starting with the "defq" naming. These are
quota limits, not "default quotas". I'd suggest taht this whole
set of structures need to be renamed as "quota limits". e.g

struct xfs_quota_limits {
	xfs_qcnt_t		hard;	/* default hard limit */
	xfs_qcnt_t		soft;	/* default soft limit */
	time64_t		time;	/* limit for timers */
	xfs_qwarncnt_t		warn;	/* limit for warnings */
};

Then we have

	qlim = xfs_qm_get_default_limits(q, xfs_dquot_type(dq));
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2d6b50760962..6975c27145fc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -76,22 +76,22 @@ xfs_qm_adjust_dqlimits(
>  	ASSERT(dq->q_id);
>  	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
>  
> -	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
> -		dq->q_blk.softlimit = defq->bsoftlimit;
> +	if (defq->dfq_blk.softlimit && !dq->q_blk.softlimit) {
> +		dq->q_blk.softlimit = defq->dfq_blk.softlimit;
>  		prealloc = 1;
>  	}
> -	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
> -		dq->q_blk.hardlimit = defq->bhardlimit;
> +	if (defq->dfq_blk.hardlimit && !dq->q_blk.hardlimit) {
> +		dq->q_blk.hardlimit = defq->dfq_blk.hardlimit;
>  		prealloc = 1;
>  	}
> -	if (defq->isoftlimit && !dq->q_ino.softlimit)
> -		dq->q_ino.softlimit = defq->isoftlimit;
> -	if (defq->ihardlimit && !dq->q_ino.hardlimit)
> -		dq->q_ino.hardlimit = defq->ihardlimit;
> -	if (defq->rtbsoftlimit && !dq->q_rtb.softlimit)
> -		dq->q_rtb.softlimit = defq->rtbsoftlimit;
> -	if (defq->rtbhardlimit && !dq->q_rtb.hardlimit)
> -		dq->q_rtb.hardlimit = defq->rtbhardlimit;
> +	if (defq->dfq_ino.softlimit && !dq->q_ino.softlimit)
> +		dq->q_ino.softlimit = defq->dfq_ino.softlimit;
> +	if (defq->dfq_ino.hardlimit && !dq->q_ino.hardlimit)
> +		dq->q_ino.hardlimit = defq->dfq_ino.hardlimit;
> +	if (defq->dfq_rtb.softlimit && !dq->q_rtb.softlimit)
> +		dq->q_rtb.softlimit = defq->dfq_rtb.softlimit;
> +	if (defq->dfq_rtb.hardlimit && !dq->q_rtb.hardlimit)
> +		dq->q_rtb.hardlimit = defq->dfq_rtb.hardlimit;

And all this turns into somthing much easier to read:

....
	if (qlim->ino.soft && !dq->q_ino.softlimit)
		dq->q_ino.softlimit = qlim->ino.soft;
	if (qlim->ino.hard && !dq->q_ino.hardlimit)
		dq->q_ino.hardlimit = qlim->ino.hard;
....

I'll also suggest we don't need to check qlim values here. It could
just be:

	if (!dq->q_ino.softlimit)
		dq->q_ino.softlimit = qlim->ino.soft;
	if (!dq->q_ino.hardlimit)
		dq->q_ino.hardlimit = qlim->ino.hard;


> @@ -41,20 +41,18 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   */
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>  
> +struct xfs_def_qres {
> +	xfs_qcnt_t		hardlimit;	/* default hard limit */
> +	xfs_qcnt_t		softlimit;	/* default soft limit */
> +	time64_t		timelimit;	/* limit for timers */
> +	xfs_qwarncnt_t		warnlimit;	/* limit for warnings */
> +};

As I implied above, this is a quota limits structure, not a "default
quota" structure. I'm not sure what the "res" in the name means,
either...

> +
>  /* Defaults for each quota type: time limits, warn limits, usage limits */
>  struct xfs_def_quota {
> -	time64_t	btimelimit;	/* limit for blks timer */
> -	time64_t	itimelimit;	/* limit for inodes timer */
> -	time64_t	rtbtimelimit;	/* limit for rt blks timer */
> -	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
> -	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
> -	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
> -	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
> -	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
> -	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> -	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
> -	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
> -	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
> +	struct xfs_def_qres	dfq_blk;
> +	struct xfs_def_qres	dfq_ino;
> +	struct xfs_def_qres	dfq_rtb;
>  };

The namespacing of these variables adds no value. It just makes the
code more verbose and harder to read. e.g.

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1b2b70b1660f..393b88612cc8 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -502,8 +502,8 @@ xfs_qm_scall_setqlim(
>  		dqp->q_blk.softlimit = soft;
>  		xfs_dquot_set_prealloc_limits(dqp);
>  		if (id == 0) {
> -			defq->bhardlimit = hard;
> -			defq->bsoftlimit = soft;
> +			defq->dfq_blk.hardlimit = hard;
> +			defq->dfq_blk.softlimit = soft;

IMO, these sorts of changes decrease the reability of the code. I'd
much prefer something like:

 		if (id == 0) {
-			defq->bhardlimit = hard;
-			defq->bsoftlimit = soft;
+			qlim->blk.hard = hard;
+			qlim->blk.soft = soft;

As it is still clear we are changing the hard block quota limits...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
