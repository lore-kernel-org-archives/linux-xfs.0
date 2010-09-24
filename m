Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OE6UO0185230 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 09:06:31 -0500
Received: from smtp03-01.atm.binero.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53F3F14FC7D8
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:20:04 -0700 (PDT)
Received: from smtp03-01.atm.binero.net (lb-smtp01.atm.binero.net
	[195.74.38.28]) by cuda.sgi.com with ESMTP id 8vYCrWlU5885emLK
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:20:04 -0700 (PDT)
Received: from [192.168.1.128] (81-235-239-15-no92.business.telia.com
	[81.235.239.15])
	by smtp03-01.atm.binero.net (Postfix) with ESMTPSA id DED4B116340
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 16:07:23 +0200 (CEST)
From: Turbo Fredriksson <turbo@bayour.com>
Subject: No space left on device
Date: Fri, 24 Sep 2010 16:07:23 +0200
Message-Id: <A7468B16-5A58-4012-B38B-784D89566D86@bayour.com>
Mime-Version: 1.0 (Apple Message framework v1081)
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

I started with a few hundred gig on my FS
(on top of LVM which in turn is on top a bunch
of MD devices).

Slowly increasing the size with pvmove/{vg,lv}extend
etc. Yesterday, I added more disks yet again and
now have about 8Tb on one FS... ~1Tb free. But still
get the 'No space left on device'.


I've been looking through the 'Net and it
must be because I'm out of inodes (and that
the data is on the first 1Tb etc)...

I'm running on AMD 64bit (native kernel, but
Debian Lenny 32bit userland - 2.6.2[4-6] kernel).



Now, if I use (I'll try to upgrade to a newer
kernel so I can reverse) the inode64, what
impact will this have? I guess I still have
to move my firstly created 1Tb of-disk and
then back again?


The worst thing is that every time I grow
the FS, I have to reboot into a 32bit kernel:

xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument

and then back to the 64bit kernel... How will
this (system/FS) react if I go 64bit inodes?!


And how safe is this!? I just don't have the
possibility to do a full backup of all this
data, not even temporarily... I _might_ be
able to do this in a few weeks (work is ordering
a bunch of LaCie 8Tb USB/eSATA storage boxes
which I might be able to load for a few days
'to do some stress testing on' :)


References:
http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_device_after_xfs_growfs.3F
http://xfs.org/index.php/XFS_FAQ#Q:_Can_I_just_try_the_inode64_option_to_see_if_it_helps_me.3F
http://www.doc.ic.ac.uk/~dcw/xfs_16tb/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
