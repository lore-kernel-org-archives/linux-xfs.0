Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AED37CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 14:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CE5E30404E
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 12:26:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TfC37aC8Z7nr2tAX for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2016 12:26:25 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] xfsprogs: populate fs table with xfs entries
	first, foreign entries last
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
	<1473953386-10242-1-git-send-email-billodo@redhat.com>
	<1473953386-10242-2-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8f5cd105-ce7f-9338-e657-5c298f2b8ada@sandeen.net>
Date: Thu, 15 Sep 2016 14:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <1473953386-10242-2-git-send-email-billodo@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On 9/15/16 10:29 AM, Bill O'Donnell wrote:
> Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> non-XFS filesystems. Modifications to fs_initialise_mounts
> (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> fs paths being picked up first from the fs table. The xfs_quota
> print command then complained about not being able to print the
> foreign paths, instead of previous behavior (quiet).
> 
> This patch restores correct behavior, sorting the table so that
> xfs entries are first, followed by foreign fs entries. The patch
> maintains the order of xfs entries and foreign entries in the
> same order as mtab entries. Then, in functions which print all
> paths we can simply break at the first foreign path if the -f
> switch is not specified.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

worksforme, thanks

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/path.h  |  1 +
>  libxcmd/paths.c | 12 +++++++++++-
>  quota/path.c    | 24 ++++++++++++++++++------
>  3 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/include/path.h b/include/path.h
> index 39c1a95..d077bac 100644
> --- a/include/path.h
> +++ b/include/path.h
> @@ -44,6 +44,7 @@ typedef struct fs_path {
>  } fs_path_t;
>  
>  extern int fs_count;		/* number of entries in fs table */
> +extern int xfs_fs_count;	/* number of xfs entries in fs table */
>  extern fs_path_t *fs_table;	/* array of entries in fs table  */
>  extern fs_path_t *fs_path;	/* current entry in the fs table */
>  extern char *mtab_file;
> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index 4158688..3455217 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -32,6 +32,7 @@
>  extern char *progname;
>  
>  int fs_count;
> +int xfs_fs_count;
>  struct fs_path *fs_table;
>  struct fs_path *fs_path;
>  
> @@ -138,7 +139,16 @@ fs_table_insert(
>  		goto out_norealloc;
>  	fs_table = tmp_fs_table;
>  
> -	fs_path = &fs_table[fs_count];
> +	/* Put foreign filesystems at the end, xfs filesystems at the front */
> +	if (flags & FS_FOREIGN || fs_count == 0) {
> +		fs_path = &fs_table[fs_count];
> +	} else {
> +		/* move foreign fs entries down, insert new one just before */
> +		memmove(&fs_table[xfs_fs_count + 1], &fs_table[xfs_fs_count],
> +			sizeof(fs_path_t)*(fs_count - xfs_fs_count));
> +		fs_path = &fs_table[xfs_fs_count];
> +		xfs_fs_count++;
> +	}
>  	fs_path->fs_dir = dir;
>  	fs_path->fs_prid = prid;
>  	fs_path->fs_flags = flags;
> diff --git a/quota/path.c b/quota/path.c
> index a623d25..01ccab4 100644
> --- a/quota/path.c
> +++ b/quota/path.c
> @@ -75,9 +75,15 @@ static int
>  pathlist_f(void)
>  {
>  	int		i;
> +	struct fs_path	*path;
>  
> -	for (i = 0; i < fs_count; i++)
> -		printpath(&fs_table[i], i, 1, &fs_table[i] == fs_path);
> +	for (i = 0; i < fs_count; i++) {
> +		path = &fs_table[i];
> +		/* Table is ordered xfs first, then foreign */
> +		if (path->fs_flags & FS_FOREIGN && !foreign_allowed)
> +			break;
> +		printpath(path, i, 1, path == fs_path);
> +	}
>  	return 0;
>  }
>  
> @@ -87,9 +93,14 @@ print_f(
>  	char		**argv)
>  {
>  	int		i;
> +	struct fs_path	*path;
>  
> -	for (i = 0; i < fs_count; i++)
> -		printpath(&fs_table[i], i, 0, 0);
> +	for (i = 0; i < fs_count; i++) {
> +		path = &fs_table[i];
> +		if (path->fs_flags & FS_FOREIGN && !foreign_allowed)
> +			break;
> +		printpath(path, i, 0, 0);
> +	}
>  	return 0;
>  }
>  
> @@ -99,6 +110,7 @@ path_f(
>  	char		**argv)
>  {
>  	int	i;
> +	int	max = foreign_allowed ? fs_count : xfs_fs_count;
>  
>  	if (fs_count == 0) {
>  		printf(_("No paths are available\n"));
> @@ -109,9 +121,9 @@ path_f(
>  		return pathlist_f();
>  
>  	i = atoi(argv[1]);
> -	if (i < 0 || i >= fs_count) {
> +	if (i < 0 || i >= max) {
>  		printf(_("value %d is out of range (0-%d)\n"),
> -			i, fs_count-1);
> +			i, max - 1);
>  	} else {
>  		fs_path = &fs_table[i];
>  		pathlist_f();
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
