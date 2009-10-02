Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n920cZNw131502 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 19:38:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 705F714BD647
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 17:39:57 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id GGz1RJwHzSulNqp8 for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2009 17:39:57 -0700 (PDT)
Message-ID: <4AC54BDA.20806@sandeen.net>
Date: Thu, 01 Oct 2009 19:39:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS/driver bug or bad drive?
References: <20091001232759.GA12832@opus.istwok.net>
In-Reply-To: <20091001232759.GA12832@opus.istwok.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: David Engel <david@istwok.net>
Cc: xfs@oss.sgi.com

David Engel wrote:
> Hi,
> 
> I've been trying to diagnose a suspected disk drive problem for about
> a week.  I now think the problem might be a known (and fixed) xfs or
> driver bug, but I'm not 100% sure.  I'm hoping someone here can
> confirm the problem is or isn't an xfs bug.
> 
> The drive in question is a Samsung HD753LJ.  I have two of these
> drives and have had to do three replacements for various reasons in
> <10 months of use.  In short, I don't have a lot of confidence in the
> drive, even though recent evidence seems to point elsewhere.
> 
> The problem occurs when I copy several hundred gigabytes of large
> files (MythTV recordings, to be specific) to the troublesome drive
> from another drive.  When using a stock 2.6.30.8 kernel and xfs, the
> copy eventually fails because the drive quits responding (and won't
> respond again until it is power cycled).  The failure doesn't always
> occur at the same point in the copy, but it does always occur.  Here
> is a log sample of one of the failures.
> 
> Sep 29 17:59:34 tux kernel: XFS mounting filesystem sdb1
> Sep 29 17:59:34 tux kernel: Ending clean XFS mount for filesystem: sdb1
> Sep 29 18:32:07 tux kernel: ata2.00: exception Emask 0x0 SAct 0xffff SErr 0x0 action 0x6 frozen
> Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:00:af:02:eb/04:00:17:00:00/40 tag 0 ncq 524288 out
> Sep 29 18:32:07 tux kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
...
> Sep 29 18:32:07 tux kernel: ata2: hard resetting link
> Sep 29 18:32:17 tux kernel: ata2: softreset failed (device not ready)
...

> Sep 29 18:33:07 tux kernel: ata2.00: disabled
> Sep 29 18:33:07 tux kernel: ata2.00: device reported invalid CHS sector 0
> Sep 29 18:33:07 tux last message repeated 15 times
> Sep 29 18:33:07 tux kernel: ata2: EH complete
> Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Unhandled error code
> Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> Sep 29 18:33:07 tux kernel: end_request: I/O error, dev sdb, sector 401276591
> Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Unhandled error code
> Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> Sep 29 18:33:07 tux kernel: end_request: I/O error, dev sdb, sector 401275567

These are all storage errors, not xfs.  I suppose it could be differing 
IO patterns from one fs or the other that trips it up, but nothing above 
is related to an xfs bug; any xfs problems are in response to the above 
IO errors, maybe a hardware problem or a driver problem, not sure - but 
most likely a hardware issue I think.  You might point smartctl at the 
drive and see what it says.

-Eric

> I finally decided to give some other filesystems a try to see if
> anything changed.  Low and behold it did.  Still using a stock
> 2.6.30.8 kernel, but with ext3, ext4 and jfs filesystems, the large
> copy succeeded everytime!  I then decided to try a stock 2.6.31.1
> kernel with xfs.  It worked fine, too!
> 
> My question, now, is -- is this problem a known xfs bug that was fixed
> in 2.6.31.x?  I glanced through the code changes and git log and
> didn't see any smoking gun.  If it's not an xfs bug, does anyone know
> if it might be a block driver bug (ata/ahci, in this case) that was
> only tickled by xfs?
> 
> David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
