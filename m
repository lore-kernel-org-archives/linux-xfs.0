Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF8C1AA1DA;
	Fri, 13 Jun 2025 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749827336; cv=none; b=n4GWPB5L0tYA5lS1kij4GFxSOuZMKGDolBSOn4kRuDONiNIecBiRUSaJfZ+7Hi2UuWnBmMcpQ91nAseffD2OGYtJsLdANZ4c/gZPYKIHrbtZkxdEH0RGt/24q4BFzMYayh5CnT6w0iNFmmA+wJscCiUNEfCZFiW/6Yp1GwtwmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749827336; c=relaxed/simple;
	bh=KcxStdt8f8rzcLQ2tvp3NeEaAi/emd0jaeTIX1dmMLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+dt7Fge9aV3dwRvfeA0U0qjYNQ69FNZikBH4CCThF60FK//OtPlPfVx9OvFrcpkn/NX2muqLPJB0EsZlLtkOR/cyL2H39Zjif8SXQErxtV9Bx8kDdLiB2lM/dm4F1ijR6ZJBXvG3NkUpGnzepRzqKkPHeUDzv+azMFNwzalHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCszDAiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCszDAiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DBFC4CEE3;
	Fri, 13 Jun 2025 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749827336;
	bh=KcxStdt8f8rzcLQ2tvp3NeEaAi/emd0jaeTIX1dmMLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CCszDAiZcQhun/+u+GhD53nmGwteamscEbgh22Qkeu8kQBL4niBdejC8SrkRrghso
	 wY5FVO5Q5CMPR7NdyshGq1dY1awU+XFJJ7IajkG7EHJ2nmTM/v+8+mSOYojMw8CqTf
	 hzlmjceHcQzyxZsVD747XMfbYxqx3YKP/k0c9d4yD24blG9YhrQMcgv50b/yta4Wda
	 K2GnSHoUXUYZiMhGVl1cvsdpwTVz/zO9D8FHKb6Et6cVqJULwkHyAEt67HYD0ek3mP
	 RJ/gP05iMwUuj8dGCqHMhT5A/sZqKJStWUfZFtcffjhxXXSIDPZW9e/zK1R7VeTiXo
	 7qsY5kIDTdU6A==
Date: Fri, 13 Jun 2025 08:08:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250613150855.GQ6156@frogsfrogsfrogs>
References: <20250612212405.877692069@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612212405.877692069@goodmis.org>

On Thu, Jun 12, 2025 at 05:24:05PM -0400, Steven Rostedt wrote:
> 
> Trace events take up to 5K in memory for text and meta data. I have code that

Under what circumstances do they eat up that much memory?  And is that
per-class?  Or per-tracepoint?

> will trigger a warning when it detects unused tracepoints. The XFS file
> system contains many events that are not called. Most of them used to be called
> but due to code refactoring the calls were removed but the trace events stayed
> behind.
> 
> Some events were added but never used. If they were recent, I just reported
> them, but if they were older, this series simply removes them.

TBH it'd be really nice if there was /something/ in the build path that
would complain about disused tracepoints.  I often put in tracepoints
while developing a feature, then the code gets massively rewritten
during review, and none of us remember to rip out the orphaned traces...

> One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
> around it.
> 
> A couple are only called in #if 0 code (left as a reminder to fix it), so
> those events are wrapped by a #if 0 as well (with a comment).
> 
> Finally, one event is supposed to be a trace event class, but was created with
> the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
> because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
> where the class and event have the same name. But as this was a mistake, the
> event created should not exist.
> 
> Each patch is a stand alone patch. If you ack them, I can take them in my
> tree, or if you want, you can take them. I may be adding the warning code to
> linux-next near the end of the cycle, so it would be good to have this cleaned
> up before hand. As this is removing dead code, it may be even OK to send them
> to Linus as a fix.

...oh, you /do/ have a program and it's coming down the pipeline.
Excellent <tents fingers>. :)

--D

> 
> Steven Rostedt (14):
>       xfs: tracing; Remove unused event xfs_reflink_cow_found
>       xfs: Remove unused trace event xfs_attr_remove_iter_return
>       xfs: Remove unused event xlog_iclog_want_sync
>       xfs: Remove unused event xfs_ioctl_clone
>       xfs: Remove unused xfs_reflink_compare_extents events
>       xfs: Remove unused trace event xfs_attr_rmtval_set
>       xfs: ifdef out unused xfs_attr events
>       xfs: Remove unused event xfs_attr_node_removename
>       xfs: Remove unused event xfs_alloc_near_error
>       xfs: Remove unused event xfs_alloc_near_nominleft
>       xfs: Remove unused event xfs_pagecache_inval
>       xfs: Remove usused xfs_end_io_direct events
>       xfs: Only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
>       xfs: Change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()
> 
> ----
>  fs/xfs/scrub/trace.h |  2 +-
>  fs/xfs/xfs_trace.h   | 72 ++++++----------------------------------------------
>  2 files changed, 9 insertions(+), 65 deletions(-)
> 
