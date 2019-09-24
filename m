Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D11C432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 05:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 947E021655
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 05:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MxNDre3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405425AbfIXFrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 01:47:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34058 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405096AbfIXFrS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 01:47:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O5hxDW060029;
        Tue, 24 Sep 2019 05:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XDcmkM1E5isBLPPAW8y8PJE6NYOW0kghdu/e/YLyLfM=;
 b=MxNDre3nfqNtDQK48OD8ipoXX2YGgVPxBkT+Ws/dMro9HhWHC9H+qs89TlRMz7u70oPi
 XQN0OB8qE20Uh2TpKzuKl7+bpxID5l6OhWPCO2a3nDJzxW00ZC9/X7o/Dl1Pfsu7qtOJ
 MDeyevbGxeWpPhdIEwwDc2pLB0lkfhqFGFCdXToB2EElCwDH4voub2bxbjUHvVjLauBW
 5M5wf8mM2wz6gB92tpaGgzrOXblYgGvHjSWbxmc2h76nQvMS5rRJwwUWpeUWzC8IUq54
 cpilMAAQ72D3xou2qC4sOOXfY5EMciib3p7PiIZdTXmiRq7+eJLa23M8lehflkmFMaYK EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tkj4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 05:47:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O5hj7p090841;
        Tue, 24 Sep 2019 05:47:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v6yvpeu58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 05:47:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8O5l5t8015018;
        Tue, 24 Sep 2019 05:47:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 22:47:05 -0700
Date:   Mon, 23 Sep 2019 22:47:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: assure zeroed memory buffers for certain kmem
 allocations
Message-ID: <20190924054700.GX2229799@magnolia>
References: <20190916153504.30809-1-billodo@redhat.com>
 <20190919210138.13535-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919210138.13535-1-billodo@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240058
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 04:01:38PM -0500, Bill O'Donnell wrote:
> Guarantee zeroed memory buffers for cases where potential memory
> leak to disk can occur. In these cases, kmem_alloc is used and
> doesn't zero the buffer, opening the possibility of information
> leakage to disk.
> 
> Use existing infrastucture (xfs_buf_allocate_memory) to obtain
> the already zeroed buffer from kernel memory.
> 
> This solution avoids the performance issue that would occur if a
> wholesale change to replace kmem_alloc with kmem_zalloc was done.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v4: use __GFP_ZERO as part of gfp_mask (instead of KM_ZERO)
> v3: remove XBF_ZERO flag, and instead use XBF_READ flag only.
> v2: zeroed buffer not required for XBF_READ case. Correct placement
>     and rename the XBF_ZERO flag.
> 
>  fs/xfs/xfs_buf.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 120ef99d09e8..5d0a68de5fa6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -345,6 +345,15 @@ xfs_buf_allocate_memory(
>  	unsigned short		page_count, i;
>  	xfs_off_t		start, end;
>  	int			error;
> +	uint			kmflag_mask = 0;
> +
> +	/*
> +	 * assure zeroed buffer for non-read cases.
> +	 */
> +	if (!(flags & XBF_READ)) {
> +		kmflag_mask |= KM_ZERO;
> +		gfp_mask |= __GFP_ZERO;
> +	}

Jeez it feels grody to have to set two different flags variables just to
get __GFP_ZERO consistently but I'll run it through xfstests overnight.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	/*
>  	 * for buffers that are contained within a single page, just allocate
> @@ -354,7 +363,8 @@ xfs_buf_allocate_memory(
>  	size = BBTOB(bp->b_length);
>  	if (size < PAGE_SIZE) {
>  		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> -		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
> +		bp->b_addr = kmem_alloc_io(size, align_mask,
> +					   KM_NOFS | kmflag_mask);
>  		if (!bp->b_addr) {
>  			/* low memory - use alloc_page loop instead */
>  			goto use_alloc_page;
> -- 
> 2.21.0
> 
