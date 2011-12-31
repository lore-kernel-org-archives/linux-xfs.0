Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBVLo1ID255113
	for <linux-xfs@oss.sgi.com>; Sat, 31 Dec 2011 15:50:07 -0600
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id RwzcLFzLdqTFmThv for <linux-xfs@oss.sgi.com>;
	Sat, 31 Dec 2011 13:49:58 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Rh6oP-00045K-4P
	for linux-xfs@oss.sgi.com; Sat, 31 Dec 2011 22:49:57 +0100
Received: from 75-134-99-39.dhcp.aldl.mi.charter.com ([75.134.99.39])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 31 Dec 2011 22:49:57 +0100
Received: from mlueck by 75-134-99-39.dhcp.aldl.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 31 Dec 2011 22:49:57 +0100
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Why does xfsdump encounter "WARNING: could not get list of non-root
	attributes for nondir ino nnnn: Cannot allocate memory (12)"?
Date: Sat, 31 Dec 2011 16:50:27 -0500
Message-ID: <jdo01m$62j$1@dough.gmane.org>
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

Happy old year! ;-)

Running XFS on Ununtu 10.04 LTS, I have noticed more warnings with XFS dump the longer the system has been up. A reboot cuts down on the number of warnings xfsdump encounters. An example run of 
xfsdump is as follows:

/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.0.4 (dump format 3.0) - Running single-threaded
/usr/sbin/xfsdump: level 0 dump of ldslnx01:/srv
/usr/sbin/xfsdump: dump date: Sat Dec 31 15:25:42 2011
/usr/sbin/xfsdump: session id: b56b3cd7-30d6-44b4-a8a4-e131ee70b60d
/usr/sbin/xfsdump: session label: "data"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 115786343168 bytes
/usr/sbin/xfsdump: WARNING: no media label specified
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 234778: Cannot allocate memory (12)
/usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 234813: Cannot allocate memory (12)
/usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 1828443: Cannot allocate memory (12)
/usr/sbin/xfsdump: WARNING: could not get list of root attributes for nondir ino 1828443: Cannot allocate memory (12)
/usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 2234019: Cannot allocate memory (12)
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 115563111376 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 115472209824 bytes
/usr/sbin/xfsdump: dump complete: 4099 seconds elapsed
/usr/sbin/xfsdump: Dump Status: SUCCESS

Could someone please explain what is going on, and why a freshly rebooted system would result in less / no errors?

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
