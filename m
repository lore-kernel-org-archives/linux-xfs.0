Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B65F383
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 01:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734916318; cv=none; b=FtvzhiMAaTYPe7DJQJSQ/HLH09zDgG/vJcNuEpOY/kT5J7hXgGU7483HqJdYnD9YkUOxIdwPOdahCt7Q+Yd+faWvw8glwXOb5e3ms+1BsCYHyPMSCVaxjr56D0qWCWq5tEsEa9G98uWqaLy54Ol5xqv+moOzjxUF1m/vbgX6WaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734916318; c=relaxed/simple;
	bh=3IsEjoXvqV7WfWi44Ea9ajUhA7wH1pOLdbeDb/YCP5I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1ANK3+uOGC74u/Nbp8CEOr3TFLhrhyoh6zVhdiatfWTAmwprcJRH+PtcnqJXMNGK9i5efwu69fLhbqaRP/y5G+qz07TXjMoaq9JUGYyQ/mAnYJPT06SrkPde+LtNvKpT9uFplKttmjGkhflDEDvJyS4t1ogDNWoYYYdrH5AvYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4YGg3W16Wpz20mb8;
	Mon, 23 Dec 2024 09:12:07 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id C88B11A016C;
	Mon, 23 Dec 2024 09:11:47 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Dec
 2024 09:11:47 +0800
Date: Mon, 23 Dec 2024 09:08:21 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/2] xfs: remove bp->b_error check in
 xfs_attr3_root_inactive
Message-ID: <Z2i4BVpGXsxt17zj@localhost.localdomain>
References: <20241221063043.106037-1-leo.lilong@huawei.com>
 <20241221063043.106037-3-leo.lilong@huawei.com>
 <Z2Z3mLjW7KXQKexP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z2Z3mLjW7KXQKexP@infradead.org>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Sat, Dec 21, 2024 at 12:08:56AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 21, 2024 at 02:30:43PM +0800, Long Li wrote:
> > The xfs_da3_node_read earlier in the function will catch most cases of
> > incoming on-disk corruption, which makes this check mostly redundant,
> > unless someone corrupts the buffer and the AIL pushes it out to disk
> > while the buffer's unlocked.
> > 
> > In the first case we'll never reach this check, and in the second case
> > the AIL will shut down the log, at which point checking b_error becomes
> > meaningless. Remove the check to make the code consistent with most other
> > xfs_trans_get_buf() callers in XFS.
> 
> Hmm. I don't really understand the commit log.  The b_error check
> is right after a call to xfs_trans_get_buf_map.  xfs_trans_get_buf_map
> either reads the buffer from disk using xfs_buf_get_map which propagates
> b_error, or finds it in the transaction, where whoever read it from
> disk should have done the same.  So I think the change looks fine,
> but I don't think the commit log really explains it very well.
> 

It's true that the commit message is not clearly explained, and I'll rewrite
it in the next version.

Thanks,
Long Li
