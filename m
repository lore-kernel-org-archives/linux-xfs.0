Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A6D27CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 12:50:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93819AC001
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 10:50:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ELZZfMk3UVEyC0xq for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 10:50:21 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfsprogs: populate fs table with xfs entries first,
	foreign entries last
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
	<1473866381-28975-2-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b49366ac-d277-a26f-1936-8e736d1c913c@sandeen.net>
Date: Wed, 14 Sep 2016 12:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <1473866381-28975-2-git-send-email-billodo@redhat.com>
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

On 9/14/16 10:19 AM, Bill O'Donnell wrote:
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
> same order as mtab entries.

Then, in functions which print all paths we can simply break at
the first foreign path if the -f switch is not specified.

> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  libxcmd/paths.c | 12 +++++++++++-
>  quota/path.c    | 21 ++++++++++++++++-----
>  2 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index 4158688..6363d40 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -34,6 +34,7 @@ extern char *progname;
>  int fs_count;
>  struct fs_path *fs_table;
>  struct fs_path *fs_path;
> +int		xfs_fs_count;

Since there are other changes to be made, this might be prettier:

 int fs_count;
+int xfs_fs_count;
 struct fs_path *fs_table;
 struct fs_path *fs_path;

>  char *mtab_file;
>  #define PROC_MOUNTS	"/proc/self/mounts"
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
> +		memmove(&fs_table[xfs_fs_count], &fs_table[xfs_fs_count - 1],
> +			sizeof(fs_path_t)*(fs_count - xfs_fs_count + 1));
> +		fs_path = &fs_table[xfs_fs_count];
> +		xfs_fs_count++;
> +	}
>  	fs_path->fs_dir = dir;
>  	fs_path->fs_prid = prid;
>  	fs_path->fs_flags = flags;

Ok, if we run this through valgrind it squawks.

==22170== Invalid read of size 8
==22170==    at 0x4A09C1C: memmove (mc_replace_strmem.c:1026)
==22170==    by 0x40B366: fs_table_insert (paths.c:149)
==22170==    by 0x40B58E: fs_table_initialise_mounts (paths.c:337)
==22170==    by 0x40BA8E: fs_table_initialise (paths.c:516)
==22170==    by 0x401CC4: main (init.c:180)
==22170==  Address 0x4c25cb8 is 8 bytes before a block of size 192 alloc'd
==22170==    at 0x4A06BE0: realloc (vg_replace_malloc.c:662)
==22170==    by 0x40B258: fs_table_insert (paths.c:137)
==22170==    by 0x40B58E: fs_table_initialise_mounts (paths.c:337)
==22170==    by 0x40BA8E: fs_table_initialise (paths.c:516)
==22170==    by 0x401CC4: main (init.c:180)
==22170==

As I mentioned, my quick suggestion may have had off-by-ones, and it did.
I think this should fix it, but *check it* ;)

        } else {
                /* move foreign fs entries down, insert new one just before */
-               memmove(&fs_table[xfs_fs_count], &fs_table[xfs_fs_count - 1],
-                       sizeof(fs_path_t)*(fs_count - xfs_fs_count + 1));
+               memmove(&fs_table[xfs_fs_count + 1], &fs_table[xfs_fs_count],
+                       sizeof(fs_path_t)*(fs_count - xfs_fs_count));
                fs_path = &fs_table[xfs_fs_count];
                xfs_fs_count++;
        }

> diff --git a/quota/path.c b/quota/path.c
> index a623d25..aa3d33e 100644
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
> @@ -98,7 +104,7 @@ path_f(
>  	int		argc,
>  	char		**argv)
>  {
> -	int	i;
> +	int		i;
>  
>  	if (fs_count == 0) {
>  		printf(_("No paths are available\n"));
> @@ -113,8 +119,13 @@ path_f(

Oops, I mentioned this to you as needed, but it's wrong, sorry.

Just drop this hunk, this is supposed to select path i, not iterate
over anything.  Sorry for mentioning it.

>  		printf(_("value %d is out of range (0-%d)\n"),
>  			i, fs_count-1);
>  	} else {
> -		fs_path = &fs_table[i];
> -		pathlist_f();
> +		for (i = 0; i < fs_count; i++) {
> +			fs_path = &fs_table[i];
> +			/* Table is ordered xfs first, then foreign */
> +			if (fs_path->fs_flags & FS_FOREIGN && !foreign_allowed)
> +				break;
> +			pathlist_f();
> +		}
>  	}
>  	return 0;
>  }
> 

Another oddity:

# quota/xfs_quota -x
xfs_quota> path
      Filesystem          Pathname
[000]     /home               /dev/mapper/vg_bp05-lv_home
 001      /mnt/test2          /dev/sdc1

<3 foreign paths are loaded into the table but ignored, no "-f">

xfs_quota> path 3
      Filesystem          Pathname
 000      /home               /dev/mapper/vg_bp05-lv_home
 001      /mnt/test2          /dev/sdc1

why did that work?

since we're always loading *all* paths in the table now, whatever checks
the limit is looking at fs_count not xfs_fs_count.  Sigh.

So something like this (need to add xfs_fs_count to path.h too)

diff --git a/quota/path.c b/quota/path.c
index bb28d82..546db52 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -105,6 +105,7 @@ path_f(
        char            **argv)
 {
        int             i;
+       int             max = foreign_allowed ? fs_count : xfs_fs_count;
 
        if (fs_count == 0) {
                printf(_("No paths are available\n"));
@@ -115,9 +116,9 @@ path_f(
                return pathlist_f();
 
        i = atoi(argv[1]);
-       if (i < 0 || i >= fs_count) {
+       if (i < 0 || i >= max) {
                printf(_("value %d is out of range (0-%d)\n"),
-                       i, fs_count-1);
+                       i, max - 1);
        } else {
                fs_path = &fs_table[i];
                pathlist_f();

and probably need to audit for any other use of "fs_count" ... hohum.
init_args_command for example, whatever the hell that thing does ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
