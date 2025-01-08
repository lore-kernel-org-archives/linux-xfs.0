Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B82C80
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 01:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736299865; cv=none; b=EgvoRku0EUtmnX+V6F7ExKEBk6gjEWuF+PPjhH/MNy9RydGpmQJpIQqar3rwQLBv5eNaUfLoGgAwvbDIMNNo24f7aGHfXLRUmogWj2Jt8A7wqQnULizK3T88hN+8nt1fnPrd4KT0jCZkbRvf93iGrUiY059weDYGcXhckeWo69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736299865; c=relaxed/simple;
	bh=oYl4/vJKUmX4A13KEb7QMqXfa4IWhkeFZyAeMGQNLhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROhslX7wVv60BpNUnPBEEgZYv9zoI0w1bHqOrGiJDrzKiWlHu/3XrO6Na9You3rz1SmRZ/6i4ZxItWChKBkvcm/G8gaHTo7LqwYxzpPWE68SXW8pylGOF/qFrRoakhzfFWAd0Ssx0px96F0FcvhJpDllEjHPZWfQsHRy/DLEYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YSVj26ZHgz1JHD8;
	Wed,  8 Jan 2025 09:30:14 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id CE8A51400CB;
	Wed,  8 Jan 2025 09:30:59 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 8 Jan
 2025 09:30:59 +0800
Date: Wed, 8 Jan 2025 09:26:39 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z33UT3AxCjyXIhiD@localhost.localdomain>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
 <Z30n-9IusvggTuwP@localhost.localdomain>
 <20250108003206.GL6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20250108003206.GL6174@frogsfrogsfrogs>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Jan 07, 2025 at 04:32:06PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 07, 2025 at 09:11:23PM +0800, Long Li wrote:
> > On Mon, Jan 06, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> > > On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> > > > When mounting an xfs disk that incompat with metadir and has no realtime
> > > > subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> > > > fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> > > > than 0, updating the last rtag in-core is required, however, without
> > > > CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> > > > -EOPNOTSUPP, leading to mount failure.
> > > 
> > > Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?
> > > 
> > > --D
> > 
> > Indeed, when CONFIG_XFS_RT is not enabled, xfs_update_last_rtgroup_size() should
> > return 0, as returning an error is meaningless.
> > 
> > 1) For kernels without CONFIG_XFS_RT, mounting an image with realtime subvolume will
> > fail at xfs_rtmount_init().
> > 
> > 2) For kernels without CONFIG_XFS_RT, mounting an image without realtime subvolume
> > should succeed.
> > 
> > However, in the current scenario, should sb_rgcount be initialized to 0 ? it will 
> > consistent with metadir feature is enabled. The xfs-documentation [1] describes 
> > sb_rgcount as follows:
> > 
> > "Count of realtime groups in the filesystem, if the XFS_SB_FEAT_RO_INCOMPAT_METADIR
> > feature is enabled. If no realtime subvolume exists, this value will be zero."
> > 
> > [1] https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/design/XFS_Filesystem_Structure/superblock.asciidoc
> 
> Ah, I see your point finally -- if there's no realtime section, then
> there's no need to allocate any incore rtgroups, nor is there any point
> to set sb_rgcount==1.
> 
> That said, I think the correct tags here are:
> Cc: <stable@vger.kernel.org> # v6.13-rc1
> Fixes: 96768e91511bfc ("xfs: define the format of rt groups")
> 
> because 96768e91511bfc is the commit that actually added "to->sb_rgcount
> = 1;".
> 

Ok, thanks for point out that, In fact, xfs_grow_last_rtg() needs to be modified together,
otherwise the growfs may be problematic. Therefore, I will release a new version.

Long Li
