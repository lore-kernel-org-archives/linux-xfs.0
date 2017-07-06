Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59855 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751914AbdGFBIo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jul 2017 21:08:44 -0400
From: NeilBrown <neilb@suse.com>
Date: Thu, 06 Jul 2017 11:08:27 +1000
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
In-Reply-To: <20170705204928.GA8151@fieldses.org>
References: <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca> <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com> <20170629045940.GB5865@birch.djwong.org> <20170629143551.GB1651@fieldses.org> <20170629172528.GA5869@birch.djwong.org> <20170629183053.GA4178@fieldses.org> <20170629185022.GB4178@fieldses.org> <20170704040446.GB4704@birch.djwong.org> <20170705011534.GC1420@fieldses.org> <20170705191933.GA6297@magnolia> <20170705204928.GA8151@fieldses.org>
Message-ID: <87r2xuxth0.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 05 2017, J. Bruce Fields wrote:

> On Wed, Jul 05, 2017 at 12:19:33PM -0700, Darrick J. Wong wrote:
>> On Tue, Jul 04, 2017 at 09:15:34PM -0400, J. Bruce Fields wrote:
>> > On Mon, Jul 03, 2017 at 09:04:46PM -0700, Darrick J. Wong wrote:
>> > > On Thu, Jun 29, 2017 at 02:50:22PM -0400, J. Bruce Fields wrote:
>> > > > On Thu, Jun 29, 2017 at 02:30:53PM -0400, J. Bruce Fields wrote:
>> > > > > On Thu, Jun 29, 2017 at 10:25:28AM -0700, Darrick J. Wong wrote:
>> > > > > > Was there ever a version of NFS (or more generally callers of =
the
>> > > > > > exportfs code) that couldn't deal with i_generation in the fil=
e handle,
>> > > > > > and therefore we invented this generation hack to work around =
the loss
>> > > > > > of the generation information?
>> > > > > >=20
>> > > > > > There's a comment in xfs_fs_encode_fh about not supporting 64b=
it inodes
>> > > > > > with subtree_check (which seems to require one ino/gen pair fo=
r the file
>> > > > > > and a second pair for the file's parent) on NFSv2 because v2 d=
oesn't
>> > > > > > provide enough space for all the file handle information, but =
that's the
>> > > > > > furthest I got with lazy-mining the git history. :)
>> > > > >=20
>> > > > > There's a comment in fs/ext4/super.c:ext4_nfs_get_inode
>> > > > >=20
>> > > > > 	* Currently we don't know the generation for parent directory, =
so
>> > > > > 	* a generation of 0 means "accept any"
>> > > > >=20
>> > > > > But I don't see that used.
>> > > > >=20
>> > > > > It was used once upon a time; I see it actually used in old 2.5 =
code in
>> > > > > nfsd_get_dentry.  Hm.
>> > > >=20
>> > > > Oh, maybe it's here in fs/libfs.c:generic_fh_to_parent:
>> > > >=20
>> > > > 	switch (fh_type) {
>> > > > 	case FILEID_INO32_GEN_PARENT:
>> > > > 		inode =3D get_inode(sb, fid->i32.parent_ino,
>> > > >         			  (fh_len > 3 ? fid->i32.parent_gen : 0));
>> > > > 		break;
>> > > > 	}
>> > > >=20
>> > > > I'm not sure under what conditions that filehandle encoding is use=
d.
>> > >=20
>> > > The best guess I can come up with is the old nfs_fhbase_old style ha=
ndles,
>> > > which (afaict) do not carry parent i_generation?
>> >=20
>> > Yeah, I just couldn't tell in the time I looked whether they could sti=
ll
>> > be handed out.
>> >=20
>> > If not, then the only way they'd still be used is if a client had a
>> > server continually mounted while the server was upgraded from a kernel
>> > that still handed out the old filehandle.
>> >=20
>> > So if they haven't been given out for long enough it's possible nobody
>> > would notice if we dropped support.
>> >=20
>> > But, I didn't get far enough to figure that out.
>>=20
>> Hmm, so looking back through prehistory, Linux prior to 2.3.51 (11 March
>> 2000) gave out the old dentry style fhandles.  After that, the kernel
>> only gave out the new style handles that we still use today.  In 2.4.6
>> (4 July 2001) the behavior was modified again to chain handle types,
>> i.e. if the client passed in an old style handle then it would get
>> another old style handle back.  The changelog for -pre9 says that this
>> was done for compatibility reasons.
>
> Yeah, you're supposed to be able to reboot your NFS server for a kernel
> upgrade without your client applications experiencing anything worse
> than a temporary hang while you wait for the server to come back up.
> So, changing the filehandle format and returning ESTALE to everyone
> would be unpopular.
>
>> So, what's the probability that there are clients out there that started
>> talking to a 2.2-based knfsd and will now want to talk to a modern 4.13
>> kernel seventeen years later?
>
> I think it's unlikely enough that we could drop that code; cc'ing Neil
> in case we overlooked anything.

While I remain a fan of maintaining forward/backward compatibility as
much as possible, 15 years is probably more than I can realistically
hope for.
As you say, a generation number of '0' is only special when old-style
file handles are used, with the "subtree_check" export option.  They are
unlikely to have been used recently.

However, I note that include/linux/exportfs.h says:

	/*
	 * 32bit inode number, 32 bit generation number,
	 * 32 bit parent directory inode number.
	 */
	FILEID_INO32_GEN_PARENT =3D 2,

This could be seen as misleading.
Some code that reports that fid_type includes the directory generation
number.  Some other code (cephfs, squashfs) doesn't even include the
generation number for the inode (which is OK for squashfs as it is
write-only).  I could find no code that matches this documentation.

I was never a fan of having generic fid_types.  Except for 0 and 255,
these numbers are generated and interpreted by individual filesystems,
and there is no reason that they should agree on the interpretation (and
as we see here, they don't).

But for the main point of your question: I see no problem with removing
nfs_fhbase_old and related code, and that includes the special handling
of generation number zero.

Thanks,
NeilBrown

>
>> (Do nfs handles persist across client restarts/remounts?)
>
> No.
>
> (Well, with maybe a couple exceptions (fscache and persistent NFSv4
> delegations) but neither seem relevant here.)
>
> --b.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlldjY0ACgkQOeye3VZi
gbnAnA//bEezoi9OKySUGLIlymGgbukQlPUhvQeJONrK1NcekdGYrdVLSbcPWv+s
Ey+mIS4ma9+Tdq79YZkMa/LxNqYZ9ZRR7dAvG5DotvIomZA0R91maf4oXF5N2XJn
aYBCn76YG6RNMZbMlY5SaQX0LvJFg0QRpIOLX4Lz+8To1yQvFa5h41AV0TN77ne8
S8TRXbwz0MnUTLSL7cGHJXa+hUK/SVw3sK2op1fIFgY93M2NLLrF1e7rcTseXyOT
c6niD9QCLjq5odZhaGnZ7eCx6I18kpgbz1cUgsaulRzd5LlRc0nEqtNh2Effst2b
R9u9fXYJeYgcSg7TYpgUN4dQ87ZGNgncSOmTspP5LwMmkQXePzwYvue7Zf3xmjZ3
VbV5NHyLxGA6S8ysghQHCGTmdr1gazm0qeyXSM3K/SLE/OLx7n91P8IS9c/QZDMt
zwcSPU8MBgTGybJsvZyS1s202LkAlL1XC+dpuGjMcdC+N0rCHDv8b5eAxVyXFIIO
u8BwXNcAHsGQ0FF2arFxPrjaBGGRWCpw5ROtMKze6qnYRDq7TTSPa3e5R5BiCsA7
09B4f+NwZxcVljNC86lHV7qWZql/AFMhIbLoEc4PZShEUDhbi4IsIzYE0JpmSboy
JRWrH+7WuaYBsrMFlbkXf3x7AD7ZwlDAoW9BehRIj/ql+m5p4nw=
=OfdM
-----END PGP SIGNATURE-----
--=-=-=--
