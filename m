Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F36FC4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6039A20673
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9ElxZq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfJDXkB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 19:40:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 19:40:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Ncx3e076238;
        Fri, 4 Oct 2019 23:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=raJbb/hjWh7KE/pZm9gyNzp3QKmmv05HNCwHVXgqtKM=;
 b=S9ElxZq0XvioKhieaOAf8+fJLyANDqyAxlY7zjb0npg7QYBwdwZmP6XfzE6+LuaCGFU7
 K8maFu7k75ckBQiYmw9O471pPU+H1VVemAu5euGh9SkjsGFAYBirQMC+8eCQTeQ4Q8SI
 +ugxV/3soBIv+gDOCY3I13bj6T7UZV8RlMupGlo+FIRoPBUs7uEywX2Wu6BEoHVXhsEx
 pZLv4UM9K9NtOpeXrOudWYMgTVzdD851F31aK7fFvK7eXGv/BQffPZEFTMW6N/1Ky1+M
 z3rjBC0y+Pj4COYIas3lBZarGUWHrgFaNU0JHLHeF4Y3Nl/Ry8BQ0AQAVIdtH8Hq5nx4 nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05seawk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 23:39:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Nd6xJ033013;
        Fri, 4 Oct 2019 23:39:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vdxu9nvk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 23:39:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94NdlMP018744;
        Fri, 4 Oct 2019 23:39:48 GMT
Received: from localhost (/10.159.134.51) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Fri, 04 Oct 2019 16:38:25 -0700
USER-AGENT: Mutt/1.9.4 (2018-02-28)
MIME-Version: 1.0
Message-ID: <20191004233824.GO13108@magnolia>
Date:   Fri, 4 Oct 2019 16:38:24 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] xfs: assure zeroed memory buffers for certain kmem
 allocations
References: <20191004194640.17511-1-billodo@redhat.com>
In-Reply-To: <20191004194640.17511-1-billodo@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 04, 2019 at 02:46:40PM -0500, Bill O'Donnell wrote:
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
> 
> v5: apply KM_ZERO for kmem_alloc_io calls in xfs_log.c and xfs_log_recover.c
> v4: use __GFP_ZERO as part of gfp_mask (instead of KM_ZERO)
> v3: remove XBF_ZERO flag, and instead use XBF_READ flag only.
> v2: zeroed buffer not required for XBF_READ case. Correct placement
>     and rename the XBF_ZERO flag.
> 
>  fs/xfs/xfs_buf.c         | 12 +++++++++++-
>  fs/xfs/xfs_log.c         |  2 +-
>  fs/xfs/xfs_log_recover.c |  2 +-
>  3 files changed, 13 insertions(+), 3 deletions(-)
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
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2beee9f74da..641d07f30a27 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1443,7 +1443,7 @@ xlog_alloc_log(
>  		prev_iclog = iclog;
>  
>  		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
> -						KM_MAYFAIL);
> +						KM_MAYFAIL | KM_ZERO);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 508319039dce..c1a514ffff55 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -127,7 +127,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL);
> +	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);

Most of the xlog_alloc_buffer callers are reading things from disk
looking for log items to replay.  The only caller that actually writes
anything to disk is xlog_clear_stale_blocks?

I suspect we only need KM_ZERO for that one case, but OTOH I suppose log
recovery should be infrequent, so better safe than sorry...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  }
>  
>  /*
> -- 
> 2.21.0
> 
