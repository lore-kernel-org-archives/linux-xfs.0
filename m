Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA380C11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A874F24682
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dK5Gk5f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgBTP45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:56:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbgBTP44 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:56:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KFmwJG055763;
        Thu, 20 Feb 2020 15:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KFL98uWn0TV2ZNng6nvFr+mjCkReI4IDjlTJjVhvrn4=;
 b=dK5Gk5f0jh8kuh+mDKLDr+5cggzAUG6YKwBc0xXW/vVZHcZ2rhMBRevGg+cqz505Dffr
 DupRU/yAhtUkq/2TBjnvyEpXY4eNQBb0eSwJP+86Xw2AQOGfBUPNQbDLZ5Q47A1aOKaq
 MV9G1/MtKNOddmypWhbdwFpPl3WYPI2tro60QVP2rHi1kCmiSlGANE6tgdBmaI11oQka
 3SLCCEex2IvvV8Sm7smf2r5mgP+wCwSu8qQ+X/PlTiOe2S0NFe3hY5v13SeKL/cfcq4f
 Qg6D4UXjDm00wEwywzrTHFUQIzCzPcCf5n8RQzJDZDkrpqxMJkDGt34AWFb5AGbRMa1h 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8uddamq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 15:56:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KFlw2l165087;
        Thu, 20 Feb 2020 15:56:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud6as9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 15:56:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01KFuNdW004563;
        Thu, 20 Feb 2020 15:56:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 07:56:23 -0800
Date:   Thu, 20 Feb 2020 07:56:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, renxudong1@huawei.com,
        yi.zhang@huawei.com
Subject: Re: [PATCH v2] xfs: add agf freeblocks verify in xfs_agf_verify
Message-ID: <20200220155622.GT9506@magnolia>
References: <1582197182-142137-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582197182-142137-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:13:02PM +0800, Zheng Bin wrote:
> We recently used fuzz(hydra) to test XFS and automatically generate
> tmp.img(XFS v5 format, but some metadata is wrong)
> 
> xfs_repair information(just one AG):
> agf_freeblks 0, counted 3224 in ag 0
> agf_longest 536874136, counted 3224 in ag 0
> sb_fdblocks 613, counted 3228
> 
> Test as follows:
> mount tmp.img tmpdir
> cp file1M tmpdir
> sync
> 
> In 4.19-stable, sync will stuck, the reason is:
> xfs_mountfs
>   xfs_check_summary_counts
>     if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
>        XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
>        !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> 	return 0;  -->just return, incore sb_fdblocks still be 613
>     xfs_initialize_perag_data
> 
> cp file1M tmpdir -->ok(write file to pagecache)
> sync -->stuck(write pagecache to disk)
> xfs_map_blocks
>   xfs_iomap_write_allocate
>     while (count_fsb != 0) {
>       nimaps = 0;
>       while (nimaps == 0) { --> endless loop
>          nimaps = 1;
>          xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
> xfs_bmapi_write
>   xfs_bmap_alloc
>     xfs_bmap_btalloc
>       xfs_alloc_vextent
>         xfs_alloc_fix_freelist
>           xfs_alloc_space_available -->fail(agf_freeblks is 0)
> 
> In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
> use the latest extent at writeback delalloc conversion time") remove
> the above while, dmesg is as follows:
> [   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.
> 
> Users do not know why this page is discard, the better soultion is:
> 1. Like xfs_repair, make sure sb_fdblocks is equal to counted
> (xfs_initialize_perag_data did this, who is not called at this mount)
> 2. Add agf verify, if fail, will tell users to repair
> 
> This patch use the second soultion.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> Signed-off-by: Ren Xudong <renxudong1@huawei.com>
> ---
> v1->v2: modify comment, add more agf verify
>  fs/xfs/libxfs/xfs_alloc.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d8053bc..5faed42 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2839,6 +2839,7 @@ xfs_agf_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_agf		*agf = XFS_BUF_TO_AGF(bp);
> +	int i;
> 
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
> @@ -2858,6 +2859,22 @@ xfs_agf_verify(
>  	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
>  		return __this_address;
> 
> +	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks ||
> +	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length) ||

Isn't this already covered later on?

> +	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length) ||
> +	    be32_to_cpu(agf->agf_refcount_blocks) > be32_to_cpu(agf->agf_length) ||

Do these fields need checking when the corresponding feature isn't
enabled?

> +	    be32_to_cpu(agf->agf_spare2) != 0)

If, for some reason, these unused "spare" fields are *not* zero, won't
this cause mount failures on existing filesystems?

> +		return __this_address;

Please try to check only one agf field per if clause, because we use the
logged __this_address to figure out which field triggered the corruption
error.

> +
> +	for (i = 0; i < ARRAY_SIZE(agf->agf_spare64); i++)
> +		if (be64_to_cpu(agf->agf_spare64[i]) != 0)
> +			return __this_address;

memchr_inv if you leave in the spare check.

> +
> +	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
> +	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length) ||

Already covered in this function.

--D

> +	    be32_to_cpu(agf->agf_freeblks) > mp->m_sb.sb_fdblocks)
> +		return __this_address;
> +
>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
> --
> 2.7.4
> 
