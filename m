Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE03CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19A321835
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kutNgclu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgAUSdz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:33:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbgAUSdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:33:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISNZT170451;
        Tue, 21 Jan 2020 18:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9KX3ixs+Flyd/ELSA/LJwK8uFsd1B0hmOjlL0CKFGiA=;
 b=kutNgclubdN+ep3uRXudwF5FbY/t8VsgjdvPIfSVsDNVF+2zmnwWV/qKY29P3XIWhmpP
 6VDqleSlbMlZ/yUXVGFSKcgz/A3mM64dllz7R155iLjsXmtsMmxhHLh8ntIsPvKbKzWB
 t22LXSHBx7ILXXPftjmvhtn+z8lPDhqdtSQJv2fu964sSAJmn6heS3GFHWZ0PKx2chPl
 aeq/hQnLJuwAS76RdD3p21skasJwXbXWGJ2ZHRWH8P8LyoVV6V8bzMJbG6ZkCZ3BR1v7
 k8XyGODeyu52u3kmN1sw64HiD1sSbg7QJQyQKa1qnrVQop96yZRaYiv2d/AMDKOuOoVP dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xksyq6xgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:33:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISwgF086625;
        Tue, 21 Jan 2020 18:33:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xnpefbv1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:33:51 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIXodq027068;
        Tue, 21 Jan 2020 18:33:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:33:50 -0800
Date:   Tue, 21 Jan 2020 10:33:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 18/29] xfs: remove the unused ATTR_ENTRY macro
Message-ID: <20200121183349.GR8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-19-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:40AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0c8f7c7a6b65..31c0ffde4f59 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -69,14 +69,6 @@ typedef struct attrlist_ent {	/* data from attr_list() */
>  	char	a_name[1];	/* attr name (NULL terminated) */
>  } attrlist_ent_t;
>  
> -/*
> - * Given a pointer to the (char*) buffer containing the attr_list() result,
> - * and an index, return a pointer to the indicated attribute in the buffer.
> - */
> -#define	ATTR_ENTRY(buffer, index)		\
> -	((attrlist_ent_t *)			\
> -	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
> -
>  /*
>   * Kernel-internal version of the attrlist cursor.
>   */
> -- 
> 2.24.1
> 
