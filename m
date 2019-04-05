Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34974 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbfDEOTA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 10:19:00 -0400
Subject: Re: [PATCH 44/36] xfs_db: metadump should handle symlinks properly
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193750.GH1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cdd4b217-f914-c944-0fda-9a81245206e1@sandeen.net>
Date: Fri, 5 Apr 2019 09:18:58 -0500
MIME-Version: 1.0
In-Reply-To: <20190320193750.GH1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/19 2:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remote symlink target blocks are multi-fsb objects on XFS v5 filesystems
> because we only write one rmt header per data fork extent.  For fs
> blocksize >= 2048 we never have more than one block and therefore nobody
> noticed, but for blocksize == 1024 this is definitely not true and leads
> to metadump spraying error messages about symlink block crc errors.
> Therefore, reformulate the symlink metadump into a multi-fsb dump
> function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, thanks for the patient re-explanation on IRC, and after a bit of testing,
even with fragmented multi-block symlinks, this does work fine.

I'd kind of like to fully understand why, with a single map, it handles
fragmented links, but for now, moving on ... 

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'd like to change the struct bbmap initialization to outside the
declaration, though, to be more in line with other similar code.
Any heartburn over that?

	map.nmaps = 1;
	map.b[0].bm_bn = XFS_FSB_TO_DADDR(mp, s);
	map.b[0].bm_len = XFS_FSB_TO_BB(mp, c);



> ---
>  db/metadump.c |   48 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 41 insertions(+), 7 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 57216291..e0dd463f 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1638,11 +1638,39 @@ process_dir_data_block(
>  	}
>  }
>  
> -static void
> +static int
>  process_symlink_block(
> -	char			*block)
> +	xfs_fileoff_t	o,
> +	xfs_fsblock_t	s,
> +	xfs_filblks_t	c,
> +	typnm_t		btype,
> +	xfs_fileoff_t	last)
>  {
> -	char *link = block;
> +	struct bbmap	map = {
> +		.nmaps	= 1,
> +		.b	= {
> +			{
> +				.bm_bn = XFS_FSB_TO_DADDR(mp, s),
> +				.bm_len = XFS_FSB_TO_BB(mp, c),
> +			}
> +		},
> +	};
> +	char		*link;
> +	int		ret = 0;
> +
> +	push_cur();
> +	set_cur(&typtab[btype], 0, 0, DB_RING_IGN, &map);
> +	if (!iocur_top->data) {
> +		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
> +		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
> +
> +		print_warning("cannot read %s block %u/%u (%llu)",
> +				typtab[btype].name, agno, agbno, s);
> +		if (stop_on_read_error)
> +			ret = -1;
> +		goto out_pop;
> +	}
> +	link = iocur_top->data;
>  
>  	if (xfs_sb_version_hascrc(&(mp)->m_sb))
>  		link += sizeof(struct xfs_dsymlink_hdr);
> @@ -1660,6 +1688,12 @@ process_symlink_block(
>  		if (zlen < mp->m_sb.sb_blocksize)
>  			memset(link + linklen, 0, zlen);
>  	}
> +
> +	iocur_top->need_crc = 1;
> +	ret = write_buf(iocur_top);
> +out_pop:
> +	pop_cur();
> +	return ret;
>  }
>  
>  #define MAX_REMOTE_VALS		4095
> @@ -1879,10 +1913,6 @@ process_single_fsb_objects(
>  			}
>  			iocur_top->need_crc = 1;
>  			break;
> -		case TYP_SYMLINK:
> -			process_symlink_block(dp);
> -			iocur_top->need_crc = 1;
> -			break;
>  		case TYP_ATTR:
>  			process_attr_block(dp, o);
>  			iocur_top->need_crc = 1;
> @@ -1986,6 +2016,8 @@ is_multi_fsb_object(
>  {
>  	if (btype == TYP_DIR2 && mp->m_dir_geo->fsbcount > 1)
>  		return true;
> +	if (btype == TYP_SYMLINK)
> +		return true;
>  	return false;
>  }
>  
> @@ -2000,6 +2032,8 @@ process_multi_fsb_objects(
>  	switch (btype) {
>  	case TYP_DIR2:
>  		return process_multi_fsb_dir(o, s, c, btype, last);
> +	case TYP_SYMLINK:
> +		return process_symlink_block(o, s, c, btype, last);
>  	default:
>  		print_warning("bad type for multi-fsb object %d", btype);
>  		return -EINVAL;
> 
