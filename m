Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8DCCA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 15:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6AD20873
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 15:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlCRNBFL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfJUPqF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 11:46:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJUPqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 11:46:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LFdPZ4109460;
        Mon, 21 Oct 2019 15:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EqC7zEOe40rZBcleGFFPg6lGt8NIVDWTp9WD6qpdTLM=;
 b=QlCRNBFL8m0fliL0ZYWZrChXREK36K3DKrMDfbPHVxXWHbQ8KqYnqrWzAbtECwb0B4HC
 2cUUciJuXOd04omnqzZ3pE/aaMOEsudpUBsTLn0jqq6bo5uydqL3A7oNB/9Fb6LKKAaI
 Qho2l0Wuc7dp1ORLReVTG7xd8dmDYAngHb8jEoDa27Vq99nls9DFOrS0ud8DThC/VnEG
 qA/PNAhCyd5aNX6HuydRP0bx52m6UaEs9vbdvSMevYczIaAMBCCj/dITGHRtVXHUUoGH
 XG0UJSDTmvhS4ByVpSqn9mAvjI7g7ehK2Z6oVZWI3IaaX4vQhdqI0klQ6Nsj+Prs0ydG RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vqtepgkf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 15:45:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LFi8rF023604;
        Mon, 21 Oct 2019 15:45:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vrbyywjdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 15:45:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LFjvVu025451;
        Mon, 21 Oct 2019 15:45:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 08:45:57 -0700
Date:   Mon, 21 Oct 2019 08:45:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix sparse warning on allocation cursor
 initialization
Message-ID: <20191021154556.GE6719@magnolia>
References: <201910200432.0NRV75fO%lkp@intel.com>
 <20191021131404.30089-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021131404.30089-1-bfoster@redhat.com>
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
 definitions=main-1910210148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 09:14:04AM -0400, Brian Foster wrote:
> sparse complains about the initialization used for the allocation
> cursor:
> 
> >> fs/xfs/libxfs/xfs_alloc.c:1170:41: sparse: sparse: Using plain integer as NULL pointer
> 
> Fix it by removing the unnecessary initialization value.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, though I have to rebase the iomap / xfs branches anyway so I
might apply this to the original patch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e9f74eb92073..925eba9489d5 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1471,7 +1471,7 @@ STATIC int
>  xfs_alloc_ag_vextent_near(
>  	struct xfs_alloc_arg	*args)
>  {
> -	struct xfs_alloc_cur	acur = {0,};
> +	struct xfs_alloc_cur	acur = {};
>  	int			error;		/* error code */
>  	int			i;		/* result code, temporary */
>  	xfs_agblock_t		bno;
> -- 
> 2.20.1
> 
