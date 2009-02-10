Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A9pQCP042717 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 03:51:27 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65505190B7DE
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 01:50:49 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	Dug86ztjKjiRFM5y for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 01:50:49 -0800 (PST)
Date: Tue, 10 Feb 2009 20:50:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090210095045.GL8830@disturbed>
References: <20090130222359.GB32142@theco.de>
	<20090201003744.GB24173@disturbed>
	<20090205053847.GA24841@theco.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090205053847.GA24841@theco.de>
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
To: Ralf Liebenow <ralf@theco.de>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2009 at 06:38:47AM +0100, Ralf Liebenow wrote:
> Hello !
> 
> Finally I found the time to compile and test the latest stable 2.6.28.3 kernel
> but I can reproduce it:

OK.

....

> Hmmm ... can I do something to help you find the problem ? I can
> reproduce it by creating some millon of hardlinks to files and then remove some
> million hardlinks with one "rm -rf"

Interesting. Sounds like a race between writing back the inode and
it being freed. How long does it take to reproduce the problem?
Do you have a script that you could share?

Next question - what is the setting of ikeep/noikeep in your mount
options? If you dump /proc/self/mounts on 2.6.28 it will tell us
if inode clusters are being deleted or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
