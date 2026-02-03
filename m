Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0EA219E8
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770104127; cv=none; b=nVLbWmqblau7xHGDC4VBx5C3OywkU2n954dass3IdisIypVE/KuGv9Hxu8ndLhQ8vbQPUsXmn24voD40QNHRE2GjbYlun2XR8TtvkIAWx6AZy6RG6teTTOIm1BRM2av6ZYI8h8RIBCheFTzbcb9IbhXeCVqHLaiaez/Zgar47ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770104127; c=relaxed/simple;
	bh=s/E4yHzNAFpLJZrd6oF9HCa7VU2G7YcHEkGY625Q5qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=mbFXwaFNAHtd/g1SF6ewmmQlXprdy7HHaChkKnw8YKkr8bbtJnqm1jkzw8nbZcur28zjLJJ/affaez1x9lLO/FOppvuU0PPyrQRJirN33aT0OlXqDpsvAE8G/6YsjSC4vr9qhaLBVzgL4H6s5O1flheljZJFEJ4lWxJgegW1SZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hR2XnZHt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hR2XnZHt"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260203073523epoutp01db1852d0bc45e2f7ca119f12702c4011~QrFJxle9O2134421344epoutp01y
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:35:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260203073523epoutp01db1852d0bc45e2f7ca119f12702c4011~QrFJxle9O2134421344epoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770104123;
	bh=5e6l+frt0X8jsKW5wcAhHw0CC1saut3jeRxaRHbnCOM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=hR2XnZHt1/E9zyyYvMnjL9UQKz/Q6HrF62DpNi5qUc6/IwAknWhmEvzCe2dUv/6u+
	 6dVXuGHDoWE94MKy9ct38OSi2jMQi+XrFwcyrDsGh9l91lWgtYJp0+0dQTJQt50+t5
	 1Q3DxF6KcLBmqeHNITIxPJVsiS7zgjt9CvuPpbU0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203073522epcas5p1196f2ef31bd5d09ffc122e3292a51d6d~QrFI0NeqS1880218802epcas5p1z;
	Tue,  3 Feb 2026 07:35:22 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4f4wHs3rjGz3hhTB; Tue,  3 Feb
	2026 07:35:21 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260203073520epcas5p10baf65c36e6deea9e7d4c25b68fbaee6~QrFHDTkG11658116581epcas5p10;
	Tue,  3 Feb 2026 07:35:20 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260203073517epsmtip223831a9695b31985fb20f435698e6c08~QrFD3QvYH0291302913epsmtip2S;
	Tue,  3 Feb 2026 07:35:17 +0000 (GMT)
Message-ID: <d0365256-43d1-4701-9175-5391755dc45e@samsung.com>
Date: Tue, 3 Feb 2026 13:05:16 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129222101.GD7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203073520epcas5p10baf65c36e6deea9e7d4c25b68fbaee6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
	<20260116100818.7576-6-kundan.kumar@samsung.com>
	<20260129222101.GD7712@frogsfrogsfrogs>

On 1/30/2026 3:51 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:17PM +0530, Kundan Kumar wrote:
>> Introduce per-AG writeback worker infrastructure at mount time.
>> This patch adds initialization and teardown only, without changing
>> writeback behavior.
>>
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_aops.c  | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_aops.h  |  3 ++
>>   fs/xfs/xfs_mount.c |  2 ++
>>   fs/xfs/xfs_mount.h | 10 ++++++
>>   fs/xfs/xfs_super.c |  2 ++
>>   5 files changed, 96 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index a26f79815533..9d5b65922cd2 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -23,6 +23,23 @@
>>   #include "xfs_zone_alloc.h"
>>   #include "xfs_rtgroup.h"
>>   
>> +#define XFS_AG_TASK_POOL_MIN 1024
>> +
>> +struct xfs_ag_wb_task {
>> +	struct list_head list;
>> +	struct xfs_inode *ip;
>> +	struct writeback_control wbc;
>> +	xfs_agnumber_t agno;
>> +};
>> +
>> +struct xfs_ag_wb {
>> +	struct delayed_work ag_work;
>> +	spinlock_t lock;
>> +	struct list_head task_list;
>> +	xfs_agnumber_t agno;
>> +	struct xfs_mount *mp;
>> +};
> 
> Help me understand the data structures here ... for each AG there's an
> xfs_ag_wb object which can be run as a delayed workqueue item.  This
> xfs_ag_wb is the head of a list of xfs_ag_wb_task items?
> 
> In turn, each xfs_ag_wb_task list item points to an inode and
> (redundantly?) the agnumber?  So in effect each AG has a kworker that
> can say "do all of this file's pagecache writeback for all dirty folios
> tagged with the same agnumber"?
> 
> <shrug> It's hard to tell with no comments about how these two pieces of
> data relate to each other.
> 
> --D
> 

Yes, that’s the intent. struct xfs_ag_wb is per-AG state and owns the
delayed_work that runs the AG worker on m_ag_wq. Each xfs_ag_wb
maintains a queue of pending work items that request "process inode X 
for AG Y".

struct xfs_ag_wb_task is the queued request, it carries the target inode
plus a snapshot of wbc.

When the AG worker runs, it drains its task list and for each inode does 
a one-pass scan of the mapping, filtering folios tagged for that AG and
submitting IO for those folios only.

>>   struct xfs_writepage_ctx {
>>   	struct iomap_writepage_ctx ctx;
>>   	unsigned int		data_seq;
>> @@ -666,6 +683,68 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>>   	.writeback_submit	= xfs_zoned_writeback_submit,
>>   };
>>   
>> +void
>> +xfs_init_ag_writeback(struct xfs_mount *mp)
>> +{
>> +	xfs_agnumber_t agno;
>> +
>> +	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
>> +				      0);
>> +	if (!mp->m_ag_wq)
>> +		return;
>> +
>> +	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
>> +				sizeof(struct xfs_ag_wb),
>> +				GFP_KERNEL);
>> +
>> +	if (!mp->m_ag_wb) {
>> +		destroy_workqueue(mp->m_ag_wq);
>> +		mp->m_ag_wq = NULL;
>> +		return;
>> +	}
>> +
>> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>> +		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>> +
>> +		spin_lock_init(&awb->lock);
>> +		INIT_LIST_HEAD(&awb->task_list);
>> +		awb->agno = agno;
>> +		awb->mp = mp;
> 
> Can't you stuff this information in struct xfs_perag instead of asking
> for a potentially huge allocation?
> 

I can switch the xfs_ag_wb fields (lock/list/work/agno/mp) into
struct xfs_perag and initialize them when perags are set up.


