Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07GmqqG089427 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 10:48:53 -0600
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC551D17216
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 08:51:02 -0800 (PST)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id Y3KcWbuxHCDAwFzf for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 08:51:02 -0800 (PST)
Subject: Re: TRIM details
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <4D2686ED.7000304@philkarn.net> <20110107091120.GA6634@citd.de>
	<4D271F8D.3030404@ka9q.net>
Date: Fri, 07 Jan 2011 11:50:09 -0500
In-Reply-To: <4D271F8D.3030404@ka9q.net> (Phil Karn's message of "Fri, 07 Jan
	2011 06:13:33 -0800")
Message-ID: <yq1ei8oodz2.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
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
To: Phil Karn <karn@ka9q.net>
Cc: xfs@oss.sgi.com

>>>>> "Phil" == Phil Karn <karn@ka9q.net> writes:

Phil> Oh, there's no question that an explicit TRIM command would be
Phil> *far* more efficient than an implicit TRIM that writes zeroes. If
Phil> nothing else, implicit TRIMming requires writing every single
Phil> sector individually, while the WRITE SAME command lets the host
Phil> wipe up to 65,536 (I think) sectors with a single command.

ATA does not have WRITE SAME. It's a SCSI command.

WRITE SAME(10) allows clearing 32MB per command on a device with
512-byte blocks. WRITE SAME(16) allows a bigger area but most drives
don't support it. Those that do often cap at 16-bits anyway (Note that
I'm talking about drives. Arrays are more flexible).

DSM TRIM allows you to clear 2GB per command with a 512-byte
payload. Several modern drives will let you clear 16GB with a 4KB
payload.


Phil> But that's not my point. My point is that if the drive could
Phil> recognize a write of 0s to a sector as an implicit TRIM, then it
Phil> would still be possible to manually trim the drive without any
Phil> support whatsoever from the device driver or file system.

But the fact remains that drives don't implement this. They do implement
DSM TRIM. Even if the drives did support zero detection we'd have no way
of getting the information to them short of sending a bazillion zeroes
down the pipe. And why would the drive vendors add support for a
crappier interface when DSM exists?

If you are set on using dd you could do zero detection in the kernel and
have the filesystem either send the data pages or issue discards for the
relevant regions if the device supports it. We pretty much have all the
infrastructure in place for that. But your time is better spent adding
FITRIM support to your filesystem of choice. XFS is done already,
Christoph posted the patches.


Phil> I don't think it would be that hard for the drive to recognize a
Phil> write of all zeroes. It already has to compute a set of Reed
Phil> Solomon parity symbols for every block written to the
Phil> drive.

That typically happens way later. There's usually a clear separation
between command processing and encoding. The zero detection needs to
happen early as it affects whether you need to mark the block in a
bitmap or allocate a real flash block.

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
