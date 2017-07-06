Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:41847 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752503AbdGFNa2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jul 2017 09:30:28 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id CD799547C26
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2017 09:30:17 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 8560660B2F0
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2017 09:30:17 -0400 (EDT)
Date: Thu, 6 Jul 2017 15:30:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Weird xfs_repair error
Message-ID: <20170706153020.0ad6dd47@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//DybmXksNVIFW440H2zLs5G"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_//DybmXksNVIFW440H2zLs5G
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


After a RAID controller went bananas, I encountered an XFS corruption
on a filesystem. Weirdly, the corruption seems to be mostly located in
lost+found.

(I'm currently working on a metadump'd image of course, not the real
thing; there are 90TB of data to be hopefully salvaged in there).

"ls /mnt/rescue/lost+found" gave this:

XFS (loop0): metadata I/O error: block 0x22b03f490
("xfs_trans_read_buf_map") error 117 numblks 16=20
XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
XFS (loop0): Corruption detected. Unmount and run xfs_repair=20
XFS (loop0): Corruption detected. Unmount and run xfs_repair

I've run xfs_repair 4.9 on the xfs_mdrestored image. It dumps an insane
lot of errors (the output log is 65MB)  and ends with this very strange
message:

disconnected inode 26417467, moving to lost+found
disconnected inode 26417468, moving to lost+found
disconnected inode 26417469, moving to lost+found
disconnected inode 26417470, moving to lost+found

fatal error -- name create failed in lost+found (117), filesystem may
be out of space

Even stranger, after mounting back the image, there is no lost+found
anywhere to be found! However the filesystem has lots of free space and
free inodes, how come?

df -i
Sys. fich.                    Inodes  IUtil.     ILibre IUti% Mont=C3=A9 sur
rootfs                             0       0          0     - /
/dev/root                          0       0          0     - /
tmpfs                        2058692     990    2057702    1% /run
tmpfs                        2058692       6    2058686    1% /run/lock
tmpfs                        2058692    1623    2057069    1% /dev
tmpfs                        2058692       3    2058689    1% /run/shm
guitare:/mnt/raid/partage   33554432  305069   33249363    1% /mnt/qnap1
/dev/loop0                4914413568 5199932 4909213636    1% /mnt/rescue

df
/dev/loop0                122858252288 88827890868 34030361420  73% /mnt/re=
scue

I'll give a shot to a newer version of xfs_repair just in case...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_//DybmXksNVIFW440H2zLs5G
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlleO20ACgkQX3jQXNUicVbLYQCZAfv4ILNLlTG5ONgjCJy/LVxP
cNsAoLFRDWX2fDakJg2gKMlJYn/tRQMQ
=c0ju
-----END PGP SIGNATURE-----

--Sig_//DybmXksNVIFW440H2zLs5G--
