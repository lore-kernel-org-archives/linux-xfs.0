Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549803;
	b=YeNMzLhkDPsd5PfzpA4AK8qMGQyIzhACVCOTO+36PbbDAts6J+GU0bQYRBvb4sOaRcFP
	 2/CfgAj3jLKCHwYSKsbXsTlfFRgTcRloPkhf4dCgYn8+VnbWRKAVT5nEJSgV3L6doDKB0
	 MISIbrVjjaKeiRK17nmcvg80cTW1jQeATzg8hqAfJLYYBegAuZJK2dipshn0zSMDbR20n
	 BmZnRkZxCXasQ3/1AH4YGNk0omJ2yF8PJCzRgnxH5lJ2+RTj+aGknKSYQNXKGy13+bHO7
	 wD+xw8xq6JZQIXmV75KcdoAnZkLLru4ZJ/t4C6TPhoHqCEYkzH0Fbeh3UNt1t1uWV3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549803;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jk/+An4Tq9yr8l5pdd/sFTQrAku+UXbvv4J7iHzCn20=;
	b=eiOk2Y5PKdUhwCPUUVzmCiQKo1UMKlDtambR7s4pfMWXFBLAh4pbiW9xKCX//uVQ75sk
	 m0Wfd6XyNTjoFOKzvQXeneN8Q2lWToqDm0OqFwqUOn2mJX+NNWEdLr7jzGKDEG1hJBuhC
	 n3B88FE5jmr5UA3iL9lDJ39/x/PD44nNE4wMEr5L49xuokaRdCnbieCsYwBZ/GGOJRokQ
	 xtnzAMj4gdFR6PFkcrbCITRpTEvZ6/72vGDq2PKSW/rGq8OpuNFWWDW3sMrv0WHYvAqRa
	 dBSwARs7C+Jde3xjaBzRgNqYTKRPpInH0+e61/216lyx87w5rOu5Td5DdzFiblmkf8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFvUkmmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B96606A33C
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFvUkmmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324BB1F000F2;
	Tue, 24 Nov 2026 19:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795549803;
	bh=jk/+An4Tq9yr8l5pdd/sFTQrAku+UXbvv4J7iHzCn20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lFvUkmmYwTRet+Vr/inMtsIkermWBG5tFbyjAY4hS8J+tFwtYnl1mWg99ND6dg3a0
	 NicaMx7egNsdg2yxaDfz1kjBQjWjJQ35YxYZcayO+q+N3bNOf+dTgwKFP6LlVT7mUg
	 fllZ9LnzYvNbqNfB1C19rDmmcYTAeAJvahN+7p206eaoIDWRCSwCot4BCQLkb65qIo
	 vJcLQhgrgyWcE7EG/iCmnOkodX1WVEfXrqDNjuxcuy1ZPHVKMFe0/sLTbqUHi3pZqd
	 3cs/g8BknSbBFM1ypNC4418e52gZl4kcikaLipORe9Kje1h+9B9d7Tj649z20NEVs7
	 4etVHxrMcXKoQ==
Date: Wed, 25 Nov 2026 06:49:53 +1100
From: Dave Chinner <dgc@kernel.org>
To: Ran Hongyun <ranhongyun1@huawei.com>
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	chengzhihao1@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
	wozizhi@huawei.com
Subject: Re: [PATCH 0/2] xfs: fix zero-link inode link count handling
Message-ID: <awXqYTBgUOMmWCzW@dread>
References: <20261124115337.2297318-1-ranhongyun1@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124115337.2297318-1-ranhongyun1@huawei.com>

On Tue, Nov 24, 2026 at 07:53:37PM +0800, Ran Hongyun wrote:
> This series fixes two paths that hand a zero-link inode to the VFS link
> count helpers.
> 
> Patch 1 makes the metadir repair code set the link count directly when
> reconnecting an inode that was found on the unlinked list, instead of
> calling inc_nlink() on a zero-link inode.
> 
> Patch 2 makes xfs_bumplink() reject the abnormal zero link count with
> -EFSCORRUPTED.  A crafted image can contain a reachable directory with
> di_nlink == 0; mkdir() or rename() into it then reaches inc_nlink() and
> trips the VFS warning.

With your changes, it shuts down the filesystem instead of issuing a
warning and allowing things to keep working, yes? i.e. it turns a
warning in a production system into a guaranteed denial of service.

AFAICT, the link count being wrong doesn't immediately result in
anything worse than the link count being wrong. The warning is there
to tell us the link count is wrong, but I'm not convinced that
turning a warning into a shutdown is the right thing to be doing
here.

If we are going to abort modification operations on inodes with
incorrect zero link counts, then the link count needs to be checked
-before- we start modifying anything in the transaction, not deep in
the guts where we cannot sanely back out with an error. i.e.
xfs_bumplink() is the wrong place to be doing these sorts of
corruption checks.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
