Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1F1C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3FD2072A
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:28:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a1rsZy3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgD1W2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:28:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39394 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1W2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:28:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMNF9E093407;
        Tue, 28 Apr 2020 22:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EBDXN7PXZ0tkqi/WbFbfC6XgyuD4CBQltmeivLz/iD4=;
 b=a1rsZy3sQKg/6hKJe1qGelzdC57xIiWaXeIulYse0UGQwyUa8khUicYWRhHNpiXdK1Yu
 k3IuK/+8XkwJ392lneCgImYCMu0+Vw0d8tjWfHaZ4Zw3N2/6id7sN6ZJaREeLqKLl/+h
 xdBWtGQTDNzC7YkZiNJJDBwignvpvetU5lTewCrP0YQQAj1b6jJU35R/GEp7iUEP90tC
 J4tqr6a7AOMtxDdIYf2wdo5OanO9i6LHp9bfzhEXIJ3fGorjt0gVw3Tc/VlQOl1ur9O0
 PcZGPwwnKJIbX47JygYsgKW1JsnVbBNAslG5epA5oWfBdogZFE1asw84EBFq9fF3ikds Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30p01ns7dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:28:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMS4Ot133341;
        Tue, 28 Apr 2020 22:28:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30mxrtkpnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:28:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMSSlN024744;
        Tue, 28 Apr 2020 22:28:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:28:28 -0700
Date:   Tue, 28 Apr 2020 15:28:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/19] xfs: refactor log recovery
Message-ID: <20200428222827.GK6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <20200428062242.GB18850@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428062242.GB18850@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 11:22:42PM -0700, Christoph Hellwig wrote:
> With all patches applied we can also drop several includes in
> xfs_log_recovery.c:

Heh, neat, I'll add that somewhere.

--D

> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b210457d6ba23..9250c29193a71 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -18,21 +18,13 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_extfree_item.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
> -#include "xfs_quota.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> -#include "xfs_bmap_btree.h"
>  #include "xfs_error.h"
> -#include "xfs_dir2.h"
> -#include "xfs_rmap_item.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_refcount_item.h"
> -#include "xfs_bmap_item.h"
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
