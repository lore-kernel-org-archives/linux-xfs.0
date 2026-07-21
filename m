Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1490F4CA26F
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647664; cv=none; b=DYx5jS/GhNL3kseOLT9IIOrytfhTWguJ74HJIwWCTP3EkbuBtXkTTzmExqwjfb5RCSxrjrRMusiQt/jUiLYYJQg7IEIdE7JLqEDkNIn2vhNQi9nML01bDcKume2AzMYp9mUSWglkpIDegKSESM80jT8Iwl2qarXysj0w+2HB2TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647664; c=relaxed/simple;
	bh=vudqL70cP7e5iteeqtqeT5ZVRUuB8sHR9U/khHfKfkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmlBdCDAthBWxe0+ZAQ8p35Kar2fh0rqhAiUMxvVMrPopURSc5b8m6uAS7Anufb/O56CObYO9E1RkUZmdlZipJt6wE/RfohynHLJWGA8Hrr6J7jMwUXrqf/vquS+YF0wRKffn1XYHQ/5r8A/iuRg+IkuC4jJXZkietvVXqrTG2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DCF3F68BEB; Tue, 21 Jul 2026 17:27:38 +0200 (CEST)
Date: Tue, 21 Jul 2026 17:27:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, dgc@kernel.org
Subject: Re: improve log context annotations
Message-ID: <20260721152738.GA16685@lst.de>
References: <20260720094609.2191633-1-hch@lst.de> <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc> <20260721150142.GA14984@lst.de> <20260721152348.GY7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721152348.GY7380@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 08:23:48AM -0700, Darrick J. Wong wrote:
> > More review is always good.  But as a reminder for the audience:
> > lockdep and the lock context annotations are two totally seaprate
> > things.  The former verifies the locking state at runtime, while
> > the latter is about compile-time enforcement for the cases where
> > that is possible.
> 
> <shrug> The new annotations are consistent with my understanding of the
> annotated functions, but as I don't build with clang I can't say I've
> actually dug into its auto-verifier features, let alone run it.

Even with clang you need to opt into the in the Makefile for XFS.
As mentioned in this cover letter we're not quite ready for
that yet, but I want to get there.

