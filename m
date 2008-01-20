Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 14:26:56 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0KMQpt3007852
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:26:53 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47FB053DDA9
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:27:10 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id SPOCesKWkCnPAsT4 for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 14:27:10 -0800 (PST)
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200801181905.05263.Martin@lichtvoll.de>
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 (sfid-20080118_105816_866313_50CC6B33)  <200801181905.05263.Martin@lichtvoll.de>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 09:30:14 +1100
Message-Id: <1200868214.9463.274.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Fri, 2008-01-18 at 19:05 +0100, Martin Steigerwald wrote:
> Hi Barry!
> 
> Am Freitag 18 Januar 2008 schrieb Barry Naujok:
> 
> > There are two mount options for enabling case-insensitivity
> > on a Unicode XFS filesystem:
> >    - "ci" - enables case-insensitivity for file names
> >    - "ciattr" - enables case-insensitivity for extended
> >                 attributes.
> 
> How do I know that I am on an Unicode XFS filesystem. Could I see this 
> with xfs_db -r -c 'sb 0' -c p <device>? Hmm, nothing unicode related in 
> there as far as I can see. The fs was created with 2.6.23, mkfs.xfs 2.9.4 
> and the mkfs options that David suggested.

You'd have created it with the magic (new) mkfs option, and the
xfs_db "version" command would tell you it was enabled.

> Do I need to backup / mkfs / restore to switch to one? I understand that I 

Yes.

> can switch between enable / disable case-insensitivity via a mount 
> option.

No.

>  Would I be able to enable unicode via xfs_db version command or 
> something like it?

Not as far as I know.  It would be more likely implemented as an
extension to xfs_repair I think, if it were ever done (the xfs_db
version command definately wont have the right kind of logic to
enable/disable this).

cheers.

-- 
Nathan
