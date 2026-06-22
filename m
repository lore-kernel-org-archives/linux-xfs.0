Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F016355F5C;
	Mon, 22 Jun 2026 05:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782107515; cv=none; b=JqwB+0eJxURi4UFYsiwEuUU1GQI20tuyu4o7FKWJllj4+w/oBEsrfHSYP//tH1TxYckLPRPxWQ2jGfLHZzSajkm3oCVxHdF0eH+f1qxVRsponldqiAGBm6njvFPpXEJlNqzj4DjwU4MNJappDdJ4YRgEgHH0AJJv8J/LJRMMuGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782107515; c=relaxed/simple;
	bh=GlfLZaTub/lxfFXF2HJRQ47ypmQgW6erH/AiqJxy1uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SEejH4INqThdHWLGAECDUy7/wh7FTzlJcLFYuYssf4Leh/RgvA/PPdUo2tZDpxp8B4krioXqehCiOi9ivH8+mmaAJDcK7BkHDKt9/ztg1z/2twJ+pS5+0wRYfxtvRXGSqimTlS9LE0mmJ2rNJGn9KmDC5lQZkmPceE2GcncWjgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yfeEizFa; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yfeEizFa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782107503; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yH0G0MgETg7Oe3omWmp44CsC9IA7RpwOCBDGLc2x2XY=;
	b=yfeEizFazeECxtRtY0srVJHy0dD74lGSdbRGC4CZs1ScxWquAQXzd35ufxlXqt6ZjhEOaFtJGeclmtVXS6dbd1h1bBDsDTVRPPwzZ1aVc0vE7R7tNj0+FLZLdx+AjTacNyBMe2eVAgtG1LSNWztOBRcUSOuipUO5w29AACupKTU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5HdX1o_1782107502;
Received: from 30.221.130.114(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5HdX1o_1782107502 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 13:51:43 +0800
Message-ID: <adbeabf4-8f3b-48db-bf28-de040863c04e@linux.alibaba.com>
Date: Mon, 22 Jun 2026 13:51:41 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: submit read bio after each extent
To: Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Joanne Koong
 <joannelkoong@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260619050105.439956-2-hch@lst.de>
 <20260619-kundgeben-hippen-abrunden-643fba56e35d@brauner>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260619-kundgeben-hippen-abrunden-643fba56e35d@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christian,

On 2026/6/19 18:15, Christian Brauner wrote:
> On Fri, 19 Jun 2026 07:00:53 +0200, Christoph Hellwig wrote:
>> Currently the iomap buffered read path tries to build up read context
>> (i.e. bios for the typical block based case) over multiple iomaps as
>> long as the sector matches.  This does not take into account files
>> that can map to multiple different devices.  While this could be fixed
>> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
>> over iomaps actually was a problem for the not yet merged ext2 iomap
>> port, as that does want to send out I/O at the end of an indirect
>> block mapped range.
>>
>> [...]
> 
> Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

btw, could we address this issue in the 7.2 cycle?

Not because that is a quite common case and needs a rush fix,
but Just because that can be reproducible under given
circumstances and users can get corrupted data.

Or if we need to hear thoughts from others, I think we could
delay one or two weeks though.

Thanks,
Gao Xiang
