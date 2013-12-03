Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A46017F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 18:45:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F3A2AC004
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:45:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zVAqoA7J1gVpGNjn for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 16:45:23 -0800 (PST)
Date: Tue, 3 Dec 2013 11:45:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfstests: Introduce xfs/323 to verify turn
	group/project quotas off
Message-ID: <20131203004513.GJ10988@dastard>
References: <52983C48.50007@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52983C48.50007@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 29, 2013 at 03:03:36PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce xfs/323 to verify that turn group/project quotas off
> while user quotas is on.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

One minor thing:

> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_xfs_quota
> +_require_xfs_crc_sb
> +
> +_qmount_option "uquota,gquota,pquota"
> +_qmount
> +
> +TESTDIR=$SCRATCH_MNT/testdir

Too similar to TEST_DIR. "quota_dir", or something like it, so
people don't get confused by what device this test is running on at
a glance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
