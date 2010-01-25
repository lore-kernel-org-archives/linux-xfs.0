Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PFeNMJ062276 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 09:40:24 -0600
Received: from mail-fx0-f223.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B44B1C758DF
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 07:41:26 -0800 (PST)
Received: from mail-fx0-f223.google.com (mail-fx0-f223.google.com
	[209.85.220.223]) by cuda.sgi.com with ESMTP id
	WmdxzEyPVfYB2BZJ for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 07:41:26 -0800 (PST)
Received: by fxm23 with SMTP id 23so3700569fxm.18
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 07:41:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5A7D8E.3090001@sandeen.net>
References: <f4da9efd1001220748i140ec49jddbb7098dddf4960@mail.gmail.com>
	<4B5A7D8E.3090001@sandeen.net>
Date: Mon, 25 Jan 2010 10:41:25 -0500
Message-ID: <f4da9efd1001250741o6d0b49c0i93b39c611e7bd212@mail.gmail.com>
Subject: Re: Assistance needed mounting XFS version 1 filesystem
From: Jordan <jordan.chadwick@gmail.com>
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

On Fri, Jan 22, 2010 at 11:39 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Jordan wrote:
>> Hello,
>> I have been trying to mount an old Maxoptix optical drive with
>> XFS-formatted media for a week now without success. =A0From what I can
>> tell, the media were formatted using XFS version 1, support for which
>> was removed from the Linux kernel a few years back.
>>
>> Here is the output of fdisk -l:
>> Disk /dev/sda (SGI disk label): 64 heads, 32 sectors, 1096 cylinders
>> Units =3D cylinders of 2048 * 512 bytes
>>
>> ----- partitions -----
>> Pt# =A0 =A0 Device =A0Info =A0 =A0 Start =A0 =A0 =A0 End =A0 Sectors =A0=
Id =A0System
>> =A01: =A0/dev/sda1 =A0boot =A0 =A0 =A0 =A0 2 =A0 =A0 =A0 986 =A0 2018340=
 =A0 a =A0SGI xfs
>> =A02: =A0/dev/sda2 =A0swap =A0 =A0 =A0 987 =A0 =A0 =A01096 =A0 =A0224490=
 =A0 3 =A0SGI raw
>> =A09: =A0/dev/sda3 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 1 =A0 =
=A0 =A02100 =A0 0 =A0SGI volhdr
>> 11: =A0/dev/sda4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A01096 =A0 22449=
30 =A0 6 =A0SGI volume
>> ----- Bootinfo -----
>> Bootfile: /unix
>> ----- Directory Entries -----
>> =A00: sgilabel =A0 sector =A0 =A02 size =A0 =A0 512
>>
>> When I try to mount the /dev/sda1 partition, I get the following error:
>>
>> # mount -t xfs /dev/sda1 /optical
>> mount: block device /dev/sda1 is write-protected, mounting read-only
>> mount: /dev/sda1: can't read superblock
>>
>> # dmesg | tail
>> Current sda: sense key Data Protect
>> Additional sense: Write protected
>> end_request: I/O error, dev sda, sector 1017642
>
> Seems like this might be a real IO error... it's within the size
> of sda1 (from above), and also within the filesystem geometry
> (from db output below)
>
> Maybe you can try creating a dd_rescue image of the fs, and mount that?
>
> -Eric


That did the trick.  Thanks very much for the idea, I hadn't thought
to try accessing it through another means besides mount.

Jordan


>
>> xfs_force_shutdown(sda1,0x1) called from line 353 of file
>> fs/xfs/xfs_rw.c. =A0Return address =3D 0x44ff9bfa
>> Filesystem "sda1": I/O Error Detected. =A0Shutting down filesystem: sda1
>> Please umount the filesystem, and rectify the problem(s)
>> I/O error in filesystem ("sda1") meta-data dev sda1 block 0xf7dfe
>> =A0("xlog_bwrite") error 5 buf count 131072
>> XFS: failed to locate log tail
>> XFS: log mount/recovery failed
>> XFS: log mount failed
>>
>> xfs_check comes back with no errors.
>>
>> # xfs_db /dev/sda1
>> xfs_db> sb 0
>> xfs_db> p
>> magicnum =3D 0x58465342
>> blocksize =3D 4096
>> dblocks =3D 252292
>> rblocks =3D 0
>> rextents =3D 0
>> uuid =3D d4bc0c01-b21d-1001-866b-0800690a794d
>> logstart =3D 131076
>> rootino =3D 128
>> rbmino =3D 129
>> rsumino =3D 130
>> rextsize =3D 16
>> agblocks =3D 31537
>> agcount =3D 8
>> rbmblocks =3D 0
>> logblocks =3D 1000
>> versionnum =3D 0x1
>> sectsize =3D 512
>> inodesize =3D 256
>> inopblock =3D 16
>> fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
>> blocklog =3D 12
>> sectlog =3D 9
>> inodelog =3D 8
>> inopblog =3D 4
>> agblklog =3D 15
>> rextslog =3D 0
>> inprogress =3D 0
>> imax_pct =3D 25
>> icount =3D 704
>> ifree =3D 322
>> fdblocks =3D 122918
>> frextents =3D 0
>> uquotino =3D 0
>> gquotino =3D 0
>> qflags =3D 0
>> flags =3D 0
>> shared_vn =3D 0
>> inoalignmt =3D 0
>> unit =3D 0
>> width =3D 0
>> dirblklog =3D 0
>> logsectlog =3D 0
>> logsectsize =3D 0
>> logsunit =3D 0
>> features2 =3D 0
>> xfs_db>
>>
>> My running kernel is 2.6.5-1.358 on Fedora Core 2. =A0I went with an old
>> distribution to try to find a kernel that still has XFS version 1
>> support built in.
>>
>> Any help or advice you could provide would be great.
>>
>> Jordan
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
