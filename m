Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UHqGMf219664
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 12:52:16 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62A781307020
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 10:59:02 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 03fKKWaY0HQPnTRM for
	<linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 10:59:02 -0700 (PDT)
Message-ID: <4A4A50EC.4090201@sandeen.net>
Date: Tue, 30 Jun 2009 12:52:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: do_IRQ stack overflow on 32-bit CentOS 4
References: <loom.20090630T165732-116@post.gmane.org>
In-Reply-To: <loom.20090630T165732-116@post.gmane.org>
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
To: Orion Poplawski <orion@cora.nwra.com>
Cc: linux-xfs@oss.sgi.com

Orion Poplawski wrote:
> Just hit a:
> 
> do_IRQ: stack overflow: 452
> 
> on 32-bit CentOS 4 machine with xfs-kmod-0.4-2.el4.  Is there anything that can
> be done to minimize this risk?  Running xfs over md raid5 array, exporting via
> nfs.  More kernel dump messages are posted at:
> 
> http://bugs.centos.org/view.php?id=3136

get an x86_64 machine ;)

The stack overflow message is misleading; it means you have 452 -left-

unfortunately on some kernels, simply printing that message actually
consumes what's left, and more.  See http://lkml.org/lkml/2007/8/29/245

This was fixed in 2.6.18-108.el5 and beyond.

Upstream has some xfs stack size fixes; this may eventually make it to a
centos near you.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
