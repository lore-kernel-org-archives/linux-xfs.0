Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAC71F1315;
	Wed, 10 Dec 2025 05:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765342969; cv=none; b=BF2IG5yB9aBntOPYxCl+kLW7Lm4QtWZwL21BawspfAIBKqVEhjNn/sZjtdk/hVq9Hm/uPoGon7lM/GDQ9LmZ0a498BWoHIgipFoRM82Qn10Pl4thGo3JJR3uP+AafPcahnzNEtg8j9D6xTtQnzbbGBSiXcjbfmKaRARSfq6lpvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765342969; c=relaxed/simple;
	bh=42jNbugG8pQMKeJ4tz3Pjm7eLLC93En4NGjVSBZpYbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vF295gmyFqiXM3byI5essqkjmzFW//kHgj2vm1ZNhYpoVDYA3XSO9n54HoYP4q91e6UpfCJU5BU0/Erd9aCIrBIlp6smEEGYyUiqSATRU7/hSSfcaehFmw2Pao3KCo1U87v+rL+NUIaUGKn7nUzzks9VRsWdOAsuV0xAPgp9wfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/AJcOAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/AJcOAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D163C16AAE;
	Wed, 10 Dec 2025 05:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765342966;
	bh=42jNbugG8pQMKeJ4tz3Pjm7eLLC93En4NGjVSBZpYbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/AJcOAx8MXzCC4B+fbKn0hohRkdJx/GXvEOOTs+6u77i1jZu6ODvObJB4IdCYUpI
	 cZ4HHnoWTg6h1BEVa2FXEMwqNyMCA/NtJFQFw/jOJn6vyarKEvpI2yNv6Sg9DCHUpB
	 4qE20e6EcSu6gWXLQNClrxw/uqprCeoxX41TjAVf0xEq/F6wvQly89DTd83ikOhc+8
	 zz8fIidPoFCalyWUMFDHqaha2G7vFmM35xNQA0Q7fhExIDPtQ15hW1M6dTX0kT7DCC
	 5TRnpIhjGJwu96NpnRQdie4jiCfsv8nCN/CiGAVUAGb8meAwowjP7MfRq3F7qEmN7K
	 mSyq3SAXBVWGQ==
Date: Wed, 10 Dec 2025 14:02:43 +0900
From: Keith Busch <kbusch@kernel.org>
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-nvme@lists.infradead.org, iommu@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Message-ID: <aTj-8-_tHHY7q5C0@kbusch-mbp>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>

On Tue, Dec 09, 2025 at 12:43:31PM +0100, Sebastian Ott wrote:
> got the following warning after a kernel update on Thurstday, leading to a
> panic and fs corruption. I didn't capture the first warning but I'm pretty
> sure it was the same. It's reproducible but I didn't bisect since it
> borked my fs. The only hint I can give is that v6.18 worked. Is this a
> known issue? Anything I should try?

Could you check if your nvme device supports SGLs? There are some new
features in 6.19 that would allow merging IO that wouldn't have happened
before. You can check from command line:

  # nvme id-ctrl /dev/nvme0 | grep sgl

Replace "nvme0" with whatever your instance was named if it's not using
the 0 suffix.

What I'm thinking happened is that you had an IO that could be coalesced
in IOVA space at one point, and then when that request was completed and
later reused. The new request merged bio's that could not coalesce, and
the problem with that is that we never reinitialize the iova state, so
we're using the old context. And if that is what's happening, here's a
quick fix:

---
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index e9108ccaf4b06..7bff480d666e2 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -199,6 +199,7 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	if (blk_can_dma_map_iova(req, dma_dev) &&
 	    dma_iova_try_alloc(dma_dev, state, vec.paddr, total_len))
 		return blk_rq_dma_map_iova(req, dma_dev, state, iter, &vec);
+	state->__size = 0;
 	return blk_dma_map_direct(req, dma_dev, iter, &vec);
 }

--
