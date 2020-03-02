Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A2DC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C754722B48
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 17:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HPQH4vw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCBRoG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 12:44:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgCBRoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 12:44:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hi4r6074008
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LQV85LEXDbAf8Fp5vLIH3C309akZcQlnhMON/rUJhtg=;
 b=HPQH4vw84lomkd94LRCVW8fcJT/k2OVCHnwxJlJnpVnLv+4yBsUTCCNYyJkKmqVkGBUM
 myI+KoxLsQI54QLUwfL6z7uiOit3JuLLu8y6kyPAbHqzauY3m7FuNiC7f82U6b3+VAgH
 pVLmhVLi8ht9+cFLKrj5NG4UeD/XT6SU7sTpGudnCZ42K+29UVAea8QSZGcPcHu2NtpU
 KuiDi9W5s7ERb2B7612k3tvRpKLnL8lp1bwHR2xHPI6RATfGjkVPyXlaiOwOSPagyJ+l
 10ktu0Qz5SB0pGDe+msFHF2R6c/bzOeboPz50TI7+Sy73mwQZwAp/CM/NovR5W7nbdQ5 nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwqh8s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:44:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hgmcp185763
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yg1rg12tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2020 17:44:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 022Hi3mC013561
        for <linux-xfs@vger.kernel.org>; Mon, 2 Mar 2020 17:44:03 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 09:44:03 -0800
Subject: Re: [PATCH 2/3] xfs: mark extended attr corrupt when lookup-by-hash
 fails
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158294094367.1730101.10848559171120744339.stgit@magnolia>
 <158294095587.1730101.1908515041366122931.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <80415cd3-b7ec-665a-29fa-6f18d5f04744@oracle.com>
Date:   Mon, 2 Mar 2020 10:44:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158294095587.1730101.1908515041366122931.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/20 6:49 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_xattr_listent, we attempt to validate the extended attribute
> hash structures by performing a attr lookup by (hashed) name.  If the
> lookup returns ENODATA, that means that the hash information is corrupt.
> The _process_error functions don't catch this, so we have to add that
> explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks good:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/scrub/attr.c |    5 +++++
>   1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index d9f0dd444b80..54ea1efa7ddc 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -163,6 +163,11 @@ xchk_xattr_listent(
>   	args.valuelen = valuelen;
>   
>   	error = xfs_attr_get_ilocked(context->dp, &args);
> +	if (error == -ENODATA) {
> +		/* ENODATA means the hash lookup failed and the attr is bad */
> +		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
> +		goto fail_xref;
> +	}
>   	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
>   			&error))
>   		goto fail_xref;
> 
