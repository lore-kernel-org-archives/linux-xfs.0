Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199940BCB8;
	Fri, 11 Sep 2026 07:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110757; cv=none; b=m3LzqIkhqQ/1rzmQq/yksVYlsHoMXxB0TQHj5bGzZpU8V44Ru6uXQkDfX0XIK5UUgBOfiS4DCvJTcVhaeJOC1LJdnn9Xy94dK6T/q2IAHUIsbvfvWjis2mNR2blJ7rFeFLLBdOW8VugalB2CC/Ite1JINIfUHcDs2txEUn4it1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110757; c=relaxed/simple;
	bh=nXHvbRgh0ZrB8Lqi0a5FrQ0dc2KqUdrF7f6A6ypab0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mp/WVsJgz+1dgek5shCv/yutUQ7Die8OLE4WN7NE72xPlRPQcwmUYhOqE+0M2GWitRmgfJLPN6y7Q2v0trF8wYV6PVaYI3sZi58UoavVN39SNYxcVWIaZJ2r93vR685GI+Z4s0rmCkuOmNalEZw1y3Bk/zEAMGr9cqlUTZEzujA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mZ27Wgh0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mZ27Wgh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CSLl2pTV9G5RNi/qW1WAhE3OwQjF0Em548onbv341dk=; b=mZ27Wgh0fh4rJTM043iPLCyA2S
	S13CZu2W4O8GvGPHN9qwQG/Z2gy3iC3U/bqNmqbzQySy5Y0ZtGr33+DD+UeoPiCWKB1Wo6xv+0lGY
	auk8hxk0OaNMWG9KHl82aC0nZzdxMf5KVHaNyr+YMnCkm+iWOj7RYlEzILWR9NNjjL3bfukiQ0BOP
	Xopf/XWgZxQq0rbAfStyERZQ+b6DSNRhNAb9W2P/0316R9bIeCncmLVahaFGsVRe2K+z8uMTRZfYE
	gHZXNvqKkHTDjeJQxa4cGdo2RddJfnfnIbm4sGbIjS26CdpTe1MYDdRLCTJRCehE/Dy2xEujYCmJ5
	MV8MsGRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vQp-0000000G0Hn-1o0m;
	Fri, 11 Sep 2026 07:12:19 +0000
Date: Fri, 11 Sep 2026 00:12:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, brauner@kernel.org,
	djwong@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
	david@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	ljs@kernel.org, linux-xfs@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
Message-ID: <aqOp035i41XIrDXg@infradead.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster>
 <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 11, 2026 at 08:57:53AM +0800, Kefeng Wang wrote:
> Another question is the target repository for merging this patch.
> Both this patch and the previous bug fix are based on the mm-new
> branch. Merging into xfs separately (if an independent branch exists) might
> cause conflicts.

Your first follow up fixes a xfs bug that can have somewhat nasty
consequences.  So I'd suggest you send us a standalone series that
we can get into 7.3 and -stable with as few dependencies as possible.
mm-new can get rebased on top of that, and then we can delay the pure
cleanups for xfs until after that is merged

