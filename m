Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442ECC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 14:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbjFBOeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 10:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbjFBOeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 10:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2749FE41
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 07:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B179361984
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C3CC433EF;
        Fri,  2 Jun 2023 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685716448;
        bh=L01bdJoStt06IzpocYozzZcu20VHUlcG34TzhIXIQqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AthHLFfi4poDa46/oq9rvfqrSXMt+m1VT9HTymXMY3PvowWSPw+QpbVU3suaNhLFx
         T1reecVHdqquZ+dzdW2eL0XEvOa76ugRvqIO3iHGUtc+wPVE/yoMOhYI1g6alMUCJe
         aAymhR0kFceQqlSGjKRLTtTDJioa3eQ2jT4U8ojgk02tHMz1zBVJDr913FNV8yGq36
         Ppc8SYqJAQRBqapnO7q+/mcbuw9FF4tAQY62rGry9g3ulW19vV4ZlQl1X1C3tQmdrh
         KENX88AB09MG0xRjizAMpvyqDuPnkdiDQr3ADOpdvdT0znyGG7uuFrdKpbx8yJRFoA
         IDmYSiIrc6pHw==
Date:   Fri, 2 Jun 2023 07:34:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] metadump: Introduce metadump v1 operations
Message-ID: <20230602143407.GK16865@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-10-chandan.babu@oracle.com>
 <20230523172513.GP11620@frogsfrogsfrogs>
 <87lehbjx2t.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lehbjx2t.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 07:49:32PM +0530, Chandan Babu R wrote:
> On Tue, May 23, 2023 at 10:25:13 AM -0700, Darrick J. Wong wrote:
> > On Tue, May 23, 2023 at 02:30:35PM +0530, Chandan Babu R wrote:
> >> This commit moves functionality associated with writing metadump to disk into
> >> a new function. It also renames metadump initialization, write and release
> >> functions to reflect the fact that they work with v1 metadump files.
> >> 
> >> The metadump initialization, write and release functions are now invoked via
> >> metadump_ops->init_metadump(), metadump_ops->write_metadump() and
> >> metadump_ops->release_metadump() respectively.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
> >>  1 file changed, 61 insertions(+), 63 deletions(-)
> >> 
> >> diff --git a/db/metadump.c b/db/metadump.c
> >> index 56d8c3bdf..7265f73ec 100644
> >> --- a/db/metadump.c
> >> +++ b/db/metadump.c
> >> @@ -135,59 +135,6 @@ print_progress(const char *fmt, ...)
> >>  	metadump.progress_since_warning = 1;
> >>  }
> >>  
> >> -/*
> >> - * A complete dump file will have a "zero" entry in the last index block,
> >> - * even if the dump is exactly aligned, the last index will be full of
> >> - * zeros. If the last index entry is non-zero, the dump is incomplete.
> >> - * Correspondingly, the last chunk will have a count < num_indices.
> >> - *
> >> - * Return 0 for success, -1 for failure.
> >> - */
> >> -
> >> -static int
> >> -write_index(void)
> >> -{
> >> -	struct xfs_metablock *metablock = metadump.metablock;
> >> -	/*
> >> -	 * write index block and following data blocks (streaming)
> >> -	 */
> >> -	metablock->mb_count = cpu_to_be16(metadump.cur_index);
> >> -	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
> >> -			metadump.outf) != 1) {
> >> -		print_warning("error writing to target file");
> >> -		return -1;
> >> -	}
> >> -
> >> -	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
> >> -	metadump.cur_index = 0;
> >> -	return 0;
> >> -}
> >> -
> >> -/*
> >> - * Return 0 for success, -errno for failure.
> >> - */
> >> -static int
> >> -write_buf_segment(
> >> -	char		*data,
> >> -	int64_t		off,
> >> -	int		len)
> >> -{
> >> -	int		i;
> >> -	int		ret;
> >> -
> >> -	for (i = 0; i < len; i++, off++, data += BBSIZE) {
> >> -		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
> >> -		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
> >> -			data, BBSIZE);
> >> -		if (++metadump.cur_index == metadump.num_indices) {
> >> -			ret = write_index();
> >> -			if (ret)
> >> -				return -EIO;
> >> -		}
> >> -	}
> >> -	return 0;
> >> -}
> >> -
> >>  /*
> >>   * we want to preserve the state of the metadata in the dump - whether it is
> >>   * intact or corrupt, so even if the buffer has a verifier attached to it we
> >> @@ -224,15 +171,16 @@ write_buf(
> >>  
> >>  	/* handle discontiguous buffers */
> >>  	if (!buf->bbmap) {
> >> -		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
> >> +		ret = metadump.mdops->write_metadump(buf->typ->typnm, buf->data,
> >> +				buf->bb, buf->blen);
> >>  		if (ret)
> >>  			return ret;
> >>  	} else {
> >>  		int	len = 0;
> >>  		for (i = 0; i < buf->bbmap->nmaps; i++) {
> >> -			ret = write_buf_segment(buf->data + BBTOB(len),
> >> -						buf->bbmap->b[i].bm_bn,
> >> -						buf->bbmap->b[i].bm_len);
> >> +			ret = metadump.mdops->write_metadump(buf->typ->typnm,
> >> +				buf->data + BBTOB(len), buf->bbmap->b[i].bm_bn,
> >> +				buf->bbmap->b[i].bm_len);
> >>  			if (ret)
> >>  				return ret;
> >>  			len += buf->bbmap->b[i].bm_len;
> >> @@ -2994,7 +2942,7 @@ done:
> >>  }
> >>  
> >>  static int
> >> -init_metadump(void)
> >> +init_metadump_v1(void)
> >>  {
> >>  	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
> >>  	if (metadump.metablock == NULL) {
> >> @@ -3035,12 +2983,60 @@ init_metadump(void)
> >>          return 0;
> >>  }
> >>  
> >> +static int
> >> +end_write_metadump_v1(void)
> >> +{
> >> +	/*
> >> +	 * write index block and following data blocks (streaming)
> >> +	 */
> >> +	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
> >> +	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1, metadump.outf) != 1) {
> >> +		print_warning("error writing to target file");
> >> +		return -1;
> >> +	}
> >> +
> >> +	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
> >> +	metadump.cur_index = 0;
> >> +	return 0;
> >> +}
> >> +
> >> +static int
> >> +write_metadump_v1(
> >> +	enum typnm	type,
> >> +	char		*data,
> >> +	int64_t		off,
> >
> > This really ought to be an xfs_daddr_t, right?
> >
> 
> Yes, you are right. I will make the required change.
> 
> >> +	int		len)
> >> +{
> >> +	int		i;
> >> +	int		ret;
> >> +
> >> +        for (i = 0; i < len; i++, off++, data += BBSIZE) {
> >> +		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
> >> +		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
> >> +			data, BBSIZE);
> >
> > Wondering if this ought to be called ->record_segment or something, since
> > it's not really writing anything to disk, merely copying it to the index
> > buffer.
> >
> >> +		if (++metadump.cur_index == metadump.num_indices) {
> >> +			ret = end_write_metadump_v1();
> >> +			if (ret)
> >> +				return -EIO;
> >
> > This is "generic" code for "Have we filled up the index table?  If so,
> > then write the index block the indexed data".  Shouldn't it go in
> > write_buf?  And then write_buf does something like:
> >
> > 	while (len > 0) {
> > 		segment_len = min(len, metadump.num_indices - metadump.cur_index);
> >
> > 		metadump.ops->record_segment(type, buf, daddr, segment_len);
> >
> > 		metadump.cur_index += segment_len;
> > 		if (metadump.cur_index == metadump.num_indices) {
> > 			metadump.ops->write_index(...);
> > 			metadump.cur_index = 0;
> > 		}
> >
> > 		len -= segment_len;
> > 		daddr += segment_len;
> > 		buf += (segment_len << 9);
> > 	}
> >
> > 	if (metadump.cur_index)
> > 		metadump.ops->write_index(...);
> > 	metadump.cur_index = 0;
> >
> 
> The above change would require write_buf() to know about the internals of
> metadump v1 format. This change can be performed as long as the metadump
> supports only the v1 format. However, supporting the v2 format later requires
> that write_buf() invoke version specific functions via function pointers and
> to not perform any other version specific operation (e.g. checking to see if
> the v1 format's in-memory index is filled) on its own.

Ah, right.  I made that comment before you pointed out that v2
interleaves meta_extent records with dump data instead of having
separate index blocks.  Question withdrawn.

--D

> >> +		}
> >> +	}
> >> +
> >> +        return 0;
> >> +}
> >> +
> >>  static void
> >> -release_metadump(void)
> >> +release_metadump_v1(void)
> >>  {
> >>  	free(metadump.metablock);
> >>  }
> >>  
> >> +static struct metadump_ops metadump1_ops = {
> >> +	.init_metadump = init_metadump_v1,
> >> +	.write_metadump = write_metadump_v1,
> >> +	.end_write_metadump = end_write_metadump_v1,
> >> +	.release_metadump = release_metadump_v1,
> >> +};
> >> +
> >>  static int
> >>  metadump_f(
> >>  	int 		argc,
> >> @@ -3182,9 +3178,11 @@ metadump_f(
> >>  		}
> >>  	}
> >>  
> >> -	ret = init_metadump();
> >> +	metadump.mdops = &metadump1_ops;
> >> +
> >> +	ret = metadump.mdops->init_metadump();
> >>  	if (ret)
> >> -		return 0;
> >> +		goto out;
> >>  
> >>  	exitcode = 0;
> >>  
> >> @@ -3206,7 +3204,7 @@ metadump_f(
> >>  
> >>  	/* write the remaining index */
> >>  	if (!exitcode)
> >> -		exitcode = write_index() < 0;
> >> +		exitcode = metadump.mdops->end_write_metadump() < 0;
> >>  
> >>  	if (metadump.progress_since_warning)
> >>  		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
> >> @@ -3225,7 +3223,7 @@ metadump_f(
> >>  	while (iocur_sp > start_iocur_sp)
> >>  		pop_cur();
> >>  
> >> -	release_metadump();
> >> +	metadump.mdops->release_metadump();
> >>  
> >>  out:
> >>  	return 0;
> >> -- 
> >> 2.39.1
> >> 
> 
> 
> -- 
> chandan
