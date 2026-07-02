Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F1C30FF27;
	Thu,  2 Jul 2026 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000174; cv=none; b=IWPw+lI0ivOc2OkRdYL/KXny5kcIT0RneHq0bvcVRz4Y7QaOCU7l4QgTuMdlcm2EfAo36f5bcjeYIK2wffCNrd+s2LsYHSFhumahOWaYtKU11fScMyZRCXo8KnXGv9fxFwu6CZ5GNn2O/zA+EZAimG2rdrRWVBJZba5RjvO/bX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000174; c=relaxed/simple;
	bh=3Ug9c4Z9XE/ksD5EW63cpbWHHV1t/uEnyjYvHZutetg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=of1G4Cpa/D7x2iJpWguQem5aVNHylOlIas4T5YUxtEoRsX5eogBYQS5FYLxa9saDwrpgqTq/i+5uSvlZ/SkB2tQG6TWGSFERKeCmXD4xB9jKPl6Lits7tJnqbSBodoHF6waR5aEXXF//RhMAbHkpg3ktkAYjMa+OlXJwg8pUt3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wOSHFcv8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wOSHFcv8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gBiFwLwpMZ4xX7XKdbboQHYHT+1mcUqdGMEeb2uCi8g=; b=wOSHFcv8HZ65Phed7Z5NdTBSAP
	9aIZgkU9kT8A+xWn/FD1bNNZRWkoF5PS/OQRD77M0uKTGoXbFmsuK++sNENh0JbWoaLxB1NEdtwWf
	rIeiDHdjfDPlts7U6DVh6WT8h5hJhMTi4rV+spqMSZGJMuhbZxjGzUlWxhcs5OYhLZxk2On2RRieF
	RnRWnGwfY8tSFrVuOaF8PV2QAVlUKz8h5kvizCCCH6OyiqQ5VaFQOK+cZORKDBkrhdYyr6VzsYa4o
	Lg8fuY1cktvA4sq8l6CtsqtLHRavVb/cZDi05yIU0tjQ2J++600GkphW9wb+OpS+mzhyy6ua5jUiZ
	Wwo1eF8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfHnD-00000004Yhw-3y3i;
	Thu, 02 Jul 2026 13:49:27 +0000
Date: Thu, 2 Jul 2026 06:49:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/18] iomap: convert to in-iter iomap_next() model
Message-ID: <akZsZ2KV_-jsNZl9@infradead.org>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

What tree does this apply to?  I tried 7.2-rc1, Linus current
master, vfs/vfs.fixes and had slightly different failures to apply
with each one.

On Tue, Jun 30, 2026 at 05:09:15PM -0700, Joanne Koong wrote:
> This series implements a suggestion by Christoph for finishing the conversion
> of iomap to an iterator model. This revives Matthew's previous RFC [1], which
> had the same intention.

Btw, this evolved from my original suggestion to something that actually
looks much better, so don't give me too much credit :)

