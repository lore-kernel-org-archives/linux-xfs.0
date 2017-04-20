Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45008 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S944361AbdDTWWz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 18:22:55 -0400
Subject: Re: [PATCH v2] xfsprogs: ensure growfs rejects non-existent mount
 point
References: <20170407175809.8540-1-billodo@redhat.com>
 <20170411172235.9361-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8ffd0451-3455-dbe5-8905-a3c028a6932f@sandeen.net>
Date: Thu, 20 Apr 2017 17:22:48 -0500
MIME-Version: 1.0
In-Reply-To: <20170411172235.9361-1-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 12:22 PM, Bill O'Donnell wrote:
> xfs_growfs manpage clearly states that the filesystem must
> be mounted to be grown. Current behavior allows xfs_growfs
> to proceed if the filesystem /containing/ the path
> of the desired target is mounted. This is not the specified
> behavior. Instead, also check the targeted fs argument against
> the entry found in the fstable lookup. Unless the targeted
> fs is actually mounted, reject the command.
> 
> In order to cover bind-mounts, create a new lookup function
> based on the mountpoints instead of just the device name.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> 
> v2: in order to properly handle relative pathnames, symlinks,
> and bind-mounts, use realpath to establish canonical path name.
> This also requires the introduction of a lookup function based
> on the target mountpoint.
> 
>  growfs/xfs_growfs.c | 10 +++++++++-
>  include/path.h      |  1 +
>  libxcmd/paths.c     | 21 +++++++++++++++++++++
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index a294e14..a61e2f1 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -133,6 +133,7 @@ main(int argc, char **argv)
>  	int			spinodes;
>  	int			rmapbt_enabled;
>  	int			reflink_enabled;
> +	char			rpath[PATH_MAX];
>  
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -202,7 +203,14 @@ main(int argc, char **argv)
>  		aflag = 1;
>  
>  	fs_table_initialise(0, NULL, 0, NULL);
> -	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
> +
> +	if (!realpath(argv[optind], rpath)) {
> +		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
> +			progname, argv[optind]);
> +		return 1;

Probably not the clearest error message; if realpath failed, we
really don't know much at all about the path yet.

(_("Path resolution failed for %s: %s\n"), path, strerror(errno))
or something like that would be more informative if it fails..

Otherwise, I think this looks ok.  I was a little unsure about
keeping the old fs_table_lookup behavior around, but given that
xfs_growfs is the only utility (I think) which /explicitly/ says
it requires a mount point (and can have irreversible consequences
if it's pointed at the wrong thing) that's probably ok.

One other suggestion would be to document the difference between
the 2 lookup functions a bit more, making it more clear that one
will find the fs table entry for the fs hosting the file at *path,
and the other will find it only if it /is/ the mount point.

I had a concern that while you're passing a realpath'd path to
the new function, the mount points in the table aren't realpath'd.
But I /think/ that still works; if I mount onto a symlinked dir,
it's the realpath (symlink target) that ends up in /proc/mounts.

Still, it might be safest to realpath the path found in the
fs table as well prior to the comparison - if it's iterating
over /etc/mtab instead of /proc/mounts on an older machine, I'm
not sure what the paths end up looking like in that file. 

-Eric

> +	}
> +
> +	fs = fs_table_lookup_mount(rpath);
>  	if (!fs) {
>  		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
>  			progname, argv[optind]);
> diff --git a/include/path.h b/include/path.h
> index d077bac..1d3a902 100644
> --- a/include/path.h
> +++ b/include/path.h
> @@ -56,6 +56,7 @@ extern void fs_table_insert_project_path(char *__dir, uint __projid);
>  
>  
>  extern fs_path_t *fs_table_lookup(const char *__dir, uint __flags);
> +extern fs_path_t *fs_table_lookup_mount(const char *__dir);
>  
>  typedef struct fs_cursor {
>  	uint		count;		/* total count of mount entries	*/
> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index 816acc2..10927c6 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -86,6 +86,27 @@ fs_table_lookup(
>  	return NULL;
>  }
>  
> +/*
> + * Find the FS table entry for the given path. Compare
> + * the path to mountpoint entries in the table.
> + */
> +struct fs_path *
> +fs_table_lookup_mount(
> +	const char *dir)
> +{
> +	uint		i;
> +	dev_t		dev = 0;
> +
> +	if (fs_device_number(dir, &dev))
> +		return NULL;
> +
> +	for (i = 0; i < fs_count; i++) {
> +		if (strcmp(fs_table[i].fs_dir, dir) == 0)
> +			return &fs_table[i];
> +	}
> +	return NULL;
> +}
> +
>  static int
>  fs_table_insert(
>  	char		*dir,
> 
