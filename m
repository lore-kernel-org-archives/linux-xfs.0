Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0803D7FC0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:59:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0FF7304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 00:59:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DYdfKsYcG8BtXwCU for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 00:59:09 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WhaHJ-00032p-Nn
	for xfs@oss.sgi.com; Tue, 06 May 2014 17:59:05 +1000
Date: Tue, 6 May 2014 17:59:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140506075905.GA5421@dastard>
References: <20140506071855.F152E7FBC@oss.sgi.com>
MIME-Version: 1.0
In-Reply-To: <20140506071855.F152E7FBC@oss.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6895041230571082005=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6895041230571082005==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 02:18:55AM -0500, xfs@oss.sgi.com wrote:
> This is an automated email from the git hooks/post-receive script. It was
> generated because a ref change was pushed to the repository containing
> the project "XFS development tree".
>=20
> The branch, xfs-libxfs-in-kernel-RFC has been created
>         at  6579dd808ddf0ddc10e59e715dc8f2eb09705203 (commit)

No doubt you are all wondering what this is by now. :)

I spent a couple of hours doing what I'd been talking about for a
while now - converting the xfs kernel source tree to have a libxfs
abstraction. It's based on the current for-next branch, so it's
completely up-to-date.

The commits in this series move all the files used by userspace to:

	- fs/xfs/libxfs for .c and private.h files
	- fs/xfs/libxfs/include for public .h files

It converts all the libxfs includes to makes the userspace libxfs
includes (just a single #include) for both internal (libxfs_int.h)
and external (libxfs.h). These will not be shared with userspace;
userspace will provide it's own just like it does now.

The core idea around this code layout is that we can now extract all
the changes to the libxfs code in the kernel in a simple manner
(commit by commit or as a single aggregate patch), and apply it to
the userspace libxfs code with the right pathname filter to the
patch command. That's all a sync will require in future, and should
make it scriptable and easy for anyone to do. It means, ideally,
that we can do libxfs updates at the same time we do kernel updates
with almost no effort.

There's still a few little messy corners, but I'm seriously tempted
just to merge this into for-next right now because it's all good. :)"

[ Seriously, it removes almost a thousand #include lines from the
kernel code, requires almost no extra infrastructure in the kernel,
already has passed several full xfstests runs and will make our life
so much easier. ]

Things that need to be done:

	- xfs_dir2_priv.h is included in places that it shouldn't
	  be. Whatever those callers need from that header file
	  should be moved to xfs_dir2.h and into libxfs proper.
	- the Makefiles still have a little bit of messy include
	  rules (i.e. -I$(src) -I$(src)/libxfs/include) bit I can
	  live with that I think.
	- some of the libxfs header files have a dependency on
	  xfs_mount.h for things like inode cluster and directory
	  block sizes. These need to be untangled, but it's not a
	  critical issue right now.
	- xfs_vnode.h needs to die.
	- the kernel only header files that include libxfs header
	  files can now drop those includes.

Overall, though, this was surprisingly easy to do. All of the recent
header file consolidation and cleanup that we've done made this
pretty much a case of git mv of all the files and little bit of
infrastructure, and not much else...

I suspect the next thing that needs to be done is consolidate libxfs
and libxlog in userspace, and split the log recovery code in the
kernel and put the shared part into fs/xfs/libxfs.....

I've put it up as a git branch rather than patches, because nobody
wants me posting a patchset with a diffstat like this:

$ git diff --stat for-next..
=2E...
164 files changed, 47250 insertions(+), 48036 deletions(-)

However, when you tell git to be smart about renames (i.e file
movement is ignored), the actual diffstat looks like this:

$ git diff --stat --summary -C -M for-next..
=2E...
108 files changed, 291 insertions(+), 1077 deletions(-)

If you want to look at it, pull from this branch:

git://oss.sgi.com/xfs/xfs xfs-libxfs-in-kernel-RFC

And check it out. The head is here:

6579dd8 libxfs: provide extern include file

New Commits:

Dave Chinner (5):
      [20c53cb] xfs: create libxfs infrastructure
      [22b8ea8] libxfs: move header files
      [612480c] libxfs: move source files
      [5e51adf] libxfs: consolidate internal include files
      [6579dd8] libxfs: provide extern include file

Comments, flames, suggestions and beer all welcome :)

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaJZIAAoJEK3oKUf0dfodPz4P/RkDGpT2ogKilp1HWkgaGKeN
QL52uKaodE+k1rKfDC2LcmOfJNLEykWpiSYgyjD4Rki0A1cyqFHS1f34sk/Rs2wh
0HK40ACSJAxKKc1ZsMiJ7NYU4SxUNedvfwSfncGdKE7bS84TItzbKbHtppdSvMJe
bAAj4hhkdLQ9jGwZs1u5T5HK83TaXR+B0kDO7RGm6PLAyctkoX83IuH5DiS1ak8x
l8weFEzXsCkk/LV19dR1ojRtFSu5Xt6AApgFk6FpYBby6qALcV1gLF5w557cpMKW
XgPJRediCSgG0McxmENUcxmcC26p1zyx0zXcAJwCb4boMkap22OUZPkJsqa3lilD
6EHmuoEa345ChsrAtQDyQc9doquHc5h3GEYesFCUdKXZ4thCukn9+VmV4zyxO5ix
YxzvhhyG2/x4wn6LHTywIL2IhCuS71LG5/4ZEw7Q8GXBO1/ToCwdwYnGHO9ek44F
6tKvJuTryTASfpidj4F17W41N9FKgtmN6mz+KjudthDP9mrdxpUaKNws8ssageea
YI89GF/SwKq4wkHyGUspVFTh3QnxZKlWVfrIpCyK7Daj/HTRAgXXNntpYBjWDdMi
qMu3MlG40ZW4IqnAQug2q94+Ua4W7L4ie9yLtbsxqwsfuGLZ8Q6MVQQkGvx+ogaZ
z7cuCOWDBoF+VGtuUtOM
=Fa6S
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--


--===============6895041230571082005==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6895041230571082005==--
