Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ECCD7CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 01:38:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5208AC005
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 23:38:10 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qNsviBxCydMvH7Sy for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 23:38:07 -0700 (PDT)
Date: Fri, 24 Jun 2016 16:38:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: simplify the calculation of tpp at xfs_bmdr_to_bmbt
Message-ID: <20160624063805.GD12670@dastard>
References: <1466746760-155962-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466746760-155962-1-git-send-email-houtao1@huawei.com>
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
To: Hou Tao <houtao1@huawei.com>
Cc: miaoxie@huawei.com, fangwei1@huawei.com, xfs@oss.sgi.com

On Fri, Jun 24, 2016 at 01:39:20PM +0800, Hou Tao wrote:
> remove the usage of rblocklen at xfs_bmdr_to_bmbt, and
> use be16_to_cpu(dblock->bb_numrecs) instead. It also
> reduces an extra calculation.

What problem does this fix, why does it need to be made and
how did you test it?

We have to be really careful about changing code that interacts with
the on-disk format, as any bugs we introduced will result in
filesystem corruption.  Hence you need to explain to the reviewers
why the change needs to be made to the reviewers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
