Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37157 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728547AbfFXXw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:52:26 -0400
Message-ID: <c2768567de3c54cd23eba5dfe5b6421c32ba6def.camel@themaw.net>
Subject: Re: [PATCH 05/10] xfs: mount-api - add xfs_get_tree()
From: Ian Kent <raven@themaw.net>
Date: Tue, 25 Jun 2019 07:52:21 +0800
In-Reply-To: <20190624174429.GW5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134513061.2519.15444193018279732348.stgit@fedora-28>
         <20190624174429.GW5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, 2019-06-24 at 10:44 -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:50AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .get_tree that validates
> > mount options and fills the super block as previously done
> > by the file_system_type .mount method.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  139
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 139 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index cf8efb465969..0ec0142b94e1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1629,6 +1629,98 @@ xfs_fs_remount(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_validate_params(
> > +	struct xfs_mount *mp,
> > +	struct xfs_fs_context *ctx,
> > +	enum fs_context_purpose purpose)
> 
> Tabs here, please:
> 
> 	struct xfs_mount	*mp,
> 	struct xfs_fs_context	*ctx,
> 	enum fs_context_purpose	purpose)

Oops, my bad, will fix.

> 
> > +{
> > +	/*
> > +	 * no recovery flag requires a read-only mount
> > +	 */
> > +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > +	    (ctx->dsunit || ctx->dswidth)) {
> > +		xfs_warn(mp,
> > +	"sunit and swidth options incompatible with the noalign option");
> > +		return -EINVAL;
> > +	}
> > +
> > +#ifndef CONFIG_XFS_QUOTA
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		xfs_warn(mp, "quota support not available in this kernel.");
> > +		return -EINVAL;
> > +	}
> > +#endif
> > +
> > +	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
> > +		xfs_warn(mp, "sunit and swidth must be specified together");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > +		xfs_warn(mp,
> > +	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > +			ctx->dswidth, ctx->dsunit);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > +		/*
> > +		 * At this point the superblock has not been read
> > +		 * in, therefore we do not know the block size.
> > +		 * Before the mount call ends we will convert
> > +		 * these to FSBs.
> > +		 */
> > +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> > +			mp->m_dalign = ctx->dsunit;
> > +			mp->m_swidth = ctx->dswidth;
> > +		}
> > +	}
> > +
> > +	if (mp->m_logbufs != -1 &&
> > +	    mp->m_logbufs != 0 &&
> > +	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> > +	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> > +		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > +			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
> > +		return -EINVAL;
> > +	}
> > +	if (mp->m_logbsize != -1 &&
> > +	    mp->m_logbsize !=  0 &&
> > +	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > +	     !is_power_of_2(mp->m_logbsize))) {
> > +		xfs_warn(mp,
> > +			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> > +			mp->m_logbsize);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (ctx->iosizelog) {
> > +		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > +		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > +			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
> > +				ctx->iosizelog, XFS_MIN_IO_LOG,
> > +				XFS_MAX_IO_LOG);
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (purpose == FS_CONTEXT_FOR_MOUNT) {
> > +			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > +			mp->m_readio_log = ctx->iosizelog;
> > +			mp->m_writeio_log = ctx->iosizelog;
> > +		}
> > +	}
> 
> Ugggh, I don't wanna have to compare the old xfs_parseargs code with
> this new xfs_validate_params code to make sure nothing got screwed up.
> :)
> 
> Can this code be broken out of the existing parseargs (instead of added
> further down in the file) to minimize the diff?  You're getting rid of
> the old option processing code at the end of the series anyway so I
> don't mind creating temporary struct xfs_fs_context structures in
> xfs_parseargs if that makes it much more obvious that the validation
> code itself isn't changing.

Both you, Dave, and myself agree but ...

The indentation is different between the two functions resulting
in an even harder to understand patch.

I will have another go at it and see if I can come up with a
re-factoring that helps.

> 
> --D
> 
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> >   * need to take care of the metadata. Once that's done sync the superblock
> > @@ -2035,6 +2127,52 @@ xfs_fs_fill_super(
> >  	return error;
> >  }
> >  
> > +STATIC int
> > +xfs_fill_super(
> > +	struct super_block	*sb,
> > +	struct fs_context	*fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = sb->s_fs_info;
> > +	int			silent = fc->sb_flags & SB_SILENT;
> > +	int			error = -ENOMEM;
> > +
> > +	mp->m_super = sb;
> > +
> > +	/*
> > +	 * set up the mount name first so all the errors will refer to the
> > +	 * correct device.
> > +	 */
> > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> > +	if (!mp->m_fsname)
> > +		return -ENOMEM;
> > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> > +
> > +	error = xfs_validate_params(mp, ctx, fc->purpose);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	error = __xfs_fs_fill_super(mp, silent);
> > +	if (error)
> > +		goto out_free_fsname;
> > +
> > +	return 0;
> > +
> > + out_free_fsname:
> > +	sb->s_fs_info = NULL;
> > +	xfs_free_fsname(mp);
> > +	kfree(mp);
> > +
> > +	return error;
> > +}
> > +
> > +STATIC int
> > +xfs_get_tree(
> > +	struct fs_context	*fc)
> > +{
> > +	return vfs_get_block_super(fc, xfs_fill_super);
> > +}
> > +
> >  STATIC void
> >  xfs_fs_put_super(
> >  	struct super_block	*sb)
> > @@ -2107,6 +2245,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> > +	.get_tree    = xfs_get_tree,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 
