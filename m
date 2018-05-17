Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37608 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeEQFW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 01:22:28 -0400
Date: Thu, 17 May 2018 01:15:51 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not
 granted
Message-ID: <20180517051550.GB22356@hungrycats.org>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-3-mfasheh@suse.de>
 <20180512000634.GG9510@magnolia>
 <20180513182152.GE27915@wotan.suse.de>
 <20180513182639.GB4933@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20180513182639.GB4933@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 13, 2018 at 11:26:39AM -0700, Darrick J. Wong wrote:
> On Sun, May 13, 2018 at 06:21:52PM +0000, Mark Fasheh wrote:
> > On Fri, May 11, 2018 at 05:06:34PM -0700, Darrick J. Wong wrote:
> > > On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
> > > > Right now we return EINVAL if a process does not have permission to=
 dedupe a
> > > > file. This was an oversight on my part. EPERM gives a true descript=
ion of
> > > > the nature of our error, and EINVAL is already used for the case th=
at the
> > > > filesystem does not support dedupe.
> > > >=20
> > > > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > > > ---
> > > >  fs/read_write.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > > index 77986a2e2a3b..8edef43a182c 100644
> > > > --- a/fs/read_write.c
> > > > +++ b/fs/read_write.c
> > > > @@ -2038,7 +2038,7 @@ int vfs_dedupe_file_range(struct file *file, =
struct file_dedupe_range *same)
> > > >  			info->status =3D -EINVAL;
> > > >  		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
> > > >  			     uid_eq(current_fsuid(), dst->i_uid))) {
> > > > -			info->status =3D -EINVAL;
> > > > +			info->status =3D -EPERM;
> > >=20
> > > Hmm, are we allowed to change this aspect of the kabi after the fact?
> > >=20
> > > Granted, we're only trading one error code for another, but will the
> > > existing users of this care?  xfs_io won't and I assume duperemove wo=
n't
> > > either, but what about bees? :)
> >=20
> > Yeah if you see my initial e-mail I check bees and also rust-btrfs. I t=
hink
> > this is fine as we're simply expanding on an error code return. There's=
 no
> > magic behavior expected with respect to these error codes either.
>=20
> Ok.  No objections from me, then.
>=20
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

For what it's worth, no objection from me either.  ;)

bees runs only with admin privilege and will never hit the modified line.

If bees is started without admin privilege, the TREE_SEARCH_V2 ioctl
fails.  bees uses this ioctl to walk over all the data in the filesystem,
so without admin privilege, bees never opens, reads, or dedupes anything.

bees relies on having an accurate internal model of btrfs structure and
behavior to issue dedup commands that will work and do useful things;
however, unexpected kernel behavior or concurrent user data changes
will make some dedups fail.  When that happens bees just abandons the
extent immediately:  a user data change will be handled in the next pass
over the filesystem, but an unexpected kernel behavior needs bees code
changes to correctly predict the new kernel behavior before the dedup
can be reattempted.

> --D
>=20
> > 	--Mark
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWv0QAwAKCRCB+YsaVrMb
nIv+AJ9urEZriSYOpZSs3/4c4GCPHbSvvgCeIlfsU/mnNXhE19Jy/qxk7Jb80J4=
=7Xt9
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
