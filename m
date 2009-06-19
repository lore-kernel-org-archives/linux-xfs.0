Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5J9Zxbh058103 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 04:35:59 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D03C330A52C
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 02:36:23 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id zW7PtinjoEjVt9Vc
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 02:36:23 -0700 (PDT)
Received: from cerberus.net4you.net ([194.177.153.130] helo=[192.168.200.110])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.69)
	(envelope-from <mw@dermichi.com>) id 1MHaWE-0005cO-Nr
	for xfs@oss.sgi.com; Fri, 19 Jun 2009 11:36:22 +0200
Message-ID: <4A3B5C14.9070101@dermichi.com>
Date: Fri, 19 Jun 2009 11:36:20 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: XFS and atime update strangeness
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

Hi XFS-List!
As i have been playing around with atime settings recently, i noticed that XFS handles atime updates very differently than other filesystems (at least different than ext2/3/4 and reiserfs). In fact it does not record atime changes permanently, it seems that atimes are only stored in the inode cache. I was testing this on a Gentoo Box with kernel 2.6.28-gentoo-r5 and 2.6.30 Vanilla.

How to reproduce?

invincible usr # ls -lu portage/header.txt
-rw-r--r-- 1 root root 121 2009-06-18 22:06 portage/header.txt
invincible usr # date
Fri Jun 19 11:24:53 CEST 2009
invincible usr # cat portage/header.txt > /dev/null
invincible usr # ls -lu portage/header.txt
-rw-r--r-- 1 root root 121 2009-06-19 11:24 portage/header.txt
invincible usr # umount portage && mount portage
invincible usr # ls -lu portage/header.txt
-rw-r--r-- 1 root root 121 2009-06-18 22:06 portage/header.txt

So after umount && mount the atime instantly went back to the old value. I can also sometimes reproduce it by doing "sync && echo 3 > /proc/sys/vm/drop_caches". If i wait for a day the atime also reverts back. Rebooting the machine has the same effect.

I haven't found anything in the official documentation stating this. The only reference i found was a while back in the mailing list:
http://oss.sgi.com/archives/xfs/2007-10/msg00171.html

I think there should be at least some information about this behavior in the official docs and the FAQ. IMO This feature/bug of XFS also collides with the recent change to make relatime the default in kernel 2.6.30. Is there any way to enable permanent atime updates in case someone wants them?

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
