Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F884C18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F5E2071C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 15:14:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xSxws0/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgCPPOF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:14:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731673AbgCPPOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 11:14:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GF8vaR009409;
        Mon, 16 Mar 2020 15:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PfuXV2WSWirnO0iZC3JC3J2zlKRDgxKzqj3WLVShSSY=;
 b=xSxws0/s8IwCRtA3eGmVgeSw8aehmI/ohBOrT0VkPLTgvQFgH2fplyD+0AR7UppvSddG
 UkVtD6w24B38mF0HcssMusWTYiN1AC60trPJxJP0SHT5tlY0EUj8cNVOmIrs/6tJXJjN
 Lx3y5L2ZViMhnlFjitXCFjXiyMEeNBKDKgnErnD2cnXHocPSTzimsgnSLTmbGoiN8sua
 wnSKCX0IyIqpCK9zlUP/4JEuSaHuvqrSOKaSyK8RL/qnRC+jARBmjy9JvJetzbmLV9De
 CYKVhif682ZQiRQWRjSxP6+57bqbQOhv/zFvvVMezUeCb1QEMEVMQoD925fM8mLiaDGH hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yrppqyj1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:13:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GF2kqx010847;
        Mon, 16 Mar 2020 15:13:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ys8tpx342-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 15:13:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GFDDLc021107;
        Mon, 16 Mar 2020 15:13:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 08:13:12 -0700
Date:   Mon, 16 Mar 2020 08:13:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 1/2] xfs: always init fdblocks in mount
Message-ID: <20200316151311.GD256767@magnolia>
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
 <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 09:07:07PM +0800, Zheng Bin wrote:
> Use fuzz(hydra) to test XFS and automatically generate
> tmp.img(XFS v5 format, but some metadata is wrong)
> 
> xfs_repair information(just one AG):
> agf_freeblks 0, counted 3224 in ag 0
> agf_longest 0, counted 3224 in ag 0
> sb_fdblocks 3228, counted 3224
> 
> Test as follows:
> mount tmp.img tmpdir
> cp file1M tmpdir
> sync
> 
> In 4.19-stable, sync will stuck, while in linux-next, sync not stuck.
> The reason is same to commit d0c7feaf8767
> ("xfs: add agf freeblocks verify in xfs_agf_verify"), cause agf_longest
> is 0, we can not block this in xfs_agf_verify.

Uh.... what are you saying here?  That the allocator misbehaves and
loops forever if sb_fdblocks > sum(agf_freeblks) after mount?

Also, uh, what do you mean by "sync not stuck"?  Writeback will fail on
allocation error, right...?  So I think the problem with incorrect AGF
contents (on upstream) is that writeback will fail due to ENOSPC, which
should never happen under normal circumstance?

> 
> Make sure fdblocks is always inited in mount(also init ifree, icount).
> 
> xfs_mountfs
>   xfs_check_summary_counts
>     xfs_initialize_perag_data
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>  fs/xfs/xfs_mount.c | 33 ---------------------------------
>  1 file changed, 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c5513e5..dc41801 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -594,39 +594,6 @@ xfs_check_summary_counts(
>  		return -EFSCORRUPTED;
>  	}
> 
> -	/*
> -	 * Now the log is mounted, we know if it was an unclean shutdown or
> -	 * not. If it was, with the first phase of recovery has completed, we
> -	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
> -	 * but they are recovered transactionally in the second recovery phase
> -	 * later.
> -	 *
> -	 * If the log was clean when we mounted, we can check the summary
> -	 * counters.  If any of them are obviously incorrect, we can recompute
> -	 * them from the AGF headers in the next step.
> -	 */
> -	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
> -	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
> -	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
> -	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
> -		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> -
> -	/*
> -	 * We can safely re-initialise incore superblock counters from the
> -	 * per-ag data. These may not be correct if the filesystem was not
> -	 * cleanly unmounted, so we waited for recovery to finish before doing
> -	 * this.
> -	 *
> -	 * If the filesystem was cleanly unmounted or the previous check did
> -	 * not flag anything weird, then we can trust the values in the
> -	 * superblock to be correct and we don't need to do anything here.
> -	 * Otherwise, recalculate the summary counters.
> -	 */
> -	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> -	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> -	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> -		return 0;
> -
>  	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);

The downside of this is that now we /always/ have to make two trips
around all of the AGs at mount time.  If you're proposing to require a
fresh fdblocks recomputation at mount, could you please refactor all of
the mount-time AG walks into a single loop?  And perhaps use xfs_pwork
so that we don't have to do it serially?

--D

>  }
> 
> --
> 2.7.4
> 
