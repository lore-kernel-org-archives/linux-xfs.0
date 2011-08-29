Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T3rKi0038591 for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 22:53:20 -0500
Received: from nm5.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0B9F01E7D845
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 20:53:17 -0700 (PDT)
Received: from nm5.bullet.mail.sg1.yahoo.com (nm5.bullet.mail.sg1.yahoo.com
	[115.178.12.249]) by cuda.sgi.com with SMTP id eIfRpkYlFgnStBGf
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 20:53:17 -0700 (PDT)
Message-ID: <1314589995.20010.YahooMailClassic@web77719.mail.sg1.yahoo.com>
Date: Mon, 29 Aug 2011 11:53:15 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: xfsrestore Does Only Only Partial Restore
In-Reply-To: <1314544549.34681.YahooMailClassic@web77712.mail.sg1.yahoo.com>
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
To: xfs@oss.sgi.com

Thinking that it might be a xfsdump version incompatibility, I dug out the =
openSUSE 11.1 installation DVD, got the xfsdump-2.2.48-1.59 rpm and extract=
ed the xfsdump and xfsrestore from it.  I then attempted a restore using it=
, but I still have only 49 GB of 121 GB extracted:

chingl@optimus:~> df -h
  Filesystem            Size  Used Avail Use% Mounted on
  rootfs                101G   41G   60G  41% /
  devtmpfs              998M  484K  997M   1% /dev
  tmpfs                1004M  1.1M 1003M   1% /dev/shm
  /dev/sda2             101G   41G   60G  41% /
  /dev/sda3             824G  697G  127G  85% /home
  /dev/sdb2              70G  5.8G   65G   9% /tmp/mnt2
  /dev/sr0              4.4G  4.4G     0 100% /media/SU1110.001
  /dev/sdb3             830G   49G  781G   6% /tmp/mnt3
  chingl@optimus:~>
  chingl@optimus:~> df
  Filesystem           1K-blocks      Used Available Use% Mounted on
  rootfs               104878048  42055420  62822628  41% /
  devtmpfs               1021032       484   1020548   1% /dev
  tmpfs                  1027960      1060   1026900   1% /dev/shm
  /dev/sda2            104878048  42055420  62822628  41% /
  /dev/sda3            863017248 730332548 132684700  85% /home
  /dev/sdb2             73363456   6071484  67291972   9% /tmp/mnt2
  /dev/sr0               4549218   4549218         0 100% /media/SU1110.001
  /dev/sdb3            869382652  50566648 818816004   6% /tmp/mnt3
  chingl@optimus:~>
{>
(>optimus:/home/chingl/archive/rat # /home/chingl/XFS/xfsdump-2.2.48-1.59/s=
bin/xfsrestore -f ./rat18Aug2011 /tmp/mnt3
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: using file dump (dr=
ive_simple) strategy
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: version 2.2.48 (dum=
p format 3.0) - Running single-threaded                                    =
                                =

  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: searching media for=
 dump
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: examining media fil=
e 0
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: dump description:
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: hostname: rat
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: mount point: /home
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: volume: /dev/sdb3
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: session time: Thu A=
ug 18 12:57:36 2011
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: level: 0
6>/home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: session label: "rat=
_18Aug2011"
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: media label: "rat18=
Aug2011"
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: file system id: f3b=
08587-cf98-4b7b-99b0-dc9d4e77b631                                          =
                                =

  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: session id: d8069cd=
0-a092-4fb2-b378-0eda33474aae                                              =
                                =

  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: media id: 96370000-=
6e2c-40eb-9c3c-93ca42de7524
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: searching media for=
 directory dump
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: reading directories
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: 90820 directories a=
nd 539579 entries processed
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: directory post-proc=
essing
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: restoring non-direc=
tory files
4>/home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: attempt to read 100=
8286921 bytes failed: end of recorded data
1>/home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: user quota informat=
ion written to '/tmp/mnt3/xfsdump_quotas'
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: group quota informa=
tion written to '/tmp/mnt3/xfsdump_quotas_group'
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: use 'xfs_quota' to =
restore quotas
8>/home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: restore complete: 2=
546 seconds elapsed
  /home/chingl/XFS/xfsdump-2.2.48-1.59/sbin/xfsrestore: Restore Status: SUC=
CESS
0>optimus:/home/chingl/archive/rat #


Is this a case of xfsdump bug that causes null data to be written, or xfsre=
store bug that is unable to read back the data?


Thanks!


GL






--- On Sun, 28/8/11, Gim Leong Chin <chingimleong@yahoo.com.sg> wrote:

> From: Gim Leong Chin <chingimleong@yahoo.com.sg>
> Subject: Re: xfsrestore Does Only Only Partial Restore
> To: xfs@oss.sgi.com
> Date: Sunday, 28 August, 2011, 11:15 PM
> Hi,
> =

> I just tried an older back up to test, and the restore is
> again partial, looks like I am screwed, only 44 GB of 113 GB
> got restored:
> =

> optimus:/mnt/rat # ll
> total 345143448
> -rw-r--r-- 1 root root=A0 =A0 =A0
> =A0=A0=A01085 Sep 19=A0 2010 fstab
> -rw-r--r-- 1 root root 103295383456 Jul 10 04:02
> rat10July2011
> -rw-r--r-- 1 root root 129677563808 Aug 18 14:41
> rat18Aug2011
> -rw-r--r-- 1 root root 120453920672 Jul 31 02:06
> rat30July2011
> optimus:/mnt/rat # xfsrestore -f ./rat30July2011=A0
> /tmp/mnt3
> xfsrestore: using file dump (drive_simple) strategy
> xfsrestore: version 3.0.1 (dump format 3.0) - Running
> single-threaded
> xfsrestore: searching media for dump
> xfsrestore: examining media file 0
> xfsrestore: dump description: =

> xfsrestore: hostname: rat
> xfsrestore: mount point: /home
> xfsrestore: volume: /dev/sdb3
> xfsrestore: session time: Sun Jul 31 00:24:34 2011
> xfsrestore: level: 0
> xfsrestore: session label: "rat30July2011"
> xfsrestore: media label: "rat30July2011"
> xfsrestore: file system id:
> f3b08587-cf98-4b7b-99b0-dc9d4e77b631
> xfsrestore: session id:
> 8c0a0114-dc68-4e10-a48f-106c4aceecc6
> xfsrestore: media id: d8f1694a-b641-43bc-a7eb-5f86a2a84221
> xfsrestore: searching media for directory dump
> xfsrestore: reading directories
> xfsrestore: 90681 directories and 539455 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files
> xfsrestore: attempt to read 388926665 bytes failed: end of
> recorded data
> xfsrestore: user quota information written to
> '/tmp/mnt3/xfsdump_quotas'
> xfsrestore: group quota information written to
> '/tmp/mnt3/xfsdump_quotas_group'
> xfsrestore: use 'xfs_quota' to restore quotas
> xfsrestore: restore complete: 4235 seconds elapsed
> xfsrestore: Restore Status: SUCCESS
> optimus:/mnt/rat # df -h
> Filesystem=A0 =A0 =A0 =A0 =A0 =A0
> Size=A0 Used Avail Use% Mounted on
> rootfs=A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 101G=A0=A0=A041G=A0=A0=A060G=A0
> 41% /
> devtmpfs=A0 =A0 =A0 =A0 =A0 =A0 =A0
> 998M=A0 496K=A0 997M=A0=A0=A01% /dev
> tmpfs=A0 =A0 =A0 =A0 =A0 =A0 =A0
> =A0 1004M=A0 1.1M 1003M=A0=A0=A01% /dev/shm
> /dev/sda2=A0 =A0 =A0 =A0 =A0
> =A0=A0=A0101G=A0=A0=A041G=A0=A0=A060G=A0
> 41% /
> /dev/sda3=A0 =A0 =A0 =A0 =A0
> =A0=A0=A0824G=A0 697G=A0 127G=A0 85%
> /home
> /dev/sdb2=A0 =A0 =A0 =A0 =A0 =A0 =A0
> 70G=A0 5.8G=A0=A0=A065G=A0=A0=A09%
> /tmp/mnt2
> /dev/sdb3=A0 =A0 =A0 =A0 =A0
> =A0=A0=A0830G=A0=A0=A044G=A0
> 786G=A0=A0=A06% /tmp/mnt3
> /dev/sdc1=A0 =A0 =A0 =A0 =A0
> =A0=A0=A0698G=A0 504G=A0 195G=A0 73% /mnt
> optimus:/mnt/rat # ll -h
> total 330G
> -rw-r--r-- 1 root root 1.1K Sep 19=A0 2010 fstab
> -rw-r--r-- 1 root root=A0 97G Jul 10 04:02
> rat10July2011
> -rw-r--r-- 1 root root 121G Aug 18 14:41 rat18Aug2011
> -rw-r--r-- 1 root root 113G Jul 31 02:06 rat30July2011
> optimus:/mnt/rat #
> =

> =

> =

> --- On Sun, 28/8/11, Gim Leong Chin <chingimleong@yahoo.com.sg>
> wrote:
> =

> > From: Gim Leong Chin <chingimleong@yahoo.com.sg>
> > Subject: xfsrestore Does Only Only Partial Restore
> > To: xfs@oss.sgi.com
> > Date: Sunday, 28 August, 2011, 8:31 PM
> > Hi,
> > =

> > This is the very first time I tried doing a xfsrestore
> of a
> > back up and I hit some serious trouble.
> > =

> > I had openSUSE 11.1 (kernel 2.6.27) on my Acer
> > notebook.=A0 I did a xfsdump of /home to a WD My
> Passport
> > external USB hard drive with XFS on it.
> > =

> > I installed openSUSE 11.4 (kernel 2.6.37), then tried
> to do
> > xfsrestore from the WD USB drive.=A0 The dump file is
> 121
> > GB.
> > =

> > I tried two times on two different days, but each time
> the
> > xfsrestore would stop writing at the exact same point,
> 49 GB
> > and say success at the end.
> > =

> > I then copied the dump file to one hard drive on my
> desk
> > top, and did a dump to another hard drive, to
> > /tmp/mnt3.=A0 I get back identical messages:
> > =

> > chingl@optimus:~> df
> > =A0 Filesystem=A0 =A0 =A0 =A0
> > =A0=A0=A01K-blocks=A0 =A0 =A0 Used
> > Available Use% Mounted on
> > =A0 rootfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0104878048=A0 42063828=A0
> > 62814220=A0 41% /
> > =A0 devtmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0=A0=A01021032=A0 =A0
> > =A0=A0=A0480=A0=A0=A01020552=A0=A0=A01%
> > /dev
> > =A0 tmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0 =A0 1027960=A0 =A0 =A0
> > 1064=A0=A0=A01026896=A0=A0=A01% /dev/shm
> > =A0 /dev/sda2=A0 =A0 =A0 =A0 =A0 =A0
> > 104878048=A0 42063828=A0 62814220=A0 41% /
> > =A0 /dev/sda3=A0 =A0 =A0 =A0 =A0 =A0
> > 863017248 730313100 132704148=A0 85% /home
> > =A0 /dev/sdb2=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A073363456=A0=A0=A06071484=A0
> > 67291972=A0=A0=A09% /tmp/mnt2
> > =A0 /dev/sdb3=A0 =A0 =A0 =A0 =A0 =A0
> > 869382652=A0 50612736 818769916=A0=A0=A06%
> > /tmp/mnt3
> > =A0 chingl@optimus:~> df -h
> > =A0 Filesystem=A0 =A0 =A0 =A0 =A0 =A0
> > Size=A0 Used Avail Use% Mounted on
> > =A0 rootfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0
> > 101G=A0=A0=A041G=A0=A0=A060G=A0 41% /
> > =A0 devtmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 998M=A0 480K=A0 997M=A0=A0=A01% /dev
> > =A0 tmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0 1004M=A0 1.1M 1003M=A0=A0=A01%
> > /dev/shm
> > =A0 /dev/sda2=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0101G=A0=A0=A041G=A0=A0=A060G=A0
> > 41% /
> > =A0 /dev/sda3=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0824G=A0 697G=A0 127G=A0 85%
> > /home
> > =A0 /dev/sdb2=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 70G=A0
> > 5.8G=A0=A0=A065G=A0=A0=A09% /tmp/mnt2
> > =A0 /dev/sdb3=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0830G=A0=A0=A049G=A0
> > 781G=A0=A0=A06% /tmp/mnt3
> > =A0 chingl@optimus:~> cd archive/rat
> > =A0 chingl@optimus:~/archive/rat> ll
> > =A0 total 126638256
> > =A0 -rw-r--r-- 1 chingl users 129677563808 Aug 18
> 14:41
> > rat18Aug2011
> > =A0 chingl@optimus:~/archive/rat>
> > {>
> > (>optimus:~ # xfsrestore -f
> > /home/chingl/archive/rat/rat18Aug2011 /tmp/mnt3
> > =A0 xfsrestore: using file dump (drive_simple)
> strategy
> > =A0 xfsrestore: version 3.0.1 (dump format 3.0) -
> > Running single-threaded
> > =A0 xfsrestore: searching media for dump
> > =A0 xfsrestore: examining media file 0
> > =A0 xfsrestore: dump description:
> > =A0 xfsrestore: hostname: rat
> > =A0 xfsrestore: mount point: /home
> > =A0 xfsrestore: volume: /dev/sdb3
> > =A0 xfsrestore: session time: Thu Aug 18 12:57:36 2011
> > 2>xfsrestore: level: 0
> > =A0 xfsrestore: session label: "rat_18Aug2011"
> > =A0 xfsrestore: media label: "rat18Aug2011"
> > =A0 xfsrestore: file system id:
> > f3b08587-cf98-4b7b-99b0-dc9d4e77b631
> > =A0 xfsrestore: session id:
> > d8069cd0-a092-4fb2-b378-0eda33474aae
> > =A0 xfsrestore: media id:
> > 96370000-6e2c-40eb-9c3c-93ca42de7524
> > =A0 xfsrestore: searching media for directory dump
> > =A0 xfsrestore: reading directories
> > =A0 xfsrestore: 90820 directories and 539579 entries
> > processed
> > =A0 xfsrestore: directory post-processing
> > 1>xfsrestore: restoring non-directory files
> > 9>xfsrestore: attempt to read 1008286921 bytes
> failed:
> > end of recorded data
> > =A0 xfsrestore: user quota information written to
> > '/tmp/mnt3/xfsdump_quotas'
> > 7>xfsrestore: group quota information written to
> > '/tmp/mnt3/xfsdump_quotas_group'
> > 4>xfsrestore: use 'xfs_quota' to restore quotas
> > =A0 xfsrestore: restore complete: 2522 seconds elapsed
> > =A0 xfsrestore: Restore Status: SUCCESS
> > =A0 optimus:~ #
> > =

> > I downloaded xfsdump-3.0.5.tar.gz, did a build, and
> tried
> > to do a restore using the newly built xfsrestore:
> > =

> > chingl@optimus:~/testdump> df -h
> > =A0 Filesystem=A0 =A0 =A0 =A0 =A0 =A0
> > Size=A0 Used Avail Use% Mounted on
> > =A0 rootfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0
> > 101G=A0=A0=A041G=A0=A0=A060G=A0 41% /
> > =A0 devtmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 998M=A0 480K=A0 997M=A0=A0=A01% /dev
> > =A0 tmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0 1004M=A0 1.1M 1003M=A0=A0=A01%
> > /dev/shm
> > =A0 /dev/sda2=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0101G=A0=A0=A041G=A0=A0=A060G=A0
> > 41% /
> > =A0 /dev/sda3=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0824G=A0 697G=A0 127G=A0 85%
> > /home
> > =A0 /dev/sdb2=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 70G=A0
> > 5.8G=A0=A0=A065G=A0=A0=A09% /tmp/mnt2
> > =A0 /dev/sdb3=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0830G=A0=A0=A049G=A0
> > 781G=A0=A0=A06% /tmp/mnt3
> > =A0 chingl@optimus:~/testdump> df
> > =A0 Filesystem=A0 =A0 =A0 =A0
> > =A0=A0=A01K-blocks=A0 =A0 =A0 Used
> > Available Use% Mounted on
> > =A0 rootfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0=A0=A0104878048=A0 42063828=A0
> > 62814220=A0 41% /
> > =A0 devtmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0=A0=A01021032=A0 =A0
> > =A0=A0=A0480=A0=A0=A01020552=A0=A0=A01%
> > /dev
> > =A0 tmpfs=A0 =A0 =A0 =A0 =A0 =A0
> > =A0 =A0 =A0 1027960=A0 =A0 =A0
> > 1064=A0=A0=A01026896=A0=A0=A01% /dev/shm
> > =A0 /dev/sda2=A0 =A0 =A0 =A0 =A0 =A0
> > 104878048=A0 42063828=A0 62814220=A0 41% /
> > =A0 /dev/sda3=A0 =A0 =A0 =A0 =A0 =A0
> > 863017248 730313900 132703348=A0 85% /home
> > =A0 /dev/sdb2=A0 =A0 =A0 =A0 =A0
> > =A0=A0=A073363456=A0=A0=A06071484=A0
> > 67291972=A0=A0=A09% /tmp/mnt2
> > =A0 /dev/sdb3=A0 =A0 =A0 =A0 =A0 =A0
> > 869382652=A0 50612640 818770012=A0=A0=A06%
> > /tmp/mnt3
> > =A0 chingl@optimus:~/testdump>
> > =A0 =

> > {>
> > =A0 optimus:/home/chingl/archive/rat #
> > /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore -f
> > ./rat18Aug2011 /tmp/mnt3
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > using file dump (drive_simple) strategy
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > version 3.0.5 (dump format 3.0) - Running
> single-threaded
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > searching media for dump
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > examining media file 0
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > dump description:
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > hostname: rat
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > mount point: /home
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > volume: /dev/sdb3
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > session time: Thu Aug 18 12:57:36 2011
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > level: 0
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > session label: "rat_18Aug2011"
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > media label: "rat18Aug2011"
> >
> 3>/home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > file system id: f3b08587-cf98-4b7b-99b0-dc9d4e77b631
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > session id: d8069cd0-a092-4fb2-b378-0eda33474aae
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > media id: 96370000-6e2c-40eb-9c3c-93ca42de7524
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > searching media for directory dump
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > reading directories
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > 90820 directories and 539579 entries processed
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > directory post-processing
> > =A0 /home/chingl/XFS/xfsdump-3.0.5/restore/xfsrestore:
> > restoring non-directory files
> > =A0 xfsrestore: content.c:7510: restore_extent_group:
> > Assertion `ehdr.eh_type =3D=3D 4' failed.
> > (>Aborted
> > 2>optimus:/home/chingl/archive/rat #
> > =

> > =

> > Could some one please assist to enlighten me what is
> going
> > on, why does the restoration fail?=A0 The xfsdump
> session
> > looked OK.
> > =

> > Is there any way I can extract back my /home back
> up?=A0
> > This is my only back up copy.=A0 i have two other
> xfsdump
> > dump files taken earlier, I have not tried those.
> > =

> > Is xfsdump and xfsrestore really robust for dump to
> regular
> > file, or should I have done a tar instead?
> > =

> > Thank you.
> > =

> > GL
> > =

> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
