Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 Aug 2006 17:58:26 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7D0wADW024326
	for <linux-xfs@oss.sgi.com>; Sat, 12 Aug 2006 17:58:12 -0700
Date: Sat, 12 Aug 2006 18:57:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Bug in xfsrestore or NFS+XFS Filesystem on NFS Server ? Can
 anyone confirm ?
In-Reply-To: <200608120956.47466.juergen.sauer@automatix.de>
Message-ID: <Pine.LNX.4.64.0608121856400.25414@p34.internal.lan>
References: <200608120956.47466.juergen.sauer@automatix.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-2097570038-1155423430=:25414"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Juergen Sauer <juergen.sauer@automatix.de>
Cc: linux-xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-2097570038-1155423430=:25414
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

If you mounted the FS w/ Knoppix 5.0.1 and did reads/wrties, you have=20
corrupted your filesystem. It has 2.6.17, which suffers from the=20
corruption bug.

On Sat, 12 Aug 2006, Juergen Sauer wrote:

> Hi!
> Job to do: filesytem tranfer fom one raid to another / backup a server of
> about 1TB data and restore.
>
> This Senario:
> Server: Ubuntu 6.06 LTS + own xfs-fixed kernel 2.6.17.7
> Backup: Ubuntu 6.06 LTS + own xfs-fixed kernel 2.6.17.7
> Network 1Gbit Copper
>
> xfsdumped server like this:
> 1. logged into the backup system
> 1a. dumped the XFS Filesystem like that:
>> ssh server "xfsdump -l 0 -F -L transfer -M server_backup" - /dev/sdb1" >=
  /backup//backup/server_sdb1_xfsdump
> Worked fine. Rsult was:
> -rw-rw-r-- 1 root root 568776542496 2006-08-10 15:16 /backup/backup-serve=
r_sdb1_xfsdump
>
> But the ssh transfer has got an big overhead off cpu (comression, evcrypt=
ion), so the dump
> was not fast as expected, it took about 2 days.
> So I decided to drop the overhead and to use a NFS link on the restore si=
de.
>
> 2. Now I exchanged the old Hardware Raid on the server and started from K=
noppix V5.01
> (see: http://ftp.freenet.de/pub/ftp.uni-kl.de/pub/linux/knoppix/KNOPPIX_V=
5.0.1CD-2006-06-01-DE.iso
> http://ftp.freenet.de/pub/ftp.uni-kl.de/pub/linux/knoppix/KNOPPIX_V5.0.1C=
D-2006-06-01-EN.iso)
> Knoppix Booted using "knoppix 2"
>
> 2a. created anf formated partitions, sda1, sda2 (sda2 for swap, 4 GN or s=
o. aktivated swap);
> mounted the fresh XFS partiton to /mnt
> 2b. made NFS link to Backup server up (started portmap and mounted the ba=
ckup:/backup/)
>
> 2c. started xfsrestore like that
> xfsrestore -f /backup/backup-server_sda1_xfsdump /mnt/
>
> After about a few hours xfsrestore quitted with a failure:  "Too much ope=
n files", Abort
> The restore Process failed after ca. 66G of 500G.
> OK, I raised the Kernel Openfile MAX, echo 524288 > /proc/sys/fs/file-max
> and tried again.
> xfsrestore -f /backup/backup-server_sda1_xfsdump /mnt/
> Same error at same place.
> Version was:  xfsrestore: version 2.2.36 (dump format 3.0)
>
> Can s.o. confirm this ?
>
> A working around was to use the much slower ssh pipe construct:
> 2d.
> root@Knoppix[~]# ssh backup "dd if=3D/backup/backup-server_sda1_xfsdump b=
s=3D10M" | xfsrestore - /mnt/
>
> This works.
>
> Since that the last restore works, I think there is a bug in xfsrestore o=
r xfs/nfs in the kernel 2.6.17.
> Backupserver, Server, Knoppix are bugfixed 2.6.17(.7). Restoring the dump=
 via nfs failed due "too much open files".
>
> Does xfsrestore opens really 512k files ? I do not belive that.
> So It could a problem in Kernel  or NFS Stack be the problem.
>
> Can any one confirm this behavior ? (to make it better next time)
>
> Greetings from Northern Germany
> 	J=C3=BCrgen Sauer
>
> --=20
> J=C3=BCrgen Sauer - AutomatiX GmbH, +49-4209-4699, jojo@automatix.de
> Das Linux Systemhaus - Service - Support - Server - L=C3=B6sungen
> http://www.automatix.de OpenOffice erhalten Sie hier kostenfrei
> http://de.openoffice.org/
>
>
---1463747160-2097570038-1155423430=:25414--
