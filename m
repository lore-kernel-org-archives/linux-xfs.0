Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EE8D512;
	Fri, 12 Jul 2024 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720786382; cv=none; b=W+nnrx0T4og173ZvM2OYNygWj28Qx57+vLvuNyhcIaeItSXwY/joJpd3ePJCZVLS5sOnOTxZl/kCnGQZoXzsehbocLxGYksIX4w5Y6O8nEjtjctl4E8tLqidHbi65mRwfJxXM3W/cnMnwBjjoCdYYq7bxehbpHYd1paJnkb3vRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720786382; c=relaxed/simple;
	bh=1+Yfdw6riiV8LwSEY6hqiRjwk2gF445GfiGNMNa0cJY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BF/9XA2ZBULbYjJyIYywYPN7oEMi6m/f8hooHjJdSKGR8lPIJ2DYXl7niLtL7rO9KpAPDf5X/c26+yq4BBXRqCCHr5/uuHUKVy6GF+DlOzVdlKsTjk+A9oP9fUc3TAbLput88CUusQWcQExetsT1y6g4EpS0eKv/SPSNWsCt0Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526F9C32782;
	Fri, 12 Jul 2024 12:13:01 +0000 (UTC)
Date: Fri, 12 Jul 2024 08:14:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Dan Carpenter
 <dan.carpenter@linaro.org>, Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <20240712081416.1e58e32d@gandalf.local.home>
In-Reply-To: <ZpC5FTEvLDbCije6@infradead.org>
References: <ZpAB2HU8zE41s9j6@infradead.org>
	<20240711211754.316de618@gandalf.local.home>
	<ZpC5FTEvLDbCije6@infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Jul 2024 22:03:17 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jul 11, 2024 at 09:17:54PM -0400, Steven Rostedt wrote:
> > That "f->f_path.dentry" is a dereference of the passed in pointer. If we
> > did that in the TP_printk(), then it would dereference that file pointer
> > saved by the trace. This would happen at some time later from when the file
> > pointer was saved. That is, it will dereference the pointer when the user
> > reads the trace, not when the trace occurred. This could be seconds,
> > minutes, hours, days even months later! So %pD would not work there.  
> 
> Indeed.  I'm so used to these useful format strings that I keep
> forgetting about them doing non-trivial things.
> 
> Which also brings up that it would be good if we had some kind of static
> checker that detects usage of these magic %p extensions in the trace
> macros and warns about them.

Well, at bootup there's a runtime check that is done to every trace event
that is registered (an also on module load). It looks at the TP_printk
string for any dereference characters. If it finds one it then tests to
make sure the pointer points to something that would be in the ring buffer.
That is, if you have TP_printk("%pI", &__entry->saved_ip), that would be
OK. But if you had: TP_printk("%pI", __entry->ip_addr) it would trigger a
big WARN_ON() on boot.

See kernel/trace/trace_events.c: test_event_printk()

> 
> > 		__dynamic_array(char, pathname, snprintf(NULL, 0, "%pD", xf->file) + 1);
> > 
> > // This will allocated the space needed for the string
> >   
> 
> > 		sprintf(__get_dynamic_array(pathname), "%pD", xf->file);
> > 
> > // and the above will copy it directly to that location.
> > // It assumes the value of the first snprintf() will be the same as the second.
> >   
> 
> > 		  (char *)__get_dynamic_array(pathname),
> > 
> > // for accessing the string, although yes, __get_str(pathname) would work,
> > // but that's more by luck than design.  
> 
> That sounds pretty cool, but except for the dynamic sizing doesn't
> really buy us much over the version Darrick proposed, right?

The difference is that you save more space on the ring buffer. Instead of
just allocating 256 bytes for every path, it will only allocate what is
need, plus 4 bytes of metadata. If most of your paths are less than 248
characters in length, you will likely get much better use out of the ring
buffer. That is, less dropped events.

> 
> > Looking at this file, I noticed that you have some open coded __string_len()
> > fields. Why not just use that? In fact, I think I even found a bug:
> > 
> > There's a:
> > 		memcpy(__get_str(name), name, name->len);
> > 
> > Where I think it should have been:
> > 
> > 		memcpy(__get_str(name), name->name, name->len);
> > 
> > Hmm, I should make sure that __string() and __string_len() are passed in
> > strings. As this is a common bug.
> > 
> > I can make this a formal patch if you like. Although, I haven't even tried
> > compile testing it ;-)  
> 
> Without having compiled it either, this looks sensible to me.  As XFS
> was one of the earliest adopters of event tracing I suspect these
> predate the string helpers.

Yeah, I was thinking that this was probably added before __string_len() was
added for this exact purpose.

I'll write the formal patch and test it too.

-- Steve
