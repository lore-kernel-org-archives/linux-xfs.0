Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66231194C80;
	Thu, 30 May 2024 23:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717110794; cv=none; b=ed6n+ELmFsr66UXEsbtlDmPS1uFxhG05N1w2lJEuGTGFT9FonSAvqdiWx3aqMQbn4vak4TQkJzgzfoXvIxKCGprqOILN7Llm8l51xlXlbgiOIYA4WoNpWpMTKp9Ympw3AmMR9x52P+5ntreLbOfNfKliSMvIcKP2LDzjMv6GV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717110794; c=relaxed/simple;
	bh=vuiX7wqkxeV9upJpfw9l9zGoXF0lwieB3Xf2aJMWEkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EK5DSo4bLzGY4GwQFPutrawHQB4JWF1DEWavj0Kq5yHd/7b0SE+XBpFAl9LgbOTn+gDMbC7tsULfP4mvF2zqTbEGQkM0j+aHNx05uYBiOYrhcfi2pRICNQ8hAS9TAXd1r3fGPWH+sJToIjoJytMh0l/TDq6wSfFtOG9xdA+i6CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=posJuOdl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="posJuOdl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=89rvWf/4Tfim/r3IdL4EWF39hSjLRqnEGNhNF2V+WL8=; b=posJuOdlzqWwym4tkDNS9mbv0h
	QNPOB2hUhXSWa9A6QiTW1YiR+WPWr44gl7qhxhxtV/YUh9sTkbixFg/E5bn+O8yq62VPNx22KcK4Z
	lzXeUb8NRnx4PWZH3tp8SFvAwYM1HnJgoCl4Sb8MSkoDQFpLD23gsLzoLhl68LUqDi21RDW4mViLj
	Rn0nEahCwstCGJVvRuAaIyJb5EVl2YwmDeeObY8PRG/5yN5LerjYXIsiRKwpwK9NrC6QZq3/ElJHx
	i/Xd7Hcuu4+xMNqC7R714TnJjrk8Ic4Q3ssf39wdYZ2YJqYVFFt619H2Iyc0vbUxQbgPgnDrhBJ/t
	pBacJfQA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCoxM-00000008fIm-2CRu;
	Thu, 30 May 2024 23:13:12 +0000
Date: Thu, 30 May 2024 16:13:12 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-xfs@vger.kernel.org, surenb@google.com, linux-mm@kvack.org,
	david@fromorbit.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com, kdevops@lists.linux.dev
Subject: Re: allocation tagging splats xfs generic/531
Message-ID: <ZlkICDI7djlmpYpr@bombadil.infradead.org>
References: <Zlj0CNam_zIuJuB6@bombadil.infradead.org>
 <fkotssj75qj5g5kosjgsewitoiyyqztj2hlxfmgwmwn6pxjhpl@ps57kalkeeqp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fkotssj75qj5g5kosjgsewitoiyyqztj2hlxfmgwmwn6pxjhpl@ps57kalkeeqp>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, May 30, 2024 at 07:03:47PM -0400, Kent Overstreet wrote:
> this only pops with kasan enabled, so kasan is doing something weird

Ok thanks, but it means I gotta disable either mem profiling or kasan. And
since this is to see what other kernel configs to enable or disable
to help debug fstests better on kdevops too, kasan seems to win, and
I suspect I can't be the only other user who might end up concluding the
same.

This is easily redproducible by just *boot* on kdevops if you enable
KASAN and memprofiling today. generic/531 was just another example. So
hopefully kasan folks have enough info for folks interested to help
chase it down.

  Luis
