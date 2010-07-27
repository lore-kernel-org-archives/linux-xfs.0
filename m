Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R9M39N176487 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 04:22:03 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60127475556
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 02:25:08 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id ISctBWkhPDG4RSJb for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 02:25:08 -0700 (PDT)
Date: Tue, 27 Jul 2010 11:24:52 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100727092452.GA23307@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
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
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: xfs@oss.sgi.com

On 22.07.2010 09:47, Shawn Bohrer wrote:

I can't help with your exact problem, but this reminds me of a quite 
similar looking problem i have.

We have a linux-computer with samba to act as a fileserver for a few 
Windows-Clients and ever since kernel 2.6.26 (Never happend with 2.6.25) 
the server randomly "hangs" for a few seconds (Which is more of a 
problem that drives people crazy). It takes about 1-2 weeks for the 
symtoms to show and only a reboot of the computer "cures" it (for 
another 1-2 weeks).

Because of the long incubation period and the whole slew of subsystems 
(and samba) involded, i never had the drive to debug this, as a "quick" 
reboot every 1-2 weeks only takes about 2 minutes.

With "whole slew of subsystems" in mean:
Hardware: SATA on onboard-controller (Intel G41-Chipset(ICH7) with 
PIIX-driver, because BIOS is crippled and doesn't allow AHCI)
(Hardware itself is unlikly to be be at fault, because a few month ago 
the complete computer and HDDs were switched, but the problem persisted)

Kernel:
Currently 2.6.32(-5, Debian SID), first seen with 2.6.26 (vanilla)

Drivers/Filesystem:
md(RAID1), loop-aes, XFS
(I tried logbufs=8,logbsize=256k,nobarrier, no apparent changes. I'm 
not 100% sure if i tried other schedulers, but i think i did)

And finally Samba on top.


As i had to reboot the computer just yesterday, and will have to power 
down the server over the weekend because we are moving, it will be at 
least 2-3 weeks before i anticipate the problem to resurface.
In case anybody has an idea what i could do to identify and/or isolate 
the root-cause, i'm open for suggestions.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
