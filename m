Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE213CB546
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 07:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784534349; cv=none; b=ktkeLOPaV+jr//GKNq8Lh2Mil/REDUqx6iuxBtMH6feHNnk3w85O95sOG6QMFiVvmnN/kq0kdxWtWWnPEm5SgLQsBGP2xnaFxeKsoge6pSYGreIORtlhV32iNb6mQVxpLuxBFGlWCzfek7RkQtg4I6ra52h7P4Pp/jG7vR8aScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784534349; c=relaxed/simple;
	bh=5DWlOw3Ilg6IBA3BRzOrHqTcTygPmQsJYe8McEGbC8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgfEi95Lyztbl3B1dT50VLE3cy+jcCUsudayQryzaeUBGoOQHNtiuD8XlrL7B+C0AdDmRVTSEZB3JJfIho5YJEG8CxPzJikFZJOyAb9s6beZE1ANpuAL0WkzTNyzYZiuHU9Y1uV/yocWNez8pywVh23Uywr7NZy25PFnJrMTGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7395468BEB; Mon, 20 Jul 2026 09:59:03 +0200 (CEST)
Date: Mon, 20 Jul 2026 09:59:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in
 xfs_buf_get_map
Message-ID: <20260720075902.GA18645@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-3-hch@lst.de> <aljY0uI6jY8y2b3Z@bfoster> <20260717085950.GA32056@lst.de> <alo4doLYG7BzuCfO@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alo4doLYG7BzuCfO@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 10:13:10AM -0400, Brian Foster wrote:
> I see that you're intentionally separating out the lookup from the buf
> data locking, but it does still look like we're making a potential
> functional tradeoff here by changing the insertion side locking.

Yes.  That commit log tries to cover that.

> Note
> that I don't object or know that it matters in any way, I'd just suggest
> to add a note about this in the commit log in case somebody has to refer
> back to this in the future.

... but I guess the wording wasn't goot enough.  I'll try to improve it.

