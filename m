Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n91NQchj128476 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 18:26:39 -0500
Received: from cdptpa-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 415B449951A
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 16:28:00 -0700 (PDT)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.120]) by cuda.sgi.com with ESMTP id
	cCpxAlDFsW8FFkza for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2009 16:28:00 -0700 (PDT)
Received: from opus ([76.182.216.73]) by cdptpa-omta03.mail.rr.com with ESMTP
	id <20091001232800148.YQSX26368@cdptpa-omta03.mail.rr.com>
	for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 23:28:00 +0000
Date: Thu, 1 Oct 2009 18:27:59 -0500
From: David Engel <david@istwok.net>
Subject: XFS/driver bug or bad drive?
Message-ID: <20091001232759.GA12832@opus.istwok.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi,

I've been trying to diagnose a suspected disk drive problem for about
a week.  I now think the problem might be a known (and fixed) xfs or
driver bug, but I'm not 100% sure.  I'm hoping someone here can
confirm the problem is or isn't an xfs bug.

The drive in question is a Samsung HD753LJ.  I have two of these
drives and have had to do three replacements for various reasons in
<10 months of use.  In short, I don't have a lot of confidence in the
drive, even though recent evidence seems to point elsewhere.

The problem occurs when I copy several hundred gigabytes of large
files (MythTV recordings, to be specific) to the troublesome drive
from another drive.  When using a stock 2.6.30.8 kernel and xfs, the
copy eventually fails because the drive quits responding (and won't
respond again until it is power cycled).  The failure doesn't always
occur at the same point in the copy, but it does always occur.  Here
is a log sample of one of the failures.

Sep 29 17:59:34 tux kernel: XFS mounting filesystem sdb1
Sep 29 17:59:34 tux kernel: Ending clean XFS mount for filesystem: sdb1
Sep 29 18:32:07 tux kernel: ata2.00: exception Emask 0x0 SAct 0xffff SErr 0x0 action 0x6 frozen
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:00:af:02:eb/04:00:17:00:00/40 tag 0 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:08:af:06:eb/04:00:17:00:00/40 tag 1 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:10:af:0a:eb/04:00:17:00:00/40 tag 2 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:18:af:0e:eb/04:00:17:00:00/40 tag 3 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:20:af:12:eb/04:00:17:00:00/40 tag 4 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:28:af:16:eb/04:00:17:00:00/40 tag 5 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:30:af:da:ea/04:00:17:00:00/40 tag 6 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:38:af:de:ea/04:00:17:00:00/40 tag 7 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:40:af:e2:ea/04:00:17:00:00/40 tag 8 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:48:af:e6:ea/04:00:17:00:00/40 tag 9 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:50:af:ea:ea/04:00:17:00:00/40 tag 10 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:58:af:ee:ea/04:00:17:00:00/40 tag 11 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:60:af:f2:ea/04:00:17:00:00/40 tag 12 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:68:af:f6:ea/04:00:17:00:00/40 tag 13 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:70:af:fa:ea/04:00:17:00:00/40 tag 14 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2.00: cmd 61/00:78:af:fe:ea/04:00:17:00:00/40 tag 15 ncq 524288 out
Sep 29 18:32:07 tux kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 29 18:32:07 tux kernel: ata2.00: status: { DRDY }
Sep 29 18:32:07 tux kernel: ata2: hard resetting link
Sep 29 18:32:17 tux kernel: ata2: softreset failed (device not ready)
Sep 29 18:32:17 tux kernel: ata2: hard resetting link
Sep 29 18:32:27 tux kernel: ata2: softreset failed (device not ready)
Sep 29 18:32:27 tux kernel: ata2: hard resetting link
Sep 29 18:32:38 tux kernel: ata2: link is slow to respond, please be patient (ready=0)
Sep 29 18:33:02 tux kernel: ata2: softreset failed (device not ready)
Sep 29 18:33:02 tux kernel: ata2: limiting SATA link speed to 1.5 Gbps
Sep 29 18:33:02 tux kernel: ata2: hard resetting link
Sep 29 18:33:07 tux kernel: ata2: softreset failed (device not ready)
Sep 29 18:33:07 tux kernel: ata2: reset failed, giving up
Sep 29 18:33:07 tux kernel: ata2.00: disabled
Sep 29 18:33:07 tux kernel: ata2.00: device reported invalid CHS sector 0
Sep 29 18:33:07 tux last message repeated 15 times
Sep 29 18:33:07 tux kernel: ata2: EH complete
Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Unhandled error code
Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
Sep 29 18:33:07 tux kernel: end_request: I/O error, dev sdb, sector 401276591
Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Unhandled error code
Sep 29 18:33:07 tux kernel: sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
Sep 29 18:33:07 tux kernel: end_request: I/O error, dev sdb, sector 401275567

I finally decided to give some other filesystems a try to see if
anything changed.  Low and behold it did.  Still using a stock
2.6.30.8 kernel, but with ext3, ext4 and jfs filesystems, the large
copy succeeded everytime!  I then decided to try a stock 2.6.31.1
kernel with xfs.  It worked fine, too!

My question, now, is -- is this problem a known xfs bug that was fixed
in 2.6.31.x?  I glanced through the code changes and git log and
didn't see any smoking gun.  If it's not an xfs bug, does anyone know
if it might be a block driver bug (ata/ahci, in this case) that was
only tickled by xfs?

David
-- 
David Engel
david@istwok.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
