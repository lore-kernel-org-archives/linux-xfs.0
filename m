Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3F12E11C6;
	Fri, 13 Jun 2025 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828687; cv=none; b=KZSRSFyzI8NETzN3tV/vKpJq3mm0wK4v91yD0ghAnqU15oVm6XafMR0bbm6MOyXw0aYp0v+Mvb1egRZiNnqTq8avc2LaFQrKP1uAaE9aDVujHgnkhfii0UONtbB0GsG+gYTxET3A17NpHSgZBXH6RuMSuhADUpxRaUrCw/Oun4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828687; c=relaxed/simple;
	bh=0V4cVz67m6bKVOXrmjwkE61NWMpQGCWLJTNBsxSMtl4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rb1/gjjQSbNxQ/I7QNUC/balUcdBLvOzuN1Pn8surk5WBmMYIlyS3YU5/5M1pKo3VG8Gm+pP++1Z/M/4dwU24wzV8LZX8cXcJG9MJiFccieEgYa+5j/q/4+Fny8sn3E08V3gmWIz3pahhVotQQ2cl4P23kSYLBSfk7s2a9aA4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BC38BCFF0;
	Fri, 13 Jun 2025 15:31:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 627751A;
	Fri, 13 Jun 2025 15:31:20 +0000 (UTC)
Date: Fri, 13 Jun 2025 11:31:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>, Christoph
 Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250613113119.24943f6d@batman.local.home>
In-Reply-To: <20250613150855.GQ6156@frogsfrogsfrogs>
References: <20250612212405.877692069@goodmis.org>
	<20250613150855.GQ6156@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 627751A
X-Stat-Signature: iqh69rybaagf6c4x8yf7aeabzf93kcgc
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18lGmiFOzahpOVgXIaZy/KKDFrEpTuTzQc=
X-HE-Tag: 1749828680-25266
X-HE-Meta: U2FsdGVkX1+tf6ETOK1PqRkVQ1pHs1OKlNOvo2HOGrdo7daD1E1/mHgku5l7FD6zFf7oRJzKOFAHudSzUzyQ4BzcjJSMn7Ag9ElcYJ2hp8bHgdY8iIZOUXlRfeuBDjPtnNuyPoydRtNwrxrEligHNBfVoqwTDlu+80BBlKSBRO7FBncnv1KgqxzBnREaLBzUS5hTNI/BG3wo+iR45gz/PyCf4n2wrMBahRf/kjI5OTtxxueVsqMKy9E9YU93/R7l+BU3Yo8m+74gWbCpcNJwANRIwJaD8KcHdCS3Lq5LgMPxunuAGRUpHbBPWIswtOUfpoA6EmrWuA02nYSM34ODcK9AOmA3V+lT

On Fri, 13 Jun 2025 08:08:55 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> On Thu, Jun 12, 2025 at 05:24:05PM -0400, Steven Rostedt wrote:
> > 
> > Trace events take up to 5K in memory for text and meta data. I have code that  
> 
> Under what circumstances do they eat up that much memory?  And is that
> per-class?  Or per-tracepoint?

I just did an analysis of this:

  https://lore.kernel.org/lkml/20250613104240.509ff13c@batman.local.home/T/#md81abade0df19ba9062fd51ced4458161f885ac3

A TRACE_EVENT() is about 5K, and each DEFINE_EVENT() is about 1K.

> 
> > will trigger a warning when it detects unused tracepoints. The XFS file
> > system contains many events that are not called. Most of them used to be called
> > but due to code refactoring the calls were removed but the trace events stayed
> > behind.
> > 
> > Some events were added but never used. If they were recent, I just reported
> > them, but if they were older, this series simply removes them.  
> 
> TBH it'd be really nice if there was /something/ in the build path that
> would complain about disused tracepoints.  I often put in tracepoints
> while developing a feature, then the code gets massively rewritten
> during review, and none of us remember to rip out the orphaned traces...
> 

That's exactly what I'm doing. In the thread I did the analysis, it has
code that triggers a warning for unused events. I'm currently cleaning
them up (and asking others to do it too), so that I can add that code
without triggering all the current unused tracepoints.

Feel free to take those patches and it will warn at build time. Note,
it currently only works for built in code, so you have to build your
module as a built in and not a module.

> > One is called only when CONFIG_COMPACT is defined, so an #ifdef was placed
> > around it.
> > 
> > A couple are only called in #if 0 code (left as a reminder to fix it), so
> > those events are wrapped by a #if 0 as well (with a comment).
> > 
> > Finally, one event is supposed to be a trace event class, but was created with
> > the TRACE_EVENT() macro and not the DECLARE_EVENT_CLASS() macro. This works
> > because a TRACE_EVENT() is simply a DECLARE_EVENT_CLASS() and DEFINE_EVENT()
> > where the class and event have the same name. But as this was a mistake, the
> > event created should not exist.
> > 
> > Each patch is a stand alone patch. If you ack them, I can take them in my
> > tree, or if you want, you can take them. I may be adding the warning code to
> > linux-next near the end of the cycle, so it would be good to have this cleaned
> > up before hand. As this is removing dead code, it may be even OK to send them
> > to Linus as a fix.  
> 
> ...oh, you /do/ have a program and it's coming down the pipeline.
> Excellent <tents fingers>. :)

Ah you did notice ;-)

-- Steve
