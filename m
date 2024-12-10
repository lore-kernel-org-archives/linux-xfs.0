Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2709E23312A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808124; cv=none; b=Vjcd7tL1Fq9aC3cxTMYvGpJ+2sUsdBvxjD8rZyVSh6qX6aJuGrXwYQXptH1aTTa6th8SHz+PxWUqDlZ5QJ2kQ9Gs5UBKMQBAWtQU1Y72YxTJs92/IXI3qxVTdFzVOylTdg/wmhxA9au7RkeB7E5Nlr3SgxxyTyLszOyVPMYWS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808124; c=relaxed/simple;
	bh=3BJn6AzI3TRUQZTBD1Iflmuk1FDkF1lMZhKWU0ELMuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqDjgCOE7jOWFVRzDtkH/gGttLNie4W4y8jJFDualib4BenASwYo6SzMo/ZyWBSxHBBKwo7Ua7RIXksnusnxQdXu6J+awGfUMwIQnSnlmxihIjD+vXDn3SBvL3o3zh/IkTMxUzRH1FMusz4OyfOKd0z3u5IjjNSLmLcXsb6r4kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ltg48T01; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ltg48T01"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3BJn6AzI3TRUQZTBD1Iflmuk1FDkF1lMZhKWU0ELMuQ=; b=ltg48T01FT7kcLVUuq8dKUUth9
	WQjtXxF/58qlRMGxfhkRlEpJFAYEMbCDRUlKBJvqy3G/80FMamyJ/iQa//ljTYp0QGjdFmrdhAOWQ
	C4YAnIm/3D9YXT99vcOok6Lg9LLJ++e6X65s4oh/QyoC1mJjanEnwUW/QGlnHbCiNBRAC8lUl9JxJ
	/A+gWtAEp5qY9NxM/+M2zurvqMoxAmsZQrFHW7ahNw/pDItkH7Ic37ZmWZaJ7Q2C/2qZKvpsKASgS
	k9/OC4BODEsnxBBq3PHQy13DvO3c6XtwJlucEsrJz8MVrDLxTpF8Jt7oNZcpcUYw/uE6WUsG+eVtl
	33Wissrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsh8-0000000AGf7-2hJO;
	Tue, 10 Dec 2024 05:22:02 +0000
Date: Mon, 9 Dec 2024 21:22:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/41] xfs_repair: fix maximum file offset comparison
Message-ID: <Z1fP-lpYk-O6Llaz@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748828.122992.13639585878604982942.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748828.122992.13639585878604982942.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Should this go to the front of the queue as a bug fix?

