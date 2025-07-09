Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F5F5383;
	Wed,  9 Jul 2025 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752047683; cv=none; b=ikdHJxIazQOpUdHgwd25cF+kkPjidC4f0/fmBvmkbRTsP6BY40ip0jK3Od7SzJ817+R/lf6pMiIKp5SgOgb0ZGhMNKZwQ4Bi9AHgsJnEkQdj5pNCGGBtiVq0vN+R2F2yIMl/tbDXjO7Kjx0oJRgXIvYUwlAxlcFI8QZUtPbZpUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752047683; c=relaxed/simple;
	bh=vwJNSb1g0imbYM31rsqb8a67KFO7wq3KWHuBjftjOfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J4H48vpZp5XHssgvXVfzZIseb+ctSpEqIbg3AyEfG0WJeVc7Uf46y/irDRvatYM8FmUJ+3U4ZHt9YLJX7pcd/ocKIOe9MCS9S58va859+anG55FwBE0GWOWo9nrwiXdAlg9h95h1ojjgJDI8pD+ZVzekT80FMfvUihvNuYyYZ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rtelwgqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rtelwgqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A67C4CEEF;
	Wed,  9 Jul 2025 07:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752047682;
	bh=vwJNSb1g0imbYM31rsqb8a67KFO7wq3KWHuBjftjOfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rtelwgqk1qdn6XNwAQSXrLiqiA/VPdQUsJiqdl5NZWbX05FcyUncnmtkkfpeBsph+
	 Vdisv4CALNfz/3EMj7r2bp+VaXVKzdyl8Yq9hnkGsDayEkUPlYl5daiHE4PfsPemp8
	 IzP65jchNtJgJF915x9dgw8hfJUDc9kj+GuvXrsU9G9roigElMuVQvO6j00K6Bovne
	 TQ6Me2EYogTwsmt2kdnqnfOAr5TI4feUptoNbxmp1GTFShpA5lw/szrAwo6+wcTO1i
	 ObMJcgpTssQpQwCck/32iIdQuw26quOuvzUgOIREnj1h7WfwggyBQG9SsPJKHkY+bA
	 UD/pBmrawW9iw==
Date: Wed, 9 Jul 2025 09:54:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, 
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 00/13] xfs: tracing: remove unused event
 xfs_reflink_cow_found
Message-ID: <l56iobcpwdvdd5b7elwxcvp7btp2sfubqoxg7intx5wjzuj5bc@dc3v7mpgr5pa>
References: <20250616175146.813055227@goodmis.org>
 <uggqM4FTewFhLCJboUto49yP1wdr5erpnCdX-piLRMNV8IzM9h6Qv-nkmI6ieg6aAWOSRe9IiJvLS2R3yyCklQ==@protonmail.internalid>
 <20250708180932.1ffdca63@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708180932.1ffdca63@gandalf.local.home>

On Tue, Jul 08, 2025 at 06:09:32PM -0400, Steven Rostedt wrote:
> 
> Should this go through the XFS tree, or should I take it?

FWIW, I just realized that for whatever reason b4 chocked to send a
'Thank You' msg to you when I applied your patches. It sent to every
submitter but you. That's why you didn't receive a 'personal' thanks :)

> 
> -- Steve
> 
> 
> On Mon, 16 Jun 2025 13:51:46 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Trace events take up to 5K in memory for text and meta data. I have code that
> > will trigger a warning when it detects unused tracepoints[1]. The XFS file
> > system contains many events that are not called. Most of them used to be called
> > but due to code refactoring the calls were removed but the trace events stayed
> > behind.
> >
> > Some events were added but never used. If they were recent, I just reported
> > them, but if they were older, this series simply removes them.
> >
> > One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
> > around it.
> >
> > Finally, one event is supposed to be a trace event class, but was created with
> > the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
> > because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
> > where the class and event have the same name. But as this was a mistake, the
> > event created should not exist.
> >
> > [1] https://patchwork.kernel.org/project/linux-trace-kernel/cover/20250612235827.011358765@goodmis.org/
> >
> > Changes since v1: https://lore.kernel.org/linux-trace-kernel/20250612212405.877692069@goodmis.org/
> >
> > - Removed the first patch that mistakenly removed xfs_reflink_cow_found
> >
> > - Change subjects to start with lowercase
> >
> > - Removed xfs_attr events that are used in an #if 0 section instead of
> >   adding #if 0 around them
> >
> > - I added: Reviewed-by: Christoph Hellwig <hch@lst.de>
> >   to all patches but the one with the modified #if 0 as Christoph
> >   said he looked at them all.
> >
> > Steven Rostedt (13):
> >       xfs: remove unused trace event xfs_attr_remove_iter_return
> >       xfs: remove unused event xlog_iclog_want_sync
> >       xfs: remove unused event xfs_ioctl_clone
> >       xfs: remove unused xfs_reflink_compare_extents events
> >       xfs: remove unused trace event xfs_attr_rmtval_set
> >       xfs: remove unused xfs_attr events
> >       xfs: remove unused event xfs_attr_node_removename
> >       xfs: remove unused event xfs_alloc_near_error
> >       xfs: remove unused event xfs_alloc_near_nominleft
> >       xfs: remove unused event xfs_pagecache_inval
> >       xfs: remove usused xfs_end_io_direct events
> >       xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
> >       xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()
> >
> > ----
> >  fs/xfs/scrub/trace.h |  2 +-
> >  fs/xfs/xfs_trace.h   | 68 ++--------------------------------------------------
> >  2 files changed, 3 insertions(+), 67 deletions(-)
> 
