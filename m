Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R6qcDw069278 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 01:52:48 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3CFC304075
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 23:53:31 -0700 (PDT)
Message-Id: <E07B437D-A2F0-4A93-A5A5-CFA87EA0970D@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABD9@cf--amer001e--3.americas.sgi.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs_showargs() reports group *and* project quotas enabled
Date: Thu, 27 Aug 2009 01:53:28 -0500
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABD9@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com


On Aug 26, 2009, at 12:46 PM, Alex Elder wrote:

> If you enable group or project quotas on an XFS file system, then the
> mount table presented through /proc/self/mounts erroneously shows
> that both options are in effect for the file system.  The root of
> the problem is some bad logic in the xfs_showargs() function, which
> is used to format the file system type-specific options in effect
> for a file system.
>
> The problem originated in this GIT commit:
>    Move platform specific mount option parse out of core XFS code
>    Date: 11/22/07
>    Author: Dave Chinner
>    SHA1 ID: a67d7c5f5d25d0b13a4dfb182697135b014fa478
>
> For XFS quotas, project and group quota management are mutually
> exclusive--only one can be in effect at a time.  There are two
> parts to managing quotas:  aggregating usage information; and
> enforcing limits.  It is possible to have a quota in effect
> (aggregating usage) but not enforced.
>
> These features are recorded on an XFS mount point using these flags:
>    XFS_PQUOTA_ACCT - Project quotas are aggregated
>    XFS_GQUOTA_ACCT - Group quotas are aggregated
>    XFS_OQUOTA_ENFD - Project/group quotas are enforced
>
> The code in error is in fs/xfs/linux-2.6/xfs_super.c:
>
>        if (mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))
>                seq_puts(m, "," MNTOPT_PRJQUOTA);
>        else if (mp->m_qflags & XFS_PQUOTA_ACCT)
>                seq_puts(m, "," MNTOPT_PQUOTANOENF);
>
>        if (mp->m_qflags & (XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD))
>                seq_puts(m, "," MNTOPT_GRPQUOTA);
>        else if (mp->m_qflags & XFS_GQUOTA_ACCT)
>                seq_puts(m, "," MNTOPT_GQUOTANOENF);
>
> The problem is that XFS_OQUOTA_ENFD will be set in mp->m_qflags
> if either group or project quotas are enforced, and as a result
> both MNTOPT_PRJQUOTA and MNTOPT_GRPQUOTA will be shown as mount
> options.

Good catch, Alex.

> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
