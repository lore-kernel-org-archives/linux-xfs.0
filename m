Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A08BC18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B5020674
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgCPSKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:10:31 -0400
Received: from sandeen.net ([63.231.237.45]:37502 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbgCPSKb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 14:10:31 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 84D8AFB447;
        Mon, 16 Mar 2020 13:09:36 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs: always init fdblocks in mount
To:     Zheng Bin <zhengbin13@huawei.com>, bfoster@redhat.com,
        dchinner@redhat.com, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Cc:     yi.zhang@huawei.com, houtao1@huawei.com
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
 <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <c6390a07-1bb5-57ac-e79d-f32e831d4d60@sandeen.net>
Date:   Mon, 16 Mar 2020 13:10:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/16/20 8:07 AM, Zheng Bin wrote:
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

Is there any observable problem on linux-next?  I can't tell.  Can you
provide an image that demonstrates this problem?

-Eric

> The reason is same to commit d0c7feaf8767
> ("xfs: add agf freeblocks verify in xfs_agf_verify"), cause agf_longest
> is 0, we can not block this in xfs_agf_verify.
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
>  }
> 
> --
> 2.7.4
> 
