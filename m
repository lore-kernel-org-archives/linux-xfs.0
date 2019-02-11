Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34691 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfBKQZM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Feb 2019 11:25:12 -0500
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 46B485476C4
        for <linux-xfs@vger.kernel.org>; Mon, 11 Feb 2019 11:25:11 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id E267760B0C3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Feb 2019 11:25:10 -0500 (EST)
Date: Mon, 11 Feb 2019 17:23:59 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: RAID hiccup, LVM information wiped, XFS FS gone, how to proceed?
Message-ID: <20190211172359.71aff9d6@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/HqlO8AI6QMX=wjTnbhd_ZeZ"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS list <linux-xfs@vger.kernel.org>

--Sig_/HqlO8AI6QMX=wjTnbhd_ZeZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi everyone,

I have a lost filesystem at hand: the RAID controller had a hiccup (or
someone tripped on the cord, or did some other mistake, I have no way
to know because the system is in some other country anyway).

The configuration was quite simple: RAID array -> pv -> vg -> lv -> XFS.

I've hexedit'ed the /dev/sdb and it looks like the first few kB have
been wiped out: no LVM signature, no VG UUID... However after the first
few blocks, it looks very similar to another disk>vg>lv configuration
which I hexedit side by side (there are series of 00 with regularly
placed "FIB" values interspersed with other values, then after a while
what is obviously file content) so my guess is that the data is probably
still there (better be, there are 80 TB missing).

xfs_repair can't seem to be able to do anything on the raw disk, alas.
Any ideas? I don't even know why I can't seem to find the XFSB
signature on disk: when hexediting (for instance) /dev/vg0/somelv, I
see it starting with XFSB; but editing /dev/sdc (which is hosting the
above mentioned lv), it's not there.

(I know, I could simply restore the vgcfgbackup if it existed...
please let's suppose this command doesn't exist).

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/HqlO8AI6QMX=wjTnbhd_ZeZ
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlxhoZ8ACgkQX3jQXNUicVYPLACfYCzIlGOF33E0gvyzOkMNSY/m
4MEAn2HYTVWO1aNpQpWcOhrlMFEt2gpz
=Pgm8
-----END PGP SIGNATURE-----

--Sig_/HqlO8AI6QMX=wjTnbhd_ZeZ--
