Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DGljcV148673 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 10:47:45 -0600
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id LLhENNnPYIPKN7zj for
	<xfs@oss.sgi.com>; Fri, 13 Jan 2012 08:47:41 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 8A5474C843D
	for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 17:47:37 +0100 (CET)
Date: Fri, 13 Jan 2012 17:47:39 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: xfs version and kernels
Message-ID: <20120113174739.26ae0c07@harpe.intellique.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Today, for the second time in a couple of weeks I had an XFS filesystem
that was set up (and filled up) running some kernel that I was unable
to mount on a machine running an older kernel.

The first time, it was a volume mkfs'd on some recent OpenSuse (kernel
version unknown), that couldn't mount on a RedHat 5.3 (antediluvian
kernel 2.6.18-128.el5 ).

running xfs_db version gave this:

versionnum [0xb4a4+0xa] =
V4,NLINK,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT


Today, a volume mkfs'd running 2.6.35 couldn't mount on 2.6.20. I
fortunately was able to update the running kernel to 2.6.32, and that
worked fine from there.

This FS had this version flags :
versionnum [0xb5a4+0xa] =
V4,NLINK,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT

The native xfs tools would create an XFS with these flags instead:
versionnum [0x3094+0x0] = V4,ATTR,ALIGN,DIRV2,EXTFLG

Is there some way out of a kernel upgrade, to mount a recent XFS volume
on an older system? Particularly on these goddamned RHEL 5.x systems
which are both so very common and very out of date?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
