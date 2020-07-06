Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B46C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 22:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D037A20723
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 22:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i9nMp9cC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGFWxz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 18:53:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFWxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 18:53:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066MqGSr055551;
        Mon, 6 Jul 2020 22:53:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dEEv+4lFJSBiyCn9U4jgblzJFLEzmhXtsY1W/sk/ppI=;
 b=i9nMp9cCuoTNtR/q6IdxUc7HRiqINuxeuIFWfZaX9uxW4OOeYk5uI9TrakoUguD2Io85
 3v+9bBo9pw6qt2/SWL1wahHguh5MCVs4CO3q//b6xjr85OpLRgozKDnWDaPHnz+jVrDD
 Y9tgOP+IQS/QMcE5ywOp6K8Hx1Gwh4MXWuGi6OHnh9FOqKc1Ny97UyNIehFQLdD5ZXr7
 FmmxRTvtnDVRTd5DRu4V+M7Qox2WtqXgdls6wfQYarptEJvrTXEGa5KwBJ2++M/yWQP2
 Qh7nnyeV/kB5wD4eJIDAkKyB/rk7yLyc+2up7VZ9dO3DfrXyedhlLNS2cxjoSm3FAVk2 5A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 323wacd1dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 06 Jul 2020 22:53:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066Mn9lJ125805;
        Mon, 6 Jul 2020 22:53:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3233bn5wnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jul 2020 22:53:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 066MrpL1015207;
        Mon, 6 Jul 2020 22:53:51 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jul 2020 15:53:51 -0700
Subject: Re: [PATCH 2/3] xfs_repair: simplify free space btree calculations in
 init_freespace_cursors
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <159370361029.3579756.1711322369086095823.stgit@magnolia>
 <159370362331.3579756.9359456822795462355.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <21f5265f-7fa6-bb3a-783b-8fa455f0120e@oracle.com>
Date:   Mon, 6 Jul 2020 15:53:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159370362331.3579756.9359456822795462355.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9674 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0 cotscore=-2147483648
 suspectscore=2 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007060157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/2/20 8:27 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a summary variable to the bulkload structure so that we can track
> the number of blocks that have been reserved for a particular (btree)
> bulkload operation.  Doing so enables us to simplify the logic in
> init_freespace_cursors that deals with figuring out how many more blocks
> we need to fill the bnobt/cntbt properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Alrighty, looks good
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   repair/agbtree.c  |   33 +++++++++++++++++----------------
>   repair/bulkload.c |    2 ++
>   repair/bulkload.h |    3 +++
>   3 files changed, 22 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/repair/agbtree.c b/repair/agbtree.c
> index 339b1489..de8015ec 100644
> --- a/repair/agbtree.c
> +++ b/repair/agbtree.c
> @@ -217,8 +217,6 @@ init_freespace_cursors(
>   	struct bt_rebuild	*btr_bno,
>   	struct bt_rebuild	*btr_cnt)
>   {
> -	unsigned int		bno_blocks;
> -	unsigned int		cnt_blocks;
>   	int			error;
>   
>   	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
> @@ -244,9 +242,7 @@ init_freespace_cursors(
>   	 */
>   	do {
>   		unsigned int	num_freeblocks;
> -
> -		bno_blocks = btr_bno->bload.nr_blocks;
> -		cnt_blocks = btr_cnt->bload.nr_blocks;
> +		int		delta_bno, delta_cnt;
>   
>   		/* Compute how many bnobt blocks we'll need. */
>   		error = -libxfs_btree_bload_compute_geometry(btr_bno->cur,
> @@ -262,25 +258,30 @@ _("Unable to compute free space by block btree geometry, error %d.\n"), -error);
>   			do_error(
>   _("Unable to compute free space by length btree geometry, error %d.\n"), -error);
>   
> +		/*
> +		 * Compute the deficit between the number of blocks reserved
> +		 * and the number of blocks we think we need for the btree.
> +		 */
> +		delta_bno = (int)btr_bno->newbt.nr_reserved -
> +				 btr_bno->bload.nr_blocks;
> +		delta_cnt = (int)btr_cnt->newbt.nr_reserved -
> +				 btr_cnt->bload.nr_blocks;
> +
>   		/* We don't need any more blocks, so we're done. */
> -		if (bno_blocks >= btr_bno->bload.nr_blocks &&
> -		    cnt_blocks >= btr_cnt->bload.nr_blocks)
> +		if (delta_bno >= 0 && delta_cnt >= 0) {
> +			*extra_blocks = delta_bno + delta_cnt;
>   			break;
> +		}
>   
>   		/* Allocate however many more blocks we need this time. */
> -		if (bno_blocks < btr_bno->bload.nr_blocks)
> -			reserve_btblocks(sc->mp, agno, btr_bno,
> -					btr_bno->bload.nr_blocks - bno_blocks);
> -		if (cnt_blocks < btr_cnt->bload.nr_blocks)
> -			reserve_btblocks(sc->mp, agno, btr_cnt,
> -					btr_cnt->bload.nr_blocks - cnt_blocks);
> +		if (delta_bno < 0)
> +			reserve_btblocks(sc->mp, agno, btr_bno, -delta_bno);
> +		if (delta_cnt < 0)
> +			reserve_btblocks(sc->mp, agno, btr_cnt, -delta_cnt);
>   
>   		/* Ok, now how many free space records do we have? */
>   		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
>   	} while (1);
> -
> -	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
> -			(cnt_blocks - btr_cnt->bload.nr_blocks);
>   }
>   
>   /* Rebuild the free space btrees. */
> diff --git a/repair/bulkload.c b/repair/bulkload.c
> index 81d67e62..8dd0a0c3 100644
> --- a/repair/bulkload.c
> +++ b/repair/bulkload.c
> @@ -40,6 +40,8 @@ bulkload_add_blocks(
>   	resv->len = len;
>   	resv->used = 0;
>   	list_add_tail(&resv->list, &bkl->resv_list);
> +	bkl->nr_reserved += len;
> +
>   	return 0;
>   }
>   
> diff --git a/repair/bulkload.h b/repair/bulkload.h
> index 01f67279..a84e99b8 100644
> --- a/repair/bulkload.h
> +++ b/repair/bulkload.h
> @@ -41,6 +41,9 @@ struct bulkload {
>   
>   	/* The last reservation we allocated from. */
>   	struct bulkload_resv	*last_resv;
> +
> +	/* Number of blocks reserved via resv_list. */
> +	unsigned int		nr_reserved;
>   };
>   
>   #define for_each_bulkload_reservation(bkl, resv, n)	\
> 
