Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN4XM0q025064
	for <linux-xfs@oss.sgi.com>; Thu, 22 Nov 2012 22:33:23 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id a2atLN4frg4z1Gh3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 20:35:34 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1TbkzO-0001XU-Ea
	for linux-xfs@oss.sgi.com; Fri, 23 Nov 2012 05:35:42 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 05:35:42 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 05:35:42 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: high load and xfsaild in d
Date: Thu, 22 Nov 2012 20:34:06 -0800
Message-ID: <uua3o9x9q5.ln2@goaway.wombat.san-francisco.ca.us>
References: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
	<20121123025624.GC32450@dastard>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2012-11-23, Dave Chinner <david@fromorbit.com> wrote:
> That's a side effect of a minimal set of bug fixes that were needed
> to avoid a load related log space hang. Those fixes disabled the
> aild idling logic so the aild acts as a watchdog, so they wake up
> every 50ms to check if there's anything to do. You'll find that
> 3.0.x stable kernels have the same behaviour.
>
> The aild idling logic was re-enabled in mainstream kernels after the
> root cause of the log space hangs was diagnosed and fixed, but I
> can't see it ever being re-enabled in a CentOS 6.3 kernel....

Thanks for the clarification, Dave.  It sounds like I would need to
either wait for this fix to hit the CentOS release kernel, or compile my
own.  Is this likely to be an actual problem short-term, or should it
safe to put off any fixes for a few weeks?  If it's a potential problem
beyond just impacting the system load, I'd want to try to fix it sooner.

Do you know why I might not see this behavior on a different CentOS 6.x
kernel?

Linux xxxxxx 2.6.32-279.5.2.el6.x86_64 #1 SMP Fri Aug 24 01:07:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

This kernel has its one aild thread in state S.  Is the bug state an
issue if there's more than one XFS filesystem mounted?  Aside from nfsd
and smbd (and the storage backend), that's the only obvious difference
I can find between the two boxes.  Seems unlikely, but IIRC the original
bug was a very rare case.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
