Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88ASAnx029697 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 05:28:10 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BEFC12D943A
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 03:40:03 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id GE8W0n4DSOl3rKWq for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 03:40:03 -0700 (PDT)
Message-ID: <4C876558.4050301@kernel.org>
Date: Wed, 08 Sep 2010 12:28:40 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org>
	<20100908073428.GR705@dastard> <4C87474B.3050405@kernel.org>
	<20100908082819.GV705@dastard> <4C874D55.6080402@kernel.org>
	<20100908101222.GY705@dastard>
In-Reply-To: <20100908101222.GY705@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

On 09/08/2010 12:12 PM, Dave Chinner wrote:
> Ok, so in this case if this was on CPU 1, I'd see kworker[1:0],
> kworker[1:1] and kworker[1:2] threads all accumulate CPU time?  I'm
> just trying to relate your example it to behaviour I've seen to
> check if I understand the example correctly.

Yes, you're right.  If all three works just burn CPU cycles for 5ms
then you'll only see one kworker w/ 15ms of accumulated CPU time.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
