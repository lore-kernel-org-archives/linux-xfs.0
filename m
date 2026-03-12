Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3EB306B11
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 07:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773299208; cv=none; b=FqCHPiRckezJG1oKolqlOEemjM4mL5HEKss4l0Ma2VArs9jSYkpOG7AAFq9cfoGOq18D1xdsAEVEdquC95tPqVpsig8ibiNYtyQpxsdq2Y12mED4OQRINwcauWJW7LHLmDxmIginp2V1R+Nr2rGdO2G91MmdzO7eLWp9Qy3xiPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773299208; c=relaxed/simple;
	bh=DubE6SRvgLtXvBKjYmCaNY+X9MaHFjsv4qeEbv6EYK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQ2lBeIiMDm+C6Qu11pIOWvIkh2oB3CjI46uG8PNVz6hdrGGZH7OrE40+gwKo7VWufTCbqGrLAGo15+1t6szcAlNKk9aOlQTexYo3VUkVpe2eGtZjDyYx55d5RcdJ8nPZ54jsIww8/NNlMUI6ZHrv0SM7A6KrOevhm+3+NKcEes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LVseODcg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LVseODcg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fDzo82Ao26+OxSnEAhNEGEKE+3BuBUhQ00iFOgIR3fY=; b=LVseODcgsEVxxBHcWIjN1fwjAr
	0OQi92xBl3b8QVqum3QI1raYgoVKBBPHw8LJk9zuWqx60usWpXbpcoAxki0rsuoQJgvUxnAJDQfw1
	DLlcMygKAA/sRduZkAIk4dvhLSuUNDEIkNVh1rFIzrxMC5IhTnPY464Z5t1CEiJS8ht2Dphi7wfVP
	NpUJCjvBjCTTudowVmo9LSNbxmGLHR43FCKqIfNEUYPsBcqknZdmv02MqEOo/tCOQzcX0lGHRKCR9
	2JqrgdFWipQFHST8AFdBYAZYDnxpy6cxs4Z7uv+TogbJJDdouPlTdFDgKnwNIihToEzhA8J3OdmOX
	mGTn/U+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0a87-0000000DW5t-0AZr;
	Thu, 12 Mar 2026 07:06:47 +0000
Date: Thu, 12 Mar 2026 00:06:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <abJmBzRhCK46DcVk@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
 <aa_kSzpFeT7nuJeW@infradead.org>
 <20260310185622.GT1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310185622.GT1105363@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 10, 2026 at 11:56:22AM -0700, Darrick J. Wong wrote:
> Yes we could, though the risk with dropping the previous patch is that
> someone could introduce a third-party seccomp policy that forbids
> statmount() even on kernels that support it, and then xfs_healer would
> just fail if the mount moves.

Trying toi protect against broken third party security policies is
impossible.  If people do cargo cult "security" they get what they
pay for.

> I'd rather keep the getmntent stuff around since that's the classic way
> linux programs (including xfsprogs) have handled scanning the mount
> tables.  But if you feel strongly about not having getmntent it's not
> hard to pull it out.

I'm not a fan of keeping code around that doesn't really get exercised.
Although your next mail suggest we could exercise it, so maybe we just
need goot test for both cases.

I still hate the fragility of all this, but I can't immediately thing
of a better way.

