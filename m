Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D75C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290682067B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="svH5t2Rx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506123AbgJ0FwZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:52:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506115AbgJ0FwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 01:52:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5n0rV007978;
        Tue, 27 Oct 2020 05:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zaybOWQjlR/SmNKO7rp1bikrPrCmNqhUJQWDA024sxs=;
 b=svH5t2RxkwD2lrQdd+bfWwizSWxp5xVcWGm70jzArYkNcRw8PdVDGsQ8UfqYXrS9kel6
 NoRBDQhYUN23NLj62PdwHbqtPXJb0hw2DuSj+Ct3gu6Sz/BT4cnbFlH3LTsT43IXu4Qa
 DpYKVT+ThDUKL0/hZx1/Y0tB++zBnz/v/o0g/tKbSS66m0wypkvnzHC3/4kbbDsJmvUD
 dzc9yPl/AtyFTgHTWl9W5lWV/we4m9hlJNaolL9LJZiRutbN7pkn5qLRzQ4gqNrOea7l
 9yq9Pk+oxe0h/OjDJ9xFHaNd/bm5g5vKeNodzJfRcPhyuIp29Z4vuePqF5b69JhvtyJi Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kqyd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:52:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5oOtv033433;
        Tue, 27 Oct 2020 05:52:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwum04bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:52:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R5qK7a022914;
        Tue, 27 Oct 2020 05:52:21 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:52:20 -0700
Subject: Re: [PATCH 5/5] xfs_repair: correctly detect partially written
 extents
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375514426.879169.1166063350727282652.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <52750859-15e6-67f8-127d-f55c71781807@oracle.com>
Date:   Mon, 26 Oct 2020 22:52:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160375514426.879169.1166063350727282652.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/26/20 4:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Recently, I was able to create a realtime file with a 16b extent size
> and the following data fork mapping:
> 
> data offset 0 startblock 144 (0/144) count 3 flag 0
> data offset 3 startblock 147 (0/147) count 3 flag 1
> data offset 6 startblock 150 (0/150) count 10 flag 0
> 
> Notice how we have a written extent, then an unwritten extent, and then
> another written extent.  The current code in process_rt_rec trips over
> that third extent, because repair only knows not to complain about inuse
> extents if the mapping was unwritten.
> 
> This loop logic is confusing, because it tries to do too many things.
> Move the phase3 and phase4 code to separate helper functions, then
> isolate the code that handles a mapping that starts in the middle of an
> rt extent so that it's clearer what's going on.
> 
Ok, seems reasonable, though I think I might have hoisted one helper 
separately to make that a little easier to read through.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/dinode.c |  180 ++++++++++++++++++++++++++++++++++---------------------
>   1 file changed, 112 insertions(+), 68 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index c89f21e08373..028a23cd5c8c 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -176,76 +176,69 @@ verify_dfsbno_range(
>   
>   	return XR_DFSBNORANGE_VALID;
>   }
> +
>   static int
> -process_rt_rec(
> +process_rt_rec_dups(
>   	struct xfs_mount	*mp,
> -	struct xfs_bmbt_irec	*irec,
>   	xfs_ino_t		ino,
> -	xfs_rfsblock_t		*tot,
> -	int			check_dups)
> +	struct xfs_bmbt_irec	*irec)
>   {
> -	xfs_fsblock_t		b, lastb;
> +	xfs_fsblock_t		b;
>   	xfs_rtblock_t		ext;
> -	int			state;
> -	int			pwe;		/* partially-written extent */
>   
> -	/*
> -	 * check numeric validity of the extent
> -	 */
> -	if (!libxfs_verify_rtbno(mp, irec->br_startblock)) {
> -		do_warn(
> -_("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
> -			ino,
> -			irec->br_startblock,
> -			irec->br_startoff);
> -		return 1;
> -	}
> -
> -	lastb = irec->br_startblock + irec->br_blockcount - 1;
> -	if (!libxfs_verify_rtbno(mp, lastb)) {
> -		do_warn(
> -_("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
> -			ino,
> -			lastb,
> -			irec->br_startoff);
> -		return 1;
> -	}
> -	if (lastb < irec->br_startblock) {
> -		do_warn(
> -_("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
> -  "end %" PRIu64 ", offset %" PRIu64 "\n"),
> -			ino,
> -			irec->br_startblock,
> -			lastb,
> -			irec->br_startoff);
> -		return 1;
> -	}
> -
> -	/*
> -	 * set the appropriate number of extents
> -	 * this iterates block by block, this can be optimised using extents
> -	 */
> -	for (b = irec->br_startblock; b < irec->br_startblock +
> -			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
> +	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
> +	     b < irec->br_startblock + irec->br_blockcount;
> +	     b += mp->m_sb.sb_rextsize) {
>   		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
> -		pwe = irec->br_state == XFS_EXT_UNWRITTEN &&
> -				(b % mp->m_sb.sb_rextsize != 0);
> -
> -		if (check_dups == 1)  {
> -			if (search_rt_dup_extent(mp, ext) && !pwe)  {
> -				do_warn(
> +		if (search_rt_dup_extent(mp, ext))  {
> +			do_warn(
>   _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
> -  "off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
> -					ino,
> -					irec->br_startoff,
> -					irec->br_startblock,
> -					irec->br_blockcount);
> -				return 1;
> -			}
> -			continue;
> +"off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
> +				ino,
> +				irec->br_startoff,
> +				irec->br_startblock,
> +				irec->br_blockcount);
> +			return 1;
>   		}
> +	}
>   
> +	return 0;
> +}
> +
> +static int
> +process_rt_rec_state(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	xfs_fsblock_t		b = irec->br_startblock;
> +	xfs_rtblock_t		ext;
> +	int			state;
> +
> +	do {
> +		ext = (xfs_rtblock_t)b / mp->m_sb.sb_rextsize;
>   		state = get_rtbmap(ext);
> +
> +		if ((b % mp->m_sb.sb_rextsize) != 0) {
> +			/*
> +			 * We are midway through a partially written extent.
> +			 * If we don't find the state that gets set in the
> +			 * other clause of this loop body, then we have a
> +			 * partially *mapped* rt extent and should complain.
> +			 */
> +			if (state != XR_E_INUSE)
> +				do_error(
> +_("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d at rt block %"PRIu64"\n"),
> +					ino, ext, state, b);
> +			b = roundup(b, mp->m_sb.sb_rextsize);
> +			continue;
> +		}
> +
> +		/*
> +		 * This is the start of an rt extent.  Set the extent state if
> +		 * nobody else has claimed the extent, or complain if there are
> +		 * conflicting states.
> +		 */
>   		switch (state)  {
>   		case XR_E_FREE:
>   		case XR_E_UNKNOWN:
> @@ -253,32 +246,83 @@ _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
>   			break;
>   		case XR_E_BAD_STATE:
>   			do_error(
> -_("bad state in rt block map %" PRIu64 "\n"),
> +_("bad state in rt extent map %" PRIu64 "\n"),
>   				ext);
>   		case XR_E_FS_MAP:
>   		case XR_E_INO:
>   		case XR_E_INUSE_FS:
>   			do_error(
> -_("data fork in rt inode %" PRIu64 " found metadata block %" PRIu64 " in rt bmap\n"),
> +_("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt bmap\n"),
>   				ino, ext);
>   		case XR_E_INUSE:
> -			if (pwe)
> -				break;
> -			/* fall through */
>   		case XR_E_MULT:
>   			set_rtbmap(ext, XR_E_MULT);
>   			do_warn(
> -_("data fork in rt inode %" PRIu64 " claims used rt block %" PRIu64 "\n"),
> -				ino, ext);
> +_("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
> +				ino, b);
>   			return 1;
>   		case XR_E_FREE1:
>   		default:
>   			do_error(
> -_("illegal state %d in rt block map %" PRIu64 "\n"),
> -				state, b);
> +_("illegal state %d in rt extent %" PRIu64 "\n"),
> +				state, ext);
>   		}
> +		b += mp->m_sb.sb_rextsize;
> +	} while (b < irec->br_startblock + irec->br_blockcount);
> +
> +	return 0;
> +}
> +
> +static int
> +process_rt_rec(
> +	struct xfs_mount	*mp,
> +	struct xfs_bmbt_irec	*irec,
> +	xfs_ino_t		ino,
> +	xfs_rfsblock_t		*tot,
> +	int			check_dups)
> +{
> +	xfs_fsblock_t		lastb;
> +	int			bad;
> +
> +	/*
> +	 * check numeric validity of the extent
> +	 */
> +	if (!libxfs_verify_rtbno(mp, irec->br_startblock)) {
> +		do_warn(
> +_("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
> +			ino,
> +			irec->br_startblock,
> +			irec->br_startoff);
> +		return 1;
>   	}
>   
> +	lastb = irec->br_startblock + irec->br_blockcount - 1;
> +	if (!libxfs_verify_rtbno(mp, lastb)) {
> +		do_warn(
> +_("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
> +			ino,
> +			lastb,
> +			irec->br_startoff);
> +		return 1;
> +	}
> +	if (lastb < irec->br_startblock) {
> +		do_warn(
> +_("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
> +  "end %" PRIu64 ", offset %" PRIu64 "\n"),
> +			ino,
> +			irec->br_startblock,
> +			lastb,
> +			irec->br_startoff);
> +		return 1;
> +	}
> +
> +	if (check_dups)
> +		bad = process_rt_rec_dups(mp, ino, irec);
> +	else
> +		bad = process_rt_rec_state(mp, ino, irec);
> +	if (bad)
> +		return bad;
> +
>   	/*
>   	 * bump up the block counter
>   	 */
> 
