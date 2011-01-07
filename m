Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07NfH3F141970 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 17:41:18 -0600
Received: from homer.ka9q.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C47724AAA8
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 15:43:27 -0800 (PST)
Received: from homer.ka9q.net (homer.ka9q.net [75.60.237.89]) by cuda.sgi.com
	with ESMTP id PWDGLIjwfOkQuKmh for <xfs@oss.sgi.com>;
	Fri, 07 Jan 2011 15:43:27 -0800 (PST)
Message-ID: <4D27A51A.1090207@ka9q.net>
Date: Fri, 07 Jan 2011 15:43:22 -0800
From: Phil Karn <karn@ka9q.net>
MIME-Version: 1.0
Subject: Re: TRIM details
References: <4D2686ED.7000304@philkarn.net>
	<20110107091120.GA6634@citd.de>	<4D271F8D.3030404@ka9q.net>
	<yq1ei8oodz2.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1ei8oodz2.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: xfs@oss.sgi.com

On 1/7/11 8:50 AM, Martin K. Petersen wrote:

> ATA does not have WRITE SAME. It's a SCSI command.

Ah. I keep thinking that the ATA commands are the same as SCSI commands
because Linux does a pretty good job of making ATA drives look as though
they're SCSI, but they're not a 1-1 mapping.

> But the fact remains that drives don't implement this. They do implement
> DSM TRIM. Even if the drives did support zero detection we'd have no way
> of getting the information to them short of sending a bazillion zeroes
> down the pipe.

I know.

> And why would the drive vendors add support for a
> crappier interface when DSM exists?

The *only* reason I suggest this is to make it possible to manually TRIM
a drive when the file system and/or device driver don't yet support the
explicit device-level TRIM command.

RAID subsystems are another obstacle to TRIM, but I don't quite see the
point in using RAID with SSDs, or especially why so many people seem to
want to do RAID-0 with SSDs. SSDs already implement something much like
RAID-0 internally, i.e., interleaving for speed, which is why the bigger
SSDs are generally faster than the smaller ones until the interface
saturates. At that point you're better off abandoning SATA and attaching
the SSD subsystem directly to the processor over a PCI-e path, as in the
OCX Revo drives.

The implicit TRIM-with-zeroes feature I suggest wouldn't have to be in
every drive. You wouldn't have to use it even if it were there. And I
will certainly use your new XFS code as soon as it's stable enough to go
into the production kernel.

But the many concerned about the lack of TRIM support in their
proprietary, closed-source OS/FS of choice could select such a drive and
trim manually at the application layer until (or if) their vendor
finally gets around to supporting explicit device-level TRIM. OSX still
doesn't have it, which is surprising given how many SSDs Apple has sold
in MacBooks -- and how much they charge for them.

This is not something I'd expected to be of direct use by those who use
XFS. But you've obviously been thinking a lot about SSDs and TRIM in
general so I knew you'd have some useful comments on the idea. I really
ought to approach an SSD vendor with this idea, but I don't know anybody
who works for one. Thanks for your ideas.

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
