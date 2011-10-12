Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C0ZWuj030249 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 19:35:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 449DF1918F10
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:35:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ULhItF3VsUUjER8q for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 17:35:29 -0700 (PDT)
Date: Wed, 12 Oct 2011 11:35:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111012003526.GI3159@dastard>
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
	<20111011141338.GA11808@otto.nzcorp.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111011141338.GA11808@otto.nzcorp.net>
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
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, aradford@gmail.com, xfs@oss.sgi.com

On Tue, Oct 11, 2011 at 04:13:38PM +0200, Anders Ossowicki wrote:
> On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
> > This is core VM code, and operates purely on on-stack variables except
> > for the page cache radix tree nodes / pages.  So this either could be a
> > core VM bug that no one has noticed yet, or memory corruption.  Can you
> > run memtest86 on the box?
> 
> Unfortunately not, as it is a production server. Pulling it out to memtest 256G
> properly would take too long. But it seems unlikely to me that it should be
> memory corruption.  The machine has been running with the same (ecc) memory for
> more than a year and neither the service processor nor the kernel (according to
> dmesg) has caught anything before this. It would be a rare (though I admit not
> impossible) coincidence if we got catastrophic, undetected memory corruption a
> week after attaching a new raid controller with a new disk array.

Memory corruption can be caused by more than just a bad memory
stick. You've got a brand new driver running your brand new
controller and it may still have bugs - it might be scribbling over
memory it doesn't own because of off-by-one index errors, etc. It's
much more likely that that new hardware or driver code is the cause
of your problem than an undetected ECC memory error or core VM
problem.

FWIW, if it's a repeatable problem, you might want to update the
driver and controller firmware to something more recent and see if
that solves the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
