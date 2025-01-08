Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB19476
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 07:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736320496; cv=none; b=jZhAyB0ccGKzsLdIX0uZBqnPPyhFPtQX5ZgVoU5C6n/VmRDjXnFbNLsa56ukDV/TE2RTlDrJcgpJSw5lt6qhpZx+KPf0zhjfDfM5vS4+W8uYzUISzg4tSWIsLz7NGgG3mSl8UKPERYXG3goXOr3wBsAJiw6f8JNw5I9M12y6NSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736320496; c=relaxed/simple;
	bh=/MBdFjXq0vWMgrlMapdvuuC7Al8d4OG2DMK7F4NrHN0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoThWByNhpO5Wp3ZQauvPStbjlnyo4G0tD7UHYEfCXcBrUYC7+Xch3O6i1jPKuM1tSfAhuoXPDG9FtpOq2oF9cPtFdbjrQcyFqscU5KhlDblkgQQ+Xhf1Funz3ShsmF3aZnCL15AOmt3B460XSWlAj5ITJj1+3MKW1w4UZJQp4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YSfGN32Zkz1W3jy;
	Wed,  8 Jan 2025 15:11:08 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AF891400DC;
	Wed,  8 Jan 2025 15:14:50 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 8 Jan
 2025 15:14:49 +0800
Date: Wed, 8 Jan 2025 15:10:28 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z34k5Pu8UaG0DzsB@localhost.localdomain>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
 <Z34hciJJXpgdoMOc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z34hciJJXpgdoMOc@infradead.org>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Jan 07, 2025 at 10:55:46PM -0800, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> > > When mounting an xfs disk that incompat with metadir and has no realtime
> > > subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> > > fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> > > than 0, updating the last rtag in-core is required, however, without
> > > CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> > > -EOPNOTSUPP, leading to mount failure.
> > 
> > Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?
> 
> Hmm, looks like the patch did not get merged.  I'll send a ping.
> 

Oh, I didn't notice you fixed this before!
