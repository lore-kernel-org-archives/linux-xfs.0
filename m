Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92693B5850
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734537; cv=none; b=JR00XXr7J8p0znoTzlFSaXkXLJ1xcZmnnZ1DGvVs4XCK1GTsnVsJDyuN0PTdsZWAmhvYSxtxR6j+gy2hldr9jrrLrI7sHqISca7srR2Lkii7zeZ6DuD+fZKQvUTygNjGmU55Kj9xDpgrkAPwOZAhdV07UW6C4xih1YHqOdUcqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734537; c=relaxed/simple;
	bh=6HHnuM6fG/lhvHHDzxaWxU16oVEOtCL+iVgib0KAtJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZEMaZ8nFZ45tSkI2DHzbk7W2YS/Fu6ecvSljPDE/j8qcqsO8jNFrL/9QNa+GUE+AQknSqTTCY4RqNEWW8Toh45nQzH6XmCilVFwIc6IBWB+xq+1lDI6Y05R214o/7J5YulhdLMolE7BoaujKcVrx7LV0iYKJjVyUGr6iogLTPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=K7A1suCT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="K7A1suCT"
Received: from macsyma.thunk.org ([104.135.218.88])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66MFYH17032533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 11:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784734463; bh=/XVAf9v4NJTOhwslkTBHwx0MifNIHYg+F6jgSYaisLE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=K7A1suCT0FQMfJGAljUD/0TLPbcAbvPUnohCBMVp1jWGj3dn8gNBy+eNslIZ1gw2B
	 HznDOujpIR7USvbRBKYkjRCRC5UhzAnzT6sPBhVjX9Fu5W5eXf/oGKTd5jpvn9CE3R
	 g557xFayM1vIs3S7TLoAmcjRCBAeBeN7I50cQWOdxKB+tYiSIyV1r2mSy0KQmdsxqh
	 Lf0RhghBE56wg7RNPDeu7RUNNA7gTk7iC9S1motbxT9QRsdidmquZXuiaPy/E657dX
	 d5QQWAB8kwDWR7E6KHmGnZfVdaMOJ9R1hk+9MrggBMD1dsK+1/jYJuBvjBEILAwWB5
	 Vxp49Vbbm/cnA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 1FC21BA65EF; Wed, 22 Jul 2026 11:34:17 -0400 (EDT)
Date: Wed, 22 Jul 2026 11:34:17 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
        joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        chengzhihao1@huawei.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com,
        Zhang Yi <yi.zhang@huaweicloud.com>
Subject: Re: [PATCH v4 0/5] iomap: trivial fixes for ext4 conversion
Message-ID: <amDiuuX56ChS6LO0@mit.edu>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714082325.325163-1-yi.zhang@huaweicloud.com>

Hi Christian,

These fixes are needed for landing support for buffered writes using
iomap in ext4.  That won't be ready to land this development cycle,
but could we land these fixes now?

Thanks,

						- Ted

On Tue, Jul 14, 2026 at 04:23:20PM -0500, Zhang Yi wrote:
> Hi,
> 
> This is v4 of the trivial iomap fixes for the ext4 conversion. There are
> no code changes relative to v3, the only update is the addition of a
> Fixes tag in patch 03.
> 
> Changes since v3:
>  - Collect RVB tags from Christoph.
>  - Add fix tag in patch patch 03 ("iomap: fix incorrect did_zero setting
>    in iomap_zero_iter()").
> Changes since v2:
>  - Collect RVB tags from Darrick and Joanne.
>  - Remove CC stable tag in patch 01 as Joanne suggested.
> Changes since v1:
>  - Add fix tags to patch 01 and 04.
>  - In patch 04, change ifs_set_range_uptodate() to always fall through
>    to ifs_is_fully_uptodate(), preventing a false-positive uptodate
>    mask.
>  - Add patch 05, add comments for ifs_clear/set_range_dirty().
> 
> v3: https://lore.kernel.org/linux-fsdevel/20260713072906.1726059-1-yi.zhang@huaweicloud.com/
> v2: https://lore.kernel.org/linux-fsdevel/20260520030357.679687-1-yi.zhang@huaweicloud.com/
> v1: https://lore.kernel.org/linux-fsdevel/20260514062955.1183976-1-yi.zhang@huaweicloud.com/
> 
> 
> Original Cover-letter:
> 
> This patch series contains a few trivial iomap-related fixes in
> preparation for converting ext4 buffered I/O to use iomap. 
> 
> The first three patches are taken from my ext4 conversion series [1], as
> suggested by Christoph. The fourth patch fixes a bug originally reported
> by Sashiko during review of my series; although unrelated to the ext4
> conversion, it is worth fixing on its own. Please see the following
> patches for detail. The fifth patch add comments for
> ifs_clear/set_range_dirty(), and the last patch avoids merging ioends
> that have different private data.
> 
> Thanks,
> Yi.
> 
> [1] https://lore.kernel.org/linux-ext4/20260511072344.191271-1-yi.zhang@huaweicloud.com/
> 
> Zhang Yi (5):
>   iomap: correct the range of a partial dirty clear
>   iomap: support invalidating partial folios
>   iomap: fix incorrect did_zero setting in iomap_zero_iter()
>   iomap: fix out-of-bounds bitmap_set() with zero-length range
>   iomap: add comments for ifs_clear/set_range_dirty()
> 
>  fs/iomap/buffered-io.c | 58 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 14 deletions(-)
> 
> -- 
> 2.52.0
> 
> 
