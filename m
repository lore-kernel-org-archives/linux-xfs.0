Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 09:14:29 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DGEPbm020762
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 09:14:27 -0700
Date: Fri, 13 Jul 2007 12:14:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS + RAID1 strange message
In-Reply-To: <20070713151058.GA24153@gepard>
Message-ID: <Pine.LNX.4.64.0707131213560.15808@p34.internal.lan>
References: <20070713151058.GA24153@gepard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dawid 'Kuba' Chrzan <qba@f-net.pl>
Cc: xfs@oss.sgi.com

You have hit the infamous 2.6.17-2.6.17.6 bug.

Check the XFS FAQ, I suggest you backup your files and re-format, happened 
to me too with a SW MD RAID1, kind of defats the purpose of RAID1; hence, 
backups :)

Justin.

On Fri, 13 Jul 2007, Dawid 'Kuba' Chrzan wrote:

> Hi
>
> I got linux box
> Linux gepard 2.6.17-pp3 #6 SMP Tue Feb 13 12:50:39 CET 2007 i686 unknown
>
> 2 brand new sata WDC RAPTOR disks
>
> SCSI device sda: 72303840 512-byte hdwr sectors (37020 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: drive cache: write back
> SCSI device sda: 72303840 512-byte hdwr sectors (37020 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: drive cache: write back
> sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
> sd 0:0:0:0: Attached scsi disk sda
> SCSI device sdb: 72303840 512-byte hdwr sectors (37020 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: drive cache: write back
> SCSI device sdb: 72303840 512-byte hdwr sectors (37020 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: drive cache: write back
>  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
>  sd 1:0:0:0: Attached scsi disk sdb
>
> with raid1 on them done by mdadm
>
>
> Jul 12 18:25:14 gepard kernel: raid1: raid set md0 active with 2 out of
> 2 mirrors
> Jul 12 18:25:14 gepard kernel: md: ... autorun DONE.
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem md1
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> md1
> Jul 12 18:25:14 gepard kernel: VFS: Mounted root (xfs filesystem)
> readonly.
>
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem md2
> Jul 12 18:25:14 gepard kernel: Starting XFS recovery on filesystem: md2
> (logdev: internal)
> Jul 12 18:25:14 gepard kernel: Ending XFS recovery on filesystem: md2
> (logdev: internal)
> Jul 12 18:25:14 gepard kernel: Filesystem "md0": Disabling barriers, not
> supported by the underlying device
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem md0
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> md0
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem sdc1
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> sdc1
> Jul 12 18:25:14 gepard kernel: Filesystem "md3": Disabling barriers, not
> supported by the underlying device
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem md3
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> md3
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem sdc2
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> sdc2
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem sdc5
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> sdc5
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem sdc6
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> sdc6
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem hda1
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> hda1
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem sdc7
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> sdc7
> Jul 12 18:25:14 gepard kernel: Filesystem "md4": Disabling barriers, not
> supported by the underlying device
> Jul 12 18:25:14 gepard kernel: XFS mounting filesystem md4
> Jul 12 18:25:14 gepard kernel: Ending clean XFS mount for filesystem:
> md4
> Jul 12 18:25:14 gepard kernel: Filesystem "md5": Disabling barriers, not
> supported by the underlying device
> Jul 12 18:25:15 gepard kernel: XFS mounting filesystem md5
> Jul 12 18:25:15 gepard kernel: Ending clean XFS mount for filesystem:
> md5
>
> When i reboot , halt the server i always get
> Jul 12 18:25:14 gepard kernel: Starting XFS recovery on filesystem: md2
> (logdev: internal)
> Jul 12 18:25:14 gepard kernel: Ending XFS recovery on filesystem: md2
> (logdev: internal)
>
> such errors. Only on md2.
> qba@gepard:~$ mount  | grep md2
> /dev/md2 on /usr type xfs (rw)
>
>
> I tried to disable Write Cache but without success.
>
> [root@gepard log]#hdparm -W0 /dev/sda
>
> /dev/sda:
> operation not supported on SCSI disks
>
> [root@gepard log]#sginfo -c /dev/sda
> Caching mode page (0x8)
> -----------------------
> Initiator Control                  0
> ABPF                               0
> CAP                                0
> DISC                               0
> SIZE                               0
> Write Cache Enabled                1
> MF                                 0
> Read Cache Disabled                0
> Demand Read Retention Priority     0
> Demand Write Retention Priority    0
> Disable Pre-fetch Transfer Length  0
> Minimum Pre-fetch                  0
> Maximum Pre-fetch                  0
> Maximum Pre-fetch Ceiling          0
> FSW                                0
> LBCSS                              0
> DRA                                0
> Number of Cache Segments           0
> Cache Segment size                 0
> Non-Cache Segment size             0
>
> [root@gepard log]# sginfo -cXR /dev/sda 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0
> >>> Unable to store Caching mode page 0x8 [msel_10]
>
> [root@gepard log]#sginfo -c /dev/sda | grep -i write
> Write Cache Enabled                1
>
>
> I checked the log
> [root@gepard log]#xfs_logprint /dev/md2
> xfs_logprint:
> xfs_logprint: /dev/md2 contains a mounted and writable filesystem
>    data device: 0x902
>        log device: 0x902 daddr: 2931744 length: 20480
>
>        Header 0x3 wanted 0xfeedbabe
>        **********************************************************************
>        * ERROR: header cycle=3           block=13539
>        * *
>        **********************************************************************
>        Bad log record header
>
> The disks seems to be OK
>
> [root@gepard log]#badblocks -s -v -c 512 /dev/sda5
> Checking for bad blocks in read-only mode
>> From block 0 to 2931831
> Checking for bad blocks (read-only test): done
> Pass completed, 0 bad blocks found.
> [root@gepard log]#badblocks -s -v -c 512 /dev/sdb5
> Checking for bad blocks in read-only mode
>> From block 0 to 2931831
> Checking for bad blocks (read-only test): done
> Pass completed, 0 bad blocks found.
>
>
>
> Is it normal message , and i should not worry about it?
>
> Thank You for any info and suggestions.
>
> -- 
> Pozdrawiam, Dawid 'Kuba' Chrzan
> http://f-net.pl  qba_nospam_@f-net.pl
> RLU#212729   net/sys administrator
>
> "Computer games don't affect kids; I mean if Pac-Man affected us as
> kids, we'd all be running around in darkened rooms, munching magic pills
> and listening to repetitive electronic music." - Kristian Wilson,
> Nintendo Inc., 1989.
>
>
