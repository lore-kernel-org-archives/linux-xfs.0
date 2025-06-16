Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989EC46B5;
	Mon, 16 Jun 2025 05:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750051696; cv=none; b=TZWHf/95Dqb5R1Ed8AO3J3ISJYoPAgbLK6GepWx08nptMLhrbN5c6SAMIuh1S7OoRQTjGlIyUUEfaMGdxG3m+uFs80OmO+PobDrZHZWsIEMZwdFXlGHYxAKdCCDhyyirXsiicopkSdyp2whL2gFxxsqu3aVFCplSggA21QZhtcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750051696; c=relaxed/simple;
	bh=y6/xbAj2sgoXm9Y8QGNpdpm/uiCjtktBmHi+ar3x4RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsL1I4REyGh5Y0tx1UR04jceEnt8/wyuWA31Z+PSJPjdaHvWqgv1tI5Yi9ECfkTK6tFBDjpOhGf/HPbLgS2Q1KIkiOzhMpoqpQA2Sz2IRfQss5PxFvyfVsrzIwRqq38eHTsr4frDFtI6lnhVO30j4yJfwj2UksO4RJeLNnmO5BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EC77668BFE; Mon, 16 Jun 2025 07:28:10 +0200 (CEST)
Date: Mon, 16 Jun 2025 07:28:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 07/14] xfs: ifdef out unused xfs_attr events
Message-ID: <20250616052810.GB1148@lst.de>
References: <20250612212405.877692069@goodmis.org> <20250612212635.748779142@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212635.748779142@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 12, 2025 at 05:24:12PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Trace events can take up to 5K in memory for text and meta data per event
> regardless if they are used or not, so they should not be defined when not
> used. The events xfs_attr_fillstate and xfs_attr_refillstate are only
> called in code that is #ifdef out and exists only for future reference.
> 
> Ifdef out the events that go with that code and add a comment mentioning
> the other code.

Just drop them entirely, which is what the code using them should
have done as well.  We can always triviall bring back code from
git history.

