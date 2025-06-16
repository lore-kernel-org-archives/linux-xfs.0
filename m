Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6CF22083;
	Mon, 16 Jun 2025 05:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750051885; cv=none; b=VAqw6OFW9d4CdGO3EKf3sJsKnHI3nD5hm9fCXS9wJtumBJyIRzZY1S/FkXd0caLyri7hVNB/6AnRg141fKRDzIIz6C0ayFN8rHwYNoQhGHhWylpDHzGnojIjHeozedhxX99HfYZhv0rGLhxxbsTwSNQxdEQ6y+8izh0n6r4cli4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750051885; c=relaxed/simple;
	bh=zSaOHFrXIviraOq+DBoF/OzWdoBrZxNNGBbVMZCvNrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9hyP1Yl2Q5SADcIogr4931+KTi4r9+NQuONPqiIdg5l4qf2CHN3amRRX7J/dmIqEfzbZLBKD0qhEkkRC6fKBfzlpUH+2BYcKaA/SyXJRGgGPH7kFTrLJwP5JFpDIgo9j1NB2it/VSbsgcyqhoSNeHxo9ex0QlM02UsmiYwhvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2465468C7B; Mon, 16 Jun 2025 07:31:20 +0200 (CEST)
Date: Mon, 16 Jun 2025 07:31:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250616053119.GD1148@lst.de>
References: <20250612212405.877692069@goodmis.org> <20250613150855.GQ6156@frogsfrogsfrogs> <20250613113119.24943f6d@batman.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613113119.24943f6d@batman.local.home>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 13, 2025 at 11:31:19AM -0400, Steven Rostedt wrote:
> On Fri, 13 Jun 2025 08:08:55 -0700
> "Darrick J. Wong" <djwong@kernel.org> wrote:
> 
> > On Thu, Jun 12, 2025 at 05:24:05PM -0400, Steven Rostedt wrote:
> > > 
> > > Trace events take up to 5K in memory for text and meta data. I have code that  
> > 
> > Under what circumstances do they eat up that much memory?  And is that
> > per-class?  Or per-tracepoint?
> 
> I just did an analysis of this:
> 
>   https://lore.kernel.org/lkml/20250613104240.509ff13c@batman.local.home/T/#md81abade0df19ba9062fd51ced4458161f885ac3
> 
> A TRACE_EVENT() is about 5K, and each DEFINE_EVENT() is about 1K.

That's really quite expensive.  And you only measured the tezt/data/bss
overhead and not even the dynamic memory overhead, which is probably
a lot more.

