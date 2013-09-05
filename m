Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C547C7F53
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:13:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40B9CAC006
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 05:13:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fBxzMCKAhzrXt5PM for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 05:13:40 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHYRM-0001GK-Ix
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHYRM-0004E5-Hf
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 00/12] xfs_db: write support for v5 filesystems
Date: Thu,  5 Sep 2013 22:13:21 +1000
Message-Id: <1378383213-16155-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This RFC series brings write support to xfs_db for CRC enabled
filesytsems. The series converts xfs_db to use libxfs for it's IO,
adds awareness of verifiers and CRC validation to the IO stack and
enables write support for v5 filesystem structures.

The main infrastructure change is switching to libxfs-based IO
instead of buffered block device IO. This means that xfs_db now
switches to direct IO cached in it's own address space, meaning that
when it runs it always starts with a cold cache and so we don't have
problem with it reading stale cached data out of the kernel.

With it using libxfs, we can also attach verifiers to the IO to
validate structures and CRCs before we act on them. The fact that
CRCs were passed or not is available to usres of the data that is
read, and so programs like xfs_check can be made to fail if CRC
validation fails on read of metadata.

Finally, write support is enabled because now that all data buffers
have verifiers they can recalculate CRCs on write. There's some
special support for inodes and dquots, but they will still have CRCs
recalculated before write IOs. Hence xfs_db won't corrupt v5
metadata now when you change a field value manually.

There are still some issues with the libxfs support - there are some
places where xfs_db re-reads the same block address with different
buffer lengths, resulting in libxfs throwing a cache lookup badness
warning. e.g:

$ sudo xfs_db -c "push sb" -c "p crc" /dev/vdc
7fe16ab3f740: Badness in key lookup (length)
bp=(bno 0x0, len 0 bytes) key=(bno 0x0, len 512 bytes)
Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
Use of these features is at your own risk!
crc = 0xfc7b42ec (correct)
$

This shows a buffer at block 0 was created with zero length for some
reason, but when we push the superblock onto the stack, it looks up
a buffer of 512 bytes, not 0, and it throws an error. The
experimental warning is being thrown by the superblock buffer
verifier on detecting the v5 superblock version. And the CRC of the
buffer is displayed as being correct as the verifier didn't throw a
corruption error when it ran.

This output currently causes all sorts of problems for xfstests -
the root inode cluster is another that causes issues, and there are
also cases occurring where cache purging on unmount is throwing
warnings. Hence it's not yet ready for merge, but otherwise it seems
to work reliably enough to use. Early review and testing would be
helpful at this point.

These changes also mean that we should be able to turn metadump back
on, as it needs CRC write support for the obfuscation code to
work on v5 filesystems. Patches will be coming shortly to do that.

xfs_check is still an open question. I might just re-enable it and
add CRC validation checks and see what falls out from that, without
adding any extra validation for the v5 filesystem format bits...

Comments, thoughts, flames?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
