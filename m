Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9CCThkd062318 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 07:29:43 -0500
Received: from WA2EHSNDR003.bigfish.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8595F1465B03
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 05:37:03 -0700 (PDT)
Received: from WA2EHSNDR003.bigfish.com (smtp-cpk.frontbridge.com
	[204.231.192.41]) by cuda.sgi.com with ESMTP id
	ANkE8s6uFD4EPfXp for <xfs@oss.sgi.com>;
	Wed, 12 Oct 2011 05:37:03 -0700 (PDT)
Date: Wed, 12 Oct 2011 14:29:33 +0200
From: Anders Ossowicki <aowi@novozymes.com>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111012122933.GA3719@otto.nzcorp.net>
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
	<20111011141338.GA11808@otto.nzcorp.net>
	<20111012003526.GI3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111012003526.GI3159@dastard>
Reply-To: aowi@novozymes.com
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
Cc: Christoph Hellwig <hch@infradead.org>, "aradford@gmail.com" <aradford@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Oct 12, 2011 at 02:35:26AM +0200, Dave Chinner wrote:
> Memory corruption can be caused by more than just a bad memory
> stick. You've got a brand new driver running your brand new
> controller and it may still have bugs - it might be scribbling over
> memory it doesn't own because of off-by-one index errors, etc. It's
> much more likely that that new hardware or driver code is the cause
> of your problem than an undetected ECC memory error or core VM
> problem.
Ah, now that I agree on. A few more observations from today's experiments:

First of all, there are two MegaRAID controllers in the machine. The 
old'n'reliable 8888ELP and the new'n'wonky 9285-8e. Both are using the megaraid
driver and the 8888ELP card ran with the megaraid driver prior to the 
refactoring that introduced support for 9285-8e without a hitch for about a
year.

We've gotten to a point where we can reliably reproduce this by running certain
queries in postgresql when data from the disk is cached. E.g 
 foo=# select count(*) from foo.sequence;
 ERROR:  invalid page header in block 529134 of relation base/16385/58318945

If we echo 3 >/proc/sys/vm/drop_caches and reload postgres, the same queries
work. This does indeed smell like memory corruption.

The 9285-8e controller has FastPath enabled.

> FWIW, if it's a repeatable problem, you might want to update the
> driver and controller firmware to something more recent and see if
> that solves the problem....
I upgraded the firmware (post-accident) but we're still seeing the corruption.
-- 
Anders

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
