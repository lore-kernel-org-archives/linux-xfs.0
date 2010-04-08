Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o38CCQ41021568 for <xfs@oss.sgi.com>; Thu, 8 Apr 2010 07:12:26 -0500
Received: from mx1.gb1.humyo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66D462A9170
	for <xfs@oss.sgi.com>; Thu,  8 Apr 2010 05:14:17 -0700 (PDT)
Received: from mx1.gb1.humyo.com (mx1.gb1.humyo.com [62.44.71.171]) by
	cuda.sgi.com with ESMTP id 5nvHcdQZYManNfP5 for
	<xfs@oss.sgi.com>; Thu, 08 Apr 2010 05:14:17 -0700 (PDT)
Message-ID: <4BBDC92D.8060503@humyo.com>
Date: Thu, 08 Apr 2010 13:16:45 +0100
From: John Berthels <john@humyo.com>
MIME-Version: 1.0
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
	write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard>
	<4BBCAB57.3000106@humyo.com> <20100407234341.GK11036@dastard>
	<20100408030347.GM11036@dastard>
In-Reply-To: <20100408030347.GM11036@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Gregory <nick@humyo.com>, linux-mm@kvack.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Rob Sanderson <rob@humyo.com>

Dave Chinner wrote:
> On Thu, Apr 08, 2010 at 09:43:41AM +1000, Dave Chinner wrote:
>   
> And there's a patch attached that stops direct reclaim from writing
> back dirty pages - it seems to work fine from some rough testing
> I've done. Perhaps you might want to give it a spin on a
> test box, John?
>   
Thanks very much for this. The patch is in and soaking on a THREAD_ORDER 
1 kernel (2.6.33.2 + patch + stack instrumentation), so far so good, but 
it's early days. After about 2hrs of uptime:

$ dmesg | grep stack | tail -1
[   60.350766] apache2 used greatest stack depth: 2544 bytes left

(which tallies well with your 5 1/2Kbytes usage figure).

I'll reply again after it's been running long enough to draw conclusions.

jb

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
