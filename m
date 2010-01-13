Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D9fOrh140660 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 03:41:24 -0600
Received: from web76206.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E504B1247CFD
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 01:42:17 -0800 (PST)
Received: from web76206.mail.sg1.yahoo.com (web76206.mail.sg1.yahoo.com
	[124.108.115.130]) by cuda.sgi.com with SMTP id
	P35endXIGzkzBECI for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 01:42:17 -0800 (PST)
Message-ID: <348821.11898.qm@web76206.mail.sg1.yahoo.com>
Date: Wed, 13 Jan 2010 17:42:16 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: allocsize mount option
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi,


The application is ANSYS, which writes 128 GB files.=A0 The existing comput=
er with SUSE Linux Enterprise Desktop 11 which is used for running ANSYS, h=
as two software RAID 0 devices made up of five 1 TB drives.=A0 The /home pa=
rtition is 4.5 T, and it is now 4 TB full.=A0 I see a fragmentation > 19%.


I have just set up a new computer with 16 WD Cavair Black 1 TB drives conne=
cted to an Areca 1680ix-16 RAID with 4 GB cache.=A0 14 of these drives are =
in RAID 6 with 128 kB stripes.  The OS is also SLED 11.  The system has 16 =
GB memory, and AMD Phenom II X4 965 CPU.

I have done tests writing 100 30 MB files and 1 GB, 10 GB and 20 GB files, =
with single instance and multiple instances.

There is a big difference in writing speed when=A0writing 20 GB files when =
using allocsize=3D1g and not using the option.  That is without the inode64=
 option, which gives further speed gains.

I use dd for writing the 1 GB, 10 GB and 20 GB files.

mkfs.xfs -f -b size=3D4k -d agcount=3D32,su=3D128k,sw=3D12 -i size=3D256,al=
ign=3D1,attr=3D2 -l version=3D2,su=3D128k,lazy-count=3D1 -n version=3D2 -s =
size=3D512 -L /data /dev/sdb1


defaults,nobarrier,usrquota,grpquota,noatime,nodiratime,allocsize=3D1g,logb=
ufs=3D8,logbsize=3D256k,largeio,swalloc

The start of the partition has been set to LBA 3072 using GPT Fdisk to alig=
n the stripes.

The dd command is:

chingl@tsunami:/data/test/t2> dd if=3D/dev/zero of=3Dbigfile20GB bs=3D10737=
41824 count=3D20

Single instance of 20 GB dd repeats were 214, 221, 123 MB/s with allocsize=
=3D1g, compared to 94, 126 MB/s without.

Two instances of 20 GB dd repeats were aggregate 331, 372 MB/s with allocsi=
ze=3D1g, compared to 336, 296 MB/s without.

Three instances of 20 GB dd was aggregate 400 MB/s with, 326 MB/s without.

Six instances of 20 GB dd was 606 MB/s with, 473 MB/s without.


My production configuration is

defaults,nobarrier,usrquota,grpquota,noatime,nodiratime,allocsize=3D1g,logb=
ufs=3D8,logbsize=3D256k,largeio,swalloc,inode64

for which I got up to 297 MB/s for single instance 20 GB dd.



Chin Gim Leong


--- On Tue, 12/1/10, Eric Sandeen <sandeen@sandeen.net> wrote:

> From: Eric Sandeen <sandeen@sandeen.net>
> Subject: Re: allocsize mount option
> To: "Gim Leong Chin" <chingimleong@yahoo.com.sg>
> Cc: xfs@oss.sgi.com
> Date: Tuesday, 12 January, 2010, 2:16 AM
> Gim Leong Chin wrote:
> > Hi,
> > =

> > Mount options for xfs allocsize=3Dsize Sets=A0 the
> buffered I/O
> > end-of-file preallocation size when doing delayed
> allocation writeout
> > (default size is 64KiB).
> > =

> > =

> > I read that setting allocsize to a big value can be
> used to combat
> > filesystem fragmentation when writing big files.
> =

> That's not universally necessary though, depending on how
> you are
> writing them.=A0 I've only used it in the very specific
> case of mythtv
> calling "sync" every couple seconds, and defeating
> delalloc.
> =

> > I do not understand how allocsize works.=A0 Say I
> set allocsize=3D1g, but
> > my file size is only 1 MB or even smaller.=A0 Will
> the rest of the 1 GB
> > file extent be allocated, resulting in wasted space
> and even file
> > fragmentation problem?
> =

> possibly :)=A0 It's only speculatively allocated,
> though, so you won't
> have 1g for every file; when it's closed the preallocation
> goes
> away, IIRC.
> =

> > Does setting allocsize to a big value result in
> performance gain when
> > writing big files?=A0 Is performance hurt by a big
> value setting when
> > writing files smaller than the allocsize value?
> > =

> > I am setting up a system for HPC, where two different
> applications
> > have different file size characteristics, one writes
> files of GBs and
> > even 128 GB, the other is in MBs to tens of MBs.
> =

> We should probably back up and say:=A0 are you seeing
> fragmentation
> problems -without- the mount option, and if so, what is
> your write pattern?
> =

> -Eric
> =

> > I am not able to find documentation on the behaviour
> of allocsize
> > mount option.
> > =

> > Thank you.
> > =

> > =

> > Chin Gim Leong
> > =

> > =

> > New Email names for you! Get the Email name you've
> always wanted
> > on the new @ymail and @rocketmail. Hurry before
> someone else does! =

> > http://mail.promotions.yahoo.com/newdomains/sg/
> > =

> > _______________________________________________ xfs
> mailing list =

> > xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> > =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



      New Email addresses available on Yahoo!
Get the Email name you&#39;ve always wanted on the new @ymail and @rocketma=
il. =

Hurry before someone else does!
http://mail.promotions.yahoo.com/newdomains/sg/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
