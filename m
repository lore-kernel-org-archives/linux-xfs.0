Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p12DSlij036807
	for <linux-xfs@oss.sgi.com>; Wed, 2 Feb 2011 07:28:49 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0257C2A496A
	for <linux-xfs@oss.sgi.com>; Wed,  2 Feb 2011 05:31:15 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id 0qCMpCfGIlrvGS6X for <linux-xfs@oss.sgi.com>;
	Wed, 02 Feb 2011 05:31:15 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Pkcnf-0002rD-F9
	for linux-xfs@oss.sgi.com; Wed, 02 Feb 2011 14:31:11 +0100
Received: from 24-176-21-160.dhcp.klmz.mi.charter.com ([24.176.21.160])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Feb 2011 14:31:11 +0100
Received: from mlueck by 24-176-21-160.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 02 Feb 2011 14:31:11 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get into
	Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
Date: Wed, 02 Feb 2011 08:30:56 -0500
Message-ID: <iibmah$dlp$1@dough.gmane.org>
Mime-Version: 1.0
Reply-To: mlueck@lueckdatasystems.com
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
To: linux-xfs@oss.sgi.com

Greetings,

Somehow a reported IRIX bug with XFS got into Ubuntu 10.04 (Lucid) starting with kernel 2.6.32-27.

I am cross posting to this list in order to receive details as to what bug got in Ubuntu which has been solved in IRIX, hoping with more details Ubuntu might make the same fix.

Ubuntu has since updated their kernel to 2.6.32-28 and someone already verified at the bug report that the problem persists with that kernel version.

"Regression between 2.6.32-27 and 2.6.32-26 xfsdump SGI_FS_BULKSTAT errno = 22"
https://bugs.launchpad.net/bugs/692848

On our Ubuntu 10.04 LTS server running x86 code, this evening a kernel
update was ready for installation. I updated the kernel, rebooted
(IPL'ed), and proceeded with the backup which utilized xfsdump as we use
the xfs filesystem. Four of the xfsdump received a never before seen
error: SGI_FS_BULKSTAT errno = 22

Output as follows:
using file dump (drive_simple) strategy
version 3.0.4 (dump format 3.0) - Running single-threaded
level 0 dump of ldslnx01:/srv
dump date: Mon Dec 20 21:59:33 2010
session id: f98f8cc0-963f-41a6-9a19-a89192502bf0
session label: "data"
ino map phase 1: constructing initial dump list
ino map phase 2: skipping (no pruning necessary)
ino map phase 3: skipping (only one dump stream)
ino map construction complete
estimated dump size: 100739707392 bytes
WARNING: no media label specified
creating dump session media file 0 (media 0, file 0)
dumping ino map
dumping directories
SGI_FS_BULKSTAT failed: Invalid argument (22)
dump size (non-dir files) : 0 bytes
NOTE: dump interrupted: 79 seconds elapsed: may resume later using -R option
Dump Status: INTERRUPT

This backup file did have some size to it. The other three, backing up
smaller amounts of data, were all zero (0) length dump files.

I rebooted to the prior kernel: $ uname -a
Linux ldslnx01 2.6.32-26-generic-pae #48-Ubuntu SMP Wed Nov 24 10:31:20 UTC 2010 i686 GNU/Linux

And the same backup gets to 100% success.

Reboot to the new kernel, same failure.

I think that fairly well illustrates that the problem exists only with
the kernel update installed this evening.

<><><><>

I did come across a reference to this problem on the SGI website:

http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=relnotes&fname=/usr/relnotes/eoe
   1.6.17  Bugs fixed in IRIX 6.5.13
     + 816457:  xfsdump SGI_FS_BULKSTAT errno = 22	cxfs

So evidently it is something that has been seen and corrected in IRIX.

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
