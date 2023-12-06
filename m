Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908CD12F
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 04:44:26 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SlcRK3Mvfz14L6v;
	Wed,  6 Dec 2023 20:39:25 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 6 Dec
 2023 20:44:23 +0800
Date: Wed, 6 Dec 2023 20:48:07 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH 2/2] xfs: fix perag leak when growfs fails
Message-ID: <20231206124807.GB3413285@ceph-admin>
References: <20231204043911.1273667-1-leo.lilong@huawei.com>
 <20231204043911.1273667-2-leo.lilong@huawei.com>
 <ZW6pMHNK/tUxsbuM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZW6pMHNK/tUxsbuM@infradead.org>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected

On Mon, Dec 04, 2023 at 08:38:08PM -0800, Christoph Hellwig wrote:
> > +void
> > +xfs_destroy_perag(
> > +	xfs_mount_t		*mp,
> > +	xfs_agnumber_t		agstart,
> > +	xfs_agnumber_t		agend)
> 
> Not sure xfs_destroy_perag is the right name, as it frees a range of
> AGs, how about xfs_free_unuses_perag_range?

Yes, it looks better.
But I'm not sure if it's better to use xfs_free_unused_perag_range?

> 
> Also a comment explaining that this must never be used for AGs that
> have been visible (that is included in mp->m_sb.sb_agcount) would
> probably be useful.
> 

This will be changed in the next version.

Thanks,
Long Li
