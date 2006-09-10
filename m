Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Sep 2006 17:44:45 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8B0iZDW027973
	for <xfs@oss.sgi.com>; Sun, 10 Sep 2006 17:44:35 -0700
Received: by nf-out-0910.google.com with SMTP id a25so1062790nfc
        for <xfs@oss.sgi.com>; Sun, 10 Sep 2006 17:44:00 -0700 (PDT)
Message-ID: <4504A3A9.4080704@gmail.com>
Date: Mon, 11 Sep 2006 01:45:45 +0200
From: Enrico Maria Crisostomo <enrico.m.crisostomo@gmail.com>
MIME-Version: 1.0
Subject: xfs_repair -d doesn't work
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi.

I'm running a slackware-current with xfsprogs-2.8.10_1. On some
machine I ran many 2.6.17 kernel and one machine is showing the
"directory problem": I cannot get rid of many "Filesystem "hda3": XFS
internal error xfs_da_do_buf(2) at line 2212 of file
fs/xfs/xfs_da_btree.c. Caller 0xe0ac57d9". As I'm now running
2.6.17.13 I think I'm at safe from this bug and the last thing to do
is... repairing my root filesystem. Unfortunately xfs_repair -d and
xfs_repair -n does not work, and it returns saying it could not
initialize XFS library because the filesystem is mounted AND writable.
What I did:
- - remounted the file system read only: did not work, not even
xfs_repair -n, which I expect to succeed always
- - hacked /etc/mtab to change rw to ro: did not work, error is the same
as before.

Can you suggest me some way to repair my file system and confirm me
that this xfs_repair behavior is a bug?

Thank you,
Enrico M. Crisostomo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFBKOpW8+x8v0iKa8RAkMPAKDbwuF/pgkX8epIvkKEZOjQKP2cbgCghvJB
IkbMDVHlvNJgRnwZ61YTgwk=
=ht3Y
-----END PGP SIGNATURE-----
