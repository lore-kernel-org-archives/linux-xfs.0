Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BA5C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1413205CB
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 16:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YsUvFx5K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbgGMQVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:21:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgGMQVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 12:21:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DG2urb173867;
        Mon, 13 Jul 2020 16:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BbaUJws6Rlg66c4q9DxSRk4zooNcJ0is9UNr8Ht8PSY=;
 b=YsUvFx5Kr1F9M2nmjD8RkN5EXaIcISdW/OF9zrIWUhVa2S7HQjo+GO1dWIAKofYag41u
 +kI4bxmKc+TDQpeJtZ4oZxY/RWwzd3t/y3AEb5M7KE2PXhDuBAX0qZadQBcZy16SUYSy
 yjIPri8VTCccfaboZwEdTBRkT+uy16Lr41SeH/N81IARionu5bzhEQWBGyVXbXS6kcrK
 jj15gpaLnI6HAArXxmRWTf4lvfFsYIUNx4NzKgyiFwuir8eKqAsWrW/sj5gYc2kU6uF+
 JETZcjHyAdaBucxIgRJsafFLvIdJxHMALG698nVKtGT+lhmExt3XCpIJbKGHJwzzivjd Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cm01a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 16:21:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DGJXXe023206;
        Mon, 13 Jul 2020 16:21:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0mjq00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 16:21:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DGKxbV017424;
        Mon, 13 Jul 2020 16:20:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 09:20:59 -0700
Date:   Mon, 13 Jul 2020 09:20:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove SYNC_WAIT and SYNC_TRYLOCK
Message-ID: <20200713162058.GY7606@magnolia>
References: <20200710054652.353008-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710054652.353008-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 05:46:52AM +0000, Christoph Hellwig wrote:
> These two definitions are unused now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index ae92ca53de423f..3a4c8b382cd0fe 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -17,9 +17,6 @@ struct xfs_eofblocks {
>  	__u64		eof_min_file_size;
>  };
>  
> -#define SYNC_WAIT		0x0001	/* wait for i/o to complete */
> -#define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
> -
>  /*
>   * tags for inode radix tree
>   */
> -- 
> 2.26.2
> 
