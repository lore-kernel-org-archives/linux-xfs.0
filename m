Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB510158DB1;
	Thu, 29 Aug 2024 11:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724930701; cv=none; b=M8C9ksC7dMRbhrlNLr/QUSpzuA4PNQwP2biU+WQt0HwAjD423V6iciWMzrgy09b600+qqe30kXcWHcJe4ajVC+eCCscaQ+ypXcIgAUsq3GYUJ/+0RbbUVMTobNSI2dlvKV38AU/P83qYRZ7SIUqAXTLNlplIm7Elj40z5KFKI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724930701; c=relaxed/simple;
	bh=FYDAbKjMprT+30E0SkamTgATHIiEKQyogZj2ApAJJAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fBpACDO7kOB19fPKoLA5wjY1TJbp5vIIXDCnkb2XawHn43BPCx3SoTJoLPsOCDLg/sD+HEDqrehbFXUO/9wYRanjT4SdgKdZB3ogKQ7i5wZaYQ+y6rusH3QAdHGikNNzI2uhB1nxV4JKVhTMyITNyNAtQLAbT0I5TOlcxz16EKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wvf5m3nfnzLqsJ;
	Thu, 29 Aug 2024 19:22:52 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id E0BD8180105;
	Thu, 29 Aug 2024 19:24:56 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 Aug 2024 19:24:56 +0800
Message-ID: <9337ebda-8e27-4754-bc57-748e44f3b5e0@huawei.com>
Date: Thu, 29 Aug 2024 19:24:55 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Some boundary error bugfix related to XFS fsmap.
To: <chandan.babu@oracle.com>, <djwong@kernel.org>, <dchinner@redhat.com>,
	<osandov@fb.com>, <john.g.garry@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20240826031005.2493150-1-wozizhi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf100017.china.huawei.com (7.202.181.16)

friendly ping

在 2024/8/26 11:10, Zizhi Wo 写道:
> Prior to this, I had already sent out a patchset related to xfs fsmap
> bugfix, which mainly introduced "info->end_daddr" to fix omitted extents[1]
> and Darrick had already sent out a patchbomb for merging into stable[2],
> which included my previous patches.
> 
> However, I recently discovered two new fsmap problems...What follows is a
> brief description of them:
> 
> Patch 1: In this scenario, fsmap lost one block count. The root cause is
> that during the calculation of highkey, the calculation of start_block is
> missing an increment by one, which leads to the last query missing one
> This problem is resolved by adding a sentinel node.
> 
> Patch 2: In this scenario, the fsmap query for realtime deivce may display
> extra intervals. This is due to an extra increase in "end_rtb". The issue
> is resolved by adjusting the relevant calculations. And this patch depends
> on the previous patch that introduced "info->end_daddr".
> 
> [1] https://lore.kernel.org/all/20240819005320.304211-1-wozizhi@huawei.com/
> [2] https://lore.kernel.org/all/172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs/
> 
> Zizhi Wo (2):
>    xfs: Fix missing block calculations in xfs datadev fsmap
>    xfs: Fix incorrect parameter calculation in rt fsmap
> 
>   fs/xfs/libxfs/xfs_rtbitmap.c |  4 +---
>   fs/xfs/xfs_fsmap.c           | 39 +++++++++++++++++++++++++++++++-----
>   2 files changed, 35 insertions(+), 8 deletions(-)
> 
