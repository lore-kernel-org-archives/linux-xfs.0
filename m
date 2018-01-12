Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:48385 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933810AbeALObz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jan 2018 09:31:55 -0500
Date: Fri, 12 Jan 2018 15:25:38 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180112152538.2c4d8cd4@harpe.intellique.com>
In-Reply-To: <5A58B901.7080609@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
        <20180108192607.GS5602@magnolia>
        <20180108220139.GB16421@dastard>
        <5A548D31.4000002@youngman.org.uk>
        <20180109222523.GJ16421@dastard>
        <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
        <20180111030723.GU16421@dastard>
        <5A58B901.7080609@youngman.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sm1vOhkKrlc_BcGZ.wQt07B"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

--Sig_/sm1vOhkKrlc_BcGZ.wQt07B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 12 Jan 2018 13:32:49 +0000
Wols Lists <antlists@youngman.org.uk> =C3=A9crivait:

> On 11/01/18 03:07, Dave Chinner wrote:
> > XFS comes from a different background - high performance, high
> > reliability and hardware RAID storage. Think hundreds of drives in a
> > filesystem, not a handful. i.e. The XFS world is largely enterprise
> > and HPC storage, not small DIY solutions for a home or back-room
> > office.  We live in a different world, and MD rarely enters mine. =20
>=20
> So what happens when the hardware raid structure changes?

hardware RAID controllers don't expose RAID structure to the software.
So As far as XFS knows, a hardware RAID is just a very large disk.
That's when using stripe unit and stripe width options make sense in
mkfs_xfs.

> Ext allows you to grow a filesystem. Btrfs allows you to grow a
> filesystem. Reiser allows you to grow a file system. Can you add more
> disks to XFS and grow the filesystem?

Of course. xfs_growfs is your friend. Worked with online filesystems
many years before that functionality came to other filesystems.

> My point is that all this causes geometries to change, and ext and
> btrfs amongst others can clearly handle this. Can XFS?

Neither XFS, ext4 or btrfs can handle this. That's why Dave mentioned
the fact that growing your RAID is almost always the wrong solution.
A much better solution is to add a new array and use LVM to aggregate
it with the existing ones.

Basically growing an array then the filesystem on it generally works
OK, BUT it may kill performance (or not). YMMV. At least, you *probably
won't* get the performance gain that the difference of stripe width
would permit when starting anew.

> Because if it can, it seems to me the obvious solution to changing
> raid geometries is that you need to grow the filesystem, and get that
> to adjust its geometries.

Unfortunately that's nigh impossible. No filesystem in existence does
that. The closest thing is ZFS ability to dynamically change stripe
sizes, but when you extend a ZFS zpool it doesn't rebalance existing
files and data (and offers absolutely no way to do it). Sorry, no pony.

> Bear in mind, SUSE has now adopted XFS as the default filesystem for
> partitions other than /. This means you are going to get a lot of
> "hobbyist" systems running XFS on top of MD and LVM. Are you telling
> me that XFS is actually very badly suited to be a default filesystem
> for SUSE?

Doesn't seem so. In fact XFS is less permissive than other filesystems,
and it's a *darn good thing* IMO. It's better having frightening error
messages "XFS force shutdown" than corrupted data, isn't it?

> What concerns me here is, not having a clue how LVM handles changing
> partition sizes, what effect this will have on filesystems ... The
> problem is the Unix philosophy of "do one thing and do it well".
> Sometimes that's just not practical.

LVM volumes changes are propagated to upper levels.=20

If you don't like Unix principles, use Windows then :)

> The Unix philosophy says "leave
> partition management to lvm, leave redundancy to md, leave the files
> to the filesystem, ..." and then the filesystem comes along and says
> "hey, I can't do my job very well, if I don't have a clue about the
> physical disk layout". It's a hard circle to square ... :-)

Yeah, that was apparently the very same thinking that brought us ZFS.

> (Anecdotes about btrfs are that it's made a right pigs ear of trying
> to do everything itself.)
>=20

Not so sure. Btrfs is excellent, taking into account how little love it
received for many years at Oracle.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/sm1vOhkKrlc_BcGZ.wQt07B
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlpYxWIACgkQX3jQXNUicVZUuACgzxvlii8WOaBb2pdId7r4bz1a
mEAAoM6qnhN6JtVDnSxnOUROK/xVKY8n
=XInz
-----END PGP SIGNATURE-----

--Sig_/sm1vOhkKrlc_BcGZ.wQt07B--
