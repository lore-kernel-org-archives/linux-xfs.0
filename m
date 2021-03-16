Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD47C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 20:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1287F64E76
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 20:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhCPUuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:50:37 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58272 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231701AbhCPUuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 16:50:17 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3A42F1AE113;
        Wed, 17 Mar 2021 07:50:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMGdm-003JC5-RA; Wed, 17 Mar 2021 07:50:10 +1100
Date:   Wed, 17 Mar 2021 07:50:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH] xfs: use has_capability_noaudit() instead of capable()
 where appropriate
Message-ID: <20210316205010.GN63242@dread.disaster.area>
References: <20210316173226.2220046-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316173226.2220046-1-omosnace@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2x_0iWG2yc6BsuJkHo8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 06:32:26PM +0100, Ondrej Mosnacek wrote:
> In cases when a negative result of a capability check doesn't lead to an
> immediate, user-visible error, only a subtle difference in behavior, it
> is better to use has_capability_noaudit(current, ...), so that LSMs
> (e.g. SELinux) don't generate a denial record in the audit log each time
> the capability status is queried. This patch should cover all such cases
> in fs/xfs/.

Is this something new? I only see 4 calls to
has_capability_noaudit() in 5.12-rc3...

Also, has_capability_noaudit() is an awful name. capable_noaudit()
would actually be self explanatory to anyone who is used to doing
capability checks via capable(), ns_capable(), ns_capable_noaudit(),
inode_owner_or_capable(), capable_wrt_inode_uidgid(), etc...

Please fix the name of this function to be consistent with the
existing capability APIs before propagating it further into the
kernel.

> Note that I kept the capable(CAP_FSETID) checks, since these will only
> be executed if the user explicitly tries to set the SUID/SGID bit, and
> it likely makes sense to log such attempts even if the syscall doesn't
> fail and just ignores the bits.

So how on earth are we supposed to maintain this code correctly?
These are undocumented rules that seemingly are applied to random
subsystems and to seemingly random capable() calls in those
subsystems. ANd you don't even document it in this code where there
are other capable(...) checks that will generate audit records...

How are we supposed to know when an audit record should be emitted
or not by some unknown LSM when we do a capability check?
Capabilities are already an awful nightmare maze of similar but
slightly different capability checks, and this doesn't improve the
situation at all.

Please make this easier to get right iand maintain correctly (an
absolute, non-negotiable requirement for anything security related)
before you spray yet another poorly documented capability function
into the wider kernel.

> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  fs/xfs/xfs_fsmap.c | 4 ++--
>  fs/xfs/xfs_ioctl.c | 5 ++++-
>  fs/xfs/xfs_iops.c  | 6 ++++--
>  fs/xfs/xfs_xattr.c | 2 +-
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 9ce5e7d5bf8f..14672e7ee535 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -842,8 +842,8 @@ xfs_getfsmap(
>  	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
>  		return -EINVAL;
>  
> -	use_rmap = capable(CAP_SYS_ADMIN) &&
> -		   xfs_sb_version_hasrmapbt(&mp->m_sb);
> +	use_rmap = xfs_sb_version_hasrmapbt(&mp->m_sb) &&
> +		   has_capability_noaudit(current, CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3fbd98f61ea5..3cfc1a25069c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1470,8 +1470,11 @@ xfs_ioctl_setattr(
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
>  	    ip->i_d.di_projid != fa->fsx_projid) {
> +		int flags = has_capability_noaudit(current, CAP_FOWNER) ?
> +			XFS_QMOPT_FORCE_RES : 0;
> +
>  		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
> -				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
> +				flags);
>  		if (code)	/* out of quota */
>  			goto error_trans_cancel;
>  	}

You missed a capable() call here - see the call to
xfs_trans_alloc_ichange( ... capabale(CAP_FOWNER), ...); in
xfs_ioctl_setattr_get_trans().

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 67c8dc9de8aa..abbb417c4fbd 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -729,10 +729,12 @@ xfs_setattr_nonsize(
>  		if (XFS_IS_QUOTA_RUNNING(mp) &&
>  		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
>  		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> +			int flags = has_capability_noaudit(current, CAP_FOWNER) ?
> +				XFS_QMOPT_FORCE_RES : 0;
> +
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						NULL, capable(CAP_FOWNER) ?
> -						XFS_QMOPT_FORCE_RES : 0);
> +						NULL, flags);
>  			if (error)	/* out of quota */
>  				goto out_cancel;
>  		}

You missed a capable() call here - see the call to
xfs_trans_alloc_ichange( ... capabale(CAP_FOWNER), ...); in this
function.

I think this demonstrates just how fragile and hard to maintain the
approach being taken here is.

> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index bca48b308c02..a99d19c2c11f 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -164,7 +164,7 @@ xfs_xattr_put_listent(
>  		 * Only show root namespace entries if we are actually allowed to
>  		 * see them.
>  		 */
> -		if (!capable(CAP_SYS_ADMIN))
> +		if (!has_capability_noaudit(current, CAP_SYS_ADMIN))
>  			return;
>  
>  		prefix = XATTR_TRUSTED_PREFIX;

This one should absolutely report a denial - someone has tried to
read the trusted xattr namespace without permission to do so. That's
exactly the sort of thing I'd want to see in an audit log - just
because we just elide the xattrs rather than return an error doesn't
mean we should not leave an audit trail from the attempted access
of kernel trusted attributes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
