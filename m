Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GKfbdo244718 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 15:41:37 -0500
Received: from mail.hq.newdream.net (mail.hq.newdream.net [66.33.206.127]) by
	cuda.sgi.com with ESMTP id ax2TTOVTyXMOEWft for
	<xfs@oss.sgi.com>; Mon, 16 Apr 2012 13:41:36 -0700 (PDT)
Received: from mail.hq.newdream.net (localhost [127.0.0.1])
	by mail.hq.newdream.net (Postfix) with ESMTP id 48C6524493
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 13:44:31 -0700 (PDT)
Received: from [172.22.22.4] (c-71-195-31-37.hsd1.mn.comcast.net
	[71.195.31.37])
	by mail.hq.newdream.net (Postfix) with ESMTPSA id 126D024492
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 13:44:30 -0700 (PDT)
Message-ID: <4F8C83FE.30406@dreamhost.com>
Date: Mon, 16 Apr 2012 15:41:34 -0500
From: Alex Elder <elder@dreamhost.com>
MIME-Version: 1.0
Subject: Re: BUG: task blocked on waiter in xfs_trans_dqlockedjoin()
References: <4F8C1FDD.70600@dreamhost.com>
In-Reply-To: <4F8C1FDD.70600@dreamhost.com>
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
To: xfs@oss.sgi.com

On 04/16/2012 08:34 AM, Alex Elder wrote:
> I am getting the following warning while running xfstests. I haven't
> started looking at it closely yet, but I wanted to report it so others
> could have a look. The XFS code in use was at commit c922bbc819,
> with ad637a10f4 cherry-picked on top of it. The tests all passed,
> so now I'm going to have to narrow down which test produces the failure
> (it was not near the first, nor the last test...).

I have reproduced the problem running only test 232:
# Run fsstress with quotas enabled and verify accounted quotas in the end


There is very little to this test (other than running fsstress).
It's basically:
   quotacheck -u -g $SCRATCH_MNT 2>/dev/null
   quotaon -u -g $SCRATCH_MNT 2>/dev/null
   _check_quota_usage
   _fsstress

Now I'll look a little closer at the XFS path, and will try to
grab some extra information while reproducing it.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
