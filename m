Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfCTUN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 16:13:58 -0400
Date: Wed, 20 Mar 2019 13:13:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/36] xfs_scrub: check label for misleading characters
Message-ID: <20190320201355.GM1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259753535.31886.7933186379056372168.stgit@magnolia>
 <74f2b4e3-5248-d1d6-94e4-a90fd53cbecc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74f2b4e3-5248-d1d6-94e4-a90fd53cbecc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 20, 2019 at 03:09:56PM -0500, Eric Sandeen wrote:
> On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that we can retrieve the label and that it doesn't contain
> > anything potentially misleading.
> 
> I still don't know for sure what the risk is here of having weird
> chars in a label, but sure?  :)  Anyway, nitpick below.
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/phase5.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  scrub/unicrash.c |   24 ++++++++++++++++++++++++
> >  scrub/unicrash.h |    5 +++++
> >  3 files changed, 83 insertions(+)
> > 
> > 
> > diff --git a/scrub/phase5.c b/scrub/phase5.c
> > index 6ffcec2d..49886e6f 100644
> > --- a/scrub/phase5.c
> > +++ b/scrub/phase5.c
> > @@ -11,6 +11,7 @@
> >  #ifdef HAVE_LIBATTR
> >  # include <attr/attributes.h>
> >  #endif
> > +#include <linux/fs.h>
> >  #include "handle.h"
> >  #include "list.h"
> >  #include "path.h"
> > @@ -282,6 +283,55 @@ xfs_scrub_connections(
> >  	return *pmoveon ? 0 : XFS_ITERATE_INODES_ABORT;
> >  }
> >  
> > +#ifndef FS_IOC_GETFSLABEL
> > +# define FSLABEL_MAX		256
> > +# define FS_IOC_GETFSLABEL	_IOR(0x94, 49, char[FSLABEL_MAX])
> > +#endif /* FS_IOC_GETFSLABEL */
> > +
> > +/*
> > + * Check the filesystem label for Unicode normalization problems or misleading
> > + * sequences.
> > + */
> > +static bool
> > +xfs_scrub_fs_label(
> > +	struct scrub_ctx		*ctx)
> > +{
> > +	char				label[FSLABEL_MAX];
> > +	struct unicrash			*uc = NULL;
> > +	bool				moveon = true;
> > +	int				error;
> > +
> > +	moveon = unicrash_fs_label_init(&uc, ctx);
> > +	if (!moveon)
> > +		return false;
> > +
> > +	/* Retrieve label; quietly bail if we don't support that. */
> > +	error = ioctl(ctx->mnt_fd, FS_IOC_GETFSLABEL, &label);
> > +	if (error) {
> > +		if (errno != EOPNOTSUPP && errno != ENOTTY) {
> > +			moveon = false;
> > +			perror(ctx->mntpoint);
> > +		}
> > +		goto out;
> > +	}
> > +
> > +	/* Ignore empty labels. */
> > +	if (label[0] == 0)
> > +		goto out;
> > +
> > +	/* Otherwise check for weirdness. */
> > +	if (uc)
> > +		moveon = unicrash_check_fs_label(uc, ctx->mntpoint, label);
> > +	else
> > +		moveon = xfs_scrub_check_name(ctx, ctx->mntpoint,
> > +				_("filesystem label"), label);
> > +	if (!moveon)
> > +		goto out;
> 
> This test & goto ^^^ seems rather pointless...

Yes, it's currently pointless seeing as there's nothing else that goes
on before the label.  I didn't want to leave the logic bomb that if
anyone ever /does/ add something here they'll have to add back the
if-goto-out part.

/me shrugs, will take it out and resubmit if you like. :)

--D

> > +out:
> > +	unicrash_free(uc);
> > +	return moveon;
> > +}
> > +
> >  /* Check directory connectivity. */
> >  bool
> >  xfs_scan_connections(
> > @@ -296,6 +346,10 @@ _("Filesystem has errors, skipping connectivity checks."));
> >  		return true;
> >  	}
> >  
> > +	moveon = xfs_scrub_fs_label(ctx);
> > +	if (!moveon)
> > +		return false;
> > +
> >  	ret = xfs_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
> >  	if (!ret)
> >  		moveon = false;
> > diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> > index a95fc305..121eedbc 100644
> > --- a/scrub/unicrash.c
> > +++ b/scrub/unicrash.c
> > @@ -465,6 +465,15 @@ unicrash_xattr_init(
> >  			is_only_root_writable(bstat));
> >  }
> >  
> > +/* Initialize the collision detector for a filesystem label. */
> > +bool
> > +unicrash_fs_label_init(
> > +	struct unicrash		**ucp,
> > +	struct scrub_ctx	*ctx)
> > +{
> > +	return unicrash_init(ucp, ctx, false, 16, true);
> > +}
> > +
> >  /* Free the crash detector. */
> >  void
> >  unicrash_free(
> > @@ -698,3 +707,18 @@ unicrash_check_xattr_name(
> >  	return __unicrash_check_name(uc, descr, _("extended attribute"),
> >  			attrname, 0);
> >  }
> > +
> > +/*
> > + * Check the fs label for unicode normalization problems or misleading bits.
> > + */
> > +bool
> > +unicrash_check_fs_label(
> > +	struct unicrash		*uc,
> > +	const char		*descr,
> > +	const char		*label)
> > +{
> > +	if (!uc)
> > +		return true;
> > +	return __unicrash_check_name(uc, descr, _("filesystem label"),
> > +			label, 0);
> > +}
> > diff --git a/scrub/unicrash.h b/scrub/unicrash.h
> > index 7d7276a8..85fcabc6 100644
> > --- a/scrub/unicrash.h
> > +++ b/scrub/unicrash.h
> > @@ -17,17 +17,22 @@ bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
> >  		struct xfs_bstat *bstat);
> >  bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
> >  		struct xfs_bstat *bstat);
> > +bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
> >  void unicrash_free(struct unicrash *uc);
> >  bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
> >  		struct dirent *dirent);
> >  bool unicrash_check_xattr_name(struct unicrash *uc, const char *descr,
> >  		const char *attrname);
> > +bool unicrash_check_fs_label(struct unicrash *uc, const char *descr,
> > +		const char *label);
> >  #else
> >  # define unicrash_dir_init(u, c, b)		(true)
> >  # define unicrash_xattr_init(u, c, b)		(true)
> > +# define unicrash_label_init(u, c)		(true)
> >  # define unicrash_free(u)			do {(u) = (u);} while (0)
> >  # define unicrash_check_dir_name(u, d, n)	(true)
> >  # define unicrash_check_xattr_name(u, d, n)	(true)
> > +# define unicrash_check_fs_label(u, d, n)	(true)
> >  #endif /* HAVE_LIBICU */
> >  
> >  #endif /* XFS_SCRUB_UNICRASH_H_ */
> > 
