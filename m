Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2C1C2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87DA20770
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCJsguz6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764433AbgJXUcq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:32:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38232 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764432AbgJXUcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:32:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKWejK012918;
        Sat, 24 Oct 2020 20:32:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oNbB1lhq5OOiORZn4DOHyhh2m7rgBU4preXKUeioiVI=;
 b=pCJsguz6WNIgUfAslMLvVrv2gXjouW9coCtEaNef7qwwnNYpfMEnh7vSAp8WsMZil68u
 a+P9k1TOzWwDIQ69HAQN95+JeTKkTs+JrcNskxKmP3LEAsurCIkVdHJthY9dQcOpLDN9
 sACrdg4jdshZoqCmYpmAN9Wk444bcTLEzF4mNgSW/c7I5L3GW5wbtjdFzYDr5AmMoiVQ
 YlqFQw0tD3Wo13pN1pVBT7mH407L4BO3GgjS6ySMzJahNuVujueJdcAZ6TmDsHNA0sNb
 vEduDQvV2ArAcQqzQDSJRwEoIVNnceUd7JAOrT+JROR7osLwKIB5I0UFlGaTIk5BF43j eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kh34r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:32:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKTo71082628;
        Sat, 24 Oct 2020 20:32:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cc2ym6dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:32:40 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OKWbKu025980;
        Sat, 24 Oct 2020 20:32:37 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:32:36 -0700
Subject: Re: [PATCH V7 08/14] xfs: Check for extent overflow when remapping an
 extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-9-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9328a768-7add-8ad0-000e-66041c3b03ec@oracle.com>
Date:   Sat, 24 Oct 2020 13:32:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-9-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010240158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240158
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> Remapping an extent involves unmapping the existing extent and mapping
> in the new extent. When unmapping, an extent containing the entire unmap
> range can be split into two extents,
> i.e. | Old extent | hole | Old extent |
> Hence extent count increases by 1.
> 
> Mapping in the new extent into the destination file can increase the
> extent count by 1.
> 
Following the previous discussion threads, I do think that's easier to 
look at.  I know it's more LOC, but less jumping around to understand 
what it means :-)

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/xfs_reflink.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4f0198f636ad..856fe755a5e9 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1006,6 +1006,7 @@ xfs_reflink_remap_extent(
>   	unsigned int		resblks;
>   	bool			smap_real;
>   	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
> +	int			iext_delta = 0;
>   	int			nimaps;
>   	int			error;
>   
> @@ -1099,6 +1100,16 @@ xfs_reflink_remap_extent(
>   			goto out_cancel;
>   	}
>   
> +	if (smap_real)
> +		++iext_delta;
> +
> +	if (dmap_written)
> +		++iext_delta;
> +
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
> +	if (error)
> +		goto out_cancel;
> +
>   	if (smap_real) {
>   		/*
>   		 * If the extent we're unmapping is backed by storage (written
> 
