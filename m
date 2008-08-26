Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 19:05:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7Q25M7o013596
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 19:05:23 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA13531 for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:06:45 +1000
Date: Tue, 26 Aug 2008 12:07:45 +1000
Subject: Re: REVIEW: xfs_metadump improvements
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.udjxj3hm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugg1i7vj3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.udjxj3hm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Ping?

(This is why no new xfsprogs tarball has been released yet Eric!)

On Mon, 30 Jun 2008 17:53:53 +1000, Barry Naujok <bnaujok@sgi.com> wrote:

> Based on what I found in xfs_check, I fixed up xfs_metadump in the
> same way.
>
> Also, I've increased the default maximum expected extent size for
> a directory, as in practice, 400 block extents for directory
> structures is not rare.
>
> --
>
> --- a/xfsprogs/db/metadump.c	2008-06-30 17:51:10.000000000 +1000
> +++ b/xfsprogs/db/metadump.c	2008-06-30 17:45:59.609352130 +1000
> @@ -27,6 +27,8 @@
>   #include "sig.h"
>   #include "xfs_metadump.h"
>
> +#define DEFAULT_MAX_EXT_SIZE	1000
> +
>   /* copy all metadata structures to/from a file */
>
>   static int	metadump_f(int argc, char **argv);
> @@ -58,7 +60,7 @@ static xfs_ino_t	cur_ino;
>
>   static int		show_progress = 0;
>   static int		stop_on_read_error = 0;
> -static int		max_extent_size = 20;
> +static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
>   static int		dont_obfuscate = 0;
>   static int		show_warnings = 0;
>   static int		progress_since_warning = 0;
> @@ -80,10 +82,10 @@ metadump_help(void)
>   " Options:\n"
>   "   -e -- Ignore read errors and keep going\n"
>   "   -g -- Display dump progress\n"
> -"   -m -- Specify max extent size in blocks to copy (default = 20
> blocks)\n"
> +"   -m -- Specify max extent size in blocks to copy (default = %d
> blocks)\n"
>   "   -o -- Don't obfuscate names and extended attributes\n"
>   "   -w -- Show warnings of bad metadata information\n"
> -"\n");
> +"\n", DEFAULT_MAX_EXT_SIZE);
>   }
>
>   static void
> @@ -186,22 +188,26 @@ scan_btree(
>   				typnm_t			btype,
>   				void			*arg))
>   {
> +	int		rval = 0;
> +
>   	push_cur();
>   	set_cur(&typtab[btype], XFS_AGB_TO_DADDR(mp, agno, agbno), blkbb,
>   			DB_RING_IGN, NULL);
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read %s block %u/%u", typtab[btype].name,
>   				agno, agbno);
> -		return !stop_on_read_error;
> +		rval = !stop_on_read_error;
> +		goto pop_out;
>   	}
>   	if (!write_buf(iocur_top))
> -		return 0;
> +		goto pop_out;
>
>   	if (!(*func)(iocur_top->data, agno, agbno, level - 1, btype, arg))
> -		return 0;
> -
> +		goto pop_out;
> +	rval = 1;
> +pop_out:
>   	pop_cur();
> -	return 1;
> +	return rval;
>   }
>
>   /* free space tree copy routines */
> @@ -949,8 +955,10 @@ process_bmbt_reclist(
>   		if (iocur_top->data == NULL) {
>   			print_warning("cannot read %s block %u/%u (%llu)",
>   					typtab[btype].name, agno, agbno, s);
> -			if (stop_on_read_error)
> +			if (stop_on_read_error) {
> +				pop_cur();
>   				return 0;
> +			}
>   		} else {
>   			if (!dont_obfuscate)
>   			    switch (btype) {
> @@ -973,8 +981,10 @@ process_bmbt_reclist(
>
>   				default: ;
>   			    }
> -			if (!write_buf(iocur_top))
> +			if (!write_buf(iocur_top)) {
> +				pop_cur();
>   				return 0;
> +			}
>   		}
>   		pop_cur();
>   	}
> @@ -1238,6 +1248,7 @@ copy_inode_chunk(
>   	int			off;
>   	xfs_agblock_t		agbno;
>   	int			i;
> +	int			rval = 0;
>
>   	agino = be32_to_cpu(rp->ir_startino);
>   	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> @@ -1258,7 +1269,8 @@ copy_inode_chunk(
>   			DB_RING_IGN, NULL);
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read inode block %u/%u", agno, agbno);
> -		return !stop_on_read_error;
> +		rval = !stop_on_read_error;
> +		goto pop_out;
>   	}
>
>   	/*
> @@ -1291,11 +1303,11 @@ copy_inode_chunk(
>   				((off + i) << mp->m_sb.sb_inodelog));
>
>   		if (!process_inode(agno, agino + i, dip))
> -			return 0;
> +			goto pop_out;
>   	}
>   skip_processing:
>   	if (!write_buf(iocur_top))
> -		return 0;
> +		goto pop_out;
>
>   	inodes_copied += XFS_INODES_PER_CHUNK;
>
> @@ -1303,10 +1315,10 @@ skip_processing:
>   		print_progress("Copied %u of %u inodes (%u of %u AGs)",
>   				inodes_copied, mp->m_sb.sb_icount, agno,
>   				mp->m_sb.sb_agcount);
> -
> +	rval = 1;
> +pop_out:
>   	pop_cur();
> -
> -	return 1;
> +	return rval;
>   }
>
>   static int
> @@ -1401,61 +1413,66 @@ scan_ag(
>   {
>   	xfs_agf_t	*agf;
>   	xfs_agi_t	*agi;
> +	int		stack_count = 0;
> +	int		rval = 0;
>
>   	/* copy the superblock of the AG */
>   	push_cur();
> +	stack_count++;
>   	set_cur(&typtab[TYP_SB], XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>   			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>   	if (!iocur_top->data) {
>   		print_warning("cannot read superblock for ag %u", agno);
>   		if (stop_on_read_error)
> -			return 0;
> +			goto pop_out;
>   	} else {
>   		if (!write_buf(iocur_top))
> -			return 0;
> +			goto pop_out;
>   	}
>
>   	/* copy the AG free space btree root */
>   	push_cur();
> +	stack_count++;
>   	set_cur(&typtab[TYP_AGF], XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
>   			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>   	agf = iocur_top->data;
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read agf block for ag %u", agno);
>   		if (stop_on_read_error)
> -			return 0;
> +			goto pop_out;
>   	} else {
>   		if (!write_buf(iocur_top))
> -			return 0;
> +			goto pop_out;
>   	}
>
>   	/* copy the AG inode btree root */
>   	push_cur();
> +	stack_count++;
>   	set_cur(&typtab[TYP_AGI], XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
>   			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>   	agi = iocur_top->data;
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read agi block for ag %u", agno);
>   		if (stop_on_read_error)
> -			return 0;
> +			goto pop_out;
>   	} else {
>   		if (!write_buf(iocur_top))
> -			return 0;
> +			goto pop_out;
>   	}
>
>   	/* copy the AG free list header */
>   	push_cur();
> +	stack_count++;
>   	set_cur(&typtab[TYP_AGFL], XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
>   			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read agfl block for ag %u", agno);
>   		if (stop_on_read_error)
> -			return 0;
> +			goto pop_out;
>   	} else {
>   		if (!write_buf(iocur_top))
> -			return 0;
> +			goto pop_out;
>   	}
> -	pop_cur();
>
>   	/* copy AG free space btrees */
>   	if (agf) {
> @@ -1463,22 +1480,21 @@ scan_ag(
>   			print_progress("Copying free space trees of AG %u",
>   					agno);
>   		if (!copy_free_bno_btree(agno, agf))
> -			return 0;
> +			goto pop_out;
>   		if (!copy_free_cnt_btree(agno, agf))
> -			return 0;
> +			goto pop_out;
>   	}
>
>   	/* copy inode btrees and the inodes and their associated metadata */
>   	if (agi) {
>   		if (!copy_inodes(agno, agi))
> -			return 0;
> +			goto pop_out;
>   	}
> -
> -	pop_cur();
> -	pop_cur();
> -	pop_cur();
> -
> -	return 1;
> +	rval = 1;
> +pop_out:
> +	while (stack_count--)
> +		pop_cur();
> +	return rval;
>   }
>
>   static int
> @@ -1492,6 +1508,7 @@ copy_ino(
>   	xfs_dinode_t		*dip;
>   	xfs_dinode_core_t	tdic;
>   	int			offset;
> +	int			rval = 0;
>
>   	if (ino == 0)
>   		return 1;
> @@ -1515,7 +1532,8 @@ copy_ino(
>   	if (iocur_top->data == NULL) {
>   		print_warning("cannot read %s inode %lld",
>   				typtab[itype].name, (long long)ino);
> -		return !stop_on_read_error;
> +		rval = !stop_on_read_error;
> +		goto pop_out;
>   	}
>   	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>
> @@ -1524,7 +1542,10 @@ copy_ino(
>   	memcpy(&dip->di_core, &tdic, sizeof(xfs_dinode_core_t));
>
>   	cur_ino = ino;
> -	return process_inode_data(dip, itype);
> +	rval = process_inode_data(dip, itype);
> +pop_out:
> +	pop_cur();
> +	return rval;
>   }
>
>
> @@ -1553,6 +1574,7 @@ copy_log(void)
>   	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>   			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>   	if (iocur_top->data == NULL) {
> +		pop_cur();
>   		print_warning("cannot read log");
>   		return !stop_on_read_error;
>   	}
