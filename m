Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 03:29:36 -0700 (PDT)
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7UATODW015833
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 03:29:27 -0700
Received: from localhost (albatross.madduck.net [127.0.0.1])
	by albatross.madduck.net (postfix) with ESMTP id EDD0A895D84
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 10:24:05 +0200 (CEST)
Received: from albatross.madduck.net ([127.0.0.1])
	by localhost (albatross.madduck.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 11859-02-10 for <xfs@oss.sgi.com>;
	Wed, 30 Aug 2006 10:24:05 +0200 (CEST)
Received: from lapse.madduck.net (84-72-16-26.dclient.hispeed.ch [84.72.16.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "lapse.madduck.net", Issuer "CAcert Class 3 Root" (verified OK))
	by albatross.madduck.net (postfix) with ESMTP id A11AA895D7A
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 10:24:05 +0200 (CEST)
Date: Wed, 30 Aug 2006 09:24:11 +0100
From: martin f krafft <madduck@madduck.net>
Subject: catch22: xfs_repair fails, tells me to mount, which fails
Message-ID: <20060830082411.GA9986@lapse.madduck.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

this morning I woke up to a system without /home, the reason being:

  piper:~# mount /dev/mapper/vg0-home                                      =
 [308]
  mount: Unknown error 990
  piper:~# dmesg | tail -20                                              [3=
2,309]
  Starting XFS recovery on filesystem: dm-0 (logdev: internal)
  Filesystem "dm-0": xfs_inode_recover: Bad inode magic number, dino ptr =
=3D 0xffff810028a6bd00, dino bp =3D 0xffff81002851d140, ino =3D 33629
  Filesystem "dm-0": XFS internal error xlog_recover_do_inode_trans(1) at l=
ine 2352 of file fs/xfs/xfs_log_recover.c.  Caller 0xffffffff88307729

  Call Trace: <ffffffff8830753c>{:xfs:xlog_recover_commit_trans+4198}
        <ffffffff80231360>{submit_bio+184} <ffffffff88307729>{:xfs:xlog_rec=
over_process_data+466}
        <ffffffff883081c6>{:xfs:xlog_do_recovery_pass+585} <ffffffff883096f=
4>{:xfs:xlog_recover+243}
        <ffffffff88305b2f>{:xfs:xfs_log_mount+1310} <ffffffff8830b671>{:xfs=
:xfs_mountfs+2116}
        <ffffffff880a0076>{:libata:ata_exec_command+0} <ffffffff8020bcdc>{_=
atomic_dec_and_lock+57}
        <ffffffff883119ac>{:xfs:xfs_mount+1900} <ffffffff88320bb0>{:xfs:xfs=
_fs_fill_super+126}
        <ffffffff802bc01d>{get_filesystem+18} <ffffffff802b530c>{sget+850}
        <ffffffff802b4c65>{set_bdev_super+0} <ffffffff802b4c74>{test_bdev_s=
uper+0}
        <ffffffff802b5dec>{bd_claim+24} <ffffffff802b5996>{get_sb_bdev+239}
        <ffffffff88320b32>{:xfs:xfs_fs_fill_super+0} <ffffffff802b5605>{do_=
kern_mount+157}
        <ffffffff802bd86e>{do_mount+1676} <ffffffff8022b2c2>{mntput_no_expi=
re+25}
        <ffffffff802075bb>{find_get_page+33} <ffffffff80212173>{filemap_nop=
age+387}
        <ffffffff8020878d>{__handle_mm_fault+1276} <ffffffff8020a699>{do_pa=
ge_fault+1151}
        <ffffffff80249b1f>{sys_mount+138} <ffffffff80259b0e>{system_call+12=
6}
  XFS: log mount/recovery failed: error 990
  XFS: log mount failed

When I try to run xfs_repair, I get:

  piper:~# xfs_repair /dev/mapper/vg0-home                                 =
 [310]
  Phase 1 - find and verify superblock...
  Phase 2 - using internal log
          - zero log...
  ERROR: The filesystem has valuable metadata changes in a log which needs =
to
  be replayed.  Mount the filesystem to replay the log, and unmount it befo=
re
  re-running xfs_repair.  If you are unable to mount the filesystem, then u=
se
  the -L option to destroy the log and attempt a repair.
  Note that destroying the log may cause corruption -- please attempt a mou=
nt
  of the filesystem before doing this.

I have already tried the xfs_db method of the "dir2" faq entry,
trying to delete that offending inode, but setting core.mode =3D 0 for
that inode did not do anything.

I do not have enough space around to xfsdump those 250Gb, nor would
I know how, given that I cannot mount the filesystem and xfsdump
works on mounted filesystems only.

I've had really bad experiences with XFS lately [0], but I am not
giving up just yet. This time around, I guess I can wait a bit and
try to get things fixed.

0. http://blog.madduck.net/geek/2006.08.09-through-with-xfs

Would you have any idea what I should do?

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"... (ethik und =E4sthetik sind eins.)"
                                                       -- wittgenstein

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE9UsrIgvIgzMMSnURAoHeAJ9i9+W6L6nSpfjbOJZ13DYOp5Mr2gCgu9ue
0jKJ+Gdmu23TpA78OamrkdQ=
=agwG
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
