Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07EBSua064101 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 08:11:28 -0600
Received: from homer.ka9q.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26B2B153A499
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 06:13:37 -0800 (PST)
Received: from homer.ka9q.net (homer.ka9q.net [75.60.237.89]) by cuda.sgi.com
	with ESMTP id XXwUY5qmc34xFQCn for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 06:13:37 -0800 (PST)
Message-ID: <4D271F8D.3030404@ka9q.net>
Date: Fri, 07 Jan 2011 06:13:33 -0800
From: Phil Karn <karn@ka9q.net>
MIME-Version: 1.0
Subject: Re: TRIM details
References: <4D2686ED.7000304@philkarn.net> <20110107091120.GA6634@citd.de>
In-Reply-To: <20110107091120.GA6634@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On 1/7/11 1:11 AM, Matthias Schniedermeyer wrote:

> The drive would have to look into each written sector in the off chance 
> that it might be 0, that's a lot of electrons you have to burn for not 
> much gain. And that's ignoring the performance side, doing such a check 
> on each incoming write would be expensive at best.

Oh, there's no question that an explicit TRIM command would be *far*
more efficient than an implicit TRIM that writes zeroes. If nothing
else, implicit TRIMming requires writing every single sector
individually, while the WRITE SAME command lets the host wipe up to
65,536 (I think) sectors with a single command.

But that's not my point. My point is that if the drive could recognize a
write of 0s to a sector as an implicit TRIM, then it would still be
possible to manually trim the drive without any support whatsoever from
the device driver or file system.

You could use a standard copy command, provided you have something like
/dev/zero, or you could write a simple application that wouldn't even
need root privileges (assuming it didn't need to get around any quotas
when creating the temporary file). And it would work for any file system
and any operating system while we're waiting for native TRIM support
(I'm still waiting for TRIM support for HFS+ in Mac OSX).

I don't think it would be that hard for the drive to recognize a write
of all zeroes. It already has to compute a set of Reed Solomon parity
symbols for every block written to the drive. That's quite a bit more
work than merely seeing if the block is all 0's.

You could even use the existing Reed-Solomon encoder to optimize the
process though I doubt it would really be necessary. The RS parities for
an all-0 data block are also all 0. If any of the parities are non zero,
then it can't be a block of 0's. If the parities are all zero, then
confirm in software that the data is all 0's; you'll have very few false
alarms.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
