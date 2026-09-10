Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F64235358;
	Thu, 10 Sep 2026 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031464; cv=none; b=Rn64cP4hyHKUxDpf/jAd5l2SBHCSK+NwKrJHPA01tlixzDG/EQarIfteNCTEohG0MAXm2GGg5vqdrknZNAa/Ycbh1BJLR8hZkUcK1I6IDa92Rbm/vjuT2uEBjP2y0zayMYdNDOkDtcVl5xCywiSysaQk1jikp/hpobrNOH+HO+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031464; c=relaxed/simple;
	bh=XO4XyBWt5bopJ9cQ3DUCzvhGa9mzTapSricPxGpYMD8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Vej/H8Nf5QFBS7hG6Shdoe2iL0HDC5JBM9mTolHKSgDeZ+K7IStAY16MLF3WriSsKR+8Xun/Qn8qe4rEecYPxHut4EruZfOhjSFS9EIdoqAQ7iMMfoO4DKW7QERyB5db0erMcICdts7SuhwDtj0oUghNfR2rs/foE04kFjHl+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAsI4Eq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAsI4Eq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AA41F000FF;
	Thu, 10 Sep 2026 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031462;
	bh=BUBITm3oadabboEDPFZnw4Zic7SikvaWPbVAEV/uFi8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oAsI4Eq2SzhYlmR4EsChOR+UNzA16Ua3ezup2sZYBll9YSjEgpaMnRmWCdacIqhAC
	 hcMX1lv/jj/9aw5wKyEeyMEJxO8w4blZHi+s8ft8bnk/AlTtv/PknCHAG+0+98IyNe
	 jIFO4DWpvy2D/GiYG/JUnERSEdDhL85m2kfas/z6FCwO/adDPnC6mOiPqWOlbBW2ns
	 9uUAducjdhVzld6PXhS0/7jv7W3iNlUcCQ8TNALBbOWiep7xjLHmvKADF2ldi5XW1i
	 b1QKmV0UnLwARdjutxcu8cHcuSYcmvR1rhDIt0bJ5B7fz8ypWhusK6cY0b4JCC2N9f
	 vk31RnoGE2Qsg==
From: Carlos Maiolino <cem@kernel.org>
To: dgc@kernel.org, djwong@kernel.org, hch@lst.de, 
 linux-xfs@vger.kernel.org, Zizhi Wo <wozizhi@huaweicloud.com>
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
 chengzhihao1@huawei.com, wozizhi@huawei.com
In-Reply-To: <20260905010354.142327-1-wozizhi@huaweicloud.com>
References: <20260905010354.142327-1-wozizhi@huaweicloud.com>
Subject: Re: [PATCH V2] xfs: remove several unused and never-implemented
 declarations
Message-Id: <178903146054.432315.1948146740365606179.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 11:11:00 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sat, 05 Sep 2026 09:03:54 +0800, Zizhi Wo wrote:
> Over time a number of function declarations in various headers have become
> stale: either their implementations were removed when their last callers
> went away, or they were never implemented in the first place. None of them
> refer to anything anymore.
> 
> Remove the following dead declarations and the unused stub:
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove several unused and never-implemented declarations
      commit: 157dcb8230a4e882e099ec4d1cb1957b0b2c9b26

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

