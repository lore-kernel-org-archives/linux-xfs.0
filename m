Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20629 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935113AbdCXMNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2017 08:13:30 -0400
Date: Fri, 24 Mar 2017 13:13:48 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: Re: XFS race on umount
Message-ID: <20170324121348.GH32546@chrystal.oracle.com>
References: <20170310120406.GU16870@chrystal>
 <20170310140535.GB27272@bfoster.bfoster>
 <20170310143846.GA7971@chrystal.oracle.com>
 <20170310145254.GC27272@bfoster.bfoster>
 <20170320123350.xmtcaodhrbwpfgmu@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o7gdRJTuwFmWapyH"
Content-Disposition: inline
In-Reply-To: <20170320123350.xmtcaodhrbwpfgmu@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>


--o7gdRJTuwFmWapyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2017 at 01:33:50PM +0100, Carlos Maiolino wrote:
> On Fri, Mar 10, 2017 at 09:52:54AM -0500, Brian Foster wrote:
> > On Fri, Mar 10, 2017 at 03:38:46PM +0100, Quentin Casasnovas wrote:
> > > On Fri, Mar 10, 2017 at 09:05:35AM -0500, Brian Foster wrote:
> > > > On Fri, Mar 10, 2017 at 01:04:06PM +0100, Quentin Casasnovas wrote:
> > > > > Hi Guys,
> > > > >=20
> > > > > We've been using XFS recently on our build system because we foun=
d that it
> > > > > scales pretty well and we have good use for the reflink feature :)
> > > > >=20
> > > > > I think our setup is relivatively unique in that on every one of =
our build
> > > > > server, we mount hundreds of XFS filesystem from NBD devices in p=
arallel,
> > > > > where our build environment are stored on qcow2 images and connec=
ted with
> > > > > qemu-nbd, then umount them when the build is finished.  Those qco=
w2 images
> > > > > are stored on a NFS mount, which leads to some (expected) hickups=
 when
> > > > > reading/writing blocks where sometimes the NBD layer will return =
some
> > > > > errors to the block layer, which in turn will pass them on to XFS=
=2E  It
> > > > > could be due to network contention, very high load on the server,=
 or any
> > > > > transcient error really, and in those cases, XFS will normally fo=
rce shut
> > > > > down the filesystem and wait for a umount.
> > > > >=20
> > > > > All of this is fine and is exactly the behaviour we'd expect, tho=
ugh it
> > > > > turns out that we keep hiting what I think is a race condition be=
tween
> > > > > umount and a force shutdown from XFS itself, where I have a umoun=
t process
> > > > > completely stuck in xfs_ail_push_all_sync():
> > > > >=20
> > > > >   [<ffffffff813d987e>] xfs_ail_push_all_sync+0x9e/0xe0
> > > > >   [<ffffffff813c20c7>] xfs_unmountfs+0x67/0x150
> > > > >   [<ffffffff813c5540>] xfs_fs_put_super+0x20/0x70
> > > > >   [<ffffffff811cba7a>] generic_shutdown_super+0x6a/0xf0
> > > > >   [<ffffffff811cbb2b>] kill_block_super+0x2b/0x80
> > > > >   [<ffffffff811cc067>] deactivate_locked_super+0x47/0x80
> > > > >   [<ffffffff811ccc19>] deactivate_super+0x49/0x70
> > > > >   [<ffffffff811e7b3e>] cleanup_mnt+0x3e/0x90
> > > > >   [<ffffffff811e7bdd>] __cleanup_mnt+0xd/0x10
> > > > >   [<ffffffff810e1b39>] task_work_run+0x79/0xa0
> > > > >   [<ffffffff810c2df7>] exit_to_usermode_loop+0x4f/0x75
> > > > >   [<ffffffff8100134b>] syscall_return_slowpath+0x5b/0x70
> > > > >   [<ffffffff81a2cbe3>] entry_SYSCALL_64_fastpath+0x96/0x98
> > > > >   [<ffffffffffffffff>] 0xffffffffffffffff
> > > > >=20
>=20
> This actually looks pretty much with the problem I've been working on, or=
 with
> the previous one where we've introduced fail_at_unmount syscall config to=
 avoid
> such problems like this.
>=20
> Can you confirm if fail_at_unmount is active and if it can avoid the above
> problem to happen? If it doesn't avoid the problem to happen there, then,=
 I'm
> almost 100% sure it's the same problem I've been working on with AIL item=
s not
> being retried, but FWIW, this only happens if some sort of IO error happe=
ned
> previously, which looks like to be your case too.
>=20

I have not tried fail_at_umount yet but I could reproduce similar umount
hangs using NBD and NFS:

  # Create an image with an XFS filesystem on it
  qemu-img create -f qcow2 test-img.qcow2 10GB
  qemu-nbd -c /dev/nbd0 test-img.qcow2
  mkfs.xfs /dev/nbd0
  qemu-nbd -d /dev/nbd0

Now, serve the image over NFSv3, which doesn't support delete-on-last-close:

  cp test-img.qcow2 /path/to/nfs_mountpoint/
  qemu-nbd -c /dev/nbd0 /path/to/nfs_mountpoint/test-img.qcow2
  mount /dev/nbd0 /mnt

Trigger some IO on the mount point:

  cp -r ~/linux-2.6/ /mnt/

While there is on-going IO, overwrite the image served over NFS with your
original blank image:

  cp test-img.qcow2 /path/to/nfs_mountpoint/

Interrupt the IO if it hasn't failed with IO errors already and try to
unmount, this should result the umount process being stuck.

Quentin


--o7gdRJTuwFmWapyH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY1Q12AAoJEB5Tt01po9cNMawP/ipuShLPfL5LWjoylFwq4+c9
1qSgiQtfc5b9WD59P77bOxxipBWReMGsUTDgxEyLuPRJEVrseTCDf0FCBnHYUT+7
Cx+gN3qG7YIeIoh7AOunY4jLhO8Xv//CypQKSgJQwq89hOHSju8GgkqOCaBmlWdJ
ZXS/LPeW3LCbrgkqO+XERVRZ1s9RSfBUKQhJp20O63EI0f6XE1qzGJgmfdfQ3T/J
nEqSdU+KjfBXca4qkyvcXaRUyfQ+POljMAMmzNWelgzVXY3qUq42+yqLoo37cpIz
NJwB8YZpefloa0LLX3/W7dDfESYQXb/hqDCm98PuJgp6B2/AsL3llbrPi0jno+nw
LSP02YRbBgspoClP4N0fhT8uW3hpzrQvEQnpxdCIw4GYPejvLmDQG4fC+llAwoRn
Ut1a9iafbhH0lfQMh3k8BmRUhCvNre5393A86SqX5YWhGBYCGDo426KaFpEMl1Z0
++5H59NBJibxrebR3/+gEqasG9NM5vQ69VYa1eNHjKkSjwIdanz3gN30eut5BztA
d8YIoQfKeB7F0+LaQNUDe/EYwTr+78WoYGX6ZelVWPuxWvX84GNeJSU6BO6fbrY8
IV29mjFWs25/rMySB8lxzPaI8nF/oaMBE7UOwIh5Ev4qlHIjlDQ+kgAq+29RUG15
/8HdVnNHVogIhwMd9pC/
=N0z7
-----END PGP SIGNATURE-----

--o7gdRJTuwFmWapyH--
