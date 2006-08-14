Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 08:09:16 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7EF90DW013142
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 08:09:03 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Negligible improvement when using su/sw for hardware RAID5,	expected?
Date: Mon, 14 Aug 2006 17:08:24 +0200
Message-ID: <55EF1E5D5804A542A6CA37E446DDC206471F3D@mapibe17.exchange.xchg>
In-Reply-To: <44E07AC6.6000104@comcast.net>
From: "Sebastian Brings" <sebas@silexmedia.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian Davis <bridavis@comcast.net>, utz lehmann <u.lehmann@de.tecosim.com>
Cc: xfs@oss.sgi.com

Unfortunately, yes.
When you create a standard dos partition table on a disk, this takes
some space. This shifts the beginning of your sda1 partition away from
the very beginning of your harddisk by roughly 32k. When you now write
the first 64K to you Raid, the first 32k go to disk1 (your first 64K
stripe unit, which already holds the partition table), the next 32k go
to disk 2 (your second stripe unit, which now is half "full"). Now your
Raid controller needs to update the parity disk. It has half the data it
would need from disk1, and half the data it would need from disk 2. An
ugly situation.

When using hardware raids, you should treat them as one single disk when
calculating the sunit/swidth. Sunit matches the 2x64K = 128K of your
Raid5, swidth then is 128K by <number of raids in the stripe>. Together
with a proper alignement as Utz mentioned, this allows the system to
write a complete stripe at once, and hopefully makes it easier for the
raidcontroller to calculate parity.




> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> Brian Davis
> Sent: Montag, 14. August 2006 15:30
> To: utz lehmann
> Cc: xfs@oss.sgi.com
> Subject: Re: Negligible improvement when using su/sw for hardware
RAID5,
> expected?
> 
> I'll admit to being ignorant here....all I did was created the Linux
> partition with fdisk and then created the fs on top of that.  Was
there
> something else that needed to be done?
> 
> Thanks,
> Brian
> 
> utz lehmann wrote:
> > Hi
> >
> > You are using a partition. Is it correctly aligned? Usually the
first
> > partition starts at sector 63. Which is in the middle of your
stripe.
> > Use the whole disk (/dev/sda) or align the start of the partition to
a
> > multiple of the stripe size.
> > But i doubt you will see a performance improvement with such a
simple
> > test (single threaded sequential read/ write).
> >
> >
> > utz
> >
> > On Fri, 2006-08-11 at 23:10 -0400, Brian Davis wrote:
> >
> >> Is this expected? I thought I would see more improvement when
tweaking
> >> my su/sw values for hardware RAID 5.
> >>
> >> Details, 3x300GB drives, 3Ware 7506-4LP Hardware RAID 5 using a 64K
> >> stripe size (non-configurable on this card).
> >>
> >> FS creation and Bonnie++ results:
> >>
> >>
Untweaked:-------------------------------------------------------------
> ---------
> >>
> >>
> >> localhost / # mkfs.xfs -f /dev/sda1
> >> meta-data=/dev/sda1              isize=256    agcount=32,
> agsize=4578999
> >> blks
> >>         =                       sectsz=512   attr=0
> >> data     =                       bsize=4096   blocks=146527968,
> imaxpct=25
> >>         =                       sunit=0      swidth=0 blks,
unwritten=1
> >> naming   =version 2              bsize=4096
> >> log      =internal log           bsize=4096   blocks=32768,
version=1
> >>         =                       sectsz=512   sunit=0 blks
> >> realtime =none                   extsz=65536  blocks=0, rtextents=0
> >> localhost / # mount -t xfs /dev/sda1 /raid
> >> localhost / # cd /raid
> >> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
> >> Using uid:0, gid:0.
> >> Writing intelligently...done
> >> Rewriting...done
> >> Reading intelligently...done
> >> start 'em...done...done...done...done...done...
> >> Version 1.93c       ------Sequential Output------ --Sequential
Input-
> >> --Random-
> >> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr-
--Block--
> >> --Seeks--
> >> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec
%CP
> >> /sec %CP
> >> localhost       30G           27722  40 23847  37           98367
99
> >> 88.6  11
> >> Latency                         891ms     693ms             16968us
> >> 334ms
> >>
> >>
Tweaked:---------------------------------------------------------------
> ----------
> >>
> >>
> >> localhost / # mkfs.xfs -f -d sw=2,su=64k /dev/sda1
> >> meta-data=/dev/sda1              isize=256    agcount=32,
> agsize=4578992
> >> blks
> >>         =                       sectsz=512   attr=0
> >> data     =                       bsize=4096   blocks=146527744,
> imaxpct=25
> >>         =                       sunit=16     swidth=32 blks,
> unwritten=1
> >> naming   =version 2              bsize=4096
> >> log      =internal log           bsize=4096   blocks=32768,
version=1
> >>         =                       sectsz=512   sunit=0 blks
> >> realtime =none                   extsz=65536  blocks=0, rtextents=0
> >> localhost / # mount -t xfs /dev/sda1 /raid
> >> localhost / # cd /raid
> >> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
> >> Using uid:0, gid:0.
> >> Writing intelligently...done
> >> Rewriting...done
> >> Reading intelligently...done
> >> start 'em...done...done...done...done...done...
> >> Version 1.93c       ------Sequential Output------ --Sequential
Input-
> >> --Random-
> >> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr-
--Block--
> >> --Seeks--
> >> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec
%CP
> >> /sec %CP
> >> localhost       30G           27938  43 23880  40           98066
99
> >> 91.8   9
> >> Latency                         772ms     584ms             19889us
> >> 340ms
> >>
> >>
> 
