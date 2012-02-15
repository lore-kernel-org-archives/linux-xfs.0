Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FCW5wM175934 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 06:32:06 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DuJR2BwOeJTuZvdF for
	<xfs@oss.sgi.com>; Wed, 15 Feb 2012 04:32:04 -0800 (PST)
Date: Wed, 15 Feb 2012 10:31:43 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_fsr: Get the last mount on a specific mount point
Message-ID: <20120215123143.GA22051@andromeda.usersys.redhat.com>
References: <1328640076-12645-1-git-send-email-cmaiolino@redhat.com>
	<20120213174240.GA3474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120213174240.GA3474@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi,

> ---
>  fsr/xfs_fsr.c |  142 +++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 72 insertions(+), 70 deletions(-)
> 
> Index: xfsprogs-dev/fsr/xfs_fsr.c
> ===================================================================
> --- xfsprogs-dev.orig/fsr/xfs_fsr.c	2012-02-12 16:30:07.286766766 -0800
> +++ xfsprogs-dev/fsr/xfs_fsr.c	2012-02-12 16:42:39.293447376 -0800
> @@ -109,7 +109,6 @@ static void tmp_init(char *mnt);
>  static char * tmp_next(char *mnt);
>  static void tmp_close(char *mnt);
>  int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
> -static int getmntany(FILE *, struct mntent *, struct mntent *, struct stat64 *);
>  
>  xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
>  
> @@ -178,18 +177,73 @@ aborter(int unused)
>  	exit(1);
>  }
>  
> +/*
> + * Check if the argument is either the device name or mountpoint of an XFS
> + * filesystem.  Note that we do not care about bind mounted regular files
> + * here - the code that handles defragmentation of invidual files takes care
> + * of that.
> + */
> +static char *
> +find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
> +{
> +	struct mntent *t;
> +	struct stat64 ms;
> +	FILE *mtabp;
> +	char *mntp = NULL;
> +
> +	mtabp = setmntent(mtab, "r");
> +	if (!mtabp) {
> +		fprintf(stderr, _("%s: cannot read %s\n"),
> +			progname, mtab);
> +		exit(1);
> +	}
> +
> +	while ((t = getmntent(mtabp))) {
> +		if (S_ISDIR(sb->st_mode)) {
> +			if (stat64(t->mnt_dir, &ms) < 0)
> +				continue;
> +			if (sb->st_ino != ms.st_ino)
> +				continue;
> +			if (sb->st_dev != ms.st_dev)
> +				continue;
> +		} else {
> +			if (stat64(t->mnt_fsname, &ms) < 0)
> +				continue;
> +			if (sb->st_rdev != ms.st_rdev)
> +				continue;
> +		}
> +
> +		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
> +			continue;
> +
> +		/*
> +		 * If we found an entry based on the device name make sure we
> +		 * stat the mountpoint that the mtab gave actually is accessible
> +		 * before using it.
> +		 */
I would change a little this sentence, looks a little confusing at least for me.
How about:

		/* If we found an entry based on the device name, make sure we
		 * stat the mount point given by mtab and ensure it's accessible
		 * before using it.
		 */

> +		if (S_ISBLK(sb->st_mode)) {
> +			struct stat64 sb2;
> +
> +			if (stat64(t->mnt_dir, &sb2) < 0)
> +				continue;
> +		}
> +
> +		mntp = t->mnt_dir;
> +		break;
> +	}
> +
> +	endmntent(mtabp);
> +	return mntp;
> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> -	struct stat64 sb, sb2;
> +	struct stat64 sb;
>  	char *argname;
> -	char *cp;
>  	int c;
> -	struct mntent mntpref;
> -	register struct mntent *mntp;
> -	struct mntent ment;
> +	char *mntp;
>  	char *mtab = NULL;
> -	register FILE *mtabp;
>  
>  	setlinebuf(stdout);
>  	progname = basename(argv[0]);
> @@ -281,49 +335,26 @@ main(int argc, char **argv)
>  	if (optind < argc) {
>  		for (; optind < argc; optind++) {
>  			argname = argv[optind];
> -			mntp = NULL;
> +
>  			if (lstat64(argname, &sb) < 0) {
>  				fprintf(stderr,
>  					_("%s: could not stat: %s: %s\n"),
>  					progname, argname, strerror(errno));
>  				continue;
>  			}
> -			if (S_ISLNK(sb.st_mode) && stat64(argname, &sb2) == 0 &&
> -			    (S_ISBLK(sb2.st_mode) || S_ISCHR(sb2.st_mode)))
> -				sb = sb2;
> -			if (S_ISBLK(sb.st_mode) || (S_ISDIR(sb.st_mode))) {
> -				if ((mtabp = setmntent(mtab, "r")) == NULL) {
> -					fprintf(stderr,
> -						_("%s: cannot read %s\n"),
> -						progname, mtab);
> -					exit(1);
> -				}
> -				bzero(&mntpref, sizeof(mntpref));
> -				if (S_ISDIR(sb.st_mode))
> -					mntpref.mnt_dir = argname;
> -				else
> -					mntpref.mnt_fsname = argname;
>  
> -				if (getmntany(mtabp, &ment, &mntpref, &sb) &&
> -				    strcmp(ment.mnt_type, MNTTYPE_XFS) == 0) {
> -					mntp = &ment;
> -					if (S_ISBLK(sb.st_mode)) {
> -						cp = mntp->mnt_dir;
> -						if (cp == NULL ||
> -						    stat64(cp, &sb2) < 0) {
> -							fprintf(stderr, _(
> -						"%s: could not stat: %s: %s\n"),
> -							progname, argname,
> -							strerror(errno));
> -							continue;
> -						}
> -						sb = sb2;
> -						argname = cp;
> -					}
> -				}
> +			if (S_ISLNK(sb.st_mode)) {
> +				struct stat64 sb2;

Particularly, I don't like variable declarations between statements, but I'm not
too experienced to say what's good or not :)

> +
> +				if (stat64(argname, &sb2) == 0 &&
> +				    (S_ISBLK(sb2.st_mode) ||
> +				     S_ISCHR(sb2.st_mode)))
> +				sb = sb2;
>  			}
> +
> +			mntp = find_mountpoint(mtab, argname, &sb);
>  			if (mntp != NULL) {
> -				fsrfs(mntp->mnt_dir, 0, 100);
> +				fsrfs(mntp, 0, 100);
>  			} else if (S_ISCHR(sb.st_mode)) {
>  				fprintf(stderr, _(
>  					"%s: char special not supported: %s\n"),
> @@ -1639,35 +1670,6 @@ fsrprintf(const char *fmt, ...)
>  }
>  
>  /*
> - * emulate getmntany
> - */
> -static int
> -getmntany(FILE *fp, struct mntent *mp, struct mntent *mpref, struct stat64 *s)
> -{
> -	struct mntent *t;
> -	struct stat64 ms;
> -
> -	while ((t = getmntent(fp))) {
> -		if (mpref->mnt_fsname) {	/* device */
> -			if (stat64(t->mnt_fsname, &ms) < 0)
> -				continue;
> -			if (s->st_rdev != ms.st_rdev)
> -				continue;
> -		}
> -		if (mpref->mnt_dir) {		/* mount point */
> -			if (stat64(t->mnt_dir, &ms) < 0)
> -				continue;
> -			if (s->st_ino != ms.st_ino || s->st_dev != ms.st_dev)
> -				continue;
> -		}
> -		*mp = *t;
> -		break;
> -	}
> -	return (t != NULL);
> -}
> -
> -
> -/*
>   * Initialize a directory for tmp file use.  This is used
>   * by the full filesystem defragmentation when we're walking
>   * the inodes and do not know the path for the individual
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Otherwise looks good.
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
