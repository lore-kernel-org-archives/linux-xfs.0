Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:54183 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964958AbeALShG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jan 2018 13:37:06 -0500
Date: Fri, 12 Jan 2018 19:37:10 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180112193710.1369f4ad@harpe.intellique.com>
In-Reply-To: <5A58F5FB.7000101@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
        <20180108192607.GS5602@magnolia>
        <20180108220139.GB16421@dastard>
        <5A548D31.4000002@youngman.org.uk>
        <20180109222523.GJ16421@dastard>
        <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
        <20180111030723.GU16421@dastard>
        <5A58B901.7080609@youngman.org.uk>
        <20180112152538.2c4d8cd4@harpe.intellique.com>
        <5A58F5FB.7000101@youngman.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/trEwUCPXzwFmeBridIc_JL8"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wols Lists <antlists@youngman.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

--Sig_/trEwUCPXzwFmeBridIc_JL8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 12 Jan 2018 17:52:59 +0000
Wols Lists <antlists@youngman.org.uk> =C3=A9crivait:

> >>
> >> So what happens when the hardware raid structure changes? =20
> >=20
> > hardware RAID controllers don't expose RAID structure to the
> > software. So As far as XFS knows, a hardware RAID is just a very
> > large disk. That's when using stripe unit and stripe width options
> > make sense in mkfs_xfs. =20
>=20
> Umm... So you can't partially populate a chassis and add more disks as
> you need them? So you have to manually pass stripe unit and width at
> creation time and then they are set in stone? Sorry that doesn't sound
> that enterprisey to me :-(

You *can* but it's generally frowned upon. Adding disks by large
batches of 6, 8, 10 and creating new arrays is always better. Adding
one or two disks at a time is a useful, but cheap hack at best.

> >=20
> > Neither XFS, ext4 or btrfs can handle this. That's why Dave
> > mentioned the fact that growing your RAID is almost always the
> > wrong solution. A much better solution is to add a new array and
> > use LVM to aggregate it with the existing ones. =20
>=20
> Isn't this what btrfs does with a rebalance? And I may well be wrong,
> but I got the impression that some file systems could change stripe
> geometries dynamically.

If btrfs does rebalancing, that's fine then. I suppose running xfs_fsr
on XFS could also rebalance data. Would be nice to have an option to
force rewriting of all files, that would solve this particular problem.
=20
> Adding a new array imho breaks the KISS principle. So I now have
> multiple arrays sitting on the hard drives (wasting parity disks if I
> have raid5/6), multiple instances of LVM on top of that, and then the
> filesystem sitting on top of multiple volumes.

No, you need only to declare additional arrays as new physical volumes,
add them to your existing volume group, then extend your existing LVs
as needed. That's standard storage management fare.

You're not supposed to have arrays with tens of drives anyway (unless
you really don't care about your data).

> As a hobbyist I want one array, with one LVM on top of that, and one
> filesystem per volume.

As a hobbyist you don't really have to care about performance. A single
modern hard drive can easily feed a gigabit ethernet connection, anyway.
The systems I set up these times commonly require disk throughput of 3
to 10 GB/s to feed 40GigE lines. Different problems.=20

> Anything else starts to get confusing. And if
> I'm a professional sys-admin I would want that in spades! It's all
> very well expecting a sys-admin to cope, but the fewer boobytraps and
> landmines left lying around, the better!
>=20
> Squaring the circle, again :-(

Not really, modern tools like lsblk and friends make it really easy to
sort out.

> >=20
> > Basically growing an array then the filesystem on it generally works
> > OK, BUT it may kill performance (or not). YMMV. At least, you
> > *probably won't* get the performance gain that the difference of
> > stripe width would permit when starting anew.
> >  =20
> Point taken - but how are you going to backup your huge petabyte XFS
> filesystem to get the performance on your bigger array? Catch 22 ...

Through big networks, or with big tape drives (LTO-8 is ~1GB/s
compressed).

>=20
> >> Because if it can, it seems to me the obvious solution to changing
> >> raid geometries is that you need to grow the filesystem, and get
> >> that to adjust its geometries. =20
> >=20
> > Unfortunately that's nigh impossible. No filesystem in existence
> > does that. The closest thing is ZFS ability to dynamically change
> > stripe sizes, but when you extend a ZFS zpool it doesn't rebalance
> > existing files and data (and offers absolutely no way to do it).
> > Sorry, no pony.=20
> Well, how does raid get away with it, rebalancing and restriping
> everything :-)
>=20

Then that must be because Dave is lazy :)

> > Doesn't seem so. In fact XFS is less permissive than other
> > filesystems, and it's a *darn good thing* IMO. It's better having
> > frightening error messages "XFS force shutdown" than corrupted
> > data, isn't it? =20
>=20
> False dichotomy, I'm afraid. Do you really want a filesystem that
> guarantees integrity, but trashes performance when you want to take
> advantage of features such as resizing? I'd rather have integrity,
> performance *and* features :-) (Pick any two, I know :-)

XFS is clearly optimized for performances, and is currently gaining
interesting new features (thin copy, then probably snapshots, etc). If
what you're looking for is features first, well, there are other
filesystems :)

> > LVM volumes changes are propagated to upper levels.  =20
>=20
> And what does the filesystem do with them? If LVM is sat on MD, what
> then?

MD propagates to LVM that propagates to the FS, actually. Everybody
works together nowadays (didn't used to).

> >=20
> > If you don't like Unix principles, use Windows then :)
> >  =20
> The phrase "a rock and a hard place" comes to mind. Neither were
> designed with commercial solidity and integrity and reliability in
> mind. And having used commercial systems I get the impression NIH is
> alive and kicking far too much. Both Linux and Windows are much more
> reliable and solid than they were, but too many of those features are
> bolt-ons, and they feel like it ...

Linux gives you choice. You want to resize volumes at will? Use ZFS.
You want to juice out all the performance from your disks? use XFS. You
don't bother? use ext4. etc.

> > Not so sure. Btrfs is excellent, taking into account how little
> > love it received for many years at Oracle.
> >  =20
> Yep. The solid features are just that - solid. Snag is, a lot of the
> nice features are still experimental, and dangerous! Parity raid, for
> example ... and I've heard rumours that the flaws could be unfixable,
> at least not until btrfs-2 whenever that gets started ...

Well I don't know much about btrfs so I can't comment.
=20
> When MD adds disks, it rewrites the array from top to bottom or the
> other way round, moving everything over to the new layout. Is there no
> way a file system can do the same sort of thing? Okay, it would
> probably need to be a defrag-like utility and linux prides itself on
> not needing defrag :-)
>=20
> Or could it simply switch over to optimising for the new geometry,
> accept the fact that the reshape will have caused hotspots, and every
> time it rewrites (meta)data, it adjusts it to the new geometry to
> reduce/remove hotspots over time?
>=20

I suppose it's doable but not sufficiently a prominent use case to
bother much.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/trEwUCPXzwFmeBridIc_JL8
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlpZAFYACgkQX3jQXNUicVZ4xgCfd3XeFSLGd0bwUTX4JGWTHXCy
YS4An1VH9VxR6Fp/CR9+NVBV8xsrpPIQ
=Zpzl
-----END PGP SIGNATURE-----

--Sig_/trEwUCPXzwFmeBridIc_JL8--
