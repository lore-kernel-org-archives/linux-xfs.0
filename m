Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A119B2CA9;
	Tue, 17 Jun 2025 04:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750135592; cv=none; b=P/wBs10F8x1r+UoxQcIdC87har1MFFzKAOPa9E+rd52m9ea1FU9b9z90w4pv+2lnK9+c2aYJgTpGNj8RB7TQbrbS5XwNAZuUeolRGblOdQZHGc75TEr37FdPSFI1sfHa5k+ke/UEcepSJWggVUsx0PabsMvbPavv+ZZtFrlOtiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750135592; c=relaxed/simple;
	bh=uaIQ0uIzsqVYLwBrVtD7gETmN2xXO6XDLiJQ0hFgb8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBq1DsDFYpAxJpi+47im/x2zCUcOo+oAc1H30uBf7k+SRKnerXuo/QNLaXDasW64prVEd1pbyhbzYeymlMmMEc8Bc6v9cHUPRFB8/q7OEU64t7X4ofoMUy5TdGfElpXjKQGiCdmI9DHMfZw0V2EjXxO8NOEL5ZzkbQ9e0/cuH5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 063D768D0E; Tue, 17 Jun 2025 06:46:26 +0200 (CEST)
Date: Tue, 17 Jun 2025 06:46:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 07/14] xfs: ifdef out unused xfs_attr events
Message-ID: <20250617044625.GD1824@lst.de>
References: <20250612212405.877692069@goodmis.org> <20250612212635.748779142@goodmis.org> <20250616052810.GB1148@lst.de> <20250616105214.797509de@batman.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616105214.797509de@batman.local.home>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 16, 2025 at 10:52:14AM -0400, Steven Rostedt wrote:
> On Mon, 16 Jun 2025 07:28:10 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Thu, Jun 12, 2025 at 05:24:12PM -0400, Steven Rostedt wrote:
> > > From: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Trace events can take up to 5K in memory for text and meta data per event
> > > regardless if they are used or not, so they should not be defined when not
> > > used. The events xfs_attr_fillstate and xfs_attr_refillstate are only
> > > called in code that is #ifdef out and exists only for future reference.
> > > 
> > > Ifdef out the events that go with that code and add a comment mentioning
> > > the other code.  
> > 
> > Just drop them entirely, which is what the code using them should
> > have done as well.  We can always triviall bring back code from
> > git history.
> 
> OK. But I'll only send a patch to delete the trace events. I'll let
> someone else remove the actual code.

Yeah, no need for you to fix up the other code.

