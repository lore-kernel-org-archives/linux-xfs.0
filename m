Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978F12F2910;
	Tue, 28 Jul 2026 04:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785211848; cv=none; b=Ab8MPP7ED1vGcoJ6BgygY0oS6MAvPmTxnoOtmgn3IGIRaGhwLb7g9UXn4uol2x7IfCEIh6fwhq8UhTFeu0hzjl3AcvjKrMSRi9gbrIs37SfMATFYUEhnXorjDtE213M9MBiPdImphsbi2T5BA3B3IVMV2Ho3ar8XK4qwHAYsBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785211848; c=relaxed/simple;
	bh=qQ8tiXwOfLuc4J7s3KzNrt+IwirvQhmaCdIlqEnKi2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pREuKr0vq/orVclMBMc6ClNc0FoV1QXL+OHEti/BgsFfzWiM475+c/kgUhPH2sZfvydjUh/hezpUjOPzrC3079JWl/tUnN9nHFWzXhgAT64yVxOheq6VKqJuwblSjm2bwLX87AEDB+WCDT7x81dKk67m4tBhZEud4Ri6vsqJRf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k6YB7qml; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k6YB7qml"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Td1vC0tbHFijfIC/tIoxinpG9AEVL47fpXhtFq4dESg=; b=k6YB7qmlMdueiRDklF60uxMx7R
	iYmCdKpjv7aBKd2uSTtPEPvzdVmgw5PyYWv71UZ+yZsayPAhu1tkf7iGwuvzV9EScn6VYRQt1NRBx
	cAvsx9qrqqlfc3I/8t3cAnMH4I3jQVjnZrkQUontuRxHcFx9Xp39bcQbCPhoKx1hrwn9s3apFuh80
	+aiPFUCuCWaJdy3r2pSWrsNqLerpBezTOlvjA116cNB2fz2nIKYkgz15axexTOv7J7e7a7v0G/jjv
	hNgsaAupIIFurp6o6GOwalIQ7zMOz3xHZxq6qpJgQ1/VRdg1xHXvPGevGzzIhBvdzmBLfUAkOyiPv
	sS2o1Drw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woZ9O-00000004Mtr-0p5b;
	Tue, 28 Jul 2026 04:10:42 +0000
Date: Mon, 27 Jul 2026 21:10:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <amgrwn0yQoFvJP4u@infradead.org>
References: <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 22, 2026 at 12:45:25PM -0400, Tal Zussman wrote:
> > 
> > Any progress here? The patchset looks really promising so I'd love to have
> > it completed :)
> > 
> Sorry for the delay - got caught up with some other work and had to set this
> aside for a couple weeks, but haven't forgotten about this. Planning to pick
> it back up some time this week.

Sorry for another ping, but we have a lot of code waiting on this
kind of infrastructure now, it would be great to get a version in.

