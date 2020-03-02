Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759D8C3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3252146E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XR0Og4v8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCBSMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:12:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:12:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hs4qI082916
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9++BR/uWD1YkZiyVtOOlmbmDTCY5yzuD4p0q/I0Z38I=;
 b=XR0Og4v8tyilNpukwSoel361C6Qd9qeGkanreG7KQGvkF8DXGRZLdt2QwSF9mP3ioPKM
 NgZJGQSp+sQwCJGHlezvrkeUd2Luh1NbFeNBxstuypKldtlpk5VvPL8bNambj+SL+2TI
 M+eRrDh0xDK/Lq/3TQ+mvrruzH6IkmiDld8jcJMdeenuowymrmaNg5YHNpIw21RUel06
 RZjiApd7/VJitirn9Flz30By8WnFrbu4Xu/iVgtMiXJDpSpb5hQfkHszbtuvTVd6o79s
 KiDDyFA+0G3bo9tTMFcpXq/KBnysihkslDb/4ez6f+hxg5cPkHXbNRzkBedoBintPdOF 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwqhdt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HqcEO062906
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yg1rg43ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 18:12:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 022IC1lp025046
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 18:12:02 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 10:11:55 -0800
Subject: Re: [PATCH 2/4] xfs: check owner of dir3 free blocks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092825.1729975.10937805307008830676.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <895a7804-a6c8-e1f0-a371-e6573ee2369c@oracle.com>
Date:   Mon, 2 Mar 2020 11:11:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294092825.1729975.10937805307008830676.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/20 6:48 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 free block headers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks fine:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index f622ede7119e..79b917e62ac3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -194,6 +194,8 @@ xfs_dir3_free_header_check(
>   			return __this_address;
>   		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
>   			return __this_address;
> +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> +			return __this_address;
>   	} else {
>   		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
>   
> 
