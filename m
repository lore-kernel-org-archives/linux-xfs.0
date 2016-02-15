Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA9B37CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:54:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89AD9304051
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FYsrExSA11OfkOe2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 10:54:15 -0800 (PST)
Date: Mon, 15 Feb 2016 13:54:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: convert mount option parsing to tokens
Message-ID: <20160215185410.GA33291@bfoster.bfoster>
References: <56BBC982.50804@redhat.com>
 <56BBC9E6.5030100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56BBC9E6.5030100@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 05:38:14PM -0600, Eric Sandeen wrote:
> This should be a no-op change, just switch to token parsing
> like every other respectable filesystem does.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 59c9b7b..934233a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -65,83 +65,82 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
...
>  STATIC int
> -suffix_kstrtoint(char *s, unsigned int base, int *res)
> +suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
> -	char	*value = s;
> +	char	*value = match_strdup(s);
> +	int	ret = 0;
> +	

Trailing whitespace here ^^

>  
>  	last = strlen(value) - 1;
>  	if (value[last] == 'K' || value[last] == 'k') {
...
> @@ -217,152 +218,153 @@ xfs_parseargs(
>  	if (!options)
>  		goto done;
>  
> -	while ((this_char = strsep(&options, ",")) != NULL) {
> -		if (!*this_char)
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int		token;
> +
> +		if (!*p)
>  			continue;
> -		if ((value = strchr(this_char, '=')) != NULL)
> -			*value++ = 0;
>  
> -		if (!strcmp(this_char, MNTOPT_LOGBUFS)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			if (kstrtoint(value, 10, &mp->m_logbufs))
> -				return -EINVAL;
> -		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			if (suffix_kstrtoint(value, 10, &mp->m_logbsize))
> +                token = match_token(p, tokens, args);

^^^ spaces instead of tabs.

> +		switch (token) {
> +		case Opt_logbufs:
> +			if (match_int(args, &mp->m_logbufs))
>  				return -EINVAL;
> -		} else if (!strcmp(this_char, MNTOPT_LOGDEV)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> +			break;
> +		case Opt_logbsize:
> +			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
> -			}
> -			mp->m_logname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
> +			break;
> +		case Opt_logdev:
> +			mp->m_logname = match_strdup(args);
>  			if (!mp->m_logname)
>  				return -ENOMEM;
> -		} else if (!strcmp(this_char, MNTOPT_MTPT)) {
> -			xfs_warn(mp, "%s option not allowed on this system",
> -				this_char);
> +			break;
> +		case Opt_mtpt:
> +			xfs_warn(mp, "%s option not allowed on this system", p);
>  			return -EINVAL;
> -		} else if (!strcmp(this_char, MNTOPT_RTDEV)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
> +			break;

Any reason for the break after the return here? Otherwise seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

> +		case Opt_rtdev:
> +			mp->m_rtname = match_strdup(args);
>  			if (!mp->m_rtname)
>  				return -ENOMEM;
> -		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE) ||
> -			   !strcmp(this_char, MNTOPT_BIOSIZE)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			if (suffix_kstrtoint(value, 10, &iosize))
> +			break;
> +		case Opt_allocsize:
> +		case Opt_biosize:
> +			if (suffix_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
> -		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
> -			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
> +			break;
> +		case Opt_grpid:
> +		case Opt_bsdgroups:
>  			mp->m_flags |= XFS_MOUNT_GRPID;
> -		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
> -			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
> +			break;
> +		case Opt_nogrpid:
> +		case Opt_sysvgroups:
>  			mp->m_flags &= ~XFS_MOUNT_GRPID;
> -		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
> +			break;
> +		case Opt_wsync:
>  			mp->m_flags |= XFS_MOUNT_WSYNC;
> -		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
> +			break;
> +		case Opt_norecovery:
>  			mp->m_flags |= XFS_MOUNT_NORECOVERY;
> -		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
> +			break;
> +		case Opt_noalign:
>  			mp->m_flags |= XFS_MOUNT_NOALIGN;
> -		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
> +			break;
> +		case Opt_swalloc:
>  			mp->m_flags |= XFS_MOUNT_SWALLOC;
> -		} else if (!strcmp(this_char, MNTOPT_SUNIT)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			if (kstrtoint(value, 10, &dsunit))
> -				return -EINVAL;
> -		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> +			break;
> +		case Opt_sunit:
> +			if (match_int(args, &dsunit))
>  				return -EINVAL;
> -			}
> -			if (kstrtoint(value, 10, &dswidth))
> +			break;
> +		case Opt_swidth:
> +			if (match_int(args, &dswidth))
>  				return -EINVAL;
> -		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
> +			break;
> +		case Opt_inode32:
>  			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> -		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
> +			break;
> +		case Opt_inode64:
>  			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> -		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
> +			break;
> +		case Opt_nouuid:
>  			mp->m_flags |= XFS_MOUNT_NOUUID;
> -		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
> +			break;
> +		case Opt_barrier:
>  			mp->m_flags |= XFS_MOUNT_BARRIER;
> -		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
> +			break;
> +		case Opt_nobarrier:
>  			mp->m_flags &= ~XFS_MOUNT_BARRIER;
> -		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
> +			break;
> +		case Opt_ikeep:
>  			mp->m_flags |= XFS_MOUNT_IKEEP;
> -		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
> +			break;
> +		case Opt_noikeep:
>  			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> -		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
> +			break;
> +		case Opt_largeio:
>  			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> -		} else if (!strcmp(this_char, MNTOPT_NOLARGEIO)) {
> +			break;
> +		case Opt_nolargeio:
>  			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> -		} else if (!strcmp(this_char, MNTOPT_ATTR2)) {
> +			break;
> +		case Opt_attr2:
>  			mp->m_flags |= XFS_MOUNT_ATTR2;
> -		} else if (!strcmp(this_char, MNTOPT_NOATTR2)) {
> +			break;
> +		case Opt_noattr2:
>  			mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  			mp->m_flags |= XFS_MOUNT_NOATTR2;
> -		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
> +			break;
> +		case Opt_filestreams:
>  			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> -		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
> +			break;
> +		case Opt_noquota:
>  			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
>  			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
>  			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> -		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
> -			   !strcmp(this_char, MNTOPT_UQUOTA) ||
> -			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
> +			break;
> +		case Opt_quota:
> +		case Opt_uquota:
> +		case Opt_usrquota:
>  			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
>  					 XFS_UQUOTA_ENFD);
> -		} else if (!strcmp(this_char, MNTOPT_QUOTANOENF) ||
> -			   !strcmp(this_char, MNTOPT_UQUOTANOENF)) {
> +			break;
> +		case Opt_qnoenforce:
> +		case Opt_uqnoenforce:
>  			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
>  			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> -		} else if (!strcmp(this_char, MNTOPT_PQUOTA) ||
> -			   !strcmp(this_char, MNTOPT_PRJQUOTA)) {
> +			break;
> +		case Opt_pquota:
> +		case Opt_prjquota:
>  			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
>  					 XFS_PQUOTA_ENFD);
> -		} else if (!strcmp(this_char, MNTOPT_PQUOTANOENF)) {
> +			break;
> +		case Opt_pqnoenforce:
>  			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
>  			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> -		} else if (!strcmp(this_char, MNTOPT_GQUOTA) ||
> -			   !strcmp(this_char, MNTOPT_GRPQUOTA)) {
> +		case Opt_gquota:
> +		case Opt_grpquota:
>  			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
>  					 XFS_GQUOTA_ENFD);
> -		} else if (!strcmp(this_char, MNTOPT_GQUOTANOENF)) {
> +			break;
> +		case Opt_gqnoenforce:
>  			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
>  			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> -		} else if (!strcmp(this_char, MNTOPT_DISCARD)) {
> +			break;
> +		case Opt_discard:
>  			mp->m_flags |= XFS_MOUNT_DISCARD;
> -		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
> +			break;
> +		case Opt_nodiscard:
>  			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +			break;
>  #ifdef CONFIG_FS_DAX
> -		} else if (!strcmp(this_char, MNTOPT_DAX)) {
> +		case Opt_dax:
>  			mp->m_flags |= XFS_MOUNT_DAX;
> +			break;
>  #endif
> -		} else {
> -			xfs_warn(mp, "unknown mount option [%s].", this_char);
> +		default:
> +			xfs_warn(mp, "unknown mount option [%s].", p);
>  			return -EINVAL;
>  		}
>  	}
> @@ -461,25 +463,25 @@ xfs_showargs(
>  {
>  	static struct proc_xfs_info xfs_info_set[] = {
>  		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
> -		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
> -		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
> -		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
> -		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
> -		{ XFS_MOUNT_NORECOVERY,		"," MNTOPT_NORECOVERY },
> -		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
> -		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
> -		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
> -		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
> -		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
> -		{ XFS_MOUNT_DAX,		"," MNTOPT_DAX },
> +		{ XFS_MOUNT_IKEEP,		",ikeep" },
> +		{ XFS_MOUNT_WSYNC,		",wsync" },
> +		{ XFS_MOUNT_NOALIGN,		",noalign" },
> +		{ XFS_MOUNT_SWALLOC,		",swalloc" },
> +		{ XFS_MOUNT_NOUUID,		",nouuid" },
> +		{ XFS_MOUNT_NORECOVERY,		",norecovery" },
> +		{ XFS_MOUNT_ATTR2,		",attr2" },
> +		{ XFS_MOUNT_FILESTREAMS,	",filestreams" },
> +		{ XFS_MOUNT_GRPID,		",grpid" },
> +		{ XFS_MOUNT_DISCARD,		",discard" },
> +		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
> +		{ XFS_MOUNT_DAX,		",dax" },
>  		{ 0, NULL }
>  	};
>  	static struct proc_xfs_info xfs_info_unset[] = {
>  		/* the few simple ones we can get from the mount struct */
> -		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
> -		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
> -		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
> +		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
> +		{ XFS_MOUNT_BARRIER,		",nobarrier" },
> +		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
>  		{ 0, NULL }
>  	};
>  	struct proc_xfs_info	*xfs_infop;
> @@ -494,46 +496,46 @@ xfs_showargs(
>  	}
>  
>  	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
> -		seq_printf(m, "," MNTOPT_ALLOCSIZE "=%dk",
> +		seq_printf(m, ",allocsize=%dk",
>  				(int)(1 << mp->m_writeio_log) >> 10);
>  
>  	if (mp->m_logbufs > 0)
> -		seq_printf(m, "," MNTOPT_LOGBUFS "=%d", mp->m_logbufs);
> +		seq_printf(m, ",logbufs=%d", mp->m_logbufs);
>  	if (mp->m_logbsize > 0)
> -		seq_printf(m, "," MNTOPT_LOGBSIZE "=%dk", mp->m_logbsize >> 10);
> +		seq_printf(m, ",logbsize=%dk", mp->m_logbsize >> 10);
>  
>  	if (mp->m_logname)
> -		seq_show_option(m, MNTOPT_LOGDEV, mp->m_logname);
> +		seq_show_option(m, "logdev", mp->m_logname);
>  	if (mp->m_rtname)
> -		seq_show_option(m, MNTOPT_RTDEV, mp->m_rtname);
> +		seq_show_option(m, "rtdev", mp->m_rtname);
>  
>  	if (mp->m_dalign > 0)
> -		seq_printf(m, "," MNTOPT_SUNIT "=%d",
> +		seq_printf(m, ",sunit=%d",
>  				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
>  	if (mp->m_swidth > 0)
> -		seq_printf(m, "," MNTOPT_SWIDTH "=%d",
> +		seq_printf(m, ",swidth=%d",
>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
>  
>  	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
> -		seq_puts(m, "," MNTOPT_USRQUOTA);
> +		seq_puts(m, ",usrquota");
>  	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> -		seq_puts(m, "," MNTOPT_UQUOTANOENF);
> +		seq_puts(m, ",uqnoenforce");
>  
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
> -			seq_puts(m, "," MNTOPT_PRJQUOTA);
> +			seq_puts(m, ",prjquota");
>  		else
> -			seq_puts(m, "," MNTOPT_PQUOTANOENF);
> +			seq_puts(m, ",pqnoenforce");
>  	}
>  	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_GQUOTA_ENFD)
> -			seq_puts(m, "," MNTOPT_GRPQUOTA);
> +			seq_puts(m, ",grpquota");
>  		else
> -			seq_puts(m, "," MNTOPT_GQUOTANOENF);
> +			seq_puts(m, ",gqnoenforce");
>  	}
>  
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
> -		seq_puts(m, "," MNTOPT_NOQUOTA);
> +		seq_puts(m, ",noquota");
>  
>  	return 0;
>  }
> @@ -1344,9 +1346,8 @@ xfs_finish_flags(
>  	 */
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
> -		xfs_warn(mp,
> -"Cannot mount a V5 filesystem as %s. %s is always enabled for V5 filesystems.",
> -			MNTOPT_NOATTR2, MNTOPT_ATTR2);
> +		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
> +			     "attr2 is always enabled for V5 filesystems.");
>  		return -EINVAL;
>  	}
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
