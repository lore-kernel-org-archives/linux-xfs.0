Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC6C67CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 00:31:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C849AC001
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 22:31:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Jauni7ByjNrwPt0R for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 22:31:14 -0700 (PDT)
Date: Wed, 14 Sep 2016 15:31:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_logprint: fix the transcation type string for
	delaylog-enabled fs
Message-ID: <20160914053110.GM30497@dastard>
References: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
	<20160913070913.GG30497@dastard> <57D8A1BE.60906@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57D8A1BE.60906@huawei.com>
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

On Wed, Sep 14, 2016 at 09:02:54AM +0800, Hou Tao wrote:
> >> but the value of XFS_TRANS_CHECKPOINT had been change from 42 to 40
> >> by xfs commit 61e63ec (xfs: consolidate superblock logging functions),
> >> so return trans_type[type] directly will be incorrect.
> >> And there is no flag for delaylog testing, so the suboptimal solution
> >> is to use super v5 flag instead. For pre-v5 fs used by kernel after
> >> commit 61e63ec, the result of xlog_trans_type will still be incorrect.
> > 
> > delaylog and v5 superblocks are completely unrelated and so this is
> > incorrect.
> I don't agree.  As we can see from the commit log, v5 superblock was supported
> after making delaylog as the only option, so v5 superblock implies delaylog.

You can disagree, but that doesn't make your argument correct.

Superblock versions and features define changes to the on-disk
format, and delaylog was specifically crafted to avoid changing the
on-disk fomats. Tying detection of transaction type numbering to an
unrelated on-disk feature change is simply wrong. No ifs, not buts,
it's just wrong.

> Commit 93b8a5854f247138e401471a9c3b82ccb62ff608 makes the delaylog as the only
> option, and its date is "Tue Dec 6 21:58:07 2011".
> 
> Commit 04a1e6c5b222b089c6960dfc5352002002a4355f adds the support of v5 superblock,
> and its date is "Wed Apr 3 16:11:31 2013".

Sure, but that's irrelevant because these are unrelated features.

> > And so v4 filesystems are still incorrect.
> > 
> Partial yes: For v4 filesystem before 3.19 (commit 61e63ec), the result
> is still correct.

Actually, it was introduced in 3.20-rc1, aka 4.0. It was propagated
into xfsprogs 4.2.0-rc1. The trans type code in logprint is really
for legacy filesystems with kernels older than 3.0.
I don't see much point in trying to hack legacy support
into the TOT diagnostic tool, especailly as it is trivial to pull
a logprint from a previous release if such support is actually
necessary. e.g:

$ git checkout -b old_logprint v3.2.3
$ make

And now you have a logprint/xfs_logprint binary that you can use for
diagnostics of the pre-delaylog log format.

Removing functionality from the TOT code base does not mean that
functionality is lost - it's still in the revision contorl system
and a minute away from being usable if it's ever needed.

> > IOWs, most of the logprint code is for printing log information from
> > pre-delaylog kernels. IOWs, for the anyone using a 3.0+ kernel, the
> > "trans type" output from xfs_logprint is completely useless
> > information, so we should probably either put it behind a command
> > line option or remove it completely...
> I prefer the command line option over removing it. Pre-delaylog kernel
> need it and some cases of xfstests rely on the transaction type string.
> 
> The command line will be used to tell whether or not it is a delaylog-enabled
> xfs, and if it's a v5 superblock, it must be a delaylog-enabled xfs.

Users won't know this, because "delaylog" is something that has long
been deprecated and lots of users don't even know it exists.

Really, just remove the transaction type printing from logprint and
both developers and users can continue to ignore it like we have
been for the past few years....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
