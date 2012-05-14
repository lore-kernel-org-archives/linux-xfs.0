Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4EFCXMC102740 for <xfs@oss.sgi.com>; Mon, 14 May 2012 10:12:34 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id E93EZLNO6Ixt9ltR for <xfs@oss.sgi.com>;
	Mon, 14 May 2012 08:12:31 -0700 (PDT)
Message-ID: <4FB120DE.4030703@sandeen.net>
Date: Mon, 14 May 2012 10:12:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: badly destroyed XFS (on LVM) - how to repair?
References: <1763478.Vy9F5bcWiZ@saturn>
In-Reply-To: <1763478.Vy9F5bcWiZ@saturn>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 5/12/12 7:49 AM, Michael Monnerie wrote:
> (This might be an LVM problem, but who knows?)
> =

> I have here an XFS that was on a server running within a XenServer =

> machine. In the end it existed of 4x 2TB disks:
> # pvscan =

>   PV /dev/xvdg   VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvdf   VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvdc   VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvde   VG sharestore   lvm2 [1.95 TiB / 0    free]
>   Total: 4 [7.81 TiB] / in use: 4 [7.81 TiB] / in no VG: 0 [0   ]
> =

> Then by accident the admin made "fdisk /dev/xvdg", created a partition
> like this:
> Platte /dev/xvdg: 1073 MByte, 1073741824 Byte
> 139 K=F6pfe, 8 Sektoren/Spuren, 1885 Zylinder
> Einheiten =3D Zylinder von 1112 =D7 512 =3D 569344 Bytes
> Disk identifier: 0xb30cf4db
> =

>     Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id  System
> /dev/xvdg1               1        1886     1048448   82  Linux Swap
> =

> (partittion starting sector 63), and did "mkswap /dev/xvdg1". After a =

> reboot, LVM did not recognize the full disk anymore.
> =

> # pvscan =

>   Couldn't find device with uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w.
>   PV unknown device   VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvdf        VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvdc        VG sharestore   lvm2 [1.95 TiB / 0    free]
>   PV /dev/xvde        VG sharestore   lvm2 [1.95 TiB / 0    free]
>   Total: 4 [7.81 TiB] / in use: 4 [7.81 TiB] / in no VG: 0 [0 =

> =

> This is where I jumped in. I must say that in the meantime the source VM =

> got deleted, and that I only got access to the data disks. I believe =

> /dev/xvdg was the very first of those LVM disks before, but I'm not =

> sure.
> =

> I tried "pvcreate --uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w --
> norestorefile /dev/xvdg", which did not succeed.
> Then I made a backup of the first sectors of /dev/xvdg, and did
> "dd if=3D/dev/xvdf of=3D/dev/xvdg bs=3D512 count=3D63", and tried again w=
ith
> "pvcreate --uuid 396XfX-EbMZ-0J6q-C3bj-3n6d-vruJ-6Oiy7w --norestorefile =

> /dev/xvdg" - this time it worked. Strange thing: /dev/sharestore/public =

> is not created, it's only accessible via /dev/dm-0, but =

> I can mount the XFS but it's destroyed, "ls" shows:
> ls: cannot access /1/hope: Invalid argument
> ls: cannot access /1/jog: Invalid argument
> ls: cannot access /1/maza: Invalid argument
> ls: cannot access /1/public: Invalid argument
> ls: cannot access /1/upload: Invalid argument
> ls: cannot access /1/du.old: Invalid argument
> ls: cannot access /1/.fsr: Invalid argument
> total 45

Anything in dmesg?

> drwxrwx---  17 root       1000 4096 May  1 00:00 ./
> drwxr-xr-x  25 root    root     632 May 12 12:42 ../
> ???????????  ? ?       ?          ?            ? .fsr
> drwx------   7    1007 nogroup 4096 Oct 19  2010 anse/
> -rw-r--r--   1 root    root     951 Jan  1 00:10 du.20120101
> -rw-r--r--   1 root    root     456 Feb  1 00:10 du.20120201
> -rw-r--r--   1 root    root     455 Mar  1 00:11 du.20120301
> -rw-r--r--   1 root    root     464 Apr  1 00:06 du.20120401
> -rw-r--r--   1 root    root     464 May  1 00:00 du.20120501
> ???????????  ? ?       ?          ?            ? du.old
> -rwx------   1 root    root     253 Nov  7  2010 find-inode.sh*
> ???????????  ? ?       ?          ?            ? hope
> drwxrwxr-x+  4    1007 nogroup   49 Nov 29  2009 itm/
> ???????????  ? ?       ?          ?            ? jog
> drwx------   6 makedns nogroup 4096 Aug 24  2010 lama/
> ???????????  ? ?       ?          ?            ? maza
> drwx------   2    1008 nogroup   68 Jan 12  2010 paan/
> ???????????  ? ?       ?          ?            ? public
> drwxrwxr-t   5 root    www     4096 Mar 17 11:33 tmp/
> drwxr-xr-x   2 nobody  root     144 Mar 17 11:41 torrent/
> ???????????  ? ?       ?          ?            ? upload
> drwx------   2    1003 nogroup   88 Nov 23  2009 vop/
> =

> Then I made a xfs_metadump, and xfs_repair, both with version 3.0.1, =

> which seems to not work. xfs_repair said this:
> =

> # xfs_repair -n /dev/dm-0 2>&1|tee xfs.log
> Phase 1 - find and verify superblock...

...

> No modify flag set, skipping filesystem flush and exiting.
> =

> So it found no error. I then installed xfsprogs 3.1.8, and tried the =

> repair on the metadump:
> =

> # xfs_repair xfs.metadump

You have to mdrestore the metadump before you can point repair it it, so th=
at's not a valid operation.  No =


<later>

> Seems like it's an XFS problem - could someone help me here?

Considering that the problem began when the block device got
repartitioned etc, I don't see how this can be an XFS problem...

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
