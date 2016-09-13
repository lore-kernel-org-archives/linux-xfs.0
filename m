Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE81A7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 02:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1E7D304064
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 00:09:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GXcevInHME57lUAa for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 00:09:15 -0700 (PDT)
Date: Tue, 13 Sep 2016 17:09:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_logprint: fix the transcation type string for
	delaylog-enabled fs
Message-ID: <20160913070913.GG30497@dastard>
References: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
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
Cc: xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 12:08:27PM +0800, Hou Tao wrote:
> For delaylog-enabled fs, the only th_type is XFS_TRANS_CHECKPOINT,
> but the value of XFS_TRANS_CHECKPOINT had been change from 42 to 40
> by xfs commit 61e63ec (xfs: consolidate superblock logging functions),
> so return trans_type[type] directly will be incorrect.
> And there is no flag for delaylog testing, so the suboptimal solution
> is to use super v5 flag instead. For pre-v5 fs used by kernel after
> commit 61e63ec, the result of xlog_trans_type will still be incorrect.

delaylog and v5 superblocks are completely unrelated and so this is
incorrect.

> before patch:
> (1) v5 fs
> TRAN:    type: SWAPEXT       tid: 321be024       num_items: 2
> TRANS: tid:0x772d0805  type:SWAPEXT  #items:37  trans:0x772d0805  q:0x559104d71bc0
> 
> after patch:
> (2) v5 fs
> TRAN:    type: CHECKPOINT       tid: 321be024       num_items: 2
> TRANS: tid:0x772d0805  type:SWAPEXT  #items:37  trans:0x772d0805  q:0x559104d71bc0

And so v4 filesystems are still incorrect.

Indeed, when delaylog is enabled, the only transaction type in the
log is "CHECKPOINT" - the whole "trans type" stuff has gone away
from the kernel and only exists as this in xfs_log_format.h:

/*
 * The only type valid for th_type in CIL-enabled file system logs:
 */
#define XFS_TRANS_CHECKPOINT    40

IOWs, most of the logprint code is for printing log information from
pre-delaylog kernels. IOWs, for the anyone using a 3.0+ kernel, the
"trans type" output from xfs_logprint is completely useless
information, so we should probably either put it behind a command
line option or remove it completely...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
