Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 2.mo302.mail-out.ovh.net ([137.74.110.75]:39875 "EHLO
        2.mo302.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfAUPlu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 10:41:50 -0500
Received: from dag002ex1.OVH.local (gw1.corp.ovh.com [51.255.55.226])
        by mo302.mail-out.ovh.net (Postfix) with ESMTPS id 61B504A37D
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jan 2019 16:36:11 +0100 (CET)
From: Julien Lutran <julien.lutran@corp.ovh.com>
Subject: Unable to fix metadata corruption with xfs_repair
Date: Mon, 21 Jan 2019 15:36:11 +0000
Message-ID: <68A7E1A3-8AE1-4CD5-86E2-ABDD5F64D2CB@corp.ovh.com>
Content-Language: en-US
Content-Type: multipart/signed;
        boundary="Apple-Mail=_62E64CC6-F48A-4B4F-814F-0F7C6997C3A9";
        protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

--Apple-Mail=_62E64CC6-F48A-4B4F-814F-0F7C6997C3A9
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_4005CA70-654D-417A-9B1D-994C90F9A5E5"


--Apple-Mail=_4005CA70-654D-417A-9B1D-994C90F9A5E5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello,

I=E2=80=99m experiencing an issue with metadata corruption while trying =
to fix several corrupted xfs filesystems.
Here=E2=80=99s an excerpt of the kernel messages when the disk is =
mounted :

[=E2=80=A6]
Jan 21 15:44:16 rescue kernel: XFS (sdb): Metadata corruption detected =
at xfs_inode_buf_verify+0x6d/0xf0, xfs_inode block 0x300160
Jan 21 15:44:16 rescue kernel: XFS (sdb): Unmount and run xfs_repair
Jan 21 15:44:16 rescue kernel: XFS (sdb): First 64 bytes of corrupted =
metadata buffer:
Jan 21 15:44:16 rescue kernel: XFS (sdb): metadata I/O error: block =
0x300160 ("xfs_trans_read_buf_map") error 117 numblks 16
Jan 21 15:44:16 rescue kernel: XFS (sdb): xfs_imap_to_bp: =
xfs_trans_read_buf() returned error -117.

I tried to run a xfs_repair (see attached log) but it ends up the same =
way : metadata error on block 0x300160
Is there a way to fix this corruption ?

Linux kernel version is 4.14.17 but I encountered the exact same issue =
in several other hosts running an older kernel.
Xfsprogs version is 4.19.0


Best regards,
Julien Lutran



--Apple-Mail=_4005CA70-654D-417A-9B1D-994C90F9A5E5
Content-Disposition: attachment;
	filename=xfs_repair.log
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="xfs_repair.log"
Content-Transfer-Encoding: 7bit

Start xfs_repair with cmdline: xfs_repair -L -m 8047 /dev/sdb

Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 11:33:19: scanning filesystem freespace - 32 of 32 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 11:33:19: scanning agi unlinked lists - 32 of 32 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 0
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
        - agno = 11
        - agno = 27
        - agno = 12
        - agno = 28
        - agno = 13
        - agno = 29
        - agno = 14
        - 14:22:46: process known inodes and inode discovery - 22952512 of 22952512 inodes done
        - process newly discovered inodes...
        - 14:22:46: process newly discovered inodes - 32 of 32 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 14:22:47: setting up duplicate extent list - 32 of 32 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 15
        - agno = 0
        - agno = 30
Metadata corruption detected at 0x4314b3, xfs_inode block 0x300160/0x2000
        - agno = 1
        - agno = 16
        - agno = 31
        - agno = 17
        - agno = 2
        - agno = 3
        - agno = 18
        - agno = 19
        - agno = 4
        - agno = 20
        - agno = 5
        - agno = 21
        - agno = 6
        - agno = 7
        - agno = 22
        - agno = 8
        - agno = 23
        - agno = 9
        - agno = 24
        - agno = 10
        - agno = 25
        - agno = 11
        - agno = 26
        - agno = 12
        - agno = 27
        - agno = 13
        - agno = 28
        - agno = 14
        - agno = 29
        - 14:31:35: check for inodes claiming duplicate blocks - 22952512 of 22952512 inodes done
Phase 5 - rebuild AG headers and trees...
        - 14:31:37: rebuild AG headers and trees - 32 of 32 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
Metadata corruption detected at 0x4314b3, xfs_inode block 0x300160/0x2000
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
        - 14:39:59: verify and correct link counts - 32 of 32 allocation groups done
Metadata corruption detected at 0x431775, xfs_inode block 0x300160/0x2000
libxfs_writebufr: write verifer failed on xfs_inode bno 0x300160/0x2000
releasing dirty buffer (bulk) to free list!done

--Apple-Mail=_4005CA70-654D-417A-9B1D-994C90F9A5E5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii






--Apple-Mail=_4005CA70-654D-417A-9B1D-994C90F9A5E5--

--Apple-Mail=_62E64CC6-F48A-4B4F-814F-0F7C6997C3A9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIzBAEBCgAdFiEEHWtkGxqIdLStc9rVXqwUC54mmJYFAlxF5ukACgkQXqwUC54m
mJYlOxAAtXQu/A6bqiZHUT/iLucYXYBmhEA15fdMGautuDErViJm2+q0k1d7eVJh
B399SE+e+iVD32sP8Utj6QJ9EW2sCS7o0LW82ZRVUpTBLCh2/kkJFmtnzONi3fIE
/ZK5HRZIJ6FSc3eXEgOInzsUWYnP0op8xm/nP1QOVSKfWOpUOxCvZX6GV9FY2mb0
G97hY9I55kcE1pdGdb/V7H/MVzRcGnrlhJpZwKtLiDytuv5Gnfyk5BuRkS+nneuj
UardJDeS2SzEpbTOx88fZB1gp6YWFeOlahBUe1XIDAp1h6Pa/e69S2RnNsHtHr7p
v+8nH2CRNIRtaC0Phbx0ECNI96O2WpuGvQxRlbyB3UQfQxWNRdziGrEKMFeZP2Wz
A6gNCj9tlM83L4pkvcL7VoZvTjMhPc4AKgKzatO+D1/eGfdXtQQKyJGOXks+ifCS
pQvFJAfhieUADw/+q4Hv7Y7DpEzSa+8PRIv7ZUaJyUyDZZL/MfR3LtY1FHdVQZm7
yoeywMKmuG6gPwzwNYZnv69kwTvuox6dVBTYlJ1YKUWpxSRPyG1jb1KK/H0grbtk
6eIpTQgOZS2hSzXcDStFTjn/kFOFUu2guZWQrbcgYrGntuVjU0bKIud5DerGN1jK
hGQyxPGER9bqpTu7t8EGez1+xE+9U1xk22RXpUhPx/GTX5XhZPg=
=EKAI
-----END PGP SIGNATURE-----

--Apple-Mail=_62E64CC6-F48A-4B4F-814F-0F7C6997C3A9--
