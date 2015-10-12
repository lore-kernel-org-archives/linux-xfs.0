Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62A4B7F50
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 23:05:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0099FAC002
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 21:05:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Dl27zb1mCzlAaOpJ for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 21:05:49 -0700 (PDT)
Date: Mon, 12 Oct 2015 15:05:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
Message-ID: <20151012040545.GC27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
	<CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?= <andreas.gruenbacher@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API Mailing List <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Oct 12, 2015 at 03:51:15AM +0200, Andreas Gr=FCnbacher wrote:
> 2015-10-12 2:10 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > On Mon, Oct 12, 2015 at 12:58:35AM +0200, Andreas Gruenbacher wrote:
> >> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> >> index 5d47b4d..05dd312 100644
> >> --- a/fs/xfs/Kconfig
> >> +++ b/fs/xfs/Kconfig
> >> @@ -52,6 +52,17 @@ config XFS_POSIX_ACL
> >>
> >>         If you don't know what Access Control Lists are, say N.
> >>
> >> +config XFS_RICHACL
> >> +        bool "XFS Rich Access Control Lists (EXPERIMENTAL)"
> >> +        depends on XFS_FS
> >> +        select FS_RICHACL
> >> +        help
> >> +          Richacls are an implementation of NFSv4 ACLs, extended by f=
ile masks
> >> +          to cleanly integrate into the POSIX file permission model. =
 To learn
> >> +       more about them, see http://www.bestbits.at/richacl/.
> >> +
> >> +          If you don't know what Richacls are, say N.
> >> +
> >
> > So now we have multiple compile time ACL configs that we have to
> > test. Personally, I see no reason for making either posix or rich
> > acls compile time dependent. How about we just change CONFIG_FS_XFS
> > to have "select FS_POSIX_ACL" and "select FS_RICHACL"
> > unconditionally, and then we can get rid of all the conditional
> > code?
> =

> I'm sure neither kind of ACLs makes sense on many tiny systems, it
> should be possible to disable them. XFS may not make sense on those
> kinds of systems either, that is not my call to make though.

Well, the smallest systems that use XFS are typically 1-2 disk NAS
boxes, and I can see them wanting richacls. As it is, the xfs kernel
module is almost 1MB of object code, so it you have a small embedded
box you don't want XFS. Almost all distros turn on ACL support I'm
not sure that it makes sense to have these config options in XFS
anymore....

> >> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> >> index 9590a06..8c6da45 100644
> >> --- a/fs/xfs/libxfs/xfs_format.h
> >> +++ b/fs/xfs/libxfs/xfs_format.h
> >> @@ -461,10 +461,18 @@ xfs_sb_has_ro_compat_feature(
> >>  #define XFS_SB_FEAT_INCOMPAT_FTYPE   (1 << 0)        /* filetype in d=
irent */
> >>  #define XFS_SB_FEAT_INCOMPAT_SPINODES        (1 << 1)        /* spars=
e inode chunks */
> >>  #define XFS_SB_FEAT_INCOMPAT_META_UUID       (1 << 2)        /* metad=
ata UUID */
> >> +
> >> +#ifdef CONFIG_XFS_RICHACL
> >> +#define XFS_SB_FEAT_INCOMPAT_RICHACL (1 << 3)        /* richacls */
> >> +#else
> >> +#define XFS_SB_FEAT_INCOMPAT_RICHACL 0
> >> +#endif
> >> +
> >
> > Regardless of whether we build in richacl support, this is wrong.
> > Feature bits are on-disk format definitions, so it will always have
> > this value whether or not the kernel supports the feature.
> =

> This is so that xfs_mount_validate_sb() will complain when mounting a
> richacl filesystem on a kernel which doesn't have richacl suport
> compiled in. The same effect can be had with extra code there of
> course.

If the kernel doesn't know about a feature, then it will report
"unknown feature". However, as of this patch set, the kernel will
know about the richacl feature, and so the correct error message
is to say "Rich ACLs not supported by this kernel".

Also, from a disk format perspective, this is a this is a read-only
compat feature, as kernels that don't have richacl support are still
able to mount and walk the filesystem without errors occurring. It's
only when allowing modifications are made that problems will arise,
so why did you make it an incompat feature?

> >> +int
> >> +xfs_set_richacl(struct inode *inode, struct richacl *acl)
> >> +{
> >> +     struct xfs_inode *ip =3D XFS_I(inode);
> >> +     umode_t mode =3D inode->i_mode;
> >> +     int error;
> >> +
> >> +     if (acl) {
> >> +             /* Don't allow acls with unmapped identifiers. */
> >> +             if (richacl_has_unmapped_identifiers(acl))
> >> +                     return -EINVAL;
> >> +
> >> +             if (richacl_equiv_mode(acl, &mode) =3D=3D 0) {
> >> +                     xfs_set_mode(inode, mode);
> >> +                     acl =3D NULL;
> >> +             }
> >
> > Comment needed here - why does this now seem to accidentally fall
> > through to removing the ACL?
> =

> Setting an ACL that is equivalent to a file mode is the same as
> removing any existing ACLs and doing a chmod to that equivalent file
> mode. It's the sams as with POSIX ACLs, and the code is the same as
> well. I'll add a comment though.
> =

> > Also, why is this in the XFS specific
> > code when it's generic richacl functionality that is being checked?
> =

> This turns into two non-atomic operations if we move it into generic code.

I don't follow you - this isn't an atomic operation to begin with...

> > Also, I really dislike the API where passing a NULL acl means to
> > "set this acl" actually means "remove the existing ACL". Why no
> > ->remove_acl method called from the generic code?
> =

> It's not uncommon, it saves inode operations and wiring-up code.

I know it's common. All it does is put extra branches in the
filesystem code to do this, because remove is a different operation
to set. The API sucks, and we're not limited on inode operations,
and the operator overloading makes the filesystem code unnecessarily
complex as it has to detect when to branch out ot remove or not...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
