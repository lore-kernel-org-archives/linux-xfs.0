Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7FBB7
	for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2023 05:25:21 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SqK8d70KtzvS1x;
	Tue, 12 Dec 2023 21:24:33 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id D971F180032;
	Tue, 12 Dec 2023 21:25:19 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 12 Dec
 2023 21:25:19 +0800
Date: Tue, 12 Dec 2023 21:28:54 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH v2 2/3] xfs: don't assert perag when free perag
Message-ID: <20231212132854.GA2694327@ceph-admin>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
 <20231209122107.2422441-2-leo.lilong@huawei.com>
 <ZXeGkisobA2nXX5D@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZXeGkisobA2nXX5D@dread.disaster.area>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Tue, Dec 12, 2023 at 09:00:50AM +1100, Dave Chinner wrote:
> On Sat, Dec 09, 2023 at 08:21:06PM +0800, Long Li wrote:
> > When releasing the perag in xfs_free_perag(), the assertion that the
> > perag in readix tree is correct in most cases. However, there is one
> > corner case where the assertion is not true. During log recovery, the
> > AGs become visible(that is included in mp->m_sb.sb_agcount) first, and
> > then the perag is initialized. If the initialization of the perag fails,
> > the assertion will be triggered. Worse yet, null pointer dereferencing
> > can occur.
> 
> I'm going to assume that you are talking about xlog_do_recover()
> because the commit message doesn't actually tell us how this
> situation occurs.
> 
> That code re-reads the superblock, then copies it to mp->m_sb,
> then calls xfs_initialize_perag() with the values from mp->m_sb.
> 
> If log recovery replayed a growfs transaction, the mp->m_sb has a
> larger sb_agcount and so then xfs_initialize_perag() is called
> and if that fails we end up back in xfs_mountfs and the error
> stack calls xfs_free_perag().
> 
> Is that correct?

Yes, you are right. When I tried to fix the perag leak issue in patch 3,
I found this problem.

> 
> If so, then the fix is to change how xlog_do_recover() works. It
> needs to initialise the new perags before it updates the in-memory
> superblock. If xfs_initialize_perag() fails, it undoes all the
> changes it has made, so if we haven't updated the in-memory
> superblock when the init of the new perags fails then the error
> unwinding code works exactly as it should right now.
> 
> i.e. the bug is that xlog_do_recover() is leaving the in-memory
> state inconsistent on init failure, and we need to fix that rather
> than remove the assert that is telling us that in-memory state is
> inconsistent....
> 

Yes, agree with you, I used to think that removing the assertion
would solve the problem, but now it seems a bit lazy, the problem
should be solved at the source. Right now, I haven't figured out
how to fix this problem comprehensively, so I'll fix perag leak
issue first. 

Thanks,
Long Li

