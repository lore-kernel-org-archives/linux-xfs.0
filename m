Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F80EC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D8C24655
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UjjufMWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgAUSg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:36:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAUSg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:36:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISs3j170880;
        Tue, 21 Jan 2020 18:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FroLkC4eUsXqcg//OWiyr93P7EIFgX704znAIjnbP4A=;
 b=UjjufMWn1ch59uHGz7UXr8SRrRTk9XvGLufQaaz0p8Cv00c/jWVnLo4kI9j+aR2PyF/A
 V5TNJFZ92EQpepQXr8pEoZQ2Pp1W7kp/Unn5uQdp/qaM34RNBLBxDq3UWuV4f5nBD6bt
 bLbGlT/71Bdp13ChOBsdeGbDg4C6FuUzSQnGGmp+q4KHgJ1yF5jllCn9+Q4I2U66gi6p
 jXhAigD4N/3rG5HiQ3JXREpbasW266af5y8onmCfUbr7mNr1fI+/U6Hdfufp+IEmpN7R
 rN7GAS36mvZ9eHshSNSlYLZOkeCkIcFY1WFK/rV7OMmgP7OmbsNmPTjesy4S+c201Gjk 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq6xwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:36:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LIT0e8086800;
        Tue, 21 Jan 2020 18:36:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xnpefc0u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:36:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIaN8B001039;
        Tue, 21 Jan 2020 18:36:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:36:22 -0800
Date:   Tue, 21 Jan 2020 10:36:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 19/29] xfs: replace ATTR_ENTBASESIZE with offsetoff
Message-ID: <20200121183621.GS8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-20-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-20-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=836
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=898 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:41AM +0100, Christoph Hellwig wrote:
> Replace an opencoded offsetof with the actual helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_list.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 9c4acb6dc856..7f08e417d131 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -545,10 +545,9 @@ xfs_attr_list_int(
>  	return error;
>  }
>  
> -#define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
> -	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
>  #define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
> -	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
> +	((offsetof(struct attrlist_ent, a_name) + \
> +	 (namelen) + 1 + sizeof(uint32_t) - 1) \
>  	 & ~(sizeof(uint32_t)-1))

This looks like an open-coded round_up(), doesn't it?  Or roundup(), I
can't remember which is which. :?

--D

>  
>  /*
> -- 
> 2.24.1
> 
