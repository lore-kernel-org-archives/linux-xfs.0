Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0241dxx023004 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 22:01:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2068176A80A
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 20:01:37 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id psF2aTxVLDAeiApO for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 20:01:37 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 1A461AC6273
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 22:01:38 -0600 (CST)
Message-ID: <495D91A0.4050304@sandeen.net>
Date: Thu, 01 Jan 2009 22:01:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: oopses in xfs_attr_shortform_* on kerneloops.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

I noticed this on kerneloops.org and pinged Christoph about it but I'll
go ahead & point it out here & file a bug so it doesn't get lost:

http://www.kerneloops.org/search.php?search=xfs_attr_shortform&btnG=Function+Search

would seem to indicate a problem, though not a (recent) regression anyway.

Many traces like:

RIP: 0010:[<ffffffff8802e346>]  [<ffffffff8802e346>]
:xfs:xfs_attr_shortform_getvalue+0x27/0xf3
...
Call Trace:
 [<ffffffff8802ce07>] :xfs:xfs_attr_fetch+0xba/0x114
 [<ffffffff810cc227>] ? inotify_d_instantiate+0x1a/0x42
 [<ffffffff8802cf12>] :xfs:xfs_attr_get+0xb1/0xd1
 [<ffffffff8802cf50>] :xfs:attr_generic_get+0x1e/0x2e
 [<ffffffff880713fb>] :xfs:xfs_vn_getxattr+0x86/0x95
 [<ffffffff810be6ff>] vfs_getxattr+0xa1/0xb4
 [<ffffffff810be7ae>] getxattr+0x9c/0xfb
 [<ffffffff810b9f8a>] ? mntput_no_expire+0x20/0x85
 [<ffffffff810ab1c5>] ? path_put+0x2c/0x30
 [<ffffffff810adc45>] ? path_walk+0xb6/0xc3
 [<ffffffff810adfee>] ? do_path_lookup+0x1d6/0x231
 [<ffffffff810acb45>] ? putname+0x30/0x39
 [<ffffffff810aea41>] ? __user_walk_fd+0x4c/0x5c
 [<ffffffff810be8e2>] sys_lgetxattr+0x53/0x73
 [<ffffffff810a7343>] ? sys_newlstat+0x31/0x3c
 [<ffffffff8100bedb>] system_call_after_swapgs+0x7b/0x80

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
