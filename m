Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9G2tqDT176502
	for <linux-xfs@oss.sgi.com>; Fri, 15 Oct 2010 21:55:54 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A26211F5C58
	for <linux-xfs@oss.sgi.com>; Fri, 15 Oct 2010 20:11:37 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id DMw28KbdeClUEvMv for <linux-xfs@oss.sgi.com>;
	Fri, 15 Oct 2010 20:11:37 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1P6wx9-000738-5k
	for linux-xfs@oss.sgi.com; Sat, 16 Oct 2010 04:56:59 +0200
Received: from 24-176-21-160.dhcp.klmz.mi.charter.com ([24.176.21.160])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 16 Oct 2010 04:56:59 +0200
Received: from mlueck by 24-176-21-160.dhcp.klmz.mi.charter.com with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 16 Oct 2010 04:56:59 +0200
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free
	-- how much does it need?
Date: Fri, 15 Oct 2010 22:56:44 -0400
Message-ID: <i9b49c$rrp$1@dough.gmane.org>
References: <4BF7D787.4020903@tlinx.org> <20100525164244.GB18666@infradead.org>
	<4C083AAD.80906@tlinx.org>
Mime-Version: 1.0
In-Reply-To: <4C083AAD.80906@tlinx.org>
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

Greetings Linda-

I had not seen this message until this evening, and we too are running Ubuntu Lucid (10.04.1) with all updates.

/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: WARNING: could not get list of non-root attributes for nondir ino 235386: Cannot allocate memory (12)
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 98262032976 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 98162141360 bytes
/usr/sbin/xfsdump: dump complete: 3481 seconds elapsed
/usr/sbin/xfsdump: Dump Status: SUCCESS

$ uname -a
Linux ldslnx01 2.6.32-25-generic-pae #44-Ubuntu SMP Fri Sep 17 21:57:48 UTC 2010 i686 GNU/Linux

$ free -m
              total       used       free     shared    buffers     cached
Mem:          2003       1104        899          0          0       1012
-/+ buffers/cache:         92       1911
Swap:            0          0          0

Which that memory count is after the backup just completed. Usually this server draws under 512M.

Linda A. Walsh wrote:
> FWIF -- upgrading to the latest tool set seems to have caused
> these messages to "go away"...

Where did you get a newer set of xfs tools than what comes from the Ubuntu repo?

I show the following versions: $ dpkg -l|grep xfs
ii  xfsdump                                   3.0.4                             Administrative utilities for the XFS filesys
ii  xfsprogs                                  3.1.0ubuntu1                      Utilities for managing the XFS filesystem

Sincerely,

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
