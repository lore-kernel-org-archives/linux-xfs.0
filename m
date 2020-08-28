Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D290C433E7
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 06:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E85D20CC7
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 06:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L4Lu1nt5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgH1GJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 02:09:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgH1GJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 02:09:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S63wU0146406;
        Fri, 28 Aug 2020 06:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EG7+UOZfXI41WAzvC7Y90pDEt8LWAcvCr+e00A2oFVI=;
 b=L4Lu1nt5jxuNCCiubCYdwij/70bXLjDf/XI9kEgyqZqEUezO6nQdXD56I/4WlQrrBJDp
 jLMr3bdmGsuy7bdRMMTaPLrwbo3LlZRLyKcdxwU5HQl3EoRMd5nLyZMraL6SrodclSou
 nhXd/8+kdPEP5vO1AFcCyr2GdkG9KA7f7MT0LAt3H/OcvA/1eZHZOZiGjLHaQPZRJWEq
 DdbqXXT8SEPtazs9qfyrUmB5pOwOiqbuLijUDICfwdcPZsxSDN8frcgKBmQZZ9GLu7a+
 q9ja1lnaZosvFHi9LBmlbP7cb1N8ifutVBvxhyorDQw2XXGsWKfKSObt7FPZu0r3OnrH sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbsa50h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 06:09:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S64kvf040766;
        Fri, 28 Aug 2020 06:09:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 333ru2cs5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 06:09:03 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S692th005137;
        Fri, 28 Aug 2020 06:09:02 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 23:09:02 -0700
Subject: Re: [PATCH 11/11] xfs: enable big timestamps
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847956949.2601708.15618175960582121127.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c4b4d27a-4643-c53d-d997-56a73c158a51@oracle.com>
Date:   Thu, 27 Aug 2020 23:09:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847956949.2601708.15618175960582121127.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the big timestamp feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_format.h |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9cf84b57e2ce..4ba92b8fb0a7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -471,7 +471,8 @@ xfs_sb_has_ro_compat_feature(
>   #define XFS_SB_FEAT_INCOMPAT_ALL \
>   		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>   		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> +		 XFS_SB_FEAT_INCOMPAT_BIGTIME)
>   
>   #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>   static inline bool
> 
