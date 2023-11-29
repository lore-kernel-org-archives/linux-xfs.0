Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K4yfY7zR"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B483A3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XSFPLggjgGe6SUVTvOGlI1IfsnU7u/d7jhHTDXxfBcg=; b=K4yfY7zR2L4PLhfiDoSjRuYsmD
	2dQ1/O7YZvaG2eWAYJslBnwzICk1DHcyjvL0alBsG7OQBA4zVVqmhP0tH7evqpNHb/82OMJWL7Y6Z
	6qi7ey7cD9GKTnuNWRAiSSct3GZdx7CiYH8OY0tmeI4JYnLe+hgPE79+xwp/Rv8F6+Jcn7ClgOb17
	ekq9suriQGNQbP6SL40Vm8zF5NUcHr1U/kBptWpfOGygdAwEZROW+mbDXeyTtg4BmZ8mz7bwqKy3U
	kMZFsoBRhBLvFGE7Nmnl6bupw8UmT2A9zvJw51dNC85KMDFpCuwL1yzIoW6d9KtJ2Ve3oL5b4yPwX
	8oTDJ/oQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Dfz-007AJ8-0E;
	Wed, 29 Nov 2023 06:03:59 +0000
Date: Tue, 28 Nov 2023 22:03:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: refactor repair forcing tests into a repair.c
 helper
Message-ID: <ZWbUT3L0bSQ03lpD@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927959.2771366.6049466877788933461.stgit@frogsfrogsfrogs>
 <ZWX3I1B2nAS7gF3l@infradead.org>
 <20231129054201.GQ36211@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129054201.GQ36211@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 09:42:01PM -0800, Darrick J. Wong wrote:
> > I find this code organization where the check helpers are in foo.c,
> > repair helpers in foo_repair.c and then both are used in scrub.c
> > to fill out ops really annoying to follow.  My normal taste would
> > expect a single file that has all the methods, and which then
> > registers the ops vector.  But it's probably too late for that now..
> 
> Not really, in theory I could respin the whole series to move
> FOO_repair.c into FOO.c surrounded by a giant #ifdef
> CONFIG_XFS_ONLINE_REPAIR block; and change agheader_repair.c.
> 
> OTOH I thought it was cleaner to elide the repair code via Makefiles
> instead of preprocessor directives that we could get lost in.
> 
> Longer term I've struggled with whether or not (for example) the
> alloc.c/alloc_repair.c declarations should go in alloc.h.  That's
> cleaner IMHO but explodes the number of files for usually not that much
> gain.

Heh, and I wondered if the check/repair code should just live with
the code implenenting the functionality it is checking/repairing so
things can be kept nicely static.  I really do not have a good answer
here, I just noticed that it requires quite a lot of cycling through
files to understand the repair code.
