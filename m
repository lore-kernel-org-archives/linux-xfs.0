Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BC23D4132;
	Fri,  5 Jun 2026 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648926; cv=none; b=P3wVlQ9QO23r4Shc+nq6AqSngCQGVTCUhJv1EGVVB9LYGY8gCoql516cJDQ9XT5Bt5xy16nX5j0LeOaVyfbSUTSJHEML6xMgY/ogAExFlA9HxZk8ejpIf6Dpj62vqIf1hVeapLbuLnW132xaUP0lvK9Ma1B8O/TCEBj4UD92hmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648926; c=relaxed/simple;
	bh=yzb24TpLAp45ZbSLBJ7229o+dwI8tlL0sEQYtpsUfuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mk9fHbCb5DTKEgwrlHLjP+EOnAHlqz+tE6b8KrOQdub96udIxBfw/mwU0CZMD4koe1gqaEdOzXw5Jt5Eym7NTXV8jDITaWZPMocEA+d22g4uZcwtzz8KH4MTkIGSbNYZLhzyeeZ5jCOvWGpBNW3zeuz7N7UB4e0/FxmzHPpocAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3glwLU1S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3glwLU1S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WZa9Q3L2Vk8aVEOr8JStkVf1cXxCHSmMSmwS8anhg58=; b=3glwLU1SNics0UJ2rNaqj6yrt9
	Smhqx/WeSwr7/IuGlU4GbtIb2NkE5ew2Rf0+bxcYRmuApD7rKkoNW2oOYgkDzYcRD2oKJhAVqjOha
	m2LODOgs1oNVDJ4xcV3wkfPDBFb1p9piZZREsDgAbpZt0mM+q0deVf1si+m0iW1XEG7PTwkIbGC08
	Xfy3G1efRqEt1rJbjFeackPqEbKPRQeiOfsZW+Tot7VHRMt6RWPA41IM0KQkVW48moiygMIu9h1fX
	yimZslS+jvNkFuUUf0T9FJg/iJoM7B9odndW4FqOcI1FcmOyovkucISkc4Mx3VUAJzNcruHIHqKJJ
	3rwDmjag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVQ7w-00000000Kg9-1BZ1;
	Fri, 05 Jun 2026 08:42:04 +0000
Date: Fri, 5 Jun 2026 01:42:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: Simplify data output in xfs_zoned_show_stats()
Message-ID: <aiKL3H1uJUqwZMAu@infradead.org>
References: <995bacb6-881a-4fa0-b2c8-190882522f54@web.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995bacb6-881a-4fa0-b2c8-190882522f54@web.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 04, 2026 at 11:20:55AM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 4 Jun 2026 11:16:01 +0200
> 
> Move the specification for a line break from a seq_puts() call
> to a seq_printf() call.

Umm, no.  Make the code much less redable for no real benefit.

