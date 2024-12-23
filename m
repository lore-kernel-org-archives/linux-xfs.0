Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C6F383
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 01:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734916076; cv=none; b=S8R3LubXPBFMKXEr20ji8biHBgN4B4CncBYUlqSg1VXby2M0Vl/A/TeMNDO/aQE5RIG98bkzEKDWBZ71tejeyYoXbDa2/y4HT16rTJtLx1/PGiZtlQZQxmV0rRR/KWoEBGoMTkcFjiwxuxZsR5G/OZERjmhJEgmz3YWcs0OBS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734916076; c=relaxed/simple;
	bh=Z5DSsgYWkOhmnKQGuweJ7HoypKLFfU8tj58BYCnwQvE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/aI6lHFbVGhtzV0Yb38Dxqb6qnaSg6d02DadwP6texL3qz0AYW+ArH56EkKvusi7LwxGnrz+wM4GNxOFUf4mlTl6u0SNxH8eGuHh4Nh671/mHy4Z7VxzME74YCbkpc0IY/PPIkOYXayKuvlAVJ331gEt0ZqweL0R8xQfPCMhLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YGftc0MC0z1V6tb;
	Mon, 23 Dec 2024 09:04:24 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id A7A041800FD;
	Mon, 23 Dec 2024 09:07:44 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Dec
 2024 09:07:44 +0800
Date: Mon, 23 Dec 2024 09:04:17 +0800
From: Long Li <leo.lilong@huawei.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <djwong@kernel.org>, <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH 1/2] xfs: remove redundant update for t_curr_res in
 xfs_log_ticket_regrant
Message-ID: <Z2i3EdBPFxlY5cHH@localhost.localdomain>
References: <20241221063043.106037-1-leo.lilong@huawei.com>
 <20241221063043.106037-2-leo.lilong@huawei.com>
 <Z2Z25oUtIqtV_wjO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Z2Z25oUtIqtV_wjO@infradead.org>
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Sat, Dec 21, 2024 at 12:05:58AM -0800, Christoph Hellwig wrote:
> On Sat, Dec 21, 2024 at 02:30:42PM +0800, Long Li wrote:
> > The current reservation of the log ticket has already been updated in
> > xfs_log_ticket_regrant(),
> 
> Maybe say "a few lines above" as both calls are in
> xfs_log_ticket_regrant?

Thanks for your review , it's a good suggestion for me, I'll update it
in next version. 

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
