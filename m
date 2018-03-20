Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53776 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbeCTXOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 19:14:44 -0400
Date: Tue, 20 Mar 2018 16:14:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs_fsr: refactor mountpoint finding to use libfrog
 paths functions
Message-ID: <20180320231440.GL1757@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151531831.18312.9201377632555740636.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152151531831.18312.9201377632555740636.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 19, 2018 at 08:08:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the mount-point finding code in fsr to use the libfrog helpers
> instead of open-coding yet another routine.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fsr/Makefile    |    4 ++-
>  fsr/xfs_fsr.c   |   71 +++++--------------------------------------------------
>  include/path.h  |    1 +
>  libfrog/paths.c |   47 ++++++++++++++++++++++++++++--------
>  4 files changed, 47 insertions(+), 76 deletions(-)
> 
> 
> diff --git a/fsr/Makefile b/fsr/Makefile
> index d3521b2..fc1c33b 100644
> --- a/fsr/Makefile
> +++ b/fsr/Makefile
> @@ -7,7 +7,9 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_fsr
>  CFILES = xfs_fsr.c
> -LLDLIBS = $(LIBHANDLE)
> +LLDLIBS = $(LIBHANDLE) $(LIBFROG)
> +LTDEPENDENCIES = $(LIBFROG)
> +LLDFLAGS = -static-libtool-libs
>  
>  ifeq ($(HAVE_GETMNTENT),yes)
>  LCFLAGS += -DHAVE_GETMNTENT
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 2a18ce0..ef6a68f 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -22,6 +22,7 @@
>  #include "jdm.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_attr_sf.h"
> +#include "path.h"
>  
>  #include <fcntl.h>
>  #include <errno.h>
> @@ -167,73 +168,13 @@ aborter(int unused)
>  	exit(1);
>  }
>  
> -/*
> - * Check if the argument is either the device name or mountpoint of an XFS
> - * filesystem.  Note that we do not care about bind mounted regular files
> - * here - the code that handles defragmentation of invidual files takes care
> - * of that.
> - */
> -static char *
> -find_mountpoint_check(struct stat *sb, struct mntent *t)
> -{
> -	struct stat ms;
> -
> -	if (S_ISDIR(sb->st_mode)) {		/* mount point */
> -		if (stat(t->mnt_dir, &ms) < 0)
> -			return NULL;
> -		if (sb->st_ino != ms.st_ino)
> -			return NULL;
> -		if (sb->st_dev != ms.st_dev)
> -			return NULL;
> -		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
> -			return NULL;
> -	} else {				/* device */
> -		if (stat(t->mnt_fsname, &ms) < 0)
> -			return NULL;
> -		if (sb->st_rdev != ms.st_rdev)
> -			return NULL;
> -		if (strcmp(t->mnt_type, MNTTYPE_XFS) != 0)
> -			return NULL;
> -		/*
> -		 * Make sure the mountpoint given by mtab is accessible
> -		 * before using it.
> -		 */
> -		if (stat(t->mnt_dir, &ms) < 0)
> -			return NULL;
> -	}
> -
> -	return t->mnt_dir;
> -}
> -
> -static char *
> -find_mountpoint(char *mtab, char *argname, struct stat *sb)
> -{
> -	struct mntent_cursor cursor;
> -	struct mntent *t = NULL;
> -	char *mntp = NULL;
> -
> -	if (platform_mntent_open(&cursor, mtab) != 0){
> -		fprintf(stderr, "Error: can't get mntent entries.\n");
> -		exit(1);
> -	}
> -
> -	while ((t = platform_mntent_next(&cursor)) != NULL) {
> -		mntp = find_mountpoint_check(sb, t);
> -		if (mntp == NULL)
> -			continue;
> -		break;
> -	}
> -	platform_mntent_close(&cursor);
> -	return mntp;
> -}
> -
>  int
>  main(int argc, char **argv)
>  {
>  	struct stat sb;
>  	char *argname;
>  	int c;
> -	char *mntp;
> +	struct fs_path	*fsp;
>  	char *mtab = NULL;
>  
>  	setlinebuf(stdout);
> @@ -343,9 +284,11 @@ main(int argc, char **argv)
>  				sb = sb2;
>  			}
>  
> -			mntp = find_mountpoint(mtab, argname, &sb);
> -			if (mntp != NULL) {
> -				fsrfs(mntp, 0, 100);
> +			fsp = fs_table_lookup_mount(argname);

Lovely, we call fs_table_lookup_mount without first calling
fs_table_initialise to initialize the mountpoint table.  Now this
program refuses directory and bdev arguments...

> +			if (!fsp)
> +				fsp = fs_table_lookup_blkdev(argname);
> +			if (fsp != NULL) {
> +				fsrfs(fsp->fs_dir, 0, 100);
>  			} else if (S_ISCHR(sb.st_mode)) {
>  				fprintf(stderr, _(
>  					"%s: char special not supported: %s\n"),
> diff --git a/include/path.h b/include/path.h
> index 1d3a902..88dc44b 100644
> --- a/include/path.h
> +++ b/include/path.h
> @@ -57,6 +57,7 @@ extern void fs_table_insert_project_path(char *__dir, uint __projid);
>  
>  extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
>  extern fs_path_t *fs_table_lookup_mount(const char *__dir);
> +extern fs_path_t *fs_table_lookup_blkdev(const char *bdev);
>  
>  typedef struct fs_cursor {
>  	uint		count;		/* total count of mount entries	*/
> diff --git a/libfrog/paths.c b/libfrog/paths.c
> index 19ee1ea..a80a30b 100644
> --- a/libfrog/paths.c
> +++ b/libfrog/paths.c
> @@ -89,15 +89,10 @@ fs_table_lookup(
>  	return NULL;
>  }
>  
> -/*
> - * Find the FS table entry describing an actual mount for the given path.
> - * Unlike fs_table_lookup(), fs_table_lookup_mount() compares the "dir"
> - * argument to actual mount point entries in the table. Accordingly, it
> - * will find matches only if the "dir" argument is indeed mounted.
> - */
> -struct fs_path *
> -fs_table_lookup_mount(
> -	const char	*dir)
> +static struct fs_path *
> +__fs_table_lookup_mount(
> +	const char	*dir,
> +	const char	*blkdev)
>  {
>  	uint		i;
>  	dev_t		dev = 0;
> @@ -106,13 +101,17 @@ fs_table_lookup_mount(
>  
>  	if (fs_device_number(dir, &dev))
>  		return NULL;

...which is just as well, since dir can now be NULL which means that
fs_table_lookup_blkdev will always bail out here.

nak, patch is fubar.

--D

> -	if (!realpath(dir, dpath))
> +	if (dir && !realpath(dir, dpath))
> +		return NULL;
> +	if (blkdev && !realpath(blkdev, dpath))
>  		return NULL;
>  
>  	for (i = 0; i < fs_count; i++) {
>  		if (fs_table[i].fs_flags != FS_MOUNT_POINT)
>  			continue;
> -		if (!realpath(fs_table[i].fs_dir, rpath))
> +		if (dir && !realpath(fs_table[i].fs_dir, rpath))
> +			continue;
> +		if (blkdev && !realpath(fs_table[i].fs_name, rpath))
>  			continue;
>  		if (strcmp(rpath, dpath) == 0)
>  			return &fs_table[i];
> @@ -120,6 +119,32 @@ fs_table_lookup_mount(
>  	return NULL;
>  }
>  
> +/*
> + * Find the FS table entry describing an actual mount for the given path.
> + * Unlike fs_table_lookup(), fs_table_lookup_mount() compares the "dir"
> + * argument to actual mount point entries in the table. Accordingly, it
> + * will find matches only if the "dir" argument is indeed mounted.
> + */
> +struct fs_path *
> +fs_table_lookup_mount(
> +	const char	*dir)
> +{
> +	return __fs_table_lookup_mount(dir, NULL);
> +}
> +
> +/*
> + * Find the FS table entry describing an actual mount for the block device.
> + * Unlike fs_table_lookup(), fs_table_lookup_blkdev() compares the "bdev"
> + * argument to actual mount point names in the table. Accordingly, it
> + * will find matches only if the "bdev" argument is indeed mounted.
> + */
> +struct fs_path *
> +fs_table_lookup_blkdev(
> +	const char	*bdev)
> +{
> +	return __fs_table_lookup_mount(NULL, bdev);
> +}
> +
>  static int
>  fs_table_insert(
>  	char		*dir,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
