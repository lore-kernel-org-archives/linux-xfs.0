Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7GM9G5N003677 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 17:09:17 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D58BB11D336A
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 15:18:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	SxFhxuk0nZIVdxWY for <xfs@oss.sgi.com>;
	Mon, 16 Aug 2010 15:18:54 -0700 (PDT)
Date: Tue, 17 Aug 2010 08:09:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel BUG when running xfs_fsr with 2.6.35.1
Message-ID: <20100816220941.GK10429@dastard>
References: <878w47yn36.fsf@viiru.iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <878w47yn36.fsf@viiru.iki.fi>
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
To: Arto Jantunen <viiru@debian.org>
Cc: xfs@oss.sgi.com

On Mon, Aug 16, 2010 at 11:32:29AM +0300, Arto Jantunen wrote:
> 
> Hi List,
> 
> I had a kernel BUG yesterday when running xfs_fsr on my Debian Unstable
> laptop. The kernel is upstream 2.6.35.1. I'm attaching the backtrace
> below. I haven't tried reproducing the problem yet and don't know if it is
> reproducible. I can try that, and test patches etc. if it is useful. Let me
> know if there is any other information I can provide to help with debugging.

It's not obvious what has gone wrong at all - I haven't seen
anything like this in all my recent testing, so it's something new.
The first oops implies the inode has not been joined to the
transaction, but from code inspection I cannot see how that can
happen.

What compiler did you use to build the kernel? can you reproduce the
problem at all?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
