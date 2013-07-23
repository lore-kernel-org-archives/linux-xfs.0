Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70BCB7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 17:30:11 -0500 (CDT)
Date: Tue, 23 Jul 2013 17:30:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/48] libxfs: add version 3 inode support
Message-ID: <20130723223007.GN3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

On Fri, Jun 07, 2013 at 10:25:30AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Header from folded patch 'debug':
> 
> xfs_quota: fix report command parsing
> 
> 
> The report command line needs to be parsed as a whole not as
> individual elements - report_f() is set up to do this correctly.
> When treated as non-global command line, the report function is
> called once for each command line arg, resulting in reports being
> issued multiple times.
> 
> Set the command to be a global command so that it is only called
> once.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This header looks like it came from an unrelated patch.

Looks like this patch mostly corresponds to commit 93848a999cf.
There is also:

* changes to printing i4_count, i8_count, and size fields for shortform directories
* changes to start filling in v3 inode specific fields
* make logprint stop asserting on v3 inodes
* add support for creating v3 realtime bitmap, realtime summary, and root_dir inodes

There are a couple of issues below:
  
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index feb4a4e..57fbae2 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -146,6 +146,7 @@ xfs_ialloc_inode_init(
>  	int			version;
>  	int			i, j;
>  	xfs_daddr_t		d;
> +	xfs_ino_t		ino = 0;
>  
>  	/*
>  	 * Loop over the new block(s), filling in the inodes.
> @@ -169,8 +170,18 @@ xfs_ialloc_inode_init(
>  	 * the new inode format, then use the new inode version.  Otherwise
>  	 * use the old version so that old kernels will continue to be
>  	 * able to use the file system.
> +	 *
> +	 * For v3 inodes, we also need to write the inode number into the inode,
> +	 * so calculate the first inode number of the chunk here as
> +	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
> +	 * cluster boundaries and so cannot be used in the cluster buffer loop
> +	 * below.
>  	 */
> -	if (xfs_sb_version_hasnlink(&mp->m_sb))
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		version = 3;
> +		ino = XFS_AGINO_TO_INO(mp, agno,
> +				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
> +	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
>  		version = 2;
>  	else
>  		version = 1;
> @@ -196,13 +207,21 @@ xfs_ialloc_inode_init(
>  		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);

There is a section in commit 93848a999cf where the above line is
modified to this:

xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));

I suggest you pull that in here too.

> diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
> index f9f792c..d6513b9 100644
> --- a/libxfs/xfs_inode.c
> +++ b/libxfs/xfs_inode.c
> @@ -572,6 +572,17 @@ xfs_dinode_from_disk(
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  	to->di_gen	= be32_to_cpu(from->di_gen);
> +
> +	if (to->di_version == 3) {
> +		to->di_changecount = be64_to_cpu(from->di_changecount);
> +		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
> +		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
> +		to->di_flags2 = be64_to_cpu(from->di_flags2);
> +		to->di_ino = be64_to_cpu(from->di_ino);
> +		to->di_lsn = be64_to_cpu(from->di_lsn);
> +		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> +		platform_uuid_copy(&to->di_uuid, &from->di_uuid);

You added a #define for uuid_copy in an earlier patch.  I suggest you use it if
you can.  There are several occurances.

Other than that this looks fine.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
