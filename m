Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1142D8DA4;
	Tue, 18 Nov 2025 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445536; cv=none; b=buA1tWyaISMmiLBlDmzuW5MUX/4+OhuYcyiK9UE1PTH7NHC5qWML3TDzMXohlGaC/aOGNi90ach8knG6JlGhtmeSFVoZjPZxULPDOZolVj1RJsQJ+y2YHa2sndiaBPda3JqTi/P1+F/DwHuPj3s9jrQvCq0QpfWFEVKal+NQ5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445536; c=relaxed/simple;
	bh=dSqW7QpGYuUO/t3rrijDiq3njBz6tTtYVE8YGn46ylQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmLiCvy1ZZCV4Gqqpr0vDQOaq7AW0RE9kGb0iA3OH4relCZtsiT0M3AdKAowywgq9qHWDqfC6gOinHjqUxCclDiW4JociNqnsJjzSmYNYEZMtGT/KjhjXeGRgmLxKeZm+iNagDD/TkNhaTy/f52Xh8zxZPKDxqhcKh3fD2uTY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF5D46732A; Tue, 18 Nov 2025 06:58:50 +0100 (CET)
Date: Tue, 18 Nov 2025 06:58:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lockref: add a __cond_lock annotation for
 lockref_put_or_lock
Message-ID: <20251118055850.GB22733@lst.de>
References: <20251114055249.1517520-1-hch@lst.de> <20251114055249.1517520-2-hch@lst.de> <CAADWXX_ORdj=PaW5oeMybV6sEV6UxbZnRw4=TDZpa1Ejt0vbJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADWXX_ORdj=PaW5oeMybV6sEV6UxbZnRw4=TDZpa1Ejt0vbJQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 10:18:24AM -0800, Linus Torvalds wrote:
> Macro expansion isn't recursive, and having
> 
>     #define a(x) something-something a(x)
> 
> is actually perfectly fine, and something we do intentionally for
> other reasons (typically because it also allows us to then use "#ifdef
> a" to check whether there is some architecture-specific implementation
> of 'a()')
> 
> And yes, you do need that "#undef" to then not get crazy parse errors
> in the actual definition and export of the function, but it would
> allow us to avoid yet another "underscore version of the function".
> 
> I dunno. Not a big deal, but it seems annoying to make up a new name
> for this.

I know you can redefine names using macros, and now that you remind
me I remember that you like that.  I personally hate it as it means
there are two things with the same name, which makes understanding
the code much harder and confuses tools like cscope.  But I can
switch to that approach if you prefer.

