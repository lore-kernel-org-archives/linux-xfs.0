Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 16:49:47 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH0nfMR005196
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 16:49:44 -0800
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3D8F48CA47
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 16:49:51 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 1ww150Mp85INFF3p for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 16:49:51 -0800 (PST)
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.2/8.14.2/Debian-2) with ESMTP id lBH0njmk013347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 11:49:45 +1100
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.2/8.14.2/Submit) id lBH0njsP013346
	for xfs@oss.sgi.com; Mon, 17 Dec 2007 11:49:45 +1100
Date: Mon, 17 Dec 2007 11:49:45 +1100
From: Jason White <jason@jasonjgw.net>
Subject: Installing grub onto a system with XFS root fs
Message-ID: <20071217004945.GA13335@jdc.jasonjgw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I am trying to install Grub onto a system with a single XFS partition serving
as both / and /boot.

Distribution: Debian Unstable (Sid).
Architecture: x86_64

When I run grub-install I get:
Searching for GRUB installation directory ... found: /boot/grub
Due to a bug in xfs_freeze, the following command might produce a segmentation
fault when /boot/grub is not in an XFS filesystem. This error is harmless and
can be ignored.

At this point the install script hangs and the only way to recover is to
reboot the machine (with a hard reset). Needless to say, Grub isn't installed.

Any suggestions?

Note that the installation of grub failed during the Debian installation
process for a reason that wasn't specified (no helpful error message).

I have an x86 "live CD" with grub available if that will help, but it isn't
x86_64.

Thanks.
