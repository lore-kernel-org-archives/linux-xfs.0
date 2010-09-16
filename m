Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GKEHTF014158
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 15:14:20 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41038180A9BD
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:15:06 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id Oym5lmHy0sRU4H0d for <linux-xfs@oss.sgi.com>;
	Thu, 16 Sep 2010 13:15:06 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OwKrH-0002gf-Kk
	for linux-xfs@oss.sgi.com; Thu, 16 Sep 2010 22:15:03 +0200
Received: from p4fd4a76f.dip0.t-ipconnect.de ([79.212.167.111])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 22:15:03 +0200
Received: from Manuel.Spam by p4fd4a76f.dip0.t-ipconnect.de with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 16 Sep 2010 22:15:03 +0200
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: System partially unusable after power loss...
Date: Thu, 16 Sep 2010 22:10:52 +0200
Message-ID: <i6ttq6$41d$1@dough.gmane.org>
Mime-Version: 1.0
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

Hello,

Kernel is 2.6.27.7.

My Problem started as I got called, that login from KDM is not longer 
possible. In fact, the KDE login is possible, but soon after entering 
the password, a "kbuildsycoca" hangs and takes 100% CPU. Shortly before 
this happened, power was abruptly lost.

I rebooted to a live CD. As, for some reason, xfs_check was broken on 
that live CD (something with "db" in it was missing), I directly ran 
xfs_repair on the broken hard drive and it found some zero byte files 
and two files with ELF header, which may be (a part of) library files, I 
don't know, as the name wasn't restored.

Is it possible to find out what exactly happened to cause this system to 
be unusable? For me it seems like those restored ELF files are 
something, needed by KDE to start up properly. Why did library files get 
destroyed, the user, using this PC, isn't able to write to? Doesn't this 
mean, they don't get into a write cache and even a power loss can't 
destroy them?

Yours

Manuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
