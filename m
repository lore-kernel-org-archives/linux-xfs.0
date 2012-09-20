Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8K9V8jc063970 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 04:31:08 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	QglUBGERLNuCVxez for <xfs@oss.sgi.com>;
	Thu, 20 Sep 2012 02:32:19 -0700 (PDT)
Message-ID: <505AE2A1.5060703@blafoo.org>
Date: Thu, 20 Sep 2012 11:32:17 +0200
From: Volker <mail@blafoo.org>
MIME-Version: 1.0
Subject: Re: OOM on quotacheck (again?)
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
In-Reply-To: <20120919205924.GC31501@dastard>
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
Cc: xfs@oss.sgi.com

Hi,

> Which implies you are running a 32 bit kernel even on 64 bit CPUs
> (e.g. R710).

My mistake. That is not yet the case, but the plan for the future.
Thanks for pointing that out.

> No surprise if you are running an i686 kernel (32 bit). You've got
> way more inodes than can fit in the kernel memory segment.

Could you slightly elaborate on that or give me a link or two which
explain the matter?

If a 32bit kernel is not supposed to work because of the number of
inodes, why does the 2.6.39.4-kernel work flawlessy on quota-checks on
the same filesystem a 3.6.0-rc5 32bit (which is supposed to work) fails on?

Doesn't that imply, that the fix submitted for 2.6.39.4 fixed a problem
which was "reinvented" by the later patch, which is now being worked
around by using a 64bit kernel for more memory?

> Running on a x86-64 kernel will make the vmalloc problem go away.
> There's very little we can do about the limited vmalloc address
> space on i686 kernels. As it is, the known recent regression in this
> space:
> 
> bcf62ab xfs: Fix overallocation in xfs_buf_allocate_memory()
> 
> $ git describe --contains bcf62ab
> v3.6-rc1~42^2~35
> 
> was fixed in 3.6-rc1, 

Confirmed. The current 3.6.0-rc5 in 64bit works doing the quota-check.
I'll do some more testing with xfs_fsr etc. and report back.

best regards
volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
