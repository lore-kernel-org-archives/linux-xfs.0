Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA0FB7CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 06:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A92E8F8039
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 04:01:10 -0700 (PDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
	by cuda.sgi.com with ESMTP id Olsb3zyKeHrb9hFn (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 04:01:07 -0700 (PDT)
Subject: Re: [PATCH] xfs_logprint: fix the transcation type string for
	delaylog-enabled fs
References: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
	<20160913070913.GG30497@dastard> <57D8A1BE.60906@huawei.com>
	<20160914053110.GM30497@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <57D92DB9.4020607@huawei.com>
Date: Wed, 14 Sep 2016 19:00:09 +0800
MIME-Version: 1.0
In-Reply-To: <20160914053110.GM30497@dastard>
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

> Tying detection of transaction type numbering to an
> unrelated on-disk feature change is simply wrong. No ifs, not buts,
> it's just wrong.
Yes, I agree with you.

> Actually, it was introduced in 3.20-rc1, aka 4.0. It was propagated
> into xfsprogs 4.2.0-rc1. The trans type code in logprint is really
> for legacy filesystems with kernels older than 3.0.
> I don't see much point in trying to hack legacy support
> into the TOT diagnostic tool, especailly as it is trivial to pull
> a logprint from a previous release if such support is actually
> necessary. e.g:
> 
> $ git checkout -b old_logprint v3.2.3
> $ make
> 
> And now you have a logprint/xfs_logprint binary that you can use for
> diagnostics of the pre-delaylog log format.
> 
> Removing functionality from the TOT code base does not mean that
> functionality is lost - it's still in the revision contorl system
> and a minute away from being usable if it's ever needed.
I just think about the compatibility things too much.

> Users won't know this, because "delaylog" is something that has long
> been deprecated and lots of users don't even know it exists.
> 
> Really, just remove the transaction type printing from logprint and
> both developers and users can continue to ignore it like we have
> been for the past few years....
Thanks for your comment.
I will send a new patch to remove the transaction type printing.




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
