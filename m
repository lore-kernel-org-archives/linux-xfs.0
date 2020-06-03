Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E89C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 17:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 983B420679
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 17:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g95sZCkO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgFCR0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 13:26:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgFCR0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 13:26:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053HM7Zp125336;
        Wed, 3 Jun 2020 17:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DAK8xqjYoqvyLl8RllK8jz1RxH67VFbtYjP30D9qyDQ=;
 b=g95sZCkOLiYWePktsc+rJXdbmnq7Ixoz/WCYCJrpZ0+ZgwA4iEMxr1w5xptrjvQq8Lkx
 6Czn67Kcd8MgVz2elJ+gcCvRQAHOMWZ2JIBecRRRlnNrl/CJCJmdFXnyZH1GFchpiXmQ
 rOLh/SwTBanew7dcUzfX9hXJquqcljVPkyiTTEbZF9niFT+e1UTdjThtusBIcVDo3xqS
 lGsS1/4fDJHibdQNdcmyNNvdF+vvQLlT5Fk65ePg/gTDuSevm9+ZBtoGSvOs2cJtYWrZ
 AnWcnMosAjCyK5xbgDHGqCXyI7vFcraV7Fztc9KFhoR4LOVJ+yIWYJWI1uT0w3B+UzU4 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31ef1ngcyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 17:25:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053HI0Js006201;
        Wed, 3 Jun 2020 17:23:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25sp90e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 17:23:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053HNv3e029907;
        Wed, 3 Jun 2020 17:23:57 GMT
Received: from localhost (/10.159.239.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 10:23:57 -0700
Date:   Wed, 3 Jun 2020 10:23:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: avoid deadlock when tigger memory reclam in
 xfs_map_blocks()
Message-ID: <20200603172355.GP2162697@magnolia>
References: <1591179035-9270-1-git-send-email-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591179035-9270-1-git-send-email-laoar.shao@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=5 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1011
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0
 suspectscore=5 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 mlxscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 06:10:35AM -0400, Yafang Shao wrote:
> Recently there is an XFS deadlock on our server with an old kernel.
> The deadlock is caused by allocating memory xfs_map_blocks() while doing
> writeback on behalf of memroy reclaim. Although this deadlock happens on an
> old kernel, I think it could happen on the newest kernel as well. This
> issue only happence once and can't be reproduced, so I haven't tried to
> produce it on the newesr kernel.
> 
> Bellow is the call trace of this deadlock. Note that
> xfs_iomap_write_allocate() is replaced by xfs_convert_blocks() in
> commit 4ad765edb02a ("xfs: move xfs_iomap_write_allocate to xfs_aops.c").
> 
> [480594.790087] INFO: task redis-server:16212 blocked for more than 120 seconds.
> [480594.790087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [480594.790088] redis-server    D ffffffff8168bd60     0 16212  14347 0x00000004
> [480594.790090]  ffff880da128f070 0000000000000082 ffff880f94a2eeb0 ffff880da128ffd8
> [480594.790092]  ffff880da128ffd8 ffff880da128ffd8 ffff880f94a2eeb0 ffff88103f9d6c40
> [480594.790094]  0000000000000000 7fffffffffffffff ffff88207ffc0ee8 ffffffff8168bd60
> [480594.790096] Call Trace:
> [480594.790101]  [<ffffffff8168dce9>] schedule+0x29/0x70
> [480594.790103]  [<ffffffff8168b749>] schedule_timeout+0x239/0x2c0
> [480594.790111]  [<ffffffff8168d28e>] io_schedule_timeout+0xae/0x130
> [480594.790114]  [<ffffffff8168d328>] io_schedule+0x18/0x20
> [480594.790116]  [<ffffffff8168bd71>] bit_wait_io+0x11/0x50
> [480594.790118]  [<ffffffff8168b895>] __wait_on_bit+0x65/0x90
> [480594.790121]  [<ffffffff811814e1>] wait_on_page_bit+0x81/0xa0
> [480594.790125]  [<ffffffff81196ad2>] shrink_page_list+0x6d2/0xaf0
> [480594.790130]  [<ffffffff811975a3>] shrink_inactive_list+0x223/0x710
> [480594.790135]  [<ffffffff81198225>] shrink_lruvec+0x3b5/0x810
> [480594.790139]  [<ffffffff8119873a>] shrink_zone+0xba/0x1e0
> [480594.790141]  [<ffffffff81198c20>] do_try_to_free_pages+0x100/0x510
> [480594.790143]  [<ffffffff8119928d>] try_to_free_mem_cgroup_pages+0xdd/0x170
> [480594.790145]  [<ffffffff811f32de>] mem_cgroup_reclaim+0x4e/0x120
> [480594.790147]  [<ffffffff811f37cc>] __mem_cgroup_try_charge+0x41c/0x670
> [480594.790153]  [<ffffffff811f5cb6>] __memcg_kmem_newpage_charge+0xf6/0x180
> [480594.790157]  [<ffffffff8118c72d>] __alloc_pages_nodemask+0x22d/0x420
> [480594.790162]  [<ffffffff811d0c7a>] alloc_pages_current+0xaa/0x170
> [480594.790165]  [<ffffffff811db8fc>] new_slab+0x30c/0x320
> [480594.790168]  [<ffffffff811dd17c>] ___slab_alloc+0x3ac/0x4f0
> [480594.790204]  [<ffffffff81685656>] __slab_alloc+0x40/0x5c
> [480594.790206]  [<ffffffff811dfc43>] kmem_cache_alloc+0x193/0x1e0
> [480594.790233]  [<ffffffffa04fab67>] kmem_zone_alloc+0x97/0x130 [xfs]
> [480594.790247]  [<ffffffffa04f90ba>] _xfs_trans_alloc+0x3a/0xa0 [xfs]
> [480594.790261]  [<ffffffffa04f915c>] xfs_trans_alloc+0x3c/0x50 [xfs]
> [480594.790276]  [<ffffffffa04e958b>] xfs_iomap_write_allocate+0x1cb/0x390 [xfs]
> [480594.790299]  [<ffffffffa04d3616>] xfs_map_blocks+0x1a6/0x210 [xfs]
> [480594.790312]  [<ffffffffa04d416b>] xfs_do_writepage+0x17b/0x550 [xfs]

xfs_do_writepages doesn't exist anymore.  Does upstream have this
problem?  What kernel is this patch targeting?

--D

> [480594.790314]  [<ffffffff8118d881>] write_cache_pages+0x251/0x4d0 [xfs]
> [480594.790338]  [<ffffffffa04d3e05>] xfs_vm_writepages+0xc5/0xe0 [xfs]
> [480594.790341]  [<ffffffff8118ebfe>] do_writepages+0x1e/0x40
> [480594.790343]  [<ffffffff811837b5>] __filemap_fdatawrite_range+0x65/0x80
> [480594.790346]  [<ffffffff81183901>] filemap_write_and_wait_range+0x41/0x90
> [480594.790360]  [<ffffffffa04df2c6>] xfs_file_fsync+0x66/0x1e0 [xfs]
> [480594.790363]  [<ffffffff81231cf5>] do_fsync+0x65/0xa0
> [480594.790365]  [<ffffffff81231fe3>] SyS_fdatasync+0x13/0x20
> [480594.790367]  [<ffffffff81698d09>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  fs/xfs/xfs_aops.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1fd4fb7..3f60766 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -352,6 +352,7 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
>  	struct xfs_iext_cursor	icur;
>  	int			retries = 0;
>  	int			error = 0;
> +	unsigned int		nofs_flag;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -445,8 +446,16 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
>  	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0);
>  	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
>  	return 0;
> +
>  allocate_blocks:
> +	/*
> +	 * We can allocate memory here while doing writeback on behalf of
> +	 * memory reclaim.  To avoid memory allocation deadlocks set the
> +	 * task-wide nofs context for the following operations.
> +	 */
> +	nofs_flag = memalloc_nofs_save();
>  	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
> +	memalloc_nofs_restore(nofs_flag);
>  	if (error) {
>  		/*
>  		 * If we failed to find the extent in the COW fork we might have
> -- 
> 1.8.3.1
> 
