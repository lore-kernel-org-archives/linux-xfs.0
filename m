Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 13:14:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BKEKaG016276
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 13:14:21 -0700
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1A4148F0AB
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 13:13:37 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id o25so543529nfa
        for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 13:13:36 -0700 (PDT)
Message-ID: <acd894d40610111210o6468f40kd99ee6e0f5b148e1@mail.gmail.com>
Date: Wed, 11 Oct 2006 14:10:28 -0500
From: "Ian Williamson" <notian@gmail.com>
Subject: Re: [UNSURE] Re: Software raid 5 with XFS causing strange lockup problems
In-Reply-To: <Pine.LNX.4.64.0610111442180.27351@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>
	 <452CF770.5050902@sandeen.net>
	 <acd894d40610110921j61bcf5cdn57887c386f54f6c8@mail.gmail.com>
	 <Pine.LNX.4.64.0610111318570.27351@p34.internal.lan>
	 <acd894d40610111141p6895995dq89fd5b19b59222d5@mail.gmail.com>
	 <Pine.LNX.4.64.0610111442180.27351@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

/dev/md0:
 Timing buffered disk reads:  286 MB in  3.01 seconds =  94.97 MB/sec

For write I don't have pipebench installed, and this isn't internet
facing at the moment, so I can't install it.

I just ran an xfs_repair on /dev/md0 and it did this:
-------------------------------------------------------------------------
ian@ionlinux:~$ sudo xfs_repair /dev/md0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
       - zero log...
       - scan filesystem freespace and inode maps...
       - found root inode chunk
Phase 3 - for each AG...
       - scan and clear agi unlinked lists...
       - process known inodes and perform inode discovery...
       - agno = 0
bad attribute format 0 in inode 260, resetting value
       - agno = 1
inode 135921976 - bad extent starting block number 955543538733351,
offset 2405220210012692
bad data fork in inode 135921976
cleared inode 135921976
zero length extent (off = 0, fsbno = 0) in ino 136766006
bad data fork in inode 136766006
cleared inode 136766006
       - agno = 2
inode 268439335 - bad extent starting block number 4389451776, offset
8989827926016
bad data fork in inode 268439335
cleared inode 268439335
       - agno = 3
inode 402653478 - bad extent starting block number 6493419520, offset
123364807018496
bad data fork in inode 402653478
cleared inode 402653478
       - agno = 4
       - agno = 5
       - agno = 6
       - agno = 7
inode 939524376 - bad extent starting block number 384617748308622,
offset 13946791523993872
bad data fork in inode 939524376
cleared inode 939524376
       - agno = 8
       - agno = 9
       - agno = 10
       - agno = 11
       - agno = 12
       - agno = 13
       - agno = 14
       - agno = 15
       - agno = 16
       - agno = 17
       - agno = 18
       - agno = 19
inode 2550140476 - bad extent starting block number 3836083423429920,
offset 1232124454554406
bad data fork in inode 2550140476
cleared inode 2550140476
       - agno = 20
       - agno = 21
inode 2818586148 - bad extent starting block number 2465278532745658,
offset 9727159296556827
bad data fork in inode 2818586148
cleared inode 2818586148
       - agno = 22
       - agno = 23
       - agno = 24
       - agno = 25
       - agno = 26
       - agno = 27
       - agno = 28
       - agno = 29
       - agno = 30
       - agno = 31
       - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
       - setting up duplicate extent list...
       - clear lost+found (if it exists) ...
       - clearing existing "lost+found" inode
       - deleting existing "lost+found" entry
       - check for inodes claiming duplicate blocks...
       - agno = 0
       - agno = 1
entry "07 - Film Score Pt. II.mp3" at block 0 offset 312 in directory
inode 135921969 references free inode 135921976
       clearing inode number in entry at offset 312...
entry "Torrent downloaded from Demonoid.com.txt" in shortform
directory 136766004 references free inode 136766006
junking entry "Torrent downloaded from Demonoid.com.txt" in directory
inode 136766004
       - agno = 2
entry "robot_worldlight.png" at block 3 offset 2608 in directory inode
268436754 references free inode 268439335
       clearing inode number in entry at offset 2608...
       - agno = 3
entry "automail.php" at block 0 offset 104 in directory inode
402653475 references free inode 402653478
       clearing inode number in entry at offset 104...
       - agno = 4
       - agno = 5
       - agno = 6
       - agno = 7
entry "core.write_compiled_include.php" at block 0 offset 808 in
directory inode 939524356 references free inode 939524376
       clearing inode number in entry at offset 808...
       - agno = 8
       - agno = 9
       - agno = 10
       - agno = 11
       - agno = 12
       - agno = 13
       - agno = 14
       - agno = 15
       - agno = 16
       - agno = 17
       - agno = 18
       - agno = 19
entry "auth.php" at block 0 offset 48 in directory inode 2550140475
references free inode 2550140476
       clearing inode number in entry at offset 48...
       - agno = 20
       - agno = 21
entry "IMG_0245.jpg" at block 0 offset 1944 in directory inode
2818581782 references free inode 2818586148
       clearing inode number in entry at offset 1944...
       - agno = 22
       - agno = 23
       - agno = 24
       - agno = 25
       - agno = 26
       - agno = 27
       - agno = 28
       - agno = 29
       - agno = 30
       - agno = 31
Phase 5 - rebuild AG headers and trees...
       - reset superblock...
Phase 6 - check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - ensuring existence of lost+found directory
       - traversing filesystem starting at / ...
rebuilding directory inode 135921969
rebuilding directory inode 2818581782
rebuilding directory inode 2550140475
rebuilding directory inode 268436754
rebuilding directory inode 402653475
rebuilding directory inode 939524356
       - traversal finished ...
       - traversing all unattached subtrees ...
       - traversals finished ...
       - moving disconnected inodes to lost+found ...
disconnected dir inode 3221929786, moving to lost+found
Phase 7 - verify and correct link counts...
done
-------------------------------------------------------------------------
Right now I am copying a 20Gig directory off of the raid onto another
drive with no problems. Does an xfs filesystem need to be repaired on
a regular basis? Any ideas on what might be "corrupting" it?

On 10/11/06, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> A simple hdparm -t /dev/md0 for the read speed, but I'd be more interested
> in write speed.
>
> dd if=/dev/zero | pipebench > /path/on/raid.dat
>
> Then report the write speed in MB/s.
>
> I assume this is on a regular PCI card, which is why I am interested in
> the speeds.
>
>
> On Wed, 11 Oct 2006, Ian Williamson wrote:
>
> > Justin,
> > How would I go about benchmarking that?
> >
> > Eric,
> > Sorry, but I'm not quite an expert on the internals of Linux. What are
> > 4k stacks and how do I know if I have them. If it helps, I am using
> > Ubuntu with a custom compiled Linux kernel. (This xfs/raid problem was
> > also occured on the default Ubuntu server kernel...)
> >
> > Also, if that trace from /var/log/messages isn't of any use do you
> > know where I can look to find more information on this? Is it possible
> > that this is being caused b the cheap PCI SATA controller card that I
> > am using? (It's the Rosewill RC-209)
> >
> > - Ian
> >
> > On 10/11/06, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > > Also, quick question-- What type of speed do you get with 4 drives
> > > connected to 1 card vs. I have 8 drives connected to 3-4 cards.
> > >
> > > What speed write/read?
> > >
> > > Justin.
> > >
> > > On Wed, 11 Oct 2006, Ian Williamson wrote:
> > >
> > > > Eric,
> > > > That's all I have for the event in /var/log/messages..
> > > >
> > > > For the raid configuration I have the following:
> > > > ian@ionlinux:~$ sudo mdadm --detail /dev/md0
> > > > Password:
> > > > /dev/md0:
> > > >        Version : 00.90.03
> > > >  Creation Time : Wed Sep 13 22:04:11 2006
> > > >     Raid Level : raid5
> > > >     Array Size : 732587712 (698.65 GiB 750.17 GB)
> > > >  Device Size : 244195904 (232.88 GiB 250.06 GB)
> > > >  Raid Devices : 4
> > > >  Total Devices : 4
> > > > Preferred Minor : 0
> > > >    Persistence : Superblock is persistent
> > > >
> > > >    Update Time : Mon Oct  9 00:02:30 2006
> > > >          State : clean
> > > > Active Devices : 4
> > > > Working Devices : 4
> > > > Failed Devices : 0
> > > >  Spare Devices : 0
> > > >
> > > >         Layout : left-symmetric
> > > >     Chunk Size : 64K
> > > >
> > > >           UUID : 86770f56:8e4f51e5:fd754630:f1c65359
> > > >         Events : 0.54082
> > > >
> > > >    Number   Major   Minor   RaidDevice State
> > > >       0       8        1        0      active sync   /dev/sda1
> > > >       1       8       17        1      active sync   /dev/sdb1
> > > >       2       8       33        2      active sync   /dev/sdc1
> > > >       3       8       49        3      active sync   /dev/sdd1
> > > >
> > > > I really have no idea what could be causing this. Sometimes after
> > > > restart it still won't work through Samba, and I can never perform
> > > > massive local reads and writes, i.e. a recursive copy off of the raid.
> > > >
> > > > On 10/11/06, Eric Sandeen <sandeen@sandeen.net> wrote:
> > > > > Ian Williamson wrote:
> > > > > > I am running XFS on a software raid 5. I am doing this with a PCI
> > > > > > controller with 4 SATA drives attached to it.
> > > > > >
> > > > > > When I play my music over the network through Samba from the raid
> > > > > > volume my audio client will often loose the connection. This isn't
> > > > > > remediated until I restart the machine with the raid controller or
> > > > > > wait for an unknown amount of time. Either way, the problem still
> > > > > > persists.
> > > > > >
> > > > > > Initially I though that this was Samba's fault, but I think it may be
> > > > > > xfs related due to what was in /var/log/messages:
> > > > > >
> > > > > > Oct  9 22:37:33 ionlinux kernel: [105657.982701] Modules linked in:
> > > > > > serio_raw i2c_nforce2 pcspkr forcedeth r8169 nvidia_agp agpgart
> > > > > > i2c_core psmouse sg evdev xfs dm_mod sd_mod generic sata_nv ide_disk
> > > > > > ehci_hcd ide_cd cdrom sata_sil ohci_hcd usbcore libata scsi_mod
> > > > > > ide_generic processor
> > > > > > Oct  9 22:37:33 ionlinux kernel: [105657.982985] EIP:
> > > > > > 0060:[<f8a1353e>]    Not tainted VLI
> > > > > > Oct  9 22:37:33 ionlinux kernel: [105657.982986] EFLAGS: 00010246
> > > > > > (2.6.18 #1)
> > > > >
> > > > > It looks like you've edited this a bit too much, what came before this
> > > > > in
> > > > > the logs?
> > > > >
> > > > > Are you running on 4k stacks, out of curiosity?
> > > > >
> > > > > -Eric
> > > > >
> > > >
> > > >
> > > > --
> > > > Ian Williamson
> > > >
> > > >
> > >
> >
> >
> > --
> > Ian Williamson
> >
> >
>


-- 
Ian Williamson
