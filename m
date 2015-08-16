Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BD6F7F47
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 19:20:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DFDA2AC003
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:20:23 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id 32ogQXyk7XJp6Mk1 for
	<xfs@oss.sgi.com>; Sat, 15 Aug 2015 17:20:21 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] v3 inodes are only valid on crc-enabled filesystems.
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <C69467E1-642A-422A-8ECF-FDED92550B1B@filmlight.ltd.uk>
Date: Sun, 16 Aug 2015 01:20:34 +0100
Message-Id: <B1687AEF-F6DB-4CC7-9011-A73B233F19D5@filmlight.ltd.uk>
References: <C69467E1-642A-422A-8ECF-FDED92550B1B@filmlight.ltd.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Roger Willcocks <roger@filmlight.ltd.uk>

With this patch, Leslie=92s filesystem now reports a Metadata corruption as=
 well as an invalid inode:

Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 00:41:25: scanning agi unlinked lists - 32 of 32 allocation group=
s done
        - process known inodes and perform inode discovery...
        - agno =3D 0
...
        - agno =3D 29
Metadata corruption detected at block 0x9e7833810/0x2000
        - agno =3D 11
bad version number 0x3 on inode 124656869424
bad version number 0x3 on inode 124656869424, resetting version number
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - 00:41:26: process known inodes and inode discovery - 42368 of 423=
68 inodes done

=97
Roger


On 16 Aug 2015, at 01:14, Roger Willcocks <roger@filmlight.ltd.uk> wrote:

> Fix an xfs_repair regression reported by Leslie Rhorer where a bad
> (v3) inode version number was not reset.
> =

> Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
> ---
> db/check.c             | 2 +-
> include/xfs_dinode.h   | 3 ++-
> libxfs/xfs_inode_buf.c | 2 +-
> repair/dinode.c        | 7 +++----
> repair/prefetch.c      | 2 +-
> 5 files changed, 8 insertions(+), 8 deletions(-)
> =

> diff --git a/db/check.c b/db/check.c
> index c4c972f..810fa55 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2637,7 +2637,7 @@ process_inode(
> 		error++;
> 		return;
> 	}
> -	if (!XFS_DINODE_GOOD_VERSION(idic.di_version)) {
> +	if (!XFS_DINODE_GOOD_VERSION(&mp->m_sb, idic.di_version)) {
> 		if (isfree || v)
> 			dbprintf(_("bad version number %#x for inode %lld\n"),
> 				idic.di_version, ino);
> diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
> index 623bbe8..40700e6 100644
> --- a/include/xfs_dinode.h
> +++ b/include/xfs_dinode.h
> @@ -19,7 +19,8 @@
> #define	__XFS_DINODE_H__
> =

> #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
> -#define XFS_DINODE_GOOD_VERSION(v)	((v) >=3D 1 && (v) <=3D 3)
> +#define XFS_DINODE_GOOD_VERSION(sb, v) \
> +	(xfs_sb_version_hascrc(sb) ? ((v) =3D=3D 3) : ((v) =3D=3D 1 || (v) =3D=
=3D 2))
> =

> typedef struct xfs_timestamp {
> 	__be32		t_sec;		/* timestamp seconds */
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index de16ed9..e9cc74c 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -78,7 +78,7 @@ xfs_inode_buf_verify(
> 		dip =3D (struct xfs_dinode *)xfs_buf_offset(bp,
> 					(i << mp->m_sb.sb_inodelog));
> 		di_ok =3D dip->di_magic =3D=3D cpu_to_be16(XFS_DINODE_MAGIC) &&
> -			    XFS_DINODE_GOOD_VERSION(dip->di_version);
> +			XFS_DINODE_GOOD_VERSION(&mp->m_sb, dip->di_version);
> 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> 						XFS_ERRTAG_ITOBP_INOTOBP,
> 						XFS_RANDOM_ITOBP_INOTOBP))) {
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 035212c..29a7a19 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -129,7 +129,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t =
*dinoc, xfs_ino_t ino_num)
> 		dinoc->di_magic =3D cpu_to_be16(XFS_DINODE_MAGIC);
> 	}
> =

> -	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
> +	if (!XFS_DINODE_GOOD_VERSION(&mp->m_sb, dinoc->di_version) ||
> 	    (!fs_inode_nlink && dinoc->di_version > 1))  {
> 		__dirty_no_modify_ret(dirty);
> 		if (xfs_sb_version_hascrc(&mp->m_sb))
> @@ -2331,9 +2331,8 @@ process_dinode_int(xfs_mount_t *mp,
> 		}
> 	}
> =

> -	if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
> -	    (!fs_inode_nlink && dino->di_version > 1) ||
> -	    (xfs_sb_version_hascrc(&mp->m_sb) && dino->di_version < 3) )  {
> +	if (!XFS_DINODE_GOOD_VERSION(&mp->m_sb, dino->di_version) ||
> +	    (!fs_inode_nlink && dino->di_version > 1) ) {
> 		retval =3D 1;
> 		if (!uncertain)
> 			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 7ea0d36..ad7082c 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -419,7 +419,7 @@ pf_read_inode_dirs(
> 		if (be16_to_cpu(dino->di_magic) !=3D XFS_DINODE_MAGIC)
> 			continue;
> =

> -		if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
> +		if (!XFS_DINODE_GOOD_VERSION(&mp->m_sb, dino->di_version) ||
> 				(!fs_inode_nlink && dino->di_version > 1))
> 			continue;
> =

> -- =

> 2.5.0.rc0
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
