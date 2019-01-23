Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 1.mo302.mail-out.ovh.net ([137.74.110.74]:44849 "EHLO
        1.mo302.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfAWJVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 04:21:40 -0500
Received: from dag002ex3.OVH.local (gw1.corp.ovh.com [51.255.55.226])
        by mo302.mail-out.ovh.net (Postfix) with ESMTPS id 5AD344A523
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 10:21:35 +0100 (CET)
From: Julien Lutran <julien.lutran@corp.ovh.com>
Subject: Re: Unable to fix metadata corruption with xfs_repair
Date: Wed, 23 Jan 2019 09:21:34 +0000
Message-ID: <0E6F5832-A9F3-4AA6-AE33-5E85A04EFC45@corp.ovh.com>
References: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
 <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
In-Reply-To: <ac8c49d2-7c51-5f4c-d891-b06fe86c87dc@sandeen.net>
Content-Language: en-US
Content-Type: multipart/signed;
        boundary="Apple-Mail=_BDDA201D-7AD6-46CD-95AE-D5FF721D6C01";
        protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

--Apple-Mail=_BDDA201D-7AD6-46CD-95AE-D5FF721D6C01
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_08E88B12-E5C1-48CF-B24D-818A066B9484"


--Apple-Mail=_08E88B12-E5C1-48CF-B24D-818A066B9484
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello,

> On 21 Jan 2019, at 17:42, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>=20
>=20
> On 1/21/19 9:36 AM, Julien Lutran wrote:
>> Hello,
>>=20
>> I=E2=80=99m experiencing an issue with metadata corruption while =
trying to fix several corrupted xfs filesystems.
>> Here=E2=80=99s an excerpt of the kernel messages when the disk is =
mounted :
>>=20
>> [=E2=80=A6]
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): Metadata corruption =
detected at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): Unmount and run xfs_repair
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): First 64 bytes of corrupted =
metadata buffer:
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): metadata I/O error: block =
0x300160 ("xfs_trans_read_buf_map") error 117 numblks 16
>> Jan 21 15:44:16 rescue kernel: XFS (sdb): xfs_imap_to_bp: =
xfs_trans_read_buf() returned error -117.
>>=20
>> I tried to run a xfs_repair (see attached log) but it ends up the =
same way : metadata error on block 0x300160
>> Is there a way to fix this corruption ?
>>=20
>> Linux kernel version is 4.14.17 but I encountered the exact same =
issue in several other hosts running an older kernel.
>> Xfsprogs version is 4.19.0
>>=20
>>=20
>> Best regards,
>> Julien Lutran
>=20
> Hi Julien -
>=20
> Your log file says:
>=20
> "Start xfs_repair with cmdline: xfs_repair -L -m 8047 /dev/sdb"
>=20
> 1) Why did you use -L, would the log not replay?

That=E2=80=99s because we=E2=80=99re dealing with a lot of corrupted =
filesystems, and our robot sets this option by default to handle =
filesystems heavily damaged.
I ran another =E2=80=9Cxfs_repair -m 8047 -v /dev/sdb=E2=80=9D, see =
attached log.

> 2) Why use -m?  Does that affect the outcome at all?

Because that=E2=80=99s a very loaded server, so we throttle the maxmem =
to 25% of the total RAM.
I tried without setting this parameter but it ends up the same way.

> 3) You could give the for-next branch in git a try, just in case, but =
otherwise

Will do :)

> 4) Please provide a compressed xfs_metadump for me to look at, off =
list, and
>   I'll see what I can find.

xfs_metadump currently running, I will provide it asap.

>=20
> Thanks,
> -Eric
>=20
>=20


--Apple-Mail=_08E88B12-E5C1-48CF-B24D-818A066B9484
Content-Disposition: attachment;
	filename=xfs_repair_verbose.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="xfs_repair_verbose.log"
Content-Transfer-Encoding: 7bit

root@rescue:~# xfs_repair -m 8087 -v /dev/sdb
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - block cache size set to 928312 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 1265445 tail block 1265445
        - scan filesystem freespace and inode maps...
        - 09:25:25: scanning filesystem freespace - 32 of 32 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 09:25:25: scanning agi unlinked lists - 32 of 32 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 30
Metadata corruption detected at 0x4314b3, xfs_inode block 0x300160/0x2000
        - agno = 16
bad magic number 0x0 on inode 6292176
bad version number 0x0 on inode 6292176
bad magic number 0x0 on inode 6292177
bad version number 0x0 on inode 6292177
bad magic number 0x0 on inode 6292178
bad version number 0x0 on inode 6292178
bad magic number 0x0 on inode 6292179
bad version number 0x0 on inode 6292179
bad magic number 0x0 on inode 6292180
bad version number 0x0 on inode 6292180
bad magic number 0x0 on inode 6292181
bad version number 0x0 on inode 6292181
bad magic number 0x0 on inode 6292182
bad version number 0x0 on inode 6292182
bad magic number 0x0 on inode 6292183
bad version number 0x0 on inode 6292183
bad magic number 0x0 on inode 6292184
bad version number 0x0 on inode 6292184
bad magic number 0x0 on inode 6292185
bad version number 0x0 on inode 6292185
bad magic number 0x0 on inode 6292186
bad version number 0x0 on inode 6292186
bad magic number 0x0 on inode 6292187
bad version number 0x0 on inode 6292187
bad magic number 0x0 on inode 6292188
bad version number 0x0 on inode 6292188
bad magic number 0x0 on inode 6292189
bad version number 0x0 on inode 6292189
bad magic number 0x0 on inode 6292190
bad version number 0x0 on inode 6292190
bad magic number 0x0 on inode 6292191
bad version number 0x0 on inode 6292191
bad magic number 0x0 on inode 6292176, resetting magic number
bad version number 0x0 on inode 6292176, resetting version number
bad magic number 0x0 on inode 6292177, resetting magic number
bad version number 0x0 on inode 6292177, resetting version number
bad magic number 0x0 on inode 6292178, resetting magic number
bad version number 0x0 on inode 6292178, resetting version number
bad magic number 0x0 on inode 6292179, resetting magic number
bad version number 0x0 on inode 6292179, resetting version number
bad magic number 0x0 on inode 6292180, resetting magic number
bad version number 0x0 on inode 6292180, resetting version number
bad magic number 0x0 on inode 6292181, resetting magic number
bad version number 0x0 on inode 6292181, resetting version number
bad magic number 0x0 on inode 6292182, resetting magic number
bad version number 0x0 on inode 6292182, resetting version number
bad magic number 0x0 on inode 6292183, resetting magic number
bad version number 0x0 on inode 6292183, resetting version number
bad magic number 0x0 on inode 6292184, resetting magic number
bad version number 0x0 on inode 6292184, resetting version number
bad magic number 0x0 on inode 6292185, resetting magic number
bad version number 0x0 on inode 6292185, resetting version number
bad magic number 0x0 on inode 6292186, resetting magic number
bad version number 0x0 on inode 6292186, resetting version number
bad magic number 0x0 on inode 6292187, resetting magic number
bad version number 0x0 on inode 6292187, resetting version number
bad magic number 0x0 on inode 6292188, resetting magic number
bad version number 0x0 on inode 6292188, resetting version number
bad magic number 0x0 on inode 6292189, resetting magic number
bad version number 0x0 on inode 6292189, resetting version number
bad magic number 0x0 on inode 6292190, resetting magic number
bad version number 0x0 on inode 6292190, resetting version number
bad magic number 0x0 on inode 6292191, resetting magic number
bad version number 0x0 on inode 6292191, resetting version number
        - agno = 1
        - agno = 17
        - agno = 31
        - agno = 2
        - agno = 18
        - agno = 19
        - agno = 3
Metadata corruption detected at 0x431775, xfs_inode block 0x300160/0x2000
libxfs_writebufr: write verifer failed on xfs_inode bno 0x300160/0x2000
        - agno = 20
        - agno = 4
        - agno = 21
        - agno = 5
        - agno = 22
        - agno = 6
        - agno = 23
        - agno = 7
        - agno = 24
        - agno = 8
        - agno = 25
        - agno = 9
        - agno = 26
        - agno = 10
        - agno = 27
        - agno = 11
        - agno = 28
        - agno = 12
        - agno = 13
        - agno = 29
        - agno = 14
        - 12:12:06: process known inodes and inode discovery - 22822912 of 22822912 inodes done
        - process newly discovered inodes...
        - 12:12:06: process newly discovered inodes - 32 of 32 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 12:12:06: setting up duplicate extent list - 32 of 32 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 15
        - agno = 0
        - agno = 30
Metadata corruption detected at 0x4314b3, xfs_inode block 0x300160/0x2000
        - agno = 16
        - agno = 1
        - agno = 31
        - agno = 17
        - agno = 2
        - agno = 18
        - agno = 3
        - agno = 19
        - agno = 4
        - agno = 20
        - agno = 21
        - agno = 5
        - agno = 6
        - agno = 22
        - agno = 7
        - agno = 23
        - agno = 8
        - agno = 9
        - agno = 24
        - agno = 10
        - agno = 25
        - agno = 11
        - agno = 26
        - agno = 12
        - agno = 13
        - agno = 27
        - agno = 14
        - agno = 28
        - agno = 29
        - 12:20:54: check for inodes claiming duplicate blocks - 22822912 of 22822912 inodes done
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
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
        - agno = 20
        - agno = 21
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
        - 12:20:58: rebuild AG headers and trees - 32 of 32 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
Metadata corruption detected at 0x4314b3, xfs_inode block 0x300160/0x2000
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
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
        - agno = 20
        - agno = 21
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
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
        - 12:29:22: verify and correct link counts - 32 of 32 allocation groups done
Metadata corruption detected at 0x431775, xfs_inode block 0x300160/0x2000
libxfs_writebufr: write verifer failed on xfs_inode bno 0x300160/0x2000
releasing dirty buffer (bulk) to free list!
        XFS_REPAIR Summary    Tue Jan 22 12:29:31 2019

Phase           Start           End             Duration
Phase 1:        01/22 09:25:08  01/22 09:25:08
Phase 2:        01/22 09:25:08  01/22 09:25:25  17 seconds
Phase 3:        01/22 09:25:25  01/22 12:12:06  2 hours, 46 minutes, 41 seconds
Phase 4:        01/22 12:12:06  01/22 12:20:54  8 minutes, 48 seconds
Phase 5:        01/22 12:20:54  01/22 12:20:58  4 seconds
Phase 6:        01/22 12:20:58  01/22 12:29:22  8 minutes, 24 seconds
Phase 7:        01/22 12:29:22  01/22 12:29:22

Total run time: 3 hours, 4 minutes, 14 seconds
done

--Apple-Mail=_08E88B12-E5C1-48CF-B24D-818A066B9484--

--Apple-Mail=_BDDA201D-7AD6-46CD-95AE-D5FF721D6C01
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIzBAEBCgAdFiEEHWtkGxqIdLStc9rVXqwUC54mmJYFAlxIMh0ACgkQXqwUC54m
mJY5ZhAAifAdXTVtKV3KQLSa2HwEcMfhf/c38Do9iyoYIj6lZibzvCY/CWd7gHrJ
cfktjU+OQrWksy9Nr/5Q0JHp11VZ/5JKJDVdTTMSAGtOO5xNt4npVcgtMoTIyVrT
g9LtM/RBaG0MpLESfUEGwzCgr0iCejHF3g1yOXvaGLckSg213oToGdeUTCyEIWNK
m+Ftryj1jXLETwoa0/rPpcOrglSb2acOZvS9bHxw7Si2czQ9sztmNV8BNZ2CMRzc
6lfnyBeIUc/eABkEfjNTjl61iHAp+HY193rHoqETyFimIaMD7g7i5UilopRUV6E7
NfP5gMzfnqnBee9jsAHz4mPjeUi+Tr5Y4hJZOwF00dUAXTyun2GDwy21ksYQrN7D
2zA1/o/idRKReyQT5alAAz5tZDwrUVUI1l2iSMfMaKyOafb5xxXFTC0BbFlUiTQM
gh6zobvtnDbnKs8zTPhNGwJtwqdtrCCma7218EjJt37LjIaJ0yPWrwJV7r99sAYu
+z/ZBkrlV1tjHSPGM9p3ExAe8J4GXAxNGy7hlD2AcsfeJQzqTkQGnuXGeKv3/029
EgszmJ6HQ8wOj2Dn4uGL+xCBjbhYE7w9nD5S9nmIEilQ/WFOKp3/d1ZObBfKM2y0
pzOPhNfOlIm9g4yfqPhOM6rFK0YqaFKmyiGT/p5BjRUor/d9eUs=
=Owo4
-----END PGP SIGNATURE-----

--Apple-Mail=_BDDA201D-7AD6-46CD-95AE-D5FF721D6C01--
