Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B484E36D4
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984289; cv=none; b=MN7DM7HmKT6QZDcDVAcDD8HhY1/D5lGLX5OD4YTfj2en2SSxnriAGWSm1FG5Iz1qgfkMfqF6X+fPl/EkHmlei3WmGAEnaAPDIg8AEXvpwScccn6TD5hSv2skpz2tDNXztCoaXKVY9yOmulGsXbRsL8ri15hn/Bp6Hkgv1C7TxCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984289; c=relaxed/simple;
	bh=DKLZMfU698DuGT+jU2WsMEuYOD/3a4Zq1CWbfhKoD3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXav39xkGbcfl6hMwrBMUf7xEUDEUikOIz6PAsbv1LuRghD0n0L6yV72AUQOMQsjRr6xKd/0YABujNqI+UChhFgpCN8e1sf79O2deKQABlHwMiepkRyY3oFTADYmme0neS+5r32DX6u91usQa0A+IegqDyBhwqH/snjOn2xCMqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R8nycZtj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R8nycZtj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AMl+YIJBCSTmE/5CAr/rU4PEZNQqE5iGdKaf8JRUB1A=; b=R8nycZtjsYygjeM8d+5B5BPMZD
	yuSSmJs/8oJv+ts4GsHfulyAN+D/98HXOyxHEr6VCeZsP6ZcX8eeETYtHjQk+KoCoZGKcA3opJ5lq
	hA9Gh5ZEynoW4foiPmF/d1r+65HSeZanTJeA303EF4RbPdZlli+9cP107Kc1ehKWCS/Kjnv4eaBlS
	yAbC88EtKeMx6c4nZUAxboXdsdCoKl4GRJX9x6MmoRq63RAJb9vbgwUdrZHeJxG1gvHnKEb9qxBc1
	5p/l3CwoOpaFYiuu+tjyQmfi+101/F9SVw03TWbXBIyhXb7mSpWvw4SPF2mE40JXwizH6c9O5R6m5
	yiWp/ZBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGyyN-0000000FaOG-1w1q;
	Wed, 14 Oct 2026 13:24:47 +0000
Date: Wed, 14 Oct 2026 06:24:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Nathan Scott <nathans@redhat.com>
Cc: Stephan Mueller <stepmueller@phys.ethz.ch>, linux-xfs@vger.kernel.org
Subject: Re: rw stat clarification
Message-ID: <as-Cn1IgedpN1BVv@infradead.org>
References: <4103a3f702be0ccf0e6eeb34981b3d65@phys.ethz.ch>
 <CAFMei7MchKT5CfDPOafJGjzxZ6L=Kr3vDSRHvYXDWK9THmuqcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFMei7MchKT5CfDPOafJGjzxZ6L=Kr3vDSRHvYXDWK9THmuqcQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 02, 2026 at 08:39:08AM +1000, Nathan Scott wrote:
> Hi Stephan,
> 
> On Fri, Oct 2, 2026 at 12:08 AM Stephan Mueller
> <stepmueller@phys.ethz.ch> wrote:
> >
> > ...
> > May I go ahead and make it
> >
> > rw #reads #writes
> >
> 
> Nope, this is an ABI.  Userspace code has been written to this
> interface for >20 years.

Indeed.  But it would be really useful if we could better document the
interface and/or make it more discoverable.

I guess we should draft up a document for it, or maybe even have another
sysfs file making it self-discoverable?

Also one think I've wondered about:  Can we add new values to existing
lines without breaking consumers?  Where the biggest consumer really
is PCP, so that's probably the most interesting answer.

