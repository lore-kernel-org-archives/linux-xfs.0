Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 07:16:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BEGXaG008473
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 07:16:33 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C73ED18D6AD
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 07:15:50 -0700 (PDT)
Message-ID: <452CF770.5050902@sandeen.net>
Date: Wed, 11 Oct 2006 08:53:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Software raid 5 with XFS causing strange lockup problems
References: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>
In-Reply-To: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ian Williamson <notian@gmail.com>
Cc: xfs@oss.sgi.com

Ian Williamson wrote:
> I am running XFS on a software raid 5. I am doing this with a PCI
> controller with 4 SATA drives attached to it.
> 
> When I play my music over the network through Samba from the raid
> volume my audio client will often loose the connection. This isn't
> remediated until I restart the machine with the raid controller or
> wait for an unknown amount of time. Either way, the problem still
> persists.
> 
> Initially I though that this was Samba's fault, but I think it may be
> xfs related due to what was in /var/log/messages:
> 
> Oct  9 22:37:33 ionlinux kernel: [105657.982701] Modules linked in:
> serio_raw i2c_nforce2 pcspkr forcedeth r8169 nvidia_agp agpgart
> i2c_core psmouse sg evdev xfs dm_mod sd_mod generic sata_nv ide_disk
> ehci_hcd ide_cd cdrom sata_sil ohci_hcd usbcore libata scsi_mod
> ide_generic processor
> Oct  9 22:37:33 ionlinux kernel: [105657.982985] EIP:
> 0060:[<f8a1353e>]    Not tainted VLI
> Oct  9 22:37:33 ionlinux kernel: [105657.982986] EFLAGS: 00010246   
> (2.6.18 #1)

It looks like you've edited this a bit too much, what came before this in the logs?

Are you running on 4k stacks, out of curiosity?

-Eric
