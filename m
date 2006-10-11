Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 09:22:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BGMZaG022487
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 09:22:36 -0700
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A10B4D18D6D2
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 09:21:53 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id o25so446289nfa
        for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 09:21:52 -0700 (PDT)
Message-ID: <acd894d40610110921j61bcf5cdn57887c386f54f6c8@mail.gmail.com>
Date: Wed, 11 Oct 2006 11:21:51 -0500
From: "Ian Williamson" <notian@gmail.com>
Subject: Re: Software raid 5 with XFS causing strange lockup problems
In-Reply-To: <452CF770.5050902@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>
	 <452CF770.5050902@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Eric,
That's all I have for the event in /var/log/messages..

For the raid configuration I have the following:
ian@ionlinux:~$ sudo mdadm --detail /dev/md0
Password:
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Sep 13 22:04:11 2006
     Raid Level : raid5
     Array Size : 732587712 (698.65 GiB 750.17 GB)
    Device Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Oct  9 00:02:30 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 86770f56:8e4f51e5:fd754630:f1c65359
         Events : 0.54082

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1

I really have no idea what could be causing this. Sometimes after
restart it still won't work through Samba, and I can never perform
massive local reads and writes, i.e. a recursive copy off of the raid.

On 10/11/06, Eric Sandeen <sandeen@sandeen.net> wrote:
> Ian Williamson wrote:
> > I am running XFS on a software raid 5. I am doing this with a PCI
> > controller with 4 SATA drives attached to it.
> >
> > When I play my music over the network through Samba from the raid
> > volume my audio client will often loose the connection. This isn't
> > remediated until I restart the machine with the raid controller or
> > wait for an unknown amount of time. Either way, the problem still
> > persists.
> >
> > Initially I though that this was Samba's fault, but I think it may be
> > xfs related due to what was in /var/log/messages:
> >
> > Oct  9 22:37:33 ionlinux kernel: [105657.982701] Modules linked in:
> > serio_raw i2c_nforce2 pcspkr forcedeth r8169 nvidia_agp agpgart
> > i2c_core psmouse sg evdev xfs dm_mod sd_mod generic sata_nv ide_disk
> > ehci_hcd ide_cd cdrom sata_sil ohci_hcd usbcore libata scsi_mod
> > ide_generic processor
> > Oct  9 22:37:33 ionlinux kernel: [105657.982985] EIP:
> > 0060:[<f8a1353e>]    Not tainted VLI
> > Oct  9 22:37:33 ionlinux kernel: [105657.982986] EFLAGS: 00010246
> > (2.6.18 #1)
>
> It looks like you've edited this a bit too much, what came before this in the logs?
>
> Are you running on 4k stacks, out of curiosity?
>
> -Eric
>


-- 
Ian Williamson
