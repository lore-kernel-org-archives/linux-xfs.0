Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p640lW7B084974 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 19:47:33 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AF011EE7012
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 17:47:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nD3OvFWbZ1PZpvjB for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2011 17:47:30 -0700 (PDT)
Date: Mon, 4 Jul 2011 10:47:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39.1: (2.6.35+ probably): delaylog bug
Message-ID: <20110704004726.GU561@dastard>
References: <alpine.DEB.2.02.1107031702380.13519@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1107031702380.13519@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

On Sun, Jul 03, 2011 at 05:24:09PM -0400, Justin Piszcz wrote:
> Hello,
> 
> I help to support a system (similar to mine) with a 3ware 9750-24i4e
> and when you rm -rf a directory with too many files, the system will
> act lagged, lock up for periods of time and drop connections
> (including samba shares) to and from the host.  Its so bad it cannot
> even talk to the UPS for example (ups: communications lost, e.g.
> from nut).  This is pretty bad and I've remounted my XFS FS w/out
> delaylog but for the xfstests package, it really needs to test with
> a few million files in a directory or two, and you should easily be
> able to reproduce the problem.

http://oss.sgi.com/archives/xfs/2011-06/msg00259.html

FYI, the problem is not easy to reproduce - it requires a specific
set of conditions to exist with interrupt configuration (i.e. all on
the same CPU that the log IO completions are running) to expose the
workqueue priority inversion that the filesystem level issue
triggers.

> When the delaylog option is removed, the files are removed slowly,
> but there are no errors, SSH/samba connections do NOT drop, etc,
> please look into this, thanks.

http://oss.sgi.com/archives/xfs/2011-06/msg00463.html
http://oss.sgi.com/archives/xfs/2011-06/msg00473.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
