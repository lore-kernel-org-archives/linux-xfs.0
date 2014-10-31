Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F3687F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 22:49:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E47B30404E
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 20:49:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JTfo0d2OMD5ejZRD for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 20:49:39 -0700 (PDT)
Date: Fri, 31 Oct 2014 14:49:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141031034925.GM13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
	<20141030230457.GK13323@dastard> <20141031000954.GL13323@dastard>
	<CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8dP7nah4QuXYk_S8KbEu4Y6ZiT7tXz7dMLkwZ=VTkKQXA@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Fri, Oct 31, 2014 at 09:51:27AM +0800, Tommy Wu wrote:
> After apply this patch, xfsdump will hang again.
> 
> the log for xfsdump:
> https://mega.co.nz/#!tUgz3QrC!q7Ix53sl9lYCg0iKRHjgOqF0tZJAVKHBNz0OHWof-ds
> 
> But 'echo w > /proc/sysrq-trigger' no any blocked task in dmesg.

echo l > /proc/sysrq-trigger
echo t > /proc/sysrq-trigger

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
