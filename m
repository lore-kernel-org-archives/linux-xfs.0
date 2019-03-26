Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbfCZQ7X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 12:59:23 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 19/36] mkfs: validate extent size hint parameters
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259754740.31886.13886644609473939892.stgit@magnolia>
Message-ID: <b440242a-5a9c-9772-0fc1-6becf6641221@sandeen.net>
Date: Tue, 26 Mar 2019 11:59:22 -0500
MIME-Version: 1.0
In-Reply-To: <155259754740.31886.13886644609473939892.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate extent and cow extent size hints that are passed to mkfs so
> that we avoid formatting a filesystem that will never mount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d1387ddf..9e1c6ec5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2202,6 +2202,66 @@ validate_rtextsize(
>  	ASSERT(cfg->rtextblocks);
>  }
>  
> +/* Validate the incoming extsize hint as if we were a file. */

I wonder why "as a file" when hints go on directories, right?

> +static void
> +validate_extsize_hint(
> +	struct xfs_mount	*mp,
> +	struct cli_params	*cli)
> +{
> +	xfs_failaddr_t		fa;
> +	bool			rt;
> +	uint16_t		flags = 0;
> +
> +	rt = (cli->fsx.fsx_xflags & XFS_DIFLAG_RTINHERIT);
> +
> +	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
> +		flags |= XFS_DIFLAG_EXTSIZE;

i.e. that feels like a weird switch from dir inherit flag to file extsize
flag, and I'm not sure why it's done here.

since the mkfs option essentially sets the inherit flag on the root inode,
(right?) I'd kind of expected this to be:

+	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
+		flags |= XFS_DIFLAG_EXTSZINHERIT;

(also surely fsx_xflags should contain XFLAGs? but that's another patch)

> +
> +	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
> +			flags);

and then:

+	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFDIR,
+			flags);

doesn't really matter to the validator, but conceptually this seems like a
root dir flag, not a "pretend it's a file!" flag, and seems more consistent.

> +	if (rt && fa == NULL)
> +		fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize,
> +				S_IFREG, flags | XFS_DIFLAG_REALTIME);

here too...?

We talked about this a little on irc but maybe you can remind me why you
switch to "it's a file!"

> +	if (fa == NULL)
> +		return;
> +

I wonder if there should be a comment here about keeping these calculations in
sync with xfs_inode_validate_extsize()?

> +	if (rt && mp->m_sb.sb_rextsize > 1)
> +		fprintf(stderr,
> +	_("illegal extent size hint %lld, must be less than %u and a multiple of %u.\n"),
> +				(long long)cli->fsx.fsx_extsize,
> +				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2),
> +				mp->m_sb.sb_rextsize);
> +	else
> +		fprintf(stderr,
> +	_("illegal extent size hint %lld, must be less than %u.\n"),
> +				(long long)cli->fsx.fsx_extsize,
> +				min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
> +	usage();
> +}
> +
> +/* Validate the incoming CoW extsize hint as if we were a file. */
> +static void
> +validate_cowextsize_hint(
> +	struct xfs_mount	*mp,
> +	struct cli_params	*cli)
> +{
> +	xfs_failaddr_t		fa;
> +	uint64_t		flags2 = 0;
> +
> +	if (cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE)
> +		flags2 |= XFS_DIFLAG2_COWEXTSIZE;

(here the flag is the same for dir or file, but same basic question)

> +	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
> +			S_IFREG, 0, flags2);
> +	if (fa == NULL)
> +		return;
> +
> +	fprintf(stderr,
> +_("illegal CoW extent size hint %lld, must be less than %u.\n"),
> +			(long long)cli->fsx.fsx_cowextsize,
> +			min(MAXEXTLEN, mp->m_sb.sb_agblocks / 2));
> +	usage();
> +}
> +
>  /*
>   * Validate the configured stripe geometry, or is none is specified, pull
>   * the configuration from the underlying device.
> @@ -3945,6 +4005,10 @@ main(
>  
>  	finish_superblock_setup(&cfg, mp, sbp);
>  
> +	/* Validate the extent size hints now that @mp is fully set up. */
> +	validate_extsize_hint(mp, &cli);
> +	validate_cowextsize_hint(mp, &cli);
> +
>  	/* Print the intended geometry of the fs. */
>  	if (!quiet || dry_run) {
>  		struct xfs_fsop_geom	geo;
> 
