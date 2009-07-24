Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OEX4uC132798 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 09:33:05 -0500
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37DA3131052F
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:42:11 -0700 (PDT)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id lZGVbraxruysv0hq for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:42:11 -0700 (PDT)
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 33B714B014B
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 16:33:43 +0200 (CEST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 41A8A4B014E
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 16:33:41 +0200 (CEST)
Date: Fri, 24 Jul 2009 16:33:45 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: A question about installing XFS filesystem support on Debian Lenny
Message-ID: <20090724163345.5e8e6364@harpe.intellique.com>
In-Reply-To: <3ec42bdd0907240652q1bfb6784n9ba1c9e931b58900@mail.gmail.com>
References: <3ec42bdd0907240652q1bfb6784n9ba1c9e931b58900@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le Fri, 24 Jul 2009 21:52:06 +0800
feiji1983@gmail.com =E9crivait:

> i recenttly got a NAS hard disk box which run Debian Lenny ,the linux
> kernel is 2.6.29. I can install xfsprogs with apt-get , after
> formatting  a partition using mkfs.xfs,  i can't mount it with command
> "mount -t xfs XXX XXX" , it says "xfs" is not supported. i think i
> have to install a path,but can't find one using apt-get,can any body
> tell me how can i fix this problem? Thanks.

The standard Debian Lenny kernel is 2.6.26, and comes with built-in xfs
support. If you're using some custom kernel, check that it was properly
compiled with xfs support (see in /boot/config-2.6.xxxxxx if there's
CONFIG_XFS_FS=3Dm or CONFIG_XFS_FS=3Dy ), or that there isn't an optional
package for some kernel modules.

-- =

----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
