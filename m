Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 06:20:09 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KEK1m7031847
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 06:20:03 -0800
Date: Tue, 20 Feb 2007 09:19:55 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfsdump/xfsrestore question
In-Reply-To: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
Message-ID: <Pine.LNX.4.64.0702200918330.11548@p34.internal.lan>
References: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: xfs@oss.sgi.com



On Tue, 20 Feb 2007, Leon Kolchinsky wrote:

> Hello All,
>
> I have a question about xfsdump/xfsrestore usage on Linux.
>
> I'm running Linux 2.6.19-gentoo-r5.
>
> Now I have 2 disks,
> /dev/hda is my system disk
> /dev/hdc is a disk I want to use for backups.
>
> This is how my fstab looks like:
>
> /dev/hda1               /                       xfs
> noatime,nodiratime,logbufs=8    1 1
> /dev/hda2               none                    swap            sw
> 0 0
> /dev/hdc3               /var/tmp/portage        xfs
> noatime,nodiratime,logbufs=8    0 0
> /dev/hdc2               /data                   xfs
> noatime,nodiratime,logbufs=8    0 0
> /dev/hdc1               none                    swap            sw
> 0 0
> /dev/cdrom              /mnt/cdrom              iso9660         noauto,ro
> 0 0
> /dev/fd0                /mnt/floppy             auto            noauto
> 0 0
>
> # NOTE: The next line is critical for boot!
> proc                    /proc           proc            defaults        0 0
>
> shm                     /dev/shm        tmpfs           nodev,nosuid,noexec
> 0 0
>
> ########################################
>
> Now the questions:
>
> 1) If I get the xfsdump synax correctly I just have to do:
>
> # cd /
> # xfsdump -f /data/backup.file /
>
> Is it right?
> What about opened and "currently in use by the system" files? Are they
> backuped in a proper way? What about tmpfs like /proc, are they been
> ignored?
>
> 2) If I'd have to restore my system from the dump, how would you recommend
> to do it? Booting from LiveCD and making # xfsrestore -f / data/backup.file
> / ?
>
> Would it be a bootable/operational system?
> What are the expected glitches?
>
>
> Best Regards,
> Leon Kolchinsky
>
>
>

This generally looks correct, there are some options to name the tape/ID 
of the backup itself, you can specify them on the command line.

For ignoring certain paths, yes this works as well, you can chattr I 
believe (check the manpage) certain directories / files and they will be 
ignored by xfsdump.

Justin.
