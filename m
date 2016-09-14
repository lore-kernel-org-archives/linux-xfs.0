Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 715FD7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 20:03:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33D76304066
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 18:03:12 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
	by cuda.sgi.com with ESMTP id NkRNAqBaJH0ZNp4c (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2016 18:03:06 -0700 (PDT)
Subject: Re: [PATCH] xfs_logprint: fix the transcation type string for
	delaylog-enabled fs
References: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
	<20160913070913.GG30497@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <57D8A1BE.60906@huawei.com>
Date: Wed, 14 Sep 2016 09:02:54 +0800
MIME-Version: 1.0
In-Reply-To: <20160913070913.GG30497@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>> but the value of XFS_TRANS_CHECKPOINT had been change from 42 to 40
>> by xfs commit 61e63ec (xfs: consolidate superblock logging functions),
>> so return trans_type[type] directly will be incorrect.
>> And there is no flag for delaylog testing, so the suboptimal solution
>> is to use super v5 flag instead. For pre-v5 fs used by kernel after
>> commit 61e63ec, the result of xlog_trans_type will still be incorrect.
> 
> delaylog and v5 superblocks are completely unrelated and so this is
> incorrect.
I don't agree. As we can see from the commit log, v5 superblock was supported
after making delaylog as the only option, so v5 superblock implies delaylog.

Commit 93b8a5854f247138e401471a9c3b82ccb62ff608 makes the delaylog as the only
option, and its date is "Tue Dec 6 21:58:07 2011".

Commit 04a1e6c5b222b089c6960dfc5352002002a4355f adds the support of v5 superblock,
and its date is "Wed Apr 3 16:11:31 2013".

> And so v4 filesystems are still incorrect.
> 
Partial yes: For v4 filesystem before 3.19 (commit 61e63ec), the result
is still correct.

> IOWs, most of the logprint code is for printing log information from
> pre-delaylog kernels. IOWs, for the anyone using a 3.0+ kernel, the
> "trans type" output from xfs_logprint is completely useless
> information, so we should probably either put it behind a command
> line option or remove it completely...
I prefer the command line option over removing it. Pre-delaylog kernel
need it and some cases of xfstests rely on the transaction type string.

The command line will be used to tell whether or not it is a delaylog-enabled
xfs, and if it's a v5 superblock, it must be a delaylog-enabled xfs.

I will send a v2 patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
