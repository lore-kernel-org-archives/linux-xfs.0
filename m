Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BFDC33CB1
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 09:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3692073A
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 09:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgASJE6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 04:04:58 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbgASJE6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 19 Jan 2020 04:04:58 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 65999C3FD4E6F8F52505;
        Sun, 19 Jan 2020 17:04:53 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 17:04:39 +0800
Subject: Re: [PATCH] xfs: change return value of xfs_inode_need_cow to int
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>
References: <1577087776-59093-1-git-send-email-zhengbin13@huawei.com>
 <20191223173246.GU7489@magnolia>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <6f3d3a92-8e12-6ff6-0e08-71fd9ed3bfa7@huawei.com>
Date:   Sun, 19 Jan 2020 17:04:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20191223173246.GU7489@magnolia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/12/24 1:32, Darrick J. Wong wrote:
> On Mon, Dec 23, 2019 at 03:56:16PM +0800, zhengbin wrote:
>> Fixes coccicheck warning:
>>
>> fs/xfs/xfs_reflink.c:236:9-10: WARNING: return of 0/1 in function 'xfs_inode_need_cow' with return type bool
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> ---
>>  fs/xfs/xfs_reflink.c | 2 +-
>>  fs/xfs/xfs_reflink.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index de45123..21eeb94 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -223,7 +223,7 @@ xfs_reflink_trim_around_shared(
>>  	}
>>  }
>>
>> -bool
>> +int
>>  xfs_inode_need_cow(
> I started to think "just fix this predicate so it doesn't return 1--"
>
> But then I realized that this is /not/ an inode predicate, it's a
> reflink trim wrapper for block mappings.  "xfs_bmap_trim_cow" is a
> somewhat better name, so I'll commit this with a name change.
>
> And yeah, we turned negative errno into bool and back to int.  Wow.
>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Does this apply? I do not see it in linux-next
>
> --D
>
>>  	struct xfs_inode	*ip,
>>  	struct xfs_bmbt_irec	*imap,
>> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
>> index d18ad7f..9a288b2 100644
>> --- a/fs/xfs/xfs_reflink.h
>> +++ b/fs/xfs/xfs_reflink.h
>> @@ -22,7 +22,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
>>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
>>  		struct xfs_bmbt_irec *irec, bool *shared);
>> -bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
>> +int xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
>>  		bool *shared);
>>
>>  int xfs_reflink_allocate_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
>> --
>> 2.7.4
>>
> .
>

