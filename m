Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA19AD21;
	Tue,  8 Jul 2025 22:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012579; cv=none; b=oHbofOykhfUDyUiDkheSPKBEcMn8JclfYFuRtMq59H4nt94Lrl0BdFf/oV6q56DezAm+MSlJShp0QOfdYz5RTQvYpH3qsuPejyEtif1YywPnERa2ce+VQf7HsGiZJQ3SeUljd2hPSbDd1srzoYr6oITb0fSoV1ryHIYS5PmzsDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012579; c=relaxed/simple;
	bh=Zrcf/4rib4V7MmaFntVQOz4YMBCbvsWPfjhkWyYeAB8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWrXlVQnZJKUOySoW4W6V3oPKQhPPdIyU0QgBY2TRp3ag4b58btqNPcyFS3JRkISevp2FlOhdxugz2s6zot7Kbhnrd+pI1sth/pqM0bWtbJvVjvYeZEOSeIySv6MIE3OV4gt2f9ADlckGQ20o1lYAHzFElaCwl6DHId4vmltQEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DA511D853C;
	Tue,  8 Jul 2025 22:09:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 29B7A20024;
	Tue,  8 Jul 2025 22:09:31 +0000 (UTC)
Date: Tue, 8 Jul 2025 18:09:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>, Carlos  Maiolino
 <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J. Wong"
 <djwong@kernel.org>
Subject: Re: [PATCH v2 00/13] xfs: tracing: remove unused event
 xfs_reflink_cow_found
Message-ID: <20250708180932.1ffdca63@gandalf.local.home>
In-Reply-To: <20250616175146.813055227@goodmis.org>
References: <20250616175146.813055227@goodmis.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pm7k4g8qysdsrm1wtfihrks9f6pniye1
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 29B7A20024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18zyU2k3dO5Lc1tmm0xtU6mAOSFP+U3xjI=
X-HE-Tag: 1752012571-580348
X-HE-Meta: U2FsdGVkX1+gP+LMV0n4w+CJAzKr0PBeKS4qefE50YlXdw1XPxWzeym1Bh3VLuVFAn4/FIg5fDtpfxLOW3Dm54FNszDfCfK/YXjtbutpwS0MBUlqZMCSNgNdyzu9LdbroZP/VGbmSQTeMtmjb51as0xW+ddFSstyTyS0TeGhamawP03ylTeaVvGYKTp38cTX6EwPoNjsu3Bz5V0V8/sqwBehtAwC7DfmkxY4GOqvZLLJkEKA1D7/zeOLK65uLaJ9cLDqYaVrdAUASwGjFhZVqfRaF+l6+rjRxxrHA+7vSmI0qwjmZPUwi3kYxr0M6fo/TrozhbEoFLwqsB8UEzhMvh7QwgHjxaEDOLR+lkVUcwascAoZpVEc+buFuccm41fGkTrF/87DR3h6N9HzsYzyJw==


Should this go through the XFS tree, or should I take it?

-- Steve


On Mon, 16 Jun 2025 13:51:46 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Trace events take up to 5K in memory for text and meta data. I have code that
> will trigger a warning when it detects unused tracepoints[1]. The XFS file
> system contains many events that are not called. Most of them used to be called
> but due to code refactoring the calls were removed but the trace events stayed
> behind.
> 
> Some events were added but never used. If they were recent, I just reported
> them, but if they were older, this series simply removes them.
> 
> One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
> around it.
> 
> Finally, one event is supposed to be a trace event class, but was created with
> the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
> because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
> where the class and event have the same name. But as this was a mistake, the
> event created should not exist.
> 
> [1] https://patchwork.kernel.org/project/linux-trace-kernel/cover/20250612235827.011358765@goodmis.org/
> 
> Changes since v1: https://lore.kernel.org/linux-trace-kernel/20250612212405.877692069@goodmis.org/
> 
> - Removed the first patch that mistakenly removed xfs_reflink_cow_found
> 
> - Change subjects to start with lowercase
> 
> - Removed xfs_attr events that are used in an #if 0 section instead of
>   adding #if 0 around them
> 
> - I added: Reviewed-by: Christoph Hellwig <hch@lst.de>
>   to all patches but the one with the modified #if 0 as Christoph
>   said he looked at them all.
> 
> Steven Rostedt (13):
>       xfs: remove unused trace event xfs_attr_remove_iter_return
>       xfs: remove unused event xlog_iclog_want_sync
>       xfs: remove unused event xfs_ioctl_clone
>       xfs: remove unused xfs_reflink_compare_extents events
>       xfs: remove unused trace event xfs_attr_rmtval_set
>       xfs: remove unused xfs_attr events
>       xfs: remove unused event xfs_attr_node_removename
>       xfs: remove unused event xfs_alloc_near_error
>       xfs: remove unused event xfs_alloc_near_nominleft
>       xfs: remove unused event xfs_pagecache_inval
>       xfs: remove usused xfs_end_io_direct events
>       xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
>       xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()
> 
> ----
>  fs/xfs/scrub/trace.h |  2 +-
>  fs/xfs/xfs_trace.h   | 68 ++--------------------------------------------------
>  2 files changed, 3 insertions(+), 67 deletions(-)

