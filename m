Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759EEC2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 14:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39DEE20678
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 14:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgDHOvg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 10:51:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726709AbgDHOvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 10:51:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038EY6eM195198
        for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2020 10:51:34 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30920rqbwg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 10:51:34 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 8 Apr 2020 15:51:20 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 15:51:17 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 038EpT0O19005566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 14:51:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31B2AAE053;
        Wed,  8 Apr 2020 14:51:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88AD4AE045;
        Wed,  8 Apr 2020 14:51:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 14:51:28 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: acquire superblock freeze protection on eofblocks scans
Date:   Wed, 08 Apr 2020 20:24:32 +0530
Organization: IBM
In-Reply-To: <20200408122119.33869-1-bfoster@redhat.com>
References: <20200408122119.33869-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040814-0012-0000-0000-000003A0BE09
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040814-0013-0000-0000-000021DDE38D
Message-Id: <1766321.ayRgbaHikr@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, April 8, 2020 5:51 PM Brian Foster wrote: 
> The filesystem freeze sequence in XFS waits on any background
> eofblocks or cowblocks scans to complete before the filesystem is
> quiesced. At this point, the freezer has already stopped the
> transaction subsystem, however, which means a truncate or cowblock
> cancellation in progress is likely blocked in transaction
> allocation. This results in a deadlock between freeze and the
> associated scanner.
> 
> Fix this problem by holding superblock write protection across calls
> into the block reapers. Since protection for background scans is
> acquired from the workqueue task context, trylock to avoid a similar
> deadlock between freeze and blocking on the write lock.

|-------------------------------------+---------------------------------|
| fsfreeze                            | eof blocks reaper               |
|-------------------------------------+---------------------------------|
| Set sb frozen state to SB_FREEZE_FS |                                 |
|                                     | Start periodic execution        |
|                                     | xfs_trans_alloc()               |
|                                     | - sb_start_intwrite()           |
|                                     |   Wait for frozen state to      |
|                                     |   return to < SB_UNFROZEN state |
| xfs_stop_block_reaping()            |                                 |
| - Wait for eof worker to finish     |                                 |
|-------------------------------------+---------------------------------|

If we add a blocking lock invocation at the beginning of eof blocks reaper,
then fsfreeze would get blocked at cancel_delayed_work_sync().

However using a trylock, "eof blocks reaper" would return back due to failure
in obtaining the lock and hence it is guaranteed that fsfreeze will make progress.

Hence the changes are logically correct.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> 
> Fixes: d6b636ebb1c9f ("xfs: halt auto-reclamation activities while rebuilding rmap")
> Reported-by: Paul Furtado <paulfurtado91@gmail.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Note that this has the opposite tradeoff as the approach I originally
> posited [1], specifically that the eofblocks ioctl() now always blocks
> on a frozen fs rather than return -EAGAIN. It's worth pointing out that
> the eofb control structure has a sync flag (that is not used for
> background scans), so yet another approach could be to tie the trylock
> to that.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20200407163739.GG28936@bfoster/
> 
>  fs/xfs/xfs_icache.c | 10 ++++++++++
>  fs/xfs/xfs_ioctl.c  |  5 ++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a7be7a9e5c1a..8bf1d15be3f6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -911,7 +911,12 @@ xfs_eofblocks_worker(
>  {
>  	struct xfs_mount *mp = container_of(to_delayed_work(work),
>  				struct xfs_mount, m_eofblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>  	xfs_icache_free_eofblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>  	xfs_queue_eofblocks(mp);
>  }
>  
> @@ -938,7 +943,12 @@ xfs_cowblocks_worker(
>  {
>  	struct xfs_mount *mp = container_of(to_delayed_work(work),
>  				struct xfs_mount, m_cowblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>  	xfs_icache_free_cowblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>  	xfs_queue_cowblocks(mp);
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cdfb3cd9a25b..309958186d33 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2363,7 +2363,10 @@ xfs_file_ioctl(
>  		if (error)
>  			return error;
>  
> -		return xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_start_write(mp->m_super);
> +		error = xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_end_write(mp->m_super);
> +		return error;
>  	}
>  
>  	default:
> 


-- 
chandan



