Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C78CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 16:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B697E205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 16:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUQeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:34:02 -0400
Received: from sandeen.net ([63.231.237.45]:41002 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJUQeC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Oct 2019 12:34:02 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4D900EC3;
        Mon, 21 Oct 2019 11:33:15 -0500 (CDT)
Subject: Re: [PATCH 02/11] xfs_scrub: improve reporting of file data media
 errors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944737999.300131.8592981210219230662.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <79b3273d-fe63-9bee-7be9-793a55aabb69@sandeen.net>
Date:   Mon, 21 Oct 2019 11:33:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <156944737999.300131.8592981210219230662.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/19 4:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we report media errors, we should tell the administrator the file
> offset and length of the bad region, not just the offset of the entire
> file extent record that overlaps a bad region.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libfrog/bitmap.c |   37 +++++++++++++++++++++++++++++++++++++
>  libfrog/bitmap.h |    2 ++
>  scrub/phase6.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  3 files changed, 86 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> index a75d085a..6a88ef48 100644
> --- a/libfrog/bitmap.c
> +++ b/libfrog/bitmap.c
> @@ -339,6 +339,43 @@ bitmap_iterate(
>  }
>  #endif
>  
> +/* Iterate the set regions of part of this bitmap. */
> +int
> +bitmap_iterate_range(
> +	struct bitmap		*bmap,
> +	uint64_t		start,
> +	uint64_t		length,
> +	int			(*fn)(uint64_t, uint64_t, void *),
> +	void			*arg)
> +{
> +	struct avl64node	*firstn;
> +	struct avl64node	*lastn;
> +	struct avl64node	*pos;
> +	struct avl64node	*n;
> +	struct avl64node	*l;
> +	struct bitmap_node	*ext;
> +	int			ret = 0;
> +
> +	pthread_mutex_lock(&bmap->bt_lock);
> +
> +	avl64_findranges(bmap->bt_tree, start, start + length, &firstn,
> +			&lastn);
> +
> +	if (firstn == NULL && lastn == NULL)
> +		goto out;
> +
> +	avl_for_each_range_safe(pos, n, l, firstn, lastn) {
> +		ext = container_of(pos, struct bitmap_node, btn_node);
> +		ret = fn(ext->btn_start, ext->btn_length, arg);
> +		if (ret)
> +			break;
> +	}
> +
> +out:
> +	pthread_mutex_unlock(&bmap->bt_lock);
> +	return ret;
> +}
> +
>  /* Do any bitmap extents overlap the given one?  (locked) */
>  static bool
>  __bitmap_test(
> diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
> index 759386a8..043b77ee 100644
> --- a/libfrog/bitmap.h
> +++ b/libfrog/bitmap.h
> @@ -16,6 +16,8 @@ void bitmap_free(struct bitmap **bmap);
>  int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
>  int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
>  		void *arg);
> +int bitmap_iterate_range(struct bitmap *bmap, uint64_t start, uint64_t length,
> +		int (*fn)(uint64_t, uint64_t, void *), void *arg);
>  bool bitmap_test(struct bitmap *bmap, uint64_t start,
>  		uint64_t len);
>  bool bitmap_empty(struct bitmap *bmap);
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 1edd98af..a16ad114 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -111,6 +111,41 @@ xfs_decode_special_owner(
>  
>  /* Routines to translate bad physical extents into file paths and offsets. */
>  
> +struct badfile_report {
> +	struct scrub_ctx	*ctx;
> +	const char		*descr;
> +	struct xfs_bmap		*bmap;
> +};
> +
> +/* Report on bad extents found during a media scan. */
> +static int
> +report_badfile(
> +	uint64_t		start,
> +	uint64_t		length,
> +	void			*arg)
> +{
> +	struct badfile_report	*br = arg;
> +	unsigned long long	bad_offset;
> +	unsigned long long	bad_length;
> +
> +	/* Clamp the bad region to the file mapping. */
> +	if (start < br->bmap->bm_physical) {
> +		length -= br->bmap->bm_physical - start;
> +		start = br->bmap->bm_physical;
> +	}
> +	length = min(length, br->bmap->bm_length);
> +
> +	/* Figure out how far into the bmap is the bad mapping and report it. */
> +	bad_offset = start - br->bmap->bm_physical;
> +	bad_length = min(start + length,
> +			 br->bmap->bm_physical + br->bmap->bm_length) - start;
> +
> +	str_error(br->ctx, br->descr,
> +_("media error at data offset %llu length %llu."),
> +			br->bmap->bm_offset + bad_offset, bad_length);
> +	return 0;
> +}
> +
>  /* Report if this extent overlaps a bad region. */
>  static bool
>  report_data_loss(
> @@ -122,8 +157,14 @@ report_data_loss(
>  	struct xfs_bmap			*bmap,
>  	void				*arg)
>  {
> +	struct badfile_report		br = {
> +		.ctx			= ctx,
> +		.descr			= descr,
> +		.bmap			= bmap,
> +	};
>  	struct media_verify_state	*vs = arg;
>  	struct bitmap			*bmp;
> +	int				ret;
>  
>  	/* Only report errors for real extents. */
>  	if (bmap->bm_flags & (BMV_OF_PREALLOC | BMV_OF_DELALLOC))
> @@ -134,11 +175,12 @@ report_data_loss(
>  	else
>  		bmp = vs->d_bad;
>  
> -	if (!bitmap_test(bmp, bmap->bm_physical, bmap->bm_length))
> -		return true;
> -
> -	str_error(ctx, descr,
> -_("offset %llu failed read verification."), bmap->bm_offset);
> +	ret = bitmap_iterate_range(bmp, bmap->bm_physical, bmap->bm_length,
> +			report_badfile, &br);
> +	if (ret) {
> +		str_liberror(ctx, ret, descr);
> +		return false;

So related to the prior question; why does changing the way we report a
media error in a file change the flow with a "return false" here?

> +	}
>  	return true;
>  }
>  
> 
