Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9E1j9HC227860
	for <linux-xfs@oss.sgi.com>; Thu, 13 Oct 2011 20:45:12 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 784E31C7267
	for <linux-xfs@oss.sgi.com>; Thu, 13 Oct 2011 18:45:07 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id DmkNLwCC46fI2m86 for <linux-xfs@oss.sgi.com>;
	Thu, 13 Oct 2011 18:45:07 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1REWpd-00040t-EM
	for linux-xfs@oss.sgi.com; Fri, 14 Oct 2011 03:45:05 +0200
Received: from ip-89-176-6-41.net.upcbroadband.cz ([89.176.6.41])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 03:45:05 +0200
Received: from zkaspar82 by ip-89-176-6-41.net.upcbroadband.cz with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 14 Oct 2011 03:45:05 +0200
From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Advanced Format drive - sectsz question
Date: Fri, 14 Oct 2011 03:38:14 +0200
Message-ID: <j783rh$gn7$1@dough.gmane.org>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hello list, I have hard drive which reports:

logical_block_size  ->  512
physical_block_size -> 4096

Default mkfs.xfs sets sectsz to 512.

kernel-2.6.32-131.17.1.el6.x86_64
xfsprogs-3.1.1-4.el6.x86_64

Is mkfs.xfs -s size=4096 the right way?

TIA!, Z.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
