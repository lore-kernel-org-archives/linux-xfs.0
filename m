Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UH4YOO217367
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 12:04:41 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C489332B2B
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 10:05:04 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id DlpuaahFBsOw5K3N for <linux-xfs@oss.sgi.com>;
	Tue, 30 Jun 2009 10:05:04 -0700 (PDT)
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MLglS-0005m5-EO
	for linux-xfs@oss.sgi.com; Tue, 30 Jun 2009 17:05:02 +0000
Received: from inferno.cora.nwra.com ([65.44.101.162])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 17:05:02 +0000
Received: from orion by inferno.cora.nwra.com with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 17:05:02 +0000
From: Orion Poplawski <orion@cora.nwra.com>
Subject: =?utf-8?b?ZG9fSVJR?= stack overflow on 32-bit CentOS 4
Date: Tue, 30 Jun 2009 17:00:13 +0000 (UTC)
Message-ID: <loom.20090630T165732-116@post.gmane.org>
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

Just hit a:

do_IRQ: stack overflow: 452

on 32-bit CentOS 4 machine with xfs-kmod-0.4-2.el4.  Is there anything that can
be done to minimize this risk?  Running xfs over md raid5 array, exporting via
nfs.  More kernel dump messages are posted at:

http://bugs.centos.org/view.php?id=3136

Thanks!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
