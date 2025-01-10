Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4818C31
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 01:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736473654; cv=none; b=SNc/nFos+hDdyeyILo5D3JEeiUl3RmT6eBTmylmvnb2O0cKfjFAJLgFIWr8Hi4lt1a294WVbjOQSLwBh8Qlv2Smx0fdzDjyLSwe9mQ3ZNQ1akhERZgoOC/qfFdxp+mwF2su6MUKVUXDn/QOg13iyn6mtN7EvleDlgZN2hldIGHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736473654; c=relaxed/simple;
	bh=IPVwXBHruQ9/lb40HvSuVWuSeo5fsl8JimIvrFYYrmU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyhlcWiBji2iqfd7SZ4FfjX9ea2YblMRUD2Vn7kk56opSeJs/ePkWWR9uZafGCIniUHyUx5Rxo4KSSrK/ZS7RLA8kMCudY6XwoOK04QfXDn5DrmV7V0jLlx6fovd8FKw4SjVSBwt2valET71KkBRQyI3o6qn3KLf1hKFBp6Ie5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YTkvj5yYCz1W3tg;
	Fri, 10 Jan 2025 09:43:45 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id A9B6B18007C;
	Fri, 10 Jan 2025 09:47:29 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jan
 2025 09:47:29 +0800
Date: Fri, 10 Jan 2025 09:43:02 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH v2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <Z4B7JvnKU1d4n_MT@localhost.localdomain>
References: <20250109021320.429625-1-leo.lilong@huawei.com>
 <20250109044142.GM1306365@frogsfrogsfrogs>
 <Z4B6f9DdpQX0IIbj@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z4B6f9DdpQX0IIbj@localhost.localdomain>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Jan 10, 2025 at 09:40:16AM +0800, Long Li wrote:
> On Wed, Jan 08, 2025 at 08:41:42PM -0800, Darrick J. Wong wrote:
> > On Thu, Jan 09, 2025 at 10:13:20AM +0800, Long Li wrote:
> > > When mounting an image containing a log with sb modifications that require
> > > log replay, the mount process hang all the time and stack as follows:
> > > 
> > >   [root@localhost ~]# cat /proc/557/stack
> > >   [<0>] xfs_buftarg_wait+0x31/0x70
> > >   [<0>] xfs_buftarg_drain+0x54/0x350
> > >   [<0>] xfs_mountfs+0x66e/0xe80
> > >   [<0>] xfs_fs_fill_super+0x7f1/0xec0
> > >   [<0>] get_tree_bdev_flags+0x186/0x280
> > >   [<0>] get_tree_bdev+0x18/0x30
> > >   [<0>] xfs_fs_get_tree+0x1d/0x30
> > >   [<0>] vfs_get_tree+0x2d/0x110
> > >   [<0>] path_mount+0xb59/0xfc0
> > >   [<0>] do_mount+0x92/0xc0
> > >   [<0>] __x64_sys_mount+0xc2/0x160
> > >   [<0>] x64_sys_call+0x2de4/0x45c0
> > >   [<0>] do_syscall_64+0xa7/0x240
> > >   [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > 
> > > During log recovery, while updating the in-memory superblock from the
> > > primary SB buffer, if an error is encountered, such as superblock
> > > corruption occurs or some other reasons, we will proceed to out_release
> > > and release the xfs_buf. However, this is insufficient because the
> > > xfs_buf's log item has already been initialized and the xfs_buf is held
> > > by the buffer log item as follows, the xfs_buf will not be released,
> > > causing the mount thread to hang.
> > 
> > Can you post a regression test for us, pretty please? :)
> > 
> 
> I performed regression testing by mounting specific images that can be
> obtained through fault injection on kernels without metadir feature support.
> I can provide it if anyone needs it.The image is big and inconvenient to send
> in the mail. The detailed steps are as follows:
> 
> 1) Kernel Build
>   - The latest realtime AG update bug [1] remains unfixed
>   - Build kernel without CONFIG_XFS_RT
>   
> 2) Mount XFS Image (superblock needs replay, incompatible with metadir and
>    no realtime subvolume)
> 
> 3) Mount Result Verification
>   - Without the current patch: mount thread hangs indefinitely
>   - With the current patch: mount thread does not hang, but XFS is shut down
> 
> The xfstests already have the fault injection test, and this test requires
> mounting specific images on specifically-compiled kernels, making it impractical
> to incorporate into xfstests.
> 

Sorry, forgot to add the fixed patch link:

[1] https://patchwork.kernel.org/project/xfs/patch/20241217042737.1755365-1-hch@lst.de/
