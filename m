Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5864DC3F2C6
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 11:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B3A246AE
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 11:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgB2LVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:21:31 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:55206 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgB2LVb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 29 Feb 2020 06:21:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 16E8B439861BC0D4F300;
        Sat, 29 Feb 2020 19:21:28 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 29 Feb 2020
 19:21:18 +0800
Subject: Re: [PATCH v3] xfs: add agf freeblocks verify in xfs_agf_verify
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <sandeen@sandeen.net>, <bfoster@redhat.com>, <dchinner@redhat.com>,
        <linux-xfs@vger.kernel.org>, <renxudong1@huawei.com>,
        <yi.zhang@huawei.com>
References: <1582260435-20939-1-git-send-email-zhengbin13@huawei.com>
 <20200221153803.GP9506@magnolia>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <7c1a5d5c-9af0-1682-38d7-25ebe016c3c3@huawei.com>
Date:   Sat, 29 Feb 2020 19:21:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20200221153803.GP9506@magnolia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, is this ok?

On 2020/2/21 23:38, Darrick J. Wong wrote:
> On Fri, Feb 21, 2020 at 12:47:15PM +0800, Zheng Bin wrote:
>> We recently used fuzz(hydra) to test XFS and automatically generate
>> tmp.img(XFS v5 format, but some metadata is wrong)
>>
>> xfs_repair information(just one AG):
>> agf_freeblks 0, counted 3224 in ag 0
>> agf_longest 536874136, counted 3224 in ag 0
>> sb_fdblocks 613, counted 3228
>>
>> Test as follows:
>> mount tmp.img tmpdir
>> cp file1M tmpdir
>> sync
>>
>> In 4.19-stable, sync will stuck, the reason is:
>> xfs_mountfs
>>   xfs_check_summary_counts
>>     if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
>>        XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
>>        !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
>> 	return 0;  -->just return, incore sb_fdblocks still be 613
>>     xfs_initialize_perag_data
>>
>> cp file1M tmpdir -->ok(write file to pagecache)
>> sync -->stuck(write pagecache to disk)
>> xfs_map_blocks
>>   xfs_iomap_write_allocate
>>     while (count_fsb != 0) {
>>       nimaps = 0;
>>       while (nimaps == 0) { --> endless loop
>>          nimaps = 1;
>>          xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
>> xfs_bmapi_write
>>   xfs_bmap_alloc
>>     xfs_bmap_btalloc
>>       xfs_alloc_vextent
>>         xfs_alloc_fix_freelist
>>           xfs_alloc_space_available -->fail(agf_freeblks is 0)
>>
>> In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
>> use the latest extent at writeback delalloc conversion time") remove
>> the above while, dmesg is as follows:
>> [   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.
>>
>> Users do not know why this page is discard, the better soultion is:
>> 1. Like xfs_repair, make sure sb_fdblocks is equal to counted
>> (xfs_initialize_perag_data did this, who is not called at this mount)
>> 2. Add agf verify, if fail, will tell users to repair
>>
>> This patch use the second soultion.
>>
>> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
>> Signed-off-by: Ren Xudong <renxudong1@huawei.com>
> Looks ok, will give this a run through fuzz testing...
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
>> ---
>>
>> v1->v2: modify comment, add more agf verify
>> v2->v3: modify code which is suggested by hellwig & darrick
>> besides, remove the agf_freeblks < sb_fdblocks check, sb_fdblocks may not be true,
>> if we have lazysbcount or not umount clean. If we check this, we need to add
>> if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
>>     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
>>     !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
>> like function xfs_check_summary_counts does.
>>
>>  fs/xfs/libxfs/xfs_alloc.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index d8053bc..183dc25 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2858,6 +2858,13 @@ xfs_agf_verify(
>>  	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
>>  		return __this_address;
>>
>> +	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
>> +		return __this_address;
>> +
>> +	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
>> +	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
>> +		return __this_address;
>> +
>>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
>>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
>>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
>> @@ -2869,6 +2876,10 @@ xfs_agf_verify(
>>  	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
>>  		return __this_address;
>>
>> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
>> +	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
>> +		return __this_address;
>> +
>>  	/*
>>  	 * during growfs operations, the perag is not fully initialised,
>>  	 * so we can't use it for any useful checking. growfs ensures we can't
>> @@ -2883,6 +2894,11 @@ xfs_agf_verify(
>>  		return __this_address;
>>
>>  	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
>> +	    be32_to_cpu(agf->agf_refcount_blocks) >
>> +	    be32_to_cpu(agf->agf_length))
>> +		return __this_address;
>> +
>> +	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
>>  	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
>>  	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
>>  		return __this_address;
>> --
>> 2.7.4
>>
> .
>

