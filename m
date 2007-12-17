Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Dec 2007 15:04:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBHN4W9s024103
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 15:04:36 -0800
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD499117603C
	for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 15:04:42 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id y0smsRbzZiNjR9xs for <xfs@oss.sgi.com>; Mon, 17 Dec 2007 15:04:42 -0800 (PST)
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.2/8.14.2/Debian-2) with ESMTP id lBHN4cVv007352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 10:04:38 +1100
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.2/8.14.2/Submit) id lBHN4bem007351
	for xfs@oss.sgi.com; Tue, 18 Dec 2007 10:04:37 +1100
Date: Tue, 18 Dec 2007 10:04:37 +1100
From: Jason White <jason@jasonjgw.net>
Subject: Re: Installing grub onto a system with XFS root fs
Message-ID: <20071217230437.GA7169@jdc.jasonjgw.net>
References: <20071217004945.GA13335@jdc.jasonjgw.net> <200712171428.51831.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712171428.51831.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Dec 17, 2007 at 02:28:51PM +0100, Martin Steigerwald wrote:
 
> Using grub shell manually always worked for me:
> 
> - grub
> - find /boot/grub/menu.lst
> - root <result from above command>
> - setup <place to install too> for example (hd0,0) for first harddisks MBR
> 
> Remember to copy over the contents of /usr/lib/grub/i386-pc to /boot 
> before you do a manual installation.

Thanks.

Apparently there is XFS support in Grub 2 as well, which is where all
development is now taking place. I hope it receives adequate testing and
attention before distributions start using Grub 2.

I'll gladly volunteer to be part of the beta testing once Grub 2 (and its XFS
support) reaches the point of being available for general use and beta
testing.

Also, I've added a note to the Debian bug report on this subject, referring to
this thread.
