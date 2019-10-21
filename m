Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A16CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 15:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06769214B2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 15:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sSnu6fRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfJUPuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:50:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbfJUPuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 11:50:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LFn0xT134739;
        Mon, 21 Oct 2019 15:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3nKw2vb9K0DC+0si25BRGV7ecdzqOBXpp9iLbHrR0tM=;
 b=sSnu6fRDtcVUsYT8qVUYXkf5ms8TxXZPlBVqwWfzdEdw6oB/js143CBB+5LHYXWW/WDh
 1o1nqM4NmIgnWoByVsPYLpA5h3n4/CL0AJo0N76Ea+XmoyorW8P1eTObHG/IoajT2dkQ
 G+kSNI5KBE6l9YmPPSoKY5u1nhmp3n96qdzXvD7Etpe8koWz1LRcFiJaLm/RBjk0hK6X
 5eMim1cY+ph9ed4bwSSJmbXz1qjOnkL3r/I7OlGcxMUB0cyCHnsMeTDfA6XS3EZfCG4G
 JoWMtFUafmpPfbBRGzlvGL/Dz8cD6naXnALKRHkzUVfbEbNCmBkvQN04ykD/XNKfvScv MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswt8q57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 15:49:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LFi7b2023528;
        Mon, 21 Oct 2019 15:47:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vrbyywmss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 15:47:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LFl6FQ029736;
        Mon, 21 Oct 2019 15:47:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 08:47:06 -0700
Date:   Mon, 21 Oct 2019 08:47:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: remove the duplicated inode log fieldmask set
Message-ID: <20191021154705.GF6719@magnolia>
References: <8df3c417-4fb2-f37b-6f27-3df069903c08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8df3c417-4fb2-f37b-6f27-3df069903c08@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 05:32:43PM +0800, kaixuxia wrote:
> The xfs_bumplink() call has set the inode log fieldmask XFS_ILOG_CORE,
> so the next xfs_trans_log_inode() call is not necessary.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b26..b0c81f1d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3327,7 +3327,6 @@ struct xfs_iunlink {
>  			goto out_trans_cancel;
>  
>  		xfs_bumplink(tp, wip);
> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>  	}
>  
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
