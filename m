Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A101F0E2B
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736255748; cv=none; b=Z2/21zbAWArK7ME1CHpNm8YbVFEi2vxm/UhBGWqMCOzsttKUbwYnHirVm/rZGknWfcbQiNh+txzxepuO9jkF38QmBEIHhpIv1iqri1QR9adF+aIStNNAzYoEQDF6fVv20bvU4wL4u0iX7nqNQij64MN/74okSFwrMC5+MqnffvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736255748; c=relaxed/simple;
	bh=JWJ4H80UhJpwOND35Yms/jmvKUX7DvnemQDYENez8xo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyetTt/OxOuD12unOruqiIsjKPFB9xYDXX0pCloXS9JUo92oWC2P1/b/tDrhBj+dN+htY6zA0qpY/XCHDmDpRWA5Ieo8zvFZ6WVbHUjPOChL+d+t6bJC42j6edWudz6ptbbpPpJqCwbc5ne456efEFL3qYoweooM42ciljzOeUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YSBKD5mYzzxWsZ;
	Tue,  7 Jan 2025 21:12:00 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id B88A91802D1;
	Tue,  7 Jan 2025 21:15:41 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jan
 2025 21:15:41 +0800
Date: Tue, 7 Jan 2025 21:11:23 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z30n-9IusvggTuwP@localhost.localdomain>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20250106195220.GK6174@frogsfrogsfrogs>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Mon, Jan 06, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> > When mounting an xfs disk that incompat with metadir and has no realtime
> > subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> > fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> > than 0, updating the last rtag in-core is required, however, without
> > CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> > -EOPNOTSUPP, leading to mount failure.
> 
> Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?
> 
> --D

Indeed, when CONFIG_XFS_RT is not enabled, xfs_update_last_rtgroup_size() should
return 0, as returning an error is meaningless.

1) For kernels without CONFIG_XFS_RT, mounting an image with realtime subvolume will
fail at xfs_rtmount_init().

2) For kernels without CONFIG_XFS_RT, mounting an image without realtime subvolume
should succeed.

However, in the current scenario, should sb_rgcount be initialized to 0 ? it will 
consistent with metadir feature is enabled. The xfs-documentation [1] describes 
sb_rgcount as follows:

"Count of realtime groups in the filesystem, if the XFS_SB_FEAT_RO_INCOMPAT_METADIR
feature is enabled. If no realtime subvolume exists, this value will be zero."

[1] https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/design/XFS_Filesystem_Structure/superblock.asciidoc

Thanks,
Long Li

> 
> > Initializing sb_rgcount as 1 is incorrect in this scenario. If no
> > realtime subvolume exists, the value of sb_rgcount should be set
> > to zero. Fix it by initializing sb_rgcount based on the actual number
> > of realtime blocks.
> > 
> > Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 3b5623611eba..1ea28f04b75a 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -830,7 +830,7 @@ __xfs_sb_from_disk(
> >  		to->sb_rsumino = NULLFSINO;
> >  	} else {
> >  		to->sb_metadirino = NULLFSINO;
> > -		to->sb_rgcount = 1;
> > +		to->sb_rgcount = to->sb_rblocks > 0 ? 1 : 0;
> >  		to->sb_rgextents = 0;
> >  	}
> >  }
> > -- 
> > 2.39.2
> > 
> > 
> 
