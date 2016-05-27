Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 381737CB0
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 17:39:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BFDA304048
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 15:39:52 -0700 (PDT)
Received: from gourmet8.spamgourmet.com (gourmet.spamgourmet.com
	[216.75.62.102]) by cuda.sgi.com with ESMTP id HbOzycQdl7eonVNQ
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 15:39:48 -0700 (PDT)
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <xfs.pkoch@dfgh.net>) id 1b6QQ0-00056Z-09
	for xfs@oss.sgi.com; Fri, 27 May 2016 22:39:48 +0000
MIME-Version: 1.0
Date: Sat, 28 May 2016 00:39:45 +0200
Message-ID: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
Subject: xfsrestore performance
From: xfs.pkoch@dfgh.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0692074155691759472=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0692074155691759472==
Content-Type: multipart/alternative; boundary=047d7bb03d8a62eec50533da95c4

--047d7bb03d8a62eec50533da95c4
Content-Type: text/plain; charset=UTF-8

Dear XFS experts,

I was using a 16TB linux mdraid raid10 volume built from 16 seagate
2TB disks, which was formatted with an ext3 filesystem. It contained
a couple of hundred very large files (ZFS full and incremental dumps
with sizes between 10GB and 400GB). It also contained 7 million
files from our users home directories, which where backuped with
rsync --link-dest=<last backup dir>, so most of these files are
just hard links to previous versions.

Two weeks ago I increased the volume from 16TB to 20TB which
can be done with linux mdraid while still using the filesystem.
Reshaping lasts two days. Then I umounted the ext3 filesystem
to grow it from 16TB to 20TB. And guess what - ext3 does not
support filesystem > 16TB.

I decided to change the filesystem to XFS but the system must be
online during weekdays so I have a 48 hour timeframe to do
lenghty copies.

I added a 16TB temporary RAID5 volume to the machine and here's
what I did so far:

1: create a 14TB XFS-filesystem on the temporary RAID5-volume
2: first rsync run to copy the ext3 fs to the temporary XFS-fs,
this took 6 days
3: another rsync run to copy what changed during the first run,
this took another 2 days
4: another rsync run to copy what changed during the second run,
this took another day
5: xfsdump the temporary xfs fs to /dev/null. took 20 hours
5: remounting the ext3 fs readonly and do a final rsync run to
copy what changed during the third run. This took 10 hours.
6: delete the ext3 fs and create a 20TB xfs fs
7: copy back the temporary xfs fs to the new xfs fs using
xfsdump | xfsrestore

Here's my problem Since dumping the temporary xfs fs to /dev/null
needed less than a day I expected the xfsdump | xfsrestore
combination to be finished in less than 2 day. xfsdump | xfsrestore
should be a lot fasten than rsync since it justs pumps blocks from
one xfs fs into another one.

But either xfsrestore is painfully slow or I did something wrong:

Please have a look:

root@backup:/var/tmp# xfsdump -J -p600 - /xtmp | xfsrestore -J -a /var/tmp
- /xtmp2
xfsrestore: using file dump (drive_simple) strategy
xfsdump: using file dump (drive_simple) strategy
xfsrestore: version 3.1.3 (dump format 3.0)
xfsdump: version 3.1.3 (dump format 3.0)
xfsrestore: searching media for dump
xfsdump: level 0 dump of backup:/xtmp
xfsdump: dump date: Fri May 27 13:15:42 2016
xfsdump: session id: adb95c2e-332b-4dde-9c8b-e03760d5a83b
xfsdump: session label: ""
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: status at 13:25:42: inomap phase 1 14008321/28643415 inos scanned,
600 seconds elapsed
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 12831156312640 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsrestore: examining media file 0
xfsrestore: dump description:
xfsrestore: hostname: backup
xfsrestore: mount point: /xtmp
xfsrestore: volume: /dev/md6
xfsrestore: session time: Fri May 27 13:15:42 2016
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: 29825afd-5d7e-485f-9eb1-8871a21ce71d
xfsrestore: session id: adb95c2e-332b-4dde-9c8b-e03760d5a83b
xfsrestore: media id: 5ef22542-774a-4504-a823-d007d2ce4720
xfsrestore: searching media for directory dump
xfsrestore: NOTE: attempt to reserve 1162387864 bytes for
/var/tmp/xfsrestorehousekeepingdir/dirattr using XFS_IOC_RESVSP64 failed:
Operation not supported (95)
xfsrestore: NOTE: attempt to reserve 286438226 bytes for
/var/tmp/xfsrestorehousekeepingdir/namreg using XFS_IOC_RESVSP64 failed:
Operation not supported (95)
xfsrestore: reading directories
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: status at 20:04:52: 1/7886560 files dumped, 0.0% data dumped,
24550 seconds elapsed
xfsrestore: 20756853 directories and 274128228 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: status at 21:27:27: 26/7886560 files dumped, 0.0% data dumped,
29505 seconds elapsed
xfsdump: status at 21:35:46: 20930/7886560 files dumped, 0.0% data dumped,
30004 seconds elapsed
xfsdump: status at 21:46:26: 46979/7886560 files dumped, 0.1% data dumped,
30644 seconds elapsed
xfsdump: status at 21:55:52: 51521/7886560 files dumped, 0.1% data dumped,
31210 seconds elapsed
xfsdump: status at 22:05:45: 57770/7886560 files dumped, 0.1% data dumped,
31803 seconds elapsed
xfsdump: status at 22:15:43: 63142/7886560 files dumped, 0.1% data dumped,
32401 seconds elapsed
xfsdump: status at 22:25:42: 73621/7886560 files dumped, 0.1% data dumped,
33000 seconds elapsed
xfsdump: status at 22:35:51: 91223/7886560 files dumped, 0.1% data dumped,
33609 seconds elapsed
xfsdump: status at 22:45:42: 94096/7886560 files dumped, 0.2% data dumped,
34200 seconds elapsed
xfsdump: status at 22:55:42: 96702/7886560 files dumped, 0.2% data dumped,
34800 seconds elapsed
xfsdump: status at 23:05:42: 102808/7886560 files dumped, 0.2% data dumped,
35400 seconds elapsed
xfsdump: status at 23:16:15: 107096/7886560 files dumped, 0.2% data dumped,
36033 seconds elapsed
xfsdump: status at 23:25:47: 109079/7886560 files dumped, 0.2% data dumped,
36605 seconds elapsed
xfsdump: status at 23:35:52: 112318/7886560 files dumped, 0.2% data dumped,
37210 seconds elapsed
xfsdump: status at 23:45:46: 114975/7886560 files dumped, 0.2% data dumped,
37804 seconds elapsed
xfsdump: status at 23:55:55: 117260/7886560 files dumped, 0.2% data dumped,
38413 seconds elapsed
xfsdump: status at 00:05:44: 118722/7886560 files dumped, 0.2% data dumped,
39002 seconds elapsed

Seems like 2 days was a little optimistic

Any ideas what's going wrong here?

Peter Koch

--047d7bb03d8a62eec50533da95c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div>Dear XFS experts,<=
br><br></div>I was using a 16TB linux mdraid raid10 volume built from 16 se=
agate<br>2TB disks, which was formatted with an ext3 filesystem. It contain=
ed<br>a couple of hundred very large files (ZFS full and incremental dumps<=
br>with sizes between 10GB and 400GB). It also contained 7 million<br>files=
 from our users home directories, which where backuped with<br>rsync --link=
-dest=3D&lt;last backup dir&gt;, so most of these files are<br>just hard li=
nks to previous versions.<br><br></div>Two weeks ago I increased the volume=
 from 16TB to 20TB which<br>can be done with linux mdraid while still using=
 the filesystem.<br>Reshaping lasts two days. Then I umounted the ext3 file=
system<br>to grow it from 16TB to 20TB. And guess what - ext3 does not<br>s=
upport filesystem &gt; 16TB.<br><br></div>I decided to change the filesyste=
m to XFS but the system must be<br></div>online during weekdays so I have a=
 48 hour timeframe to do<br></div>lenghty copies.<br><br></div>I added a 16=
TB temporary RAID5 volume to the machine and here&#39;s<br>what I did so fa=
r:<br><br>1: create a 14TB XFS-filesystem on the temporary RAID5-volume<br>=
2: first rsync run to copy the ext3 fs to the temporary XFS-fs,<br></div><d=
iv>this took 6 days<br></div><div>3: another rsync run to copy what changed=
 during the first run,<br></div>this took another 2 days<br><div>4: another=
 rsync run to copy what changed during the second run,<br></div>this took a=
nother day<br></div><div>5: xfsdump the temporary xfs fs to /dev/null. took=
 20 hours<br></div><div><div>5: remounting the ext3 fs readonly and do a fi=
nal rsync run to<br>copy what changed during the third run. This took 10 ho=
urs.<br></div><div>6: delete the ext3 fs and create a 20TB xfs fs<br></div>=
<div>7: copy back the temporary xfs fs to the new xfs fs using<br></div><di=
v>xfsdump | xfsrestore<br><br></div><div>Here&#39;s my problem Since dumpin=
g the temporary xfs fs to /dev/null<br></div><div>needed less than a day I =
expected the xfsdump | xfsrestore<br></div><div>combination to be finished =
in less than 2 day. xfsdump | xfsrestore<br></div><div>should be a lot fast=
en than rsync since it justs pumps blocks from<br>one xfs fs into another o=
ne.<br><br></div><div>But either xfsrestore is painfully slow or I did some=
thing wrong:<br><br></div><div>Please have a look:<br><br>root@backup:/var/=
tmp# xfsdump -J -p600 - /xtmp | xfsrestore -J -a /var/tmp - /xtmp2<br>xfsre=
store: using file dump (drive_simple) strategy<br>xfsdump: using file dump =
(drive_simple) strategy<br>xfsrestore: version 3.1.3 (dump format 3.0)<br>x=
fsdump: version 3.1.3 (dump format 3.0)<br>xfsrestore: searching media for =
dump<br>xfsdump: level 0 dump of backup:/xtmp<br>xfsdump: dump date: Fri Ma=
y 27 13:15:42 2016<br>xfsdump: session id: adb95c2e-332b-4dde-9c8b-e03760d5=
a83b<br>xfsdump: session label: &quot;&quot;<br>xfsdump: ino map phase 1: c=
onstructing initial dump list<br>xfsdump: status at 13:25:42: inomap phase =
1 14008321/28643415 inos scanned, 600 seconds elapsed<br>xfsdump: ino map p=
hase 2: skipping (no pruning necessary)<br>xfsdump: ino map phase 3: skippi=
ng (only one dump stream)<br>xfsdump: ino map construction complete<br>xfsd=
ump: estimated dump size: 12831156312640 bytes<br>xfsdump: creating dump se=
ssion media file 0 (media 0, file 0)<br>xfsdump: dumping ino map<br>xfsrest=
ore: examining media file 0<br>xfsrestore: dump description:<br>xfsrestore:=
 hostname: backup<br>xfsrestore: mount point: /xtmp<br>xfsrestore: volume: =
/dev/md6<br>xfsrestore: session time: Fri May 27 13:15:42 2016<br>xfsrestor=
e: level: 0<br>xfsrestore: session label: &quot;&quot;<br>xfsrestore: media=
 label: &quot;&quot;<br>xfsrestore: file system id: 29825afd-5d7e-485f-9eb1=
-8871a21ce71d<br>xfsrestore: session id: adb95c2e-332b-4dde-9c8b-e03760d5a8=
3b<br>xfsrestore: media id: 5ef22542-774a-4504-a823-d007d2ce4720<br>xfsrest=
ore: searching media for directory dump<br>xfsrestore: NOTE: attempt to res=
erve 1162387864 bytes for /var/tmp/xfsrestorehousekeepingdir/dirattr using =
XFS_IOC_RESVSP64 failed: Operation not supported (95)<br>xfsrestore: NOTE: =
attempt to reserve 286438226 bytes for /var/tmp/xfsrestorehousekeepingdir/n=
amreg using XFS_IOC_RESVSP64 failed: Operation not supported (95)<br>xfsres=
tore: reading directories<br>xfsdump: dumping directories<br>xfsdump: dumpi=
ng non-directory files<br>xfsdump: status at 20:04:52: 1/7886560 files dump=
ed, 0.0% data dumped, 24550 seconds elapsed<br>xfsrestore: 20756853 directo=
ries and 274128228 entries processed<br>xfsrestore: directory post-processi=
ng<br>xfsrestore: restoring non-directory files<br>xfsdump: status at 21:27=
:27: 26/7886560 files dumped, 0.0% data dumped, 29505 seconds elapsed<br>xf=
sdump: status at 21:35:46: 20930/7886560 files dumped, 0.0% data dumped, 30=
004 seconds elapsed<br>xfsdump: status at 21:46:26: 46979/7886560 files dum=
ped, 0.1% data dumped, 30644 seconds elapsed<br>xfsdump: status at 21:55:52=
: 51521/7886560 files dumped, 0.1% data dumped, 31210 seconds elapsed<br>xf=
sdump: status at 22:05:45: 57770/7886560 files dumped, 0.1% data dumped, 31=
803 seconds elapsed<br>xfsdump: status at 22:15:43: 63142/7886560 files dum=
ped, 0.1% data dumped, 32401 seconds elapsed<br>xfsdump: status at 22:25:42=
: 73621/7886560 files dumped, 0.1% data dumped, 33000 seconds elapsed<br>xf=
sdump: status at 22:35:51: 91223/7886560 files dumped, 0.1% data dumped, 33=
609 seconds elapsed<br>xfsdump: status at 22:45:42: 94096/7886560 files dum=
ped, 0.2% data dumped, 34200 seconds elapsed<br>xfsdump: status at 22:55:42=
: 96702/7886560 files dumped, 0.2% data dumped, 34800 seconds elapsed<br>xf=
sdump: status at 23:05:42: 102808/7886560 files dumped, 0.2% data dumped, 3=
5400 seconds elapsed<br>xfsdump: status at 23:16:15: 107096/7886560 files d=
umped, 0.2% data dumped, 36033 seconds elapsed<br>xfsdump: status at 23:25:=
47: 109079/7886560 files dumped, 0.2% data dumped, 36605 seconds elapsed<br=
>xfsdump: status at 23:35:52: 112318/7886560 files dumped, 0.2% data dumped=
, 37210 seconds elapsed<br>xfsdump: status at 23:45:46: 114975/7886560 file=
s dumped, 0.2% data dumped, 37804 seconds elapsed<br>xfsdump: status at 23:=
55:55: 117260/7886560 files dumped, 0.2% data dumped, 38413 seconds elapsed=
<br>xfsdump: status at 00:05:44: 118722/7886560 files dumped, 0.2% data dum=
ped, 39002 seconds elapsed<br></div><div><br></div><div>Seems like 2 days w=
as a little optimistic<br></div><br>Any ideas what&#39;s going wrong here?<=
br><br>Peter Koch<br clear=3D"all"></div></div>

--047d7bb03d8a62eec50533da95c4--


--===============0692074155691759472==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0692074155691759472==--
