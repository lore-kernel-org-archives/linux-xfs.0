Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17491A08DF
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736321187; cv=none; b=GV7xCWIRgibutboe0kBdrFHSk91tXDkmwrAHytI4Nv5U8uLJPGua/9QuRprCicYtTV+B5zu11+f7oGXUWCNx4J1y31KATwzBy/3p598yhTUOOU7LE8ybhln1NOeezQE7QmcvCuRO6YzrNlR9Q/iTkZvpPkSd7CrmocGCjMVtbXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736321187; c=relaxed/simple;
	bh=/fPq4nMc86GWyggwGP/+5zuYpLJPgO17izkY0xdCkGk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbsoKPg9mFSJ5GHTcKJAcQOOdaJfbz/8S+tHx++2EvbijgMBCnhnBbj+np9Us2LApZk/nJIRo/XBnzRBDg2AB//LVRy1hpxVEAkwflYqxoM/Us6I40/Mwoq8uMdppruSiwQ8sDSl3zE5QJJQYH6jYRq+Lt68KdqDXqz4HQYmT3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YSfWg70QHz1W3k4;
	Wed,  8 Jan 2025 15:22:39 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 941E61400DC;
	Wed,  8 Jan 2025 15:26:21 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 8 Jan
 2025 15:26:21 +0800
Date: Wed, 8 Jan 2025 15:22:00 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <Z34nmIFrYqqvHnBe@localhost.localdomain>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
 <Z30n-9IusvggTuwP@localhost.localdomain>
 <Z34h-hdI8VC_32g4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z34h-hdI8VC_32g4@infradead.org>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Jan 07, 2025 at 10:58:02PM -0800, Christoph Hellwig wrote:
> sb_rgcount for file system without a RT subvolume and without the
> metadir/rtgroup feature should be 1.  That is because we have an implicit
> default rtgroup that points to the global bitmap and summary inodes,
> which exist even with zero rtblocks.  Now for a kernel without
> CONFIG_XFS_RT that probably does not matter, but I'd prefer to keep the
> value consistent for CONFIG_XFS_RT vs !CONFIG_XFS_RT.
> 
> 

Your explanation seems reasonable to me, thanks for your replay.

Long Li
