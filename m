Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 10:51:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91HpCK3024881
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 10:51:13 -0700
Received: from smtpout.eastlink.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DCC31305EA4
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 10:52:44 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30]) by cuda.sgi.com with ESMTP id CN0nCvGaPN3HFpWh for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 10:52:44 -0700 (PDT)
Received: from ip01.eastlink.ca ([24.222.39.10])
 by mta02.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0K8200CEQMZVKVW2@mta02.eastlink.ca> for xfs@oss.sgi.com;
 Wed, 01 Oct 2008 14:52:43 -0300 (ADT)
Received: from peter by llama.cordes.ca with local (Exim 3.36 #1 (Debian))
	id 1Kl5sL-0006YW-00	for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 14:52:37 -0300
Date: Wed, 01 Oct 2008 14:52:37 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: RAID5/6 writes
Message-id: <20081001175237.GJ32037@cordes.ca>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=l76fUT7nc3MelDdI
Content-disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 I just had an idea for speeding up writes to parity-based RAIDs
(RAID4,5,6).[1]  If XFS wants to write sectors 1,2,3, 5,6,7, but it
knows that block 4 is free space, it might be better to write sector 4
(with zeros, don't put uninitialized kernel memory on disk!).  It's
probably only useful to do this if XFS has data in memory to prove
that the gap is not part of the filesystem.  Doing extra reads
probably doesn't make sense except in very special cases.  (e.g.
repeated writes to the same location with the same hole, so just one
read would let them all become full-block or even full-stripe writes.)

 XFS knows (or should have been told by the admin with mkfs!) what the
stripe geometry is: block size and stripe width.  So it could apply
this optimization only if it would make a write cover more whole
blocks or whole stripes.


[1]  See http://www.acnc.com/04_01_05.html if you need a reminder of
what RAID level is what...  It has good pictures and explanations. :)

 I use RAID6 on a Dell PERC 6/e with 8 500GB SATA disks, and I'm still
tuning XFS for it...  (I'll start another with some tuning questions...)
RAID5 write performance has the same limitations as RAID6, and more
people know about it, so...  RAID5 is ok at sequential writes, but
non-full-stripe writes require reading the rest of the data for stripe
so the parity stripe(s) can be recalculated and rewritten.  (typical
block size is 64kiB, and with a 7 disk RAID5, a full stripe is
64kiB*(7-1) =3D 384kiB.)  Within a single 64kiB block, small scattered
writes are deadly: It's a read-modify-write (or write-read) because
the whole 64kiB is needed (along with the data from the other disks
with data in this stripe).  HW RAID controllers have large e.g. 256MiB
caches so they can merge writes, and sometimes avoid the extra reads.

--=20
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQC1AwUBSOO45QWkmhLkWuRTAQIvPAUArBXL498eNNgWYji/kRmfU90blT5kWHpO
efranes2Oin+/JTJyTlxRzvG6tPiUYRK1ygyXWFu2FcXIwWZkAdF+lqDGOLE54Gv
8Sg1pexOQWYjXNysN6xqPYDlJW6w5gSaMEOPw2H4cBrNVpVuIbAjzrTFg2WrzA7h
BPjH7NYaTpmMTCpXvxn7R7lIcpVauePznUOqBnR1EBks5dqpdggthw==
=nyPc
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
