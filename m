Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21193C001DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 13:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjGTNNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 09:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjGTNNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 09:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5E22713
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 06:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A27A261A18
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 13:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFE3C433C7;
        Thu, 20 Jul 2023 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689858824;
        bh=bPKdiS6y3AyTPCgBHOV7k5iBpvraWCd19LDpeHxaeGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PddnQXUR6gUGvg5m6OfHJeCEn7o47Ts8sd+29MOxeqsgvqF0yIjEiD9dnn+8mQDpZ
         GvrjMkhkz13aVnRQ0CGskYT2z7mTymPy0V8x/AmJcQYyCQQQ44fTPMX6HnbOvY8Riq
         Ai8QbC1gPqRYm+H6C/X3lpBXFuS/p5brYk7PMgRPzTmxouQoOSK9dnxcb/94CT2ibL
         LCup7XZtKiGnhgqdqFrDogmuAnvfXtcjTvIH0VudWQY3b3sUcZFJ5jaMf5Su29HDji
         jB3pl99TeoGnF5Om1VVwi2JaX9Vd1yZhl8L3bwPCT+9368oS/t5PurhLqNap+IXfoz
         uAjYDQHKFSzng==
Date:   Thu, 20 Jul 2023 15:13:39 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 04/23] metadump: Define and use struct metadump
Message-ID: <20230720131339.ca63q66syb6xu77n@andromeda>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-5-chandan.babu@oracle.com>
 <t3g6GmmskavsAnU5IYLRqLbzltrRDQnLfrea3iH4lnem7TiqgeBQQjlwXfLRFr65p040b3o4hjILQKXuSc0hAg==@protonmail.internalid>
 <20230712181200.GS108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712181200.GS108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:12:00AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:57:47PM +0530, Chandan Babu R wrote:
> > This commit collects all state tracking variables in a new "struct metadump"
> > structure. This is done to collect all the global variables in one place
> > rather than having them spread across the file. A new structure member of type
> > "struct metadump_ops *" will be added by a future commit to support the two
> > versions of metadump.
> >
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> 
> FWIW I still don't see much point in wrapping the global variables in a
> global struct, but I don't feel like holding up the patchset:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> (...but ultimately it's up to Carlos to decide to accept or reject
> this.)

I don't mind either way (variables or struct), but, having everything within a
global struct just seem easier to my eyes tbh, as, at least for me,  it's easier
to identify some variable has a global scope just by seeing it within the
'global struct'.

Unless you have any big objection to leave it as a struct (as I can see you
don't), this seems totally fine to me.


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> --D
> 
> > ---
> >  db/metadump.c | 459 +++++++++++++++++++++++++++-----------------------
> >  1 file changed, 244 insertions(+), 215 deletions(-)
> >
> > diff --git a/db/metadump.c b/db/metadump.c
> > index 8b33fbfb..e5479b56 100644
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -40,25 +40,27 @@ static const cmdinfo_t	metadump_cmd =
> >  		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
> >  		N_("dump metadata to a file"), metadump_help };
> >
> > -static FILE		*outf;		/* metadump file */
> > -
> > -static xfs_metablock_t 	*metablock;	/* header + index + buffers */
> > -static __be64		*block_index;
> > -static char		*block_buffer;
> > -
> > -static int		num_indices;
> > -static int		cur_index;
> > -
> > -static xfs_ino_t	cur_ino;
> > -
> > -static bool		show_progress = false;
> > -static bool		stop_on_read_error = false;
> > -static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
> > -static bool		obfuscate = true;
> > -static bool		zero_stale_data = true;
> > -static bool		show_warnings = false;
> > -static bool		progress_since_warning = false;
> > -static bool		stdout_metadump;
> > +static struct metadump {
> > +	int			version;
> > +	bool			show_progress;
> > +	bool			stop_on_read_error;
> > +	int			max_extent_size;
> > +	bool			show_warnings;
> > +	bool			obfuscate;
> > +	bool			zero_stale_data;
> > +	bool			progress_since_warning;
> > +	bool			dirty_log;
> > +	bool			stdout_metadump;
> > +	xfs_ino_t		cur_ino;
> > +	/* Metadump file */
> > +	FILE			*outf;
> > +	/* header + index + buffers */
> > +	struct xfs_metablock	*metablock;
> > +	__be64			*block_index;
> > +	char			*block_buffer;
> > +	int			num_indices;
> > +	int			cur_index;
> > +} metadump;
> >
> >  void
> >  metadump_init(void)
> > @@ -98,9 +100,9 @@ print_warning(const char *fmt, ...)
> >  	va_end(ap);
> >  	buf[sizeof(buf)-1] = '\0';
> >
> > -	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
> > -			progname, buf);
> > -	progress_since_warning = false;
> > +	fprintf(stderr, "%s%s: %s\n",
> > +		metadump.progress_since_warning ? "\n" : "", progname, buf);
> > +	metadump.progress_since_warning = false;
> >  }
> >
> >  static void
> > @@ -118,10 +120,10 @@ print_progress(const char *fmt, ...)
> >  	va_end(ap);
> >  	buf[sizeof(buf)-1] = '\0';
> >
> > -	f = stdout_metadump ? stderr : stdout;
> > +	f = metadump.stdout_metadump ? stderr : stdout;
> >  	fprintf(f, "\r%-59s", buf);
> >  	fflush(f);
> > -	progress_since_warning = true;
> > +	metadump.progress_since_warning = true;
> >  }
> >
> >  /*
> > @@ -136,17 +138,19 @@ print_progress(const char *fmt, ...)
> >  static int
> >  write_index(void)
> >  {
> > +	struct xfs_metablock *metablock = metadump.metablock;
> >  	/*
> >  	 * write index block and following data blocks (streaming)
> >  	 */
> > -	metablock->mb_count = cpu_to_be16(cur_index);
> > -	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
> > +	metablock->mb_count = cpu_to_be16(metadump.cur_index);
> > +	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
> > +			metadump.outf) != 1) {
> >  		print_warning("error writing to target file");
> >  		return -1;
> >  	}
> >
> > -	memset(block_index, 0, num_indices * sizeof(__be64));
> > -	cur_index = 0;
> > +	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
> > +	metadump.cur_index = 0;
> >  	return 0;
> >  }
> >
> > @@ -163,9 +167,10 @@ write_buf_segment(
> >  	int		ret;
> >
> >  	for (i = 0; i < len; i++, off++, data += BBSIZE) {
> > -		block_index[cur_index] = cpu_to_be64(off);
> > -		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
> > -		if (++cur_index == num_indices) {
> > +		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
> > +		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
> > +			data, BBSIZE);
> > +		if (++metadump.cur_index == metadump.num_indices) {
> >  			ret = write_index();
> >  			if (ret)
> >  				return -EIO;
> > @@ -388,11 +393,11 @@ scan_btree(
> >  	if (iocur_top->data == NULL) {
> >  		print_warning("cannot read %s block %u/%u", typtab[btype].name,
> >  				agno, agbno);
> > -		rval = !stop_on_read_error;
> > +		rval = !metadump.stop_on_read_error;
> >  		goto pop_out;
> >  	}
> >
> > -	if (zero_stale_data) {
> > +	if (metadump.zero_stale_data) {
> >  		zero_btree_block(iocur_top->data, btype);
> >  		iocur_top->need_crc = 1;
> >  	}
> > @@ -446,7 +451,7 @@ scanfunc_freesp(
> >
> >  	numrecs = be16_to_cpu(block->bb_numrecs);
> >  	if (numrecs > mp->m_alloc_mxr[1]) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs (%u) in %s block %u/%u",
> >  				numrecs, typtab[btype].name, agno, agbno);
> >  		return 1;
> > @@ -455,7 +460,7 @@ scanfunc_freesp(
> >  	pp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
> >  	for (i = 0; i < numrecs; i++) {
> >  		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> >  					"in %s block %u/%u",
> >  					agno, be32_to_cpu(pp[i]),
> > @@ -482,13 +487,13 @@ copy_free_bno_btree(
> >
> >  	/* validate root and levels before processing the tree */
> >  	if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid block number (%u) in bnobt "
> >  					"root in agf %u", root, agno);
> >  		return 1;
> >  	}
> >  	if (levels > mp->m_alloc_maxlevels) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in bnobt root "
> >  					"in agf %u", levels, agno);
> >  		return 1;
> > @@ -510,13 +515,13 @@ copy_free_cnt_btree(
> >
> >  	/* validate root and levels before processing the tree */
> >  	if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid block number (%u) in cntbt "
> >  					"root in agf %u", root, agno);
> >  		return 1;
> >  	}
> >  	if (levels > mp->m_alloc_maxlevels) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in cntbt root "
> >  					"in agf %u", levels, agno);
> >  		return 1;
> > @@ -543,7 +548,7 @@ scanfunc_rmapbt(
> >
> >  	numrecs = be16_to_cpu(block->bb_numrecs);
> >  	if (numrecs > mp->m_rmap_mxr[1]) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs (%u) in %s block %u/%u",
> >  				numrecs, typtab[btype].name, agno, agbno);
> >  		return 1;
> > @@ -552,7 +557,7 @@ scanfunc_rmapbt(
> >  	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
> >  	for (i = 0; i < numrecs; i++) {
> >  		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> >  					"in %s block %u/%u",
> >  					agno, be32_to_cpu(pp[i]),
> > @@ -582,13 +587,13 @@ copy_rmap_btree(
> >
> >  	/* validate root and levels before processing the tree */
> >  	if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid block number (%u) in rmapbt "
> >  					"root in agf %u", root, agno);
> >  		return 1;
> >  	}
> >  	if (levels > mp->m_rmap_maxlevels) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in rmapbt root "
> >  					"in agf %u", levels, agno);
> >  		return 1;
> > @@ -615,7 +620,7 @@ scanfunc_refcntbt(
> >
> >  	numrecs = be16_to_cpu(block->bb_numrecs);
> >  	if (numrecs > mp->m_refc_mxr[1]) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs (%u) in %s block %u/%u",
> >  				numrecs, typtab[btype].name, agno, agbno);
> >  		return 1;
> > @@ -624,7 +629,7 @@ scanfunc_refcntbt(
> >  	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
> >  	for (i = 0; i < numrecs; i++) {
> >  		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> >  					"in %s block %u/%u",
> >  					agno, be32_to_cpu(pp[i]),
> > @@ -654,13 +659,13 @@ copy_refcount_btree(
> >
> >  	/* validate root and levels before processing the tree */
> >  	if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid block number (%u) in refcntbt "
> >  					"root in agf %u", root, agno);
> >  		return 1;
> >  	}
> >  	if (levels > mp->m_refc_maxlevels) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in refcntbt root "
> >  					"in agf %u", levels, agno);
> >  		return 1;
> > @@ -785,7 +790,8 @@ in_lost_found(
> >  	/* Record the "lost+found" inode if we haven't done so already */
> >
> >  	ASSERT(ino != 0);
> > -	if (!orphanage_ino && is_orphanage_dir(mp, cur_ino, namelen, name))
> > +	if (!orphanage_ino && is_orphanage_dir(mp, metadump.cur_ino, namelen,
> > +						name))
> >  		orphanage_ino = ino;
> >
> >  	/* We don't obfuscate the "lost+found" directory itself */
> > @@ -795,7 +801,7 @@ in_lost_found(
> >
> >  	/* Most files aren't in "lost+found" at all */
> >
> > -	if (cur_ino != orphanage_ino)
> > +	if (metadump.cur_ino != orphanage_ino)
> >  		return 0;
> >
> >  	/*
> > @@ -1219,7 +1225,7 @@ generate_obfuscated_name(
> >  		print_warning("duplicate name for inode %llu "
> >  				"in dir inode %llu\n",
> >  			(unsigned long long) ino,
> > -			(unsigned long long) cur_ino);
> > +			(unsigned long long) metadump.cur_ino);
> >  		return;
> >  	}
> >
> > @@ -1229,7 +1235,7 @@ generate_obfuscated_name(
> >  		print_warning("unable to record name for inode %llu "
> >  				"in dir inode %llu\n",
> >  			(unsigned long long) ino,
> > -			(unsigned long long) cur_ino);
> > +			(unsigned long long) metadump.cur_ino);
> >  }
> >
> >  static void
> > @@ -1245,9 +1251,9 @@ process_sf_dir(
> >  	ino_dir_size = be64_to_cpu(dip->di_size);
> >  	if (ino_dir_size > XFS_DFORK_DSIZE(dip, mp)) {
> >  		ino_dir_size = XFS_DFORK_DSIZE(dip, mp);
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid size in dir inode %llu",
> > -					(long long)cur_ino);
> > +					(long long)metadump.cur_ino);
> >  	}
> >
> >  	sfep = xfs_dir2_sf_firstentry(sfp);
> > @@ -1261,9 +1267,9 @@ process_sf_dir(
> >  		int	namelen = sfep->namelen;
> >
> >  		if (namelen == 0) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("zero length entry in dir inode "
> > -						"%llu", (long long)cur_ino);
> > +					"%llu", (long long)metadump.cur_ino);
> >  			if (i != sfp->count - 1)
> >  				break;
> >  			namelen = ino_dir_size - ((char *)&sfep->name[0] -
> > @@ -1271,16 +1277,17 @@ process_sf_dir(
> >  		} else if ((char *)sfep - (char *)sfp +
> >  				libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen) >
> >  				ino_dir_size) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("entry length in dir inode %llu "
> > -					"overflows space", (long long)cur_ino);
> > +					"overflows space",
> > +					(long long)metadump.cur_ino);
> >  			if (i != sfp->count - 1)
> >  				break;
> >  			namelen = ino_dir_size - ((char *)&sfep->name[0] -
> >  					 (char *)sfp);
> >  		}
> >
> > -		if (obfuscate)
> > +		if (metadump.obfuscate)
> >  			generate_obfuscated_name(
> >  					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
> >  					 namelen, &sfep->name[0]);
> > @@ -1290,7 +1297,8 @@ process_sf_dir(
> >  	}
> >
> >  	/* zero stale data in rest of space in data fork, if any */
> > -	if (zero_stale_data && (ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
> > +	if (metadump.zero_stale_data &&
> > +		(ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
> >  		memset(sfep, 0, XFS_DFORK_DSIZE(dip, mp) - ino_dir_size);
> >  }
> >
> > @@ -1346,18 +1354,18 @@ process_sf_symlink(
> >
> >  	len = be64_to_cpu(dip->di_size);
> >  	if (len > XFS_DFORK_DSIZE(dip, mp)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid size (%d) in symlink inode %llu",
> > -					len, (long long)cur_ino);
> > +					len, (long long)metadump.cur_ino);
> >  		len = XFS_DFORK_DSIZE(dip, mp);
> >  	}
> >
> >  	buf = (char *)XFS_DFORK_DPTR(dip);
> > -	if (obfuscate)
> > +	if (metadump.obfuscate)
> >  		obfuscate_path_components(buf, len);
> >
> >  	/* zero stale data in rest of space in data fork, if any */
> > -	if (zero_stale_data && len < XFS_DFORK_DSIZE(dip, mp))
> > +	if (metadump.zero_stale_data && len < XFS_DFORK_DSIZE(dip, mp))
> >  		memset(&buf[len], 0, XFS_DFORK_DSIZE(dip, mp) - len);
> >  }
> >
> > @@ -1382,9 +1390,9 @@ process_sf_attr(
> >  	ino_attr_size = be16_to_cpu(asfp->hdr.totsize);
> >  	if (ino_attr_size > XFS_DFORK_ASIZE(dip, mp)) {
> >  		ino_attr_size = XFS_DFORK_ASIZE(dip, mp);
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid attr size in inode %llu",
> > -					(long long)cur_ino);
> > +					(long long)metadump.cur_ino);
> >  	}
> >
> >  	asfep = &asfp->list[0];
> > @@ -1394,19 +1402,20 @@ process_sf_attr(
> >  		int	namelen = asfep->namelen;
> >
> >  		if (namelen == 0) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("zero length attr entry in inode "
> > -						"%llu", (long long)cur_ino);
> > +					"%llu", (long long)metadump.cur_ino);
> >  			break;
> >  		} else if ((char *)asfep - (char *)asfp +
> >  				xfs_attr_sf_entsize(asfep) > ino_attr_size) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("attr entry length in inode %llu "
> > -					"overflows space", (long long)cur_ino);
> > +					"overflows space",
> > +					(long long)metadump.cur_ino);
> >  			break;
> >  		}
> >
> > -		if (obfuscate) {
> > +		if (metadump.obfuscate) {
> >  			generate_obfuscated_name(0, asfep->namelen,
> >  						 &asfep->nameval[0]);
> >  			memset(&asfep->nameval[asfep->namelen], 'v',
> > @@ -1418,7 +1427,8 @@ process_sf_attr(
> >  	}
> >
> >  	/* zero stale data in rest of space in attr fork, if any */
> > -	if (zero_stale_data && (ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
> > +	if (metadump.zero_stale_data &&
> > +		(ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
> >  		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
> >  }
> >
> > @@ -1429,7 +1439,7 @@ process_dir_free_block(
> >  	struct xfs_dir2_free		*free;
> >  	struct xfs_dir3_icfree_hdr	freehdr;
> >
> > -	if (!zero_stale_data)
> > +	if (!metadump.zero_stale_data)
> >  		return;
> >
> >  	free = (struct xfs_dir2_free *)block;
> > @@ -1451,10 +1461,10 @@ process_dir_free_block(
> >  		break;
> >  	}
> >  	default:
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid magic in dir inode %llu "
> >  				      "free block",
> > -				      (unsigned long long)cur_ino);
> > +				      (unsigned long long)metadump.cur_ino);
> >  		break;
> >  	}
> >  }
> > @@ -1466,7 +1476,7 @@ process_dir_leaf_block(
> >  	struct xfs_dir2_leaf		*leaf;
> >  	struct xfs_dir3_icleaf_hdr	leafhdr;
> >
> > -	if (!zero_stale_data)
> > +	if (!metadump.zero_stale_data)
> >  		return;
> >
> >  	/* Yes, this works for dir2 & dir3.  Difference is padding. */
> > @@ -1549,10 +1559,10 @@ process_dir_data_block(
> >  	}
> >
> >  	if (be32_to_cpu(datahdr->magic) != wantmagic) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning(
> >  		"invalid magic in dir inode %llu block %ld",
> > -					(unsigned long long)cur_ino, (long)offset);
> > +		(unsigned long long)metadump.cur_ino, (long)offset);
> >  		return;
> >  	}
> >
> > @@ -1572,10 +1582,10 @@ process_dir_data_block(
> >  			if (dir_offset + free_length > end_of_data ||
> >  			    !free_length ||
> >  			    (free_length & (XFS_DIR2_DATA_ALIGN - 1))) {
> > -				if (show_warnings)
> > +				if (metadump.show_warnings)
> >  					print_warning(
> >  			"invalid length for dir free space in inode %llu",
> > -						(long long)cur_ino);
> > +						(long long)metadump.cur_ino);
> >  				return;
> >  			}
> >  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
> > @@ -1588,7 +1598,7 @@ process_dir_data_block(
> >  			 * actually at a variable offset, so zeroing &dup->tag
> >  			 * is zeroing the free space in between
> >  			 */
> > -			if (zero_stale_data) {
> > +			if (metadump.zero_stale_data) {
> >  				int zlen = free_length -
> >  						sizeof(xfs_dir2_data_unused_t);
> >
> > @@ -1606,23 +1616,23 @@ process_dir_data_block(
> >
> >  		if (dir_offset + length > end_of_data ||
> >  		    ptr + length > endptr) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning(
> >  			"invalid length for dir entry name in inode %llu",
> > -					(long long)cur_ino);
> > +					(long long)metadump.cur_ino);
> >  			return;
> >  		}
> >  		if (be16_to_cpu(*libxfs_dir2_data_entry_tag_p(mp, dep)) !=
> >  				dir_offset)
> >  			return;
> >
> > -		if (obfuscate)
> > +		if (metadump.obfuscate)
> >  			generate_obfuscated_name(be64_to_cpu(dep->inumber),
> >  					 dep->namelen, &dep->name[0]);
> >  		dir_offset += length;
> >  		ptr += length;
> >  		/* Zero the unused space after name, up to the tag */
> > -		if (zero_stale_data) {
> > +		if (metadump.zero_stale_data) {
> >  			/* 1 byte for ftype; don't bother with conditional */
> >  			int zlen =
> >  				(char *)libxfs_dir2_data_entry_tag_p(mp, dep) -
> > @@ -1658,7 +1668,7 @@ process_symlink_block(
> >
> >  		print_warning("cannot read %s block %u/%u (%llu)",
> >  				typtab[btype].name, agno, agbno, s);
> > -		rval = !stop_on_read_error;
> > +		rval = !metadump.stop_on_read_error;
> >  		goto out_pop;
> >  	}
> >  	link = iocur_top->data;
> > @@ -1666,10 +1676,10 @@ process_symlink_block(
> >  	if (xfs_has_crc((mp)))
> >  		link += sizeof(struct xfs_dsymlink_hdr);
> >
> > -	if (obfuscate)
> > +	if (metadump.obfuscate)
> >  		obfuscate_path_components(link, XFS_SYMLINK_BUF_SPACE(mp,
> >  							mp->m_sb.sb_blocksize));
> > -	if (zero_stale_data) {
> > +	if (metadump.zero_stale_data) {
> >  		size_t	linklen, zlen;
> >
> >  		linklen = strlen(link);
> > @@ -1736,7 +1746,8 @@ process_attr_block(
> >  	if ((be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) &&
> >  	    (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR3_LEAF_MAGIC)) {
> >  		for (i = 0; i < attr_data.remote_val_count; i++) {
> > -			if (obfuscate && attr_data.remote_vals[i] == offset)
> > +			if (metadump.obfuscate &&
> > +			    attr_data.remote_vals[i] == offset)
> >  				/* Macros to handle both attr and attr3 */
> >  				memset(block +
> >  					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
> > @@ -1753,9 +1764,9 @@ process_attr_block(
> >  	    nentries * sizeof(xfs_attr_leaf_entry_t) +
> >  			xfs_attr3_leaf_hdr_size(leaf) >
> >  				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid attr count in inode %llu",
> > -					(long long)cur_ino);
> > +					(long long)metadump.cur_ino);
> >  		return;
> >  	}
> >
> > @@ -1770,22 +1781,22 @@ process_attr_block(
> >  			first_name = xfs_attr3_leaf_name(leaf, i);
> >
> >  		if (be16_to_cpu(entry->nameidx) > mp->m_sb.sb_blocksize) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning(
> >  				"invalid attr nameidx in inode %llu",
> > -						(long long)cur_ino);
> > +						(long long)metadump.cur_ino);
> >  			break;
> >  		}
> >  		if (entry->flags & XFS_ATTR_LOCAL) {
> >  			local = xfs_attr3_leaf_name_local(leaf, i);
> >  			if (local->namelen == 0) {
> > -				if (show_warnings)
> > +				if (metadump.show_warnings)
> >  					print_warning(
> >  				"zero length for attr name in inode %llu",
> > -						(long long)cur_ino);
> > +						(long long)metadump.cur_ino);
> >  				break;
> >  			}
> > -			if (obfuscate) {
> > +			if (metadump.obfuscate) {
> >  				generate_obfuscated_name(0, local->namelen,
> >  					&local->nameval[0]);
> >  				memset(&local->nameval[local->namelen], 'v',
> > @@ -1797,18 +1808,18 @@ process_attr_block(
> >  			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
> >  				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
> >  				 nlen + vlen);
> > -			if (zero_stale_data)
> > +			if (metadump.zero_stale_data)
> >  				memset(&local->nameval[nlen + vlen], 0, zlen);
> >  		} else {
> >  			remote = xfs_attr3_leaf_name_remote(leaf, i);
> >  			if (remote->namelen == 0 || remote->valueblk == 0) {
> > -				if (show_warnings)
> > +				if (metadump.show_warnings)
> >  					print_warning(
> >  				"invalid attr entry in inode %llu",
> > -						(long long)cur_ino);
> > +						(long long)metadump.cur_ino);
> >  				break;
> >  			}
> > -			if (obfuscate) {
> > +			if (metadump.obfuscate) {
> >  				generate_obfuscated_name(0, remote->namelen,
> >  							 &remote->name[0]);
> >  				add_remote_vals(be32_to_cpu(remote->valueblk),
> > @@ -1819,13 +1830,13 @@ process_attr_block(
> >  			zlen = xfs_attr_leaf_entsize_remote(nlen) -
> >  				(sizeof(xfs_attr_leaf_name_remote_t) - 1 +
> >  				 nlen);
> > -			if (zero_stale_data)
> > +			if (metadump.zero_stale_data)
> >  				memset(&remote->name[nlen], 0, zlen);
> >  		}
> >  	}
> >
> >  	/* Zero from end of entries array to the first name/val */
> > -	if (zero_stale_data) {
> > +	if (metadump.zero_stale_data) {
> >  		struct xfs_attr_leaf_entry *entries;
> >
> >  		entries = xfs_attr3_leaf_entryp(leaf);
> > @@ -1858,16 +1869,16 @@ process_single_fsb_objects(
> >
> >  			print_warning("cannot read %s block %u/%u (%llu)",
> >  					typtab[btype].name, agno, agbno, s);
> > -			rval = !stop_on_read_error;
> > +			rval = !metadump.stop_on_read_error;
> >  			goto out_pop;
> >
> >  		}
> >
> > -		if (!obfuscate && !zero_stale_data)
> > +		if (!metadump.obfuscate && !metadump.zero_stale_data)
> >  			goto write;
> >
> >  		/* Zero unused part of interior nodes */
> > -		if (zero_stale_data) {
> > +		if (metadump.zero_stale_data) {
> >  			xfs_da_intnode_t *node = iocur_top->data;
> >  			int magic = be16_to_cpu(node->hdr.info.magic);
> >
> > @@ -1978,12 +1989,12 @@ process_multi_fsb_dir(
> >
> >  				print_warning("cannot read %s block %u/%u (%llu)",
> >  						typtab[btype].name, agno, agbno, s);
> > -				rval = !stop_on_read_error;
> > +				rval = !metadump.stop_on_read_error;
> >  				goto out_pop;
> >
> >  			}
> >
> > -			if (!obfuscate && !zero_stale_data)
> > +			if (!metadump.obfuscate && !metadump.zero_stale_data)
> >  				goto write;
> >
> >  			dp = iocur_top->data;
> > @@ -2075,25 +2086,27 @@ process_bmbt_reclist(
> >  		 * one is found, stop processing remaining extents
> >  		 */
> >  		if (i > 0 && op + cp > o) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("bmap extent %d in %s ino %llu "
> >  					"starts at %llu, previous extent "
> >  					"ended at %llu", i,
> > -					typtab[btype].name, (long long)cur_ino,
> > +					typtab[btype].name,
> > +					(long long)metadump.cur_ino,
> >  					o, op + cp - 1);
> >  			break;
> >  		}
> >
> > -		if (c > max_extent_size) {
> > +		if (c > metadump.max_extent_size) {
> >  			/*
> >  			 * since we are only processing non-data extents,
> >  			 * large numbers of blocks in a metadata extent is
> >  			 * extremely rare and more than likely to be corrupt.
> >  			 */
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("suspicious count %u in bmap "
> >  					"extent %d in %s ino %llu", c, i,
> > -					typtab[btype].name, (long long)cur_ino);
> > +					typtab[btype].name,
> > +					(long long)metadump.cur_ino);
> >  			break;
> >  		}
> >
> > @@ -2104,19 +2117,21 @@ process_bmbt_reclist(
> >  		agbno = XFS_FSB_TO_AGBNO(mp, s);
> >
> >  		if (!valid_bno(agno, agbno)) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number %u/%u "
> >  					"(%llu) in bmap extent %d in %s ino "
> >  					"%llu", agno, agbno, s, i,
> > -					typtab[btype].name, (long long)cur_ino);
> > +					typtab[btype].name,
> > +					(long long)metadump.cur_ino);
> >  			break;
> >  		}
> >
> >  		if (!valid_bno(agno, agbno + c - 1)) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("bmap extent %i in %s inode %llu "
> >  					"overflows AG (end is %u/%u)", i,
> > -					typtab[btype].name, (long long)cur_ino,
> > +					typtab[btype].name,
> > +					(long long)metadump.cur_ino,
> >  					agno, agbno + c - 1);
> >  			break;
> >  		}
> > @@ -2152,7 +2167,7 @@ scanfunc_bmap(
> >
> >  	if (level == 0) {
> >  		if (nrecs > mp->m_bmap_dmxr[0]) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid numrecs (%u) in %s "
> >  					"block %u/%u", nrecs,
> >  					typtab[btype].name, agno, agbno);
> > @@ -2163,7 +2178,7 @@ scanfunc_bmap(
> >  	}
> >
> >  	if (nrecs > mp->m_bmap_dmxr[1]) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs (%u) in %s block %u/%u",
> >  					nrecs, typtab[btype].name, agno, agbno);
> >  		return 1;
> > @@ -2178,7 +2193,7 @@ scanfunc_bmap(
> >
> >  		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
> >  				ag > mp->m_sb.sb_agcount) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> >  					"in %s block %u/%u", ag, bno,
> >  					typtab[btype].name, agno, agbno);
> > @@ -2213,10 +2228,10 @@ process_btinode(
> >  	nrecs = be16_to_cpu(dib->bb_numrecs);
> >
> >  	if (level > XFS_BM_MAXLEVELS(mp, whichfork)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in inode %lld %s "
> > -					"root", level, (long long)cur_ino,
> > -					typtab[btype].name);
> > +				"root", level, (long long)metadump.cur_ino,
> > +				typtab[btype].name);
> >  		return 1;
> >  	}
> >
> > @@ -2227,16 +2242,16 @@ process_btinode(
> >
> >  	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
> >  	if (nrecs > maxrecs) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs (%u) in inode %lld %s "
> > -					"root", nrecs, (long long)cur_ino,
> > -					typtab[btype].name);
> > +				"root", nrecs, (long long)metadump.cur_ino,
> > +				typtab[btype].name);
> >  		return 1;
> >  	}
> >
> >  	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
> >
> > -	if (zero_stale_data) {
> > +	if (metadump.zero_stale_data) {
> >  		char	*top;
> >
> >  		/* Unused btree key space */
> > @@ -2257,11 +2272,11 @@ process_btinode(
> >
> >  		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
> >  				ag > mp->m_sb.sb_agcount) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> > -						"in inode %llu %s root", ag,
> > -						bno, (long long)cur_ino,
> > -						typtab[btype].name);
> > +					"in inode %llu %s root", ag, bno,
> > +					(long long)metadump.cur_ino,
> > +					typtab[btype].name);
> >  			continue;
> >  		}
> >
> > @@ -2288,14 +2303,16 @@ process_exinode(
> >  			whichfork);
> >  	used = nex * sizeof(xfs_bmbt_rec_t);
> >  	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("bad number of extents %llu in inode %lld",
> > -				(unsigned long long)nex, (long long)cur_ino);
> > +				(unsigned long long)nex,
> > +				(long long)metadump.cur_ino);
> >  		return 1;
> >  	}
> >
> >  	/* Zero unused data fork past used extents */
> > -	if (zero_stale_data && (used < XFS_DFORK_SIZE(dip, mp, whichfork)))
> > +	if (metadump.zero_stale_data &&
> > +		(used < XFS_DFORK_SIZE(dip, mp, whichfork)))
> >  		memset(XFS_DFORK_PTR(dip, whichfork) + used, 0,
> >  		       XFS_DFORK_SIZE(dip, mp, whichfork) - used);
> >
> > @@ -2311,7 +2328,7 @@ process_inode_data(
> >  {
> >  	switch (dip->di_format) {
> >  		case XFS_DINODE_FMT_LOCAL:
> > -			if (!(obfuscate || zero_stale_data))
> > +			if (!(metadump.obfuscate || metadump.zero_stale_data))
> >  				break;
> >
> >  			/*
> > @@ -2323,7 +2340,7 @@ process_inode_data(
> >  				print_warning(
> >  "Invalid data fork size (%d) in inode %llu, preserving contents!",
> >  						XFS_DFORK_DSIZE(dip, mp),
> > -						(long long)cur_ino);
> > +						(long long)metadump.cur_ino);
> >  				break;
> >  			}
> >
> > @@ -2355,9 +2372,9 @@ process_dev_inode(
> >  	struct xfs_dinode		*dip)
> >  {
> >  	if (xfs_dfork_data_extents(dip)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("inode %llu has unexpected extents",
> > -				      (unsigned long long)cur_ino);
> > +				      (unsigned long long)metadump.cur_ino);
> >  		return;
> >  	}
> >
> > @@ -2369,11 +2386,11 @@ process_dev_inode(
> >  	if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
> >  		print_warning(
> >  "Invalid data fork size (%d) in inode %llu, preserving contents!",
> > -				XFS_DFORK_DSIZE(dip, mp), (long long)cur_ino);
> > +			XFS_DFORK_DSIZE(dip, mp), (long long)metadump.cur_ino);
> >  		return;
> >  	}
> >
> > -	if (zero_stale_data) {
> > +	if (metadump.zero_stale_data) {
> >  		unsigned int	size = sizeof(xfs_dev_t);
> >
> >  		memset(XFS_DFORK_DPTR(dip) + size, 0,
> > @@ -2399,17 +2416,17 @@ process_inode(
> >  	bool			crc_was_ok = false; /* no recalc by default */
> >  	bool			need_new_crc = false;
> >
> > -	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
> > +	metadump.cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
> >
> >  	/* we only care about crc recalculation if we will modify the inode. */
> > -	if (obfuscate || zero_stale_data) {
> > +	if (metadump.obfuscate || metadump.zero_stale_data) {
> >  		crc_was_ok = libxfs_verify_cksum((char *)dip,
> >  					mp->m_sb.sb_inodesize,
> >  					offsetof(struct xfs_dinode, di_crc));
> >  	}
> >
> >  	if (free_inode) {
> > -		if (zero_stale_data) {
> > +		if (metadump.zero_stale_data) {
> >  			/* Zero all of the inode literal area */
> >  			memset(XFS_DFORK_DPTR(dip), 0, XFS_LITINO(mp));
> >  		}
> > @@ -2451,7 +2468,8 @@ process_inode(
> >  		switch (dip->di_aformat) {
> >  			case XFS_DINODE_FMT_LOCAL:
> >  				need_new_crc = true;
> > -				if (obfuscate || zero_stale_data)
> > +				if (metadump.obfuscate ||
> > +					metadump.zero_stale_data)
> >  					process_sf_attr(dip);
> >  				break;
> >
> > @@ -2468,7 +2486,7 @@ process_inode(
> >
> >  done:
> >  	/* Heavy handed but low cost; just do it as a catch-all. */
> > -	if (zero_stale_data)
> > +	if (metadump.zero_stale_data)
> >  		need_new_crc = true;
> >
> >  	if (crc_was_ok && need_new_crc)
> > @@ -2528,7 +2546,7 @@ copy_inode_chunk(
> >  	if (agino == 0 || agino == NULLAGINO || !valid_bno(agno, agbno) ||
> >  			!valid_bno(agno, XFS_AGINO_TO_AGBNO(mp,
> >  					agino + XFS_INODES_PER_CHUNK - 1))) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("bad inode number %llu (%u/%u)",
> >  				XFS_AGINO_TO_INO(mp, agno, agino), agno, agino);
> >  		return 1;
> > @@ -2544,7 +2562,7 @@ copy_inode_chunk(
> >  			(xfs_has_align(mp) &&
> >  					mp->m_sb.sb_inoalignmt != 0 &&
> >  					agbno % mp->m_sb.sb_inoalignmt != 0)) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("badly aligned inode (start = %llu)",
> >  					XFS_AGINO_TO_INO(mp, agno, agino));
> >  		return 1;
> > @@ -2561,7 +2579,7 @@ copy_inode_chunk(
> >  		if (iocur_top->data == NULL) {
> >  			print_warning("cannot read inode block %u/%u",
> >  				      agno, agbno);
> > -			rval = !stop_on_read_error;
> > +			rval = !metadump.stop_on_read_error;
> >  			goto pop_out;
> >  		}
> >
> > @@ -2587,7 +2605,7 @@ next_bp:
> >  		ioff += inodes_per_buf;
> >  	}
> >
> > -	if (show_progress)
> > +	if (metadump.show_progress)
> >  		print_progress("Copied %u of %u inodes (%u of %u AGs)",
> >  				inodes_copied, mp->m_sb.sb_icount, agno,
> >  				mp->m_sb.sb_agcount);
> > @@ -2617,7 +2635,7 @@ scanfunc_ino(
> >
> >  	if (level == 0) {
> >  		if (numrecs > igeo->inobt_mxr[0]) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid numrecs %d in %s "
> >  					"block %u/%u", numrecs,
> >  					typtab[btype].name, agno, agbno);
> > @@ -2640,7 +2658,7 @@ scanfunc_ino(
> >  	}
> >
> >  	if (numrecs > igeo->inobt_mxr[1]) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid numrecs %d in %s block %u/%u",
> >  				numrecs, typtab[btype].name, agno, agbno);
> >  		numrecs = igeo->inobt_mxr[1];
> > @@ -2649,7 +2667,7 @@ scanfunc_ino(
> >  	pp = XFS_INOBT_PTR_ADDR(mp, block, 1, igeo->inobt_mxr[1]);
> >  	for (i = 0; i < numrecs; i++) {
> >  		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u/%u) "
> >  					"in %s block %u/%u",
> >  					agno, be32_to_cpu(pp[i]),
> > @@ -2677,13 +2695,13 @@ copy_inodes(
> >
> >  	/* validate root and levels before processing the tree */
> >  	if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid block number (%u) in inobt "
> >  					"root in agi %u", root, agno);
> >  		return 1;
> >  	}
> >  	if (levels > M_IGEO(mp)->inobt_maxlevels) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid level (%u) in inobt root "
> >  					"in agi %u", levels, agno);
> >  		return 1;
> > @@ -2697,7 +2715,7 @@ copy_inodes(
> >  		levels = be32_to_cpu(agi->agi_free_level);
> >
> >  		if (root == 0 || root > mp->m_sb.sb_agblocks) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid block number (%u) in "
> >  						"finobt root in agi %u", root,
> >  						agno);
> > @@ -2705,7 +2723,7 @@ copy_inodes(
> >  		}
> >
> >  		if (levels > M_IGEO(mp)->inobt_maxlevels) {
> > -			if (show_warnings)
> > +			if (metadump.show_warnings)
> >  				print_warning("invalid level (%u) in finobt "
> >  						"root in agi %u", levels, agno);
> >  			return 1;
> > @@ -2736,11 +2754,11 @@ scan_ag(
> >  			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
> >  	if (!iocur_top->data) {
> >  		print_warning("cannot read superblock for ag %u", agno);
> > -		if (stop_on_read_error)
> > +		if (metadump.stop_on_read_error)
> >  			goto pop_out;
> >  	} else {
> >  		/* Replace any filesystem label with "L's" */
> > -		if (obfuscate) {
> > +		if (metadump.obfuscate) {
> >  			struct xfs_sb *sb = iocur_top->data;
> >  			memset(sb->sb_fname, 'L',
> >  			       min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
> > @@ -2758,7 +2776,7 @@ scan_ag(
> >  	agf = iocur_top->data;
> >  	if (iocur_top->data == NULL) {
> >  		print_warning("cannot read agf block for ag %u", agno);
> > -		if (stop_on_read_error)
> > +		if (metadump.stop_on_read_error)
> >  			goto pop_out;
> >  	} else {
> >  		if (write_buf(iocur_top))
> > @@ -2773,7 +2791,7 @@ scan_ag(
> >  	agi = iocur_top->data;
> >  	if (iocur_top->data == NULL) {
> >  		print_warning("cannot read agi block for ag %u", agno);
> > -		if (stop_on_read_error)
> > +		if (metadump.stop_on_read_error)
> >  			goto pop_out;
> >  	} else {
> >  		if (write_buf(iocur_top))
> > @@ -2787,10 +2805,10 @@ scan_ag(
> >  			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
> >  	if (iocur_top->data == NULL) {
> >  		print_warning("cannot read agfl block for ag %u", agno);
> > -		if (stop_on_read_error)
> > +		if (metadump.stop_on_read_error)
> >  			goto pop_out;
> >  	} else {
> > -		if (agf && zero_stale_data) {
> > +		if (agf && metadump.zero_stale_data) {
> >  			/* Zero out unused bits of agfl */
> >  			int i;
> >  			 __be32  *agfl_bno;
> > @@ -2813,7 +2831,7 @@ scan_ag(
> >
> >  	/* copy AG free space btrees */
> >  	if (agf) {
> > -		if (show_progress)
> > +		if (metadump.show_progress)
> >  			print_progress("Copying free space trees of AG %u",
> >  					agno);
> >  		if (!copy_free_bno_btree(agno, agf))
> > @@ -2859,7 +2877,7 @@ copy_ino(
> >
> >  	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
> >  			offset >= mp->m_sb.sb_inopblock) {
> > -		if (show_warnings)
> > +		if (metadump.show_warnings)
> >  			print_warning("invalid %s inode number (%lld)",
> >  					typtab[itype].name, (long long)ino);
> >  		return 1;
> > @@ -2871,12 +2889,12 @@ copy_ino(
> >  	if (iocur_top->data == NULL) {
> >  		print_warning("cannot read %s inode %lld",
> >  				typtab[itype].name, (long long)ino);
> > -		rval = !stop_on_read_error;
> > +		rval = !metadump.stop_on_read_error;
> >  		goto pop_out;
> >  	}
> >  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
> >
> > -	cur_ino = ino;
> > +	metadump.cur_ino = ino;
> >  	rval = process_inode_data(iocur_top->data, itype);
> >  pop_out:
> >  	pop_cur();
> > @@ -2912,7 +2930,7 @@ copy_log(void)
> >  	int		logversion;
> >  	int		cycle = XLOG_INIT_CYCLE;
> >
> > -	if (show_progress)
> > +	if (metadump.show_progress)
> >  		print_progress("Copying log");
> >
> >  	push_cur();
> > @@ -2921,11 +2939,11 @@ copy_log(void)
> >  	if (iocur_top->data == NULL) {
> >  		pop_cur();
> >  		print_warning("cannot read log");
> > -		return !stop_on_read_error;
> > +		return !metadump.stop_on_read_error;
> >  	}
> >
> >  	/* If not obfuscating or zeroing, just copy the log as it is */
> > -	if (!obfuscate && !zero_stale_data)
> > +	if (!metadump.obfuscate && !metadump.zero_stale_data)
> >  		goto done;
> >
> >  	dirty = xlog_is_dirty(mp, &log, &x, 0);
> > @@ -2933,7 +2951,7 @@ copy_log(void)
> >  	switch (dirty) {
> >  	case 0:
> >  		/* clear out a clean log */
> > -		if (show_progress)
> > +		if (metadump.show_progress)
> >  			print_progress("Zeroing clean log");
> >
> >  		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
> > @@ -2948,7 +2966,7 @@ copy_log(void)
> >  		break;
> >  	case 1:
> >  		/* keep the dirty log */
> > -		if (obfuscate)
> > +		if (metadump.obfuscate)
> >  			print_warning(
> >  _("Warning: log recovery of an obfuscated metadata image can leak "
> >  "unobfuscated metadata and/or cause image corruption.  If possible, "
> > @@ -2956,7 +2974,7 @@ _("Warning: log recovery of an obfuscated metadata image can leak "
> >  		break;
> >  	case -1:
> >  		/* log detection error */
> > -		if (obfuscate)
> > +		if (metadump.obfuscate)
> >  			print_warning(
> >  _("Could not discern log; image will contain unobfuscated metadata in log."));
> >  		break;
> > @@ -2979,9 +2997,15 @@ metadump_f(
> >  	char		*p;
> >
> >  	exitcode = 1;
> > -	show_progress = false;
> > -	show_warnings = false;
> > -	stop_on_read_error = false;
> > +
> > +	metadump.version = 1;
> > +	metadump.show_progress = false;
> > +	metadump.stop_on_read_error = false;
> > +	metadump.max_extent_size = DEFAULT_MAX_EXT_SIZE;
> > +	metadump.show_warnings = false;
> > +	metadump.obfuscate = true;
> > +	metadump.zero_stale_data = true;
> > +	metadump.dirty_log = false;
> >
> >  	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
> >  		print_warning("bad superblock magic number %x, giving up",
> > @@ -3002,27 +3026,29 @@ metadump_f(
> >  	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
> >  		switch (c) {
> >  			case 'a':
> > -				zero_stale_data = false;
> > +				metadump.zero_stale_data = false;
> >  				break;
> >  			case 'e':
> > -				stop_on_read_error = true;
> > +				metadump.stop_on_read_error = true;
> >  				break;
> >  			case 'g':
> > -				show_progress = true;
> > +				metadump.show_progress = true;
> >  				break;
> >  			case 'm':
> > -				max_extent_size = (int)strtol(optarg, &p, 0);
> > -				if (*p != '\0' || max_extent_size <= 0) {
> > +				metadump.max_extent_size =
> > +					(int)strtol(optarg, &p, 0);
> > +				if (*p != '\0' ||
> > +					metadump.max_extent_size <= 0) {
> >  					print_warning("bad max extent size %s",
> >  							optarg);
> >  					return 0;
> >  				}
> >  				break;
> >  			case 'o':
> > -				obfuscate = false;
> > +				metadump.obfuscate = false;
> >  				break;
> >  			case 'w':
> > -				show_warnings = true;
> > +				metadump.show_warnings = true;
> >  				break;
> >  			default:
> >  				print_warning("bad option for metadump command");
> > @@ -3035,21 +3061,6 @@ metadump_f(
> >  		return 0;
> >  	}
> >
> > -	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
> > -	if (metablock == NULL) {
> > -		print_warning("memory allocation failure");
> > -		return 0;
> > -	}
> > -	metablock->mb_blocklog = BBSHIFT;
> > -	metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
> > -
> > -	/* Set flags about state of metadump */
> > -	metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
> > -	if (obfuscate)
> > -		metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
> > -	if (!zero_stale_data)
> > -		metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
> > -
> >  	/* If we'll copy the log, see if the log is dirty */
> >  	if (mp->m_sb.sb_logstart) {
> >  		push_cur();
> > @@ -3060,34 +3071,52 @@ metadump_f(
> >  			struct xlog	log;
> >
> >  			if (xlog_is_dirty(mp, &log, &x, 0))
> > -				metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
> > +				metadump.dirty_log = true;
> >  		}
> >  		pop_cur();
> >  	}
> >
> > -	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
> > -	block_buffer = (char *)metablock + BBSIZE;
> > -	num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> > +	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
> > +	if (metadump.metablock == NULL) {
> > +		print_warning("memory allocation failure");
> > +		return -1;
> > +	}
> > +	metadump.metablock->mb_blocklog = BBSHIFT;
> > +	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
> > +
> > +	/* Set flags about state of metadump */
> > +	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
> > +	if (metadump.obfuscate)
> > +		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
> > +	if (!metadump.zero_stale_data)
> > +		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
> > +	if (metadump.dirty_log)
> > +		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
> > +
> > +	metadump.block_index = (__be64 *)((char *)metadump.metablock +
> > +					sizeof(xfs_metablock_t));
> > +	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
> > +	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
> > +		sizeof(__be64);
> >
> >  	/*
> >  	 * A metadump block can hold at most num_indices of BBSIZE sectors;
> >  	 * do not try to dump a filesystem with a sector size which does not
> >  	 * fit within num_indices (i.e. within a single metablock).
> >  	 */
> > -	if (mp->m_sb.sb_sectsize > num_indices * BBSIZE) {
> > +	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
> >  		print_warning("Cannot dump filesystem with sector size %u",
> >  			      mp->m_sb.sb_sectsize);
> > -		free(metablock);
> > +		free(metadump.metablock);
> >  		return 0;
> >  	}
> >
> > -	cur_index = 0;
> >  	start_iocur_sp = iocur_sp;
> >
> >  	if (strcmp(argv[optind], "-") == 0) {
> >  		if (isatty(fileno(stdout))) {
> >  			print_warning("cannot write to a terminal");
> > -			free(metablock);
> > +			free(metadump.metablock);
> >  			return 0;
> >  		}
> >  		/*
> > @@ -3111,17 +3140,17 @@ metadump_f(
> >  			close(outfd);
> >  			goto out;
> >  		}
> > -		outf = fdopen(outfd, "a");
> > -		if (outf == NULL) {
> > +		metadump.outf = fdopen(outfd, "a");
> > +		if (metadump.outf == NULL) {
> >  			fprintf(stderr, "cannot create dump stream\n");
> >  			dup2(outfd, STDOUT_FILENO);
> >  			close(outfd);
> >  			goto out;
> >  		}
> > -		stdout_metadump = true;
> > +		metadump.stdout_metadump = true;
> >  	} else {
> > -		outf = fopen(argv[optind], "wb");
> > -		if (outf == NULL) {
> > +		metadump.outf = fopen(argv[optind], "wb");
> > +		if (metadump.outf == NULL) {
> >  			print_warning("cannot create dump file");
> >  			goto out;
> >  		}
> > @@ -3148,24 +3177,24 @@ metadump_f(
> >  	if (!exitcode)
> >  		exitcode = write_index() < 0;
> >
> > -	if (progress_since_warning)
> > -		fputc('\n', stdout_metadump ? stderr : stdout);
> > +	if (metadump.progress_since_warning)
> > +		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
> >
> > -	if (stdout_metadump) {
> > -		fflush(outf);
> > +	if (metadump.stdout_metadump) {
> > +		fflush(metadump.outf);
> >  		fflush(stdout);
> >  		ret = dup2(outfd, STDOUT_FILENO);
> >  		if (ret < 0)
> >  			perror("un-redirecting stdout");
> > -		stdout_metadump = false;
> > +		metadump.stdout_metadump = false;
> >  	}
> > -	fclose(outf);
> > +	fclose(metadump.outf);
> >
> >  	/* cleanup iocur stack */
> >  	while (iocur_sp > start_iocur_sp)
> >  		pop_cur();
> >  out:
> > -	free(metablock);
> > +	free(metadump.metablock);
> >
> >  	return 0;
> >  }
> > --
> > 2.39.1
> >
