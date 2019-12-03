Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EF1C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A794F20684
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 01:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lRur4rN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLCB4w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 20:56:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfLCB4w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 20:56:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB31rv2t055321;
        Tue, 3 Dec 2019 01:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ssznkRxX+KJGRaOfrYECBQakxwCFZ/lyEyHbUA/GT3o=;
 b=lRur4rN4MsHwUBsF/cE1kE9nRQIhPuCQjqtI6sPd1FPPJrgzg4gFGpiB7BXX3hqllz6T
 HO7JkvrwVPSrKMixmOG1Vhau7p0Oo9+dQ1dbRQ9gcXSzbtGYYojybLJo7OdPFHy+khva
 a6CVLvnvSa+oUUTai6aRHdsJMZmNDYxmjG+BmE22QIo81m6YRyghc6OjcvQDFZjRGAc8
 kYo5XAOEQwBpT/4AJtj4ha7RAocS1aIW9pDL7l2E2YlPDQcXfDbePgvDm26M46NFWJW2
 oSk+3qSnixMRIFl3INmbpwaYqpDp/kRl8SLgYlmNIU8oM7efcvPvqnbczMU1GX6tPkNF FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wkfuu473g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 01:56:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB31mWj3095472;
        Tue, 3 Dec 2019 01:56:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wn7pnvdvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 01:56:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB31ukb5019748;
        Tue, 3 Dec 2019 01:56:47 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 17:56:46 -0800
Date:   Mon, 2 Dec 2019 17:56:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] xfs: fix realtime file data space leak
Message-ID: <20191203015645.GG7335@magnolia>
References: <cover.1574799066.git.osandov@fb.com>
 <fe86a7464d77f770736404a9fbfcdfbb04b59826.1574799066.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe86a7464d77f770736404a9fbfcdfbb04b59826.1574799066.git.osandov@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 12:13:28PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Realtime files in XFS allocate extents in rextsize units. However, the
> written/unwritten state of those extents is still tracked in blocksize
> units. Therefore, a realtime file can be split up into written and
> unwritten extents that are not necessarily aligned to the realtime
> extent size. __xfs_bunmapi() has some logic to handle these various
> corner cases. Consider how it handles the following case:
> 
> 1. The last extent is unwritten.
> 2. The last extent is smaller than the realtime extent size.
> 3. startblock of the last extent is not aligned to the realtime extent
>    size, but startblock + blockcount is.
> 
> In this case, __xfs_bunmapi() calls xfs_bmap_add_extent_unwritten_real()
> to set the second-to-last extent to unwritten. This should merge the
> last and second-to-last extents, so __xfs_bunmapi() moves on to the
> second-to-last extent.
> 
> However, if the size of the last and second-to-last extents combined is
> greater than MAXEXTLEN, xfs_bmap_add_extent_unwritten_real() does not
> merge the two extents. When that happens, __xfs_bunmapi() skips past the
> last extent without unmapping it, thus leaking the space.
> 
> Fix it by only unwriting the minimum amount needed to align the last
> extent to the realtime extent size, which is guaranteed to merge with
> the last extent.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 02469d59c787..6f8791a1e460 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5376,16 +5376,17 @@ __xfs_bunmapi(
>  		}
>  		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
>  		if (mod) {
> +			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
> +
>  			/*
>  			 * Realtime extent is lined up at the end but not
>  			 * at the front.  We'll get rid of full extents if
>  			 * we can.
>  			 */
> -			mod = mp->m_sb.sb_rextsize - mod;
> -			if (del.br_blockcount > mod) {
> -				del.br_blockcount -= mod;
> -				del.br_startoff += mod;
> -				del.br_startblock += mod;
> +			if (del.br_blockcount > off) {
> +				del.br_blockcount -= off;
> +				del.br_startoff += off;
> +				del.br_startblock += off;

Ok, so we make this change so that we no longer change @mod once it's
set by the div64 operation...

>  			} else if (del.br_startoff == start &&
>  				   (del.br_state == XFS_EXT_UNWRITTEN ||
>  				    tp->t_blk_res == 0)) {
> @@ -5403,6 +5404,7 @@ __xfs_bunmapi(
>  				continue;
>  			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
>  				struct xfs_bmbt_irec	prev;
> +				xfs_fileoff_t		unwrite_start;
>  
>  				/*
>  				 * This one is already unwritten.
> @@ -5416,12 +5418,13 @@ __xfs_bunmapi(
>  				ASSERT(!isnullstartblock(prev.br_startblock));
>  				ASSERT(del.br_startblock ==
>  				       prev.br_startblock + prev.br_blockcount);
> -				if (prev.br_startoff < start) {
> -					mod = start - prev.br_startoff;
> -					prev.br_blockcount -= mod;
> -					prev.br_startblock += mod;
> -					prev.br_startoff = start;
> -				}

...and here, we have a @del extent that is unwritten and a @prev extent
that is written.  We aim to trick xfs_bmap_add_extent_unwritten_real
into extending @del towards startoff==0 and returning with @icur
pointing at @del (not @prev) so that the next time we go around the loop
we see an rtextsize-aligned @del and simply unmap it...

> +				unwrite_start = max3(start,
> +						     del.br_startoff - mod,
> +						     prev.br_startoff);

...however, if @prev is too long to convert+combine with @del, the
conversion routine converts @prev to unwritten and returns with @icur
pointing to @prev, not @del.  That's how we leak @del.

This patch fixes that by capping the conversion to the start of the
rtext alignment, which means that we can always merge with @del and
always return with @icur pointing at @del.  Ok, that's exactly what the
commit message says.

It was /really/ helpful to be able to use the test case to walk through
exactly what this patch is trying to fix.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +				mod = unwrite_start - prev.br_startoff;
> +				prev.br_startoff = unwrite_start;
> +				prev.br_startblock += mod;
> +				prev.br_blockcount -= mod;
>  				prev.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, whichfork, &icur, &cur,
> -- 
> 2.24.0
> 
