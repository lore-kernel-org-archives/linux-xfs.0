Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F44199FD0
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 05:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747114389; cv=none; b=cdJdIN/9jMWf5Pgf1YIhwpRK4cwF6E4FzmOHb9F41Lbe901tMUK3418HEyGq8RFCM84vciFUUNGTOduCQ9gtr8jhTr4LlKtORgyJLAnHZijvtwiqXj3TbzQq1DnNVAnnvAxr1rLKDdJt2bC7WFu5ttz09j9bmWU45bGemYNmaX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747114389; c=relaxed/simple;
	bh=dZSzmQl9EaQBhB2CYWUL88huLxBG5wuhqN/3RrYyFRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNAvILYc/S5519FoZkLUDQ7EhtQ6QKXnK8iEw8IxHG5jluu7bWuyL0XD/ZL7EkDpePe4X4YX1+pA1GtgdxiRBRJHb9r6OLcLjNj2xaugsYw4PJjxeOkGvxfCxLtWzRVDd/5mbR5Rg6gpJ3+GEo+xw4a7p9fJ0R6yfzRZPhvGGQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FP8OUQVJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FP8OUQVJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vJ9NTpY3OUjH6G9MgK5vtC2ac9bmHd+fwRBI45JD1mQ=; b=FP8OUQVJuSUbS9SwskVVuiqjZY
	Bcwp5yZd7Wk5O35jaLpHqDVh7IgYEgtitBwSET4si789/3d9JVm2Mk2lLyCP8TQfhxdcuUFsjsVmM
	xvKXS0kdAVOE7qDiPPuTpRmu68Nq6npqPsIPp5Jw9mjb9xrJNwBY+H8LWVtVTmZ1r+KfcLX7O6b0s
	9IyCa3uz9+IhnIc119MPihfLgOUEi1RU96NOR/fv8VXqMv+cIveydbr31qMP1esY/O4L9UOqjjKz7
	MASdm7aBmRbrzNEHD0JjmPRZ65eYQR/t1jZMnW1z3Os7bARgPQ2k7cN1Pi4BgWdq0Zhjat9FG2BSu
	jN2RXzZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEiGJ-0000000BOqD-12kr;
	Tue, 13 May 2025 05:33:07 +0000
Date: Mon, 12 May 2025 22:33:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dump cache size with sysfs
Message-ID: <aCLZkwKfKP7lxX7b@infradead.org>
References: <20250507212528.9964-1-wen.gang.wang@oracle.com>
 <aBxHLBvotK0IH3tE@infradead.org>
 <CFB084EC-00A9-4EF4-9DB6-34E1102774E2@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CFB084EC-00A9-4EF4-9DB6-34E1102774E2@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 08, 2025 at 05:14:54PM +0000, Wengang Wang wrote:
> What’s the concern to add the syses code? Though the patch looks big
> (but not really very big), It’s simple and direct.

It adds rather special cased stats for something that does not seem
like a killer use case.  Especially as we should have a generic
way to collect stats form tracepoints, be that using bpf or normal
kernel code.

