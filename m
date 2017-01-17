Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34706 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdAQUpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2017 15:45:55 -0500
Received: by mail-io0-f194.google.com with SMTP id c80so17084716iod.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2017 12:45:41 -0800 (PST)
Content-Type: multipart/signed; boundary="Apple-Mail=_207AD98F-949F-426F-A53D-974DEFA0A1C9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [LSF/MM TOPIC] online filesystem repair
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20170117062453.GJ14038@birch.djwong.org>
Date: Tue, 17 Jan 2017 13:45:34 -0700
Message-Id: <A24A05C0-5749-4181-AB46-CDDFE1E6E5E1@dilger.ca>
References: <20170114075452.GJ14033@birch.djwong.org> <1484524890.27533.16.camel@dubeyko.com> <20170117062453.GJ14038@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Vyacheslav.Dubeyko@wdc.com


--Apple-Mail=_207AD98F-949F-426F-A53D-974DEFA0A1C9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jan 16, 2017, at 11:24 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Sun, Jan 15, 2017 at 04:01:30PM -0800, Viacheslav Dubeyko wrote:
>> On Fri, 2017-01-13 at 23:54 -0800, Darrick J. Wong wrote:
>>> Hi,
>>>=20
>>> I've been working on implementing online metadata scrubbing and
>>> repair
>>> in XFS.  Most of the code is self contained inside XFS, but there's =
a
>>> small amount of interaction with the VFS freezer code that has to
>>> happen
>>> in order to shut down the filesystem to rebuild the extent backref
>>> records.  It might be interesting to discuss the (fairly slight)
>>> requirements upon the VFS to support repairs, and/or have a BoF to
>>> discuss how to build an online checker if any of the other
>>> filesystems
>>> are interested in this.
>>>=20
>>=20
>> How do you imagine a generic way to support repairs for different =
file
>> systems? =46rom one point of view, to have generic way of the online =
file
>> system repairing could be the really great subsystem.
>=20
> I don't, sadly.  There's not even a way to /check/ all fs metadata in =
a
> "generic" manner -- we can use the standard VFS interfaces to read
> all metadata, but this is fraught.  Even if we assume the fs can spot
> check obviously garbage values, that's still not the appropriate place
> for a full scan.
>=20
>> But, from another point of view, every file system has own
>> architecture, own set of metadata and own way to do fsck
>> check/recovering.
>=20
> Yes, and this wouldn't change.  The particular mechanism of fixing a
> piece of metadata will always be fs-dependent, but the thing that I'm
> interested in discussing is how do we avoid having these kinds of =
things
> interact badly with the VFS?
>=20
>> As far as I can judge, there are significant amount of research
>> efforts in this direction (Recon [1], [2], for example).
>=20
> Yes, I remember Recon.  I appreciated the insight that while it's
> impossible to block everything for a full scan, it /is/ possible to
> check a single object and its relation to other metadata items.  The =
xfs
> scrubber also takes an incremental approach to verifying a filesystem;
> we'll lock each metadata object and verify that its relationships with
> the other metadata make sense.  So long as we aren't bombarding the fs
> with heavy metadata update workloads, of course.

It is worthwhile to note that Lustre has a distributed online filesystem
checker (LFSCK) that works in a similar incremental manner, checking the
status of each object w.r.t. other objects it is related to.  This can
be done reasonably well because there is extra Lustre metadata that has
backpointers from data objects to inodes and from inodes to the parent
directory (including hard links).

That said, we depend on the local filesystem to be internally =
consistent,
and LFSCK is only verifying/repairing Lustre-specific metadata that
describes cross-server object relationships.

Cheers, Andreas

> On the repair side of things xfs added reverse-mapping records, which
> the repair code uses to regenerate damaged primary metadata.  After we
> land inode parent pointers we'll be able to do the same =
reconstructions
> that we can now do for block allocations...
>=20
> ...but there are some sticky problems with repairing the reverse
> mappings.  The normal locking order for that part of xfs is sb_writers
> -> inode -> ag header -> rmap btree blocks, but to repair we have to
> freeze the filesystem against writes so that we can scan all the =
inodes.
>=20
>> But we still haven't any real general online file system repair
>> subsystem in the Linux kernel.
>=20
> I think the ocfs2 developers have encoded some ability to repair
> metadata over the past year, though it seems limited to fixing some
> parts of inodes.  btrfs stores duplicate copies and restores when
> necessary, I think.  Unfortunately, fixing disk corruption is =
something
> that's not easily genericized, which means that I don't think we'll =
ever
> achieve a general subsystem.
>=20
> But we could at least figure out what in the VFS has to change (if
> anything) to support this type of usage.
>=20
>> Do you have some new insight? What's difference of your
>> vision? If we have online file system repair subsystem then how file
>> system driver will need to interact with the goal to make internal
>> repairing?
>=20
> It's pretty much all private xfs userspace ioctls[1] with a driver
> program[2].
>=20
> --D
>=20
> [1] =
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=3D=
djwong-devel
> [2] =
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?=
h=3Ddjwong-devel
>=20
>>=20
>> Thanks,
>> Vyacheslav Dubeyko.
>>=20
>> [1] =
http://www.eecg.toronto.edu/~ashvin/publications/recon-fs-consistency-runt=
ime.pdf
>> [2] =
https://www.researchgate.net/publication/269300836_Managing_the_file_syste=
m_from_the_kernel
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_207AD98F-949F-426F-A53D-974DEFA0A1C9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWH6CcHKl2rkXzB/gAQiiqBAAlxhwIhLuiZqaaT/d/uOgQvIqFgwdl/Ku
hfj8Gfjcp0TJ8dyKCvX3tY3EkyiD52TpeDoli4qtnRwJ9j0grvP17rmggjLazwWz
l4gCrb1nDmyBPzoXY1vuqexLrdXI7aahnfbvvI0WoTK1am3VR+wFOLoWPl2KZ3IV
+h6/+eMaPQGJKuZwymS92uvacxC3YkFLOvqRbnyHMbxqr5vtpgQkoWWuNErplqI5
cjPekozHRazRE6s3dPtA/15ink3b7AwVgoNH10LB+nq+O9XjRK4Wgt6HcRnNkfb1
KvN03Bojm89GosjR9re8pFGLix++XhJjPkM2TURqfkC078NvGcXnvdQJtxAonLDO
39KQ1+JW5+szDztIuUB8L7M8822/CukdpZZAQCHl+SvaMOEcaY3FMaRJJ6ScuNIa
9C+fH/g6qYug9UXFvaf+LAWCnRwK1hfZf7VMrxJmYr21It4kzwriRsuqgUAFls6k
Mkt24EzIMaRCnQ6dg+77bF06qGNaKmYN4yoNUIKvRYQAVRLn43LyxnObIYy+mebH
0pBrtW3ZYEfzbITwENl38gmdPc023yIbE/6ToeLuo3jP+1h/fwImAA60X+E89Qdw
8s5KoihBLEKv/YxI/4+bjtFC0RGI29VNJdGVoxDfhD2dcxfDS/nAI6MPkBQREIay
9CEZvXizmaE=
=0iTx
-----END PGP SIGNATURE-----

--Apple-Mail=_207AD98F-949F-426F-A53D-974DEFA0A1C9--
