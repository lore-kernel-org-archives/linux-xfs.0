Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 14:03:39 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIM3Ul9020125
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:03:32 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78B83118778F
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:03:41 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 1i1oKAoP9BFzftfX for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 14:03:41 -0800 (PST)
Received: from [192.168.1.21] (dslb-084-057-098-054.pools.arcor-ip.net [84.57.98.54])
	by mail.lichtvoll.de (Postfix) with ESMTP id 8F7D75ADE2
	for <linux-xfs@oss.sgi.com>; Tue, 18 Dec 2007 23:03:10 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Installing grub onto a system with XFS root fs
Date: Tue, 18 Dec 2007 23:03:04 +0100
References: <20071217004945.GA13335@jdc.jasonjgw.net> <20071217230437.GA7169@jdc.jasonjgw.net> <20071218003536.GD4396912@sgi.com> (sfid-20071218_094441_108310_A0063363)
In-Reply-To: <20071218003536.GD4396912@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712182303.05098.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 18 Dezember 2007 schrieb David Chinner:
> On Tue, Dec 18, 2007 at 10:04:37AM +1100, Jason White wrote:
> > On Mon, Dec 17, 2007 at 02:28:51PM +0100, Martin Steigerwald wrote:

[...]

> > Apparently there is XFS support in Grub 2 as well, which is where all
> > development is now taking place. I hope it receives adequate testing
> > and attention before distributions start using Grub 2.
>
> I just looked at the XFS code in ithe grub 2 CVS repository and had a
> read of the wiki (http://grub.enbug.org/).
>
> From the code and the wiki, I note that there is no indication of grub
> 2 fixing the worst design mistakes in grub and is persisting with
> stuffing around with filesystem internals to find files and get block
> mappings for file data. Hence grub 2 will break just like grub if we
> ever change things on disk like the inode, directory or extent format.
> Lucky it doesn't support btree formats yet, so that won't break if we
> change them....
>
> And there's plans on doing *journal replay* for filesystems!
> (#1 item on the todo list here: http://grub.enbug.org/TodoList). That's
> an insane layering violation and completely unsupportable by anyone. I
> certainly hope this part of the plan for grub 2 never gets implemented.

Hi David!

I think it may be a good idea to contact the GRUB development team about 
your concerns. I bet they won't read this mailing list.

But how do you think GRUB is supposed the kernel and initrd without 
knowing at least enough details of the filesystem in order to load the 
file. The only other alternative I see is LILO which uses map of the 
blocks to load and thus has to be rewritten on any change.

It might be just me, but I cannot recall having trouble with GRUB and XFS 
beside that grub-install didn't work. Well grub shell always worked for 
me so I didn't bother that much.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
