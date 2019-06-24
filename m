Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41223 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbfFXXrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 19:47:09 -0400
Message-ID: <6dc984b1eb55d201c95314d146fbeafb45d71c03.camel@themaw.net>
Subject: Re: [PATCH 03/10] xfs: mount-api - add xfs_parse_param()
From: Ian Kent <raven@themaw.net>
Date: Tue, 25 Jun 2019 07:47:02 +0800
In-Reply-To: <20190624172632.GU5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134511636.2519.2203014992522713286.stgit@fedora-28>
         <20190624172632.GU5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, 2019-06-24 at 10:26 -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:36AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .parse_param that's called
> > by the mount-api ito parse each file system mount option.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  176
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 176 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 14c2a775786c..e78fea14d598 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -495,6 +495,178 @@ xfs_parseargs(
> >  	return 0;
> >  }
> >  
> > +struct xfs_fs_context {
> > +	int	dsunit;
> > +	int	dswidth;
> > +	uint8_t	iosizelog;
> > +};
> > +
> > +/*
> > + * This function fills in xfs_mount_t fields based on mount args.
> > + * Note: the superblock has _not_ yet been read in.
> > + *
> > + * Note that this function leaks the various device name allocations on
> > + * failure.  The caller takes care of them.
> 
> Wait, what?  Do you mean "The caller is responsible for freeing the
> device name allocations if option parsing ends in failure"?

Mmm ... yes, that needs to be re-worded.

It sounded sensible at the time and was copied from the initial
code, but it isn't clear, I'll have another go at that one in
v2.

> 
> > + */
> > +STATIC int
> > +xfs_parse_param(
> > +	struct fs_context	 *fc,
> > +	struct fs_parameter	 *param)
> > +{
> > +	struct xfs_fs_context    *ctx = fc->fs_private;
> > +	struct xfs_mount	 *mp = fc->s_fs_info;
> > +	struct fs_parse_result    result;
> > +	int			  iosize = 0;
> > +	int			  opt;
> > +
> > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > +	if (opt < 0)
> > +		return opt;
> > +
> > +	switch (opt) {
> > +	case Opt_logbufs:
> > +		mp->m_logbufs = result.uint_32;
> > +		break;
> > +	case Opt_logbsize:
> > +		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
> > +			return -EINVAL;
> > +		break;
> > +	case Opt_logdev:
> > +		kfree(mp->m_logname);
> > +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> > +		if (!mp->m_logname)
> > +			return -ENOMEM;
> > +		break;
> > +	case Opt_rtdev:
> > +		kfree(mp->m_rtname);
> > +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> > +		if (!mp->m_rtname)
> > +			return -ENOMEM;
> > +		break;
> > +	case Opt_allocsize:
> > +	case Opt_biosize:
> > +		if (suffix_kstrtoint(param->string, 10, &iosize))
> > +			return -EINVAL;
> > +		ctx->iosizelog = ffs(iosize) - 1;
> > +		break;
> > +	case Opt_bsdgroups:
> > +		mp->m_flags |= XFS_MOUNT_GRPID;
> > +		break;
> > +	case Opt_grpid:
> > +		if (result.negated)
> > +			mp->m_flags &= ~XFS_MOUNT_GRPID;
> > +		else
> > +			mp->m_flags |= XFS_MOUNT_GRPID;
> > +		break;
> > +	case Opt_sysvgroups:
> > +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> > +		break;
> > +	case Opt_wsync:
> > +		mp->m_flags |= XFS_MOUNT_WSYNC;
> > +		break;
> > +	case Opt_norecovery:
> > +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> > +		break;
> > +	case Opt_noalign:
> > +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> > +		break;
> > +	case Opt_swalloc:
> > +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> > +		break;
> > +	case Opt_sunit:
> > +		ctx->dsunit = result.uint_32;
> > +		break;
> > +	case Opt_swidth:
> > +		ctx->dswidth = result.uint_32;
> > +		break;
> > +	case Opt_inode32:
> > +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > +		break;
> > +	case Opt_inode64:
> > +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > +		break;
> > +	case Opt_nouuid:
> > +		mp->m_flags |= XFS_MOUNT_NOUUID;
> > +		break;
> > +	case Opt_ikeep:
> > +		if (result.negated)
> > +			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> > +		else
> > +			mp->m_flags |= XFS_MOUNT_IKEEP;
> > +		break;
> > +	case Opt_largeio:
> > +		if (result.negated)
> > +			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> > +		else
> > +			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> > +		break;
> > +	case Opt_attr2:
> > +		if (!result.negated) {
> > +			mp->m_flags |= XFS_MOUNT_ATTR2;
> > +		} else {
> > +			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> > +			mp->m_flags |= XFS_MOUNT_NOATTR2;
> > +		}
> > +		break;
> > +	case Opt_filestreams:
> > +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> > +		break;
> > +	case Opt_quota:
> > +		if (!result.negated) {
> > +			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> > +					 XFS_UQUOTA_ENFD);
> > +		} else {
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> > +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> > +		}
> > +		break;
> > +	case Opt_uquota:
> > +	case Opt_usrquota:
> > +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> > +				 XFS_UQUOTA_ENFD);
> > +		break;
> > +	case Opt_qnoenforce:
> > +	case Opt_uqnoenforce:
> > +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> > +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> > +		break;
> > +	case Opt_pquota:
> > +	case Opt_prjquota:
> > +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> > +				 XFS_PQUOTA_ENFD);
> > +		break;
> > +	case Opt_pqnoenforce:
> > +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> > +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> > +		break;
> > +	case Opt_gquota:
> > +	case Opt_grpquota:
> > +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> > +				 XFS_GQUOTA_ENFD);
> > +		break;
> > +	case Opt_gqnoenforce:
> > +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> > +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> > +		break;
> > +	case Opt_discard:
> > +		if (result.negated)
> > +			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> > +		else
> > +			mp->m_flags |= XFS_MOUNT_DISCARD;
> > +		break;
> > +#ifdef CONFIG_FS_DAX
> > +	case Opt_dax:
> > +		mp->m_flags |= XFS_MOUNT_DAX;
> > +		break;
> > +#endif
> > +	default:
> > +		return invalf(fc, "XFS: unknown mount option [%s].", param-
> > >key);
> 
> What do these messages end up looking like in dmesg?
> 
> The reason I ask is that today when mount option processing fails we log
> the device name in the error message:
> 
> # mount /dev/sda1 /mnt -o gribblegronk
> [64010.878477] XFS (sda1): unknown mount option [gribblegronk].
> 
> AFAICT using invalf (instead of xfs_warn) means that now we don't report
> the device name, and all you'd get is:
> 
> "[64010.878477] XFS: unknown mount option [gribblegronk]."
> 
> which is not as helpful...

Yes, I thought that might be seen as a problem.

The device name was obtained from the super block in the the
original code and the super block isn't available at this
point.

Not sure what to do about it but I'll have a look.

> 
> --D
> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  struct proc_xfs_info {
> >  	uint64_t	flag;
> >  	char		*str;
> > @@ -1914,6 +2086,10 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static const struct fs_context_operations xfs_context_ops = {
> > +	.parse_param = xfs_parse_param,
> > +};
> > +
> >  static struct file_system_type xfs_fs_type = {
> >  	.owner			= THIS_MODULE,
> >  	.name			= "xfs",
> > 
