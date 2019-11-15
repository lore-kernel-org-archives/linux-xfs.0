Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE224C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9005420732
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mALV6ZSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfKOTCs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 14:02:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfKOTCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 14:02:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFIn4g6056096;
        Fri, 15 Nov 2019 19:02:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pTQ8utc6uPQxVhYupJpeLh0Wg/6z2PhU41TxFxeWGQ8=;
 b=mALV6ZSG5KIIpSeVPPjgdNbvWts5I1Cug42eAyEr2oX2dKFarXr3p54vQHNdwb7uayJZ
 xaLjfTaOkowjqham8kvmO4YJC9lo4Don6Ykcij2V9NyTPOn4Ql8PV4zpRNAJhiLNJGdg
 iDnmDV96/XU3A7mwRkCtH2KPy5+dKGo/nhRh2W/4wdNhMj1e4LL2V1lOoJFpSDVAAR/0
 LqkGrCTyzKgmVtyWo+ZM6+sdY8XSZGU48ykO7ZsvQffraFWqhj1JnjfIOGyEDeRoh0W3
 tcQSNriMaMGqP1lwTCf72/ZAxiJZpC/j7mWGM47gPGAlkNnWY78Fon3E16RK02j8BO7I Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w9gxpn2ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 19:02:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAFJ0gSC002205;
        Fri, 15 Nov 2019 19:00:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w9h18gfbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Nov 2019 19:00:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAFIxuR0022647;
        Fri, 15 Nov 2019 18:59:56 GMT
Received: from localhost (/10.159.141.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Nov 2019 10:59:56 -0800
Date:   Fri, 15 Nov 2019 10:59:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix attr leaf header freemap.size underflow
Message-ID: <20191115185955.GP6219@magnolia>
References: <20191115114137.55415-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115114137.55415-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9442 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9442 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 06:41:37AM -0500, Brian Foster wrote:
> The leaf format xattr addition helper xfs_attr3_leaf_add_work()
> adjusts the block freemap in a couple places. The first update drops
> the size of the freemap that the caller had already selected to
> place the xattr name/value data. Before the function returns, it
> also checks whether the entries array has encroached on a freemap
> range by virtue of the new entry addition. This is necessary because
> the entries array grows from the start of the block (but end of the
> block header) towards the end of the block while the name/value data
> grows from the end of the block in the opposite direction. If the
> associated freemap is already empty, however, size is zero and the
> subtraction underflows the field and causes corruption.
> 
> This is reproduced rarely by generic/070. The observed behavior is
> that a smaller sized freemap is aligned to the end of the entries
> list, several subsequent xattr additions land in larger freemaps and
> the entries list expands into the smaller freemap until it is fully
> consumed and then underflows. Note that it is not otherwise a
> corruption for the entries array to consume an empty freemap because
> the nameval list (i.e. the firstused pointer in the xattr header)
> starts beyond the end of the corrupted freemap.
> 
> Update the freemap size modification to account for the fact that
> the freemap entry can be empty and thus stale.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hm.  freemap.size == 0 means the freemap entry is stale and therefore
anything looking for free space in the leaf will ignore the entry, right?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Urk, there are still a lot of ASSERT-on-metadata in the dir/attr
code...)

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 85ec5945d29f..86155260d8b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1510,7 +1510,9 @@ xfs_attr3_leaf_add_work(
>  	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
>  		if (ichdr->freemap[i].base == tmp) {
>  			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
> -			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);
> +			ichdr->freemap[i].size -=
> +				min_t(uint16_t, ichdr->freemap[i].size,
> +						sizeof(xfs_attr_leaf_entry_t));
>  		}
>  	}
>  	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
> -- 
> 2.20.1
> 
