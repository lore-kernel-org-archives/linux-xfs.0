Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B7783
	for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2023 05:36:40 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SqKQR16FLz14M0y;
	Tue, 12 Dec 2023 21:36:31 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id ADC56140412;
	Tue, 12 Dec 2023 21:36:37 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 12 Dec
 2023 21:36:37 +0800
Date: Tue, 12 Dec 2023 21:40:12 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH v2 3/3] xfs: fix perag leak when growfs fails
Message-ID: <20231212134012.GA2905659@ceph-admin>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
 <20231209122107.2422441-3-leo.lilong@huawei.com>
 <20231211220305.GW361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20231211220305.GW361584@frogsfrogsfrogs>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Mon, Dec 11, 2023 at 02:03:05PM -0800, Darrick J. Wong wrote:
> On Sat, Dec 09, 2023 at 08:21:07PM +0800, Long Li wrote:
> > During growfs, if new ag in memory has been initialized, however
> > sb_agcount has not been updated, if an error occurs at this time it
> > will cause perag leaks as follows, these new AGs will not been freed
> > during umount , because of these new AGs are not visible(that is
> > included in mp->m_sb.sb_agcount).
> > 
> > unreferenced object 0xffff88810be40200 (size 512):
> >   comm "xfs_growfs", pid 857, jiffies 4294909093
> >   hex dump (first 32 bytes):
> >     00 c0 c1 05 81 88 ff ff 04 00 00 00 00 00 00 00  ................
> >     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace (crc 381741e2):
> >     [<ffffffff8191aef6>] __kmalloc+0x386/0x4f0
> >     [<ffffffff82553e65>] kmem_alloc+0xb5/0x2f0
> >     [<ffffffff8238dac5>] xfs_initialize_perag+0xc5/0x810
> >     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
> >     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
> >     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
> >     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
> >     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> > unreferenced object 0xffff88810be40800 (size 512):
> >   comm "xfs_growfs", pid 857, jiffies 4294909093
> >   hex dump (first 32 bytes):
> >     20 00 00 00 00 00 00 00 57 ef be dc 00 00 00 00   .......W.......
> >     10 08 e4 0b 81 88 ff ff 10 08 e4 0b 81 88 ff ff  ................
> >   backtrace (crc bde50e2d):
> >     [<ffffffff8191b43a>] __kmalloc_node+0x3da/0x540
> >     [<ffffffff81814489>] kvmalloc_node+0x99/0x160
> >     [<ffffffff8286acff>] bucket_table_alloc.isra.0+0x5f/0x400
> >     [<ffffffff8286bdc5>] rhashtable_init+0x405/0x760
> >     [<ffffffff8238dda3>] xfs_initialize_perag+0x3a3/0x810
> >     [<ffffffff824f679c>] xfs_growfs_data+0x9bc/0xbc0
> >     [<ffffffff8250b90e>] xfs_file_ioctl+0x5fe/0x14d0
> >     [<ffffffff81aa5194>] __x64_sys_ioctl+0x144/0x1c0
> >     [<ffffffff83c3d81f>] do_syscall_64+0x3f/0xe0
> >     [<ffffffff83e00087>] entry_SYSCALL_64_after_hwframe+0x62/0x6a
> > 
> > Now, the logic for freeing perag in xfs_free_perag() and
> > xfs_initialize_perag() error handling is essentially the same. Factor
> > out xfs_free_perag_range() from xfs_free_perag(), used for freeing
> > unused perag within a specified range, inclued when growfs fails.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c | 35 ++++++++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_ag.h |  2 ++
> >  fs/xfs/xfs_fsops.c     |  5 ++++-
> >  3 files changed, 26 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 11ed048c350c..edec03ab09aa 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -245,16 +245,20 @@ __xfs_free_perag(
> >  }
> >  
> >  /*
> > - * Free up the per-ag resources associated with the mount structure.
> > + * Free per-ag within the specified range, if agno is not found in the
> > + * radix tree, then it means that agno and subsequent AGs have not been
> > + * initialized.
> >   */
> >  void
> > -xfs_free_perag(
> > -	struct xfs_mount	*mp)
> > +xfs_free_perag_range(
> > +		xfs_mount_t		*mp,
> 
> Please stop reverting the codebase's use of typedefs for struct
> pointers.
> 
> > +		xfs_agnumber_t		agstart,
> > +		xfs_agnumber_t		agend)
> 
> This is also ^^ unnecessary indentation.
> 
> >  {
> > -	struct xfs_perag	*pag;
> >  	xfs_agnumber_t		agno;
> > +	struct xfs_perag	*pag;
> 
> ...and unnecessary rearranging of variables...

I ignored these minor issues, thanks for pointing them out, and it will be changed
in the next version.

Thanks,
Long Li

