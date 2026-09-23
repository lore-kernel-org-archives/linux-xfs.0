Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7745123D2A1;
	Wed, 23 Sep 2026 04:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790138351; cv=none; b=WTy85nbjrQunmf6WPqewL72ZilgGeeHrdsvCTIC/4aRLWRFhnJM738cRM5HTzGTzpUGTHI1s5+Z3y9V/JTYVw0E43eq1eRnyvV3G8KWIFCakfsgg8GloNfsxzLpMtvq+7wVvRaHjQgec0NEg8ERwZuFRRVg0Tm2wCwT1qDtUZTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790138351; c=relaxed/simple;
	bh=T5p0YoKY2yNH1uled9dzB9bEqXjfvZRTAwRwxBF3Yvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C71vp0pRAMj//ucGPcnTucrKURhEj2Pmv8nI/iukihc1TwWpiz8KtSYI8H67XQrqKg6wHVa2cDnMuhUVSKCP/k81JTWCXDPQOyCQSNBwAypFs9zjlZh6mwKkxgf129c/WXzETBKNfM2iR54OrMCdemQWNjqRQOoGbBEWEkwanwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4EpQsxwK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4EpQsxwK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T5p0YoKY2yNH1uled9dzB9bEqXjfvZRTAwRwxBF3Yvc=; b=4EpQsxwK+MTj5Bl7WqCLJCI5lz
	yrvjIB9hTQ0m84VpKU4Vq0fqRVAw3y0xJPY2PW5pRoM3wy/IgzWQHQi+DWtlXtYpM0EXXcSQu9RBu
	SO8LpuecNwAMsuPRC/mar4JO7/nPRzQtLmLLeD8G/hlMMOyO0FhPz1tqPq+vrTif9gFpvee8K9qhj
	VNCHbwM+I8KXY7rdCK8ZjxJ5dxQ/lPdP4mM3CtjAeOlBp3tQE+4aZHwGpzja+Pj/CBIl54Di4dhy2
	+z3Tuk/6IC5QXeNiF9drY6FQtDY+A9TALsvTiRcEYBaSGtGJsxiFduuSt/xBfVk75ZwVu9pbE/3n4
	SNLbZ73g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9El7-000000077c9-3rPz;
	Wed, 23 Sep 2026 04:39:05 +0000
Date: Tue, 22 Sep 2026 21:39:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/14] xfarray: don't crash when sorting if array element
 crosses a folio
Message-ID: <arNX6VG1SA1iCrXE@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120763.181988.2563798655569721557.stgit@frogsfrogsfrogs>
 <arIQntfRrNKGHyoF@infradead.org>
 <20260922175313.GW2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922175313.GW2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 22, 2026 at 10:53:13AM -0700, Darrick J. Wong wrote:
> On second glance, I think a cleaner way to fix this is to move the logic
> that loads the folio, computes the new {first,last}_folio_idx, and
> validates them into a new helper:

Heh, I was about to suggest a new helper, but didn't feel like I'd
want to cause you too much work..

