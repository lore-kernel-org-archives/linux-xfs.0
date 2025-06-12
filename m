Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762A29C328;
	Thu, 12 Jun 2025 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749761939; cv=none; b=LZaatLpIRjEEW7VHTyWgWeavNOCsXnZRMx2C/s9echsyZIW5jFejwjTLTMdGcKWxt0CNmLaxywR9j9TepXdmA+STMaqlcZAmf6QqPYCAGPmYJVWk/sqCuriXhsvNiJny2qYvQsz+qV8cXREHRQ0SMx8/9PwuskNZUYil3aTWuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749761939; c=relaxed/simple;
	bh=1oUi5CI5Cg3/w2uQTgEmj0qJnPtZ1E0fT9iDMUD+wf0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=om50bqLbyp96cL0eQn9wVftg86eFbk7oMDV04k49RsAI0yFjwHSqcRkGJL9rI9jwbW5SvNvK7yeZnlD9Z5kDLn3nMndseE4bM7XijplfapfFPUXFNb2QBrCgU99VV6N6zxwQLGCukO/r6s05YEBZjjQHRZwXRO+62+fEXOeQ5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14A261601C2;
	Thu, 12 Jun 2025 20:58:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 9F49520028;
	Thu, 12 Jun 2025 20:58:52 +0000 (UTC)
Date: Thu, 12 Jun 2025 16:58:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Carlos
 Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612165850.399fce22@batman.local.home>
In-Reply-To: <20250612174758.GN6179@frogsfrogsfrogs>
References: <20250612131021.114e6ec8@batman.local.home>
	<20250612174758.GN6179@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8y4cb4xizxgdxs6rbq8obenko5khkkbh
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 9F49520028
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19WPJj8XYSiQE4dg8pOv3urIsEC7DFXUsE=
X-HE-Tag: 1749761932-315785
X-HE-Meta: U2FsdGVkX18P/+gmwo/6cJ/vrd/lDkvCDJ8dljdqLc0TAhz2E8KnZQXO3lRre7i1ZEZHqsQq2vJLkSsr43eu4qKaLP54yDPPclwa0RFkN+zxRlbWZ7NSxvF7/LAabbYt0NlvoDPMfhHoldeRXJrN4POQarrrdnJABYwdRr3V0pMOgLSnb4IMpmDwZdnwT7cq3IsTcStRA8NrtKsDSYaIXOxm7ftl3fViNT1dMrGt7fovdQBCLLf/JtzS5yCeZ2B9vdAeVAGc7oSa+uwfB5tvwHGM/wOqD2HDjOKCA3BHuMI2IEnsZ5HYuZo3ZjZGUEnsEfscVel3ZAe8rY9bBOXLmiDGcOz/QMIM

On Thu, 12 Jun 2025 10:47:58 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> On Thu, Jun 12, 2025 at 01:10:21PM -0400, Steven Rostedt wrote:
> > I have code that will cause a warning if a trace event or tracepoint is
> > created but not used. Trace events can take up to 5K of memory in text
> > and meta data per event. There's a lot of events in the XFS file system
> > that are not used, but one in particular was added by commit
> > 59a57acbce282 ("xfs: check that the rtrmapbt maxlevels doesn't increase
> > when growing fs"). That event is xfs_growfs_check_rtgeom, but it was
> > never called.
> > 
> > It looks like it was just an oversight. I'm holding off from deleting
> > it as it may still be valid but just never been added. It was added
> > relatively recently.  
> 
> Yes that's a bug.  Will send a fix shortly.
> 

Hmm, this looks like another event that may have been forgotten to be added:

  xfs_discard_rtrelax

It was added by 3ba3ab1f671 ("xfs: enable FITRIM on the realtime
device") but never called.

As well as event xfs_log_cil_return which was added by c1220522ef4
("xfs: grant heads track byte counts, not LSNs")

And in commit defee8dff2b2 ("xfs: online repair of realtime bitmaps for
a realtime group"), the following events were added but not used:

  xrep_rtbitmap_load
  xrep_rtbitmap_load_word
  xrep_rtbitmap_load_words

Commit e6c9e75fbe79 ("xfs: move files to orphanage instead of letting
nlinks drop to zero") Added:

  xrep_nlinks_set_record

Commit dbbdbd00863 ("xfs: repair problems in CoW forks") added:

  xrep_cow_free_staging

I'll be sending patches that removes or hides other events that are no
longer used.

-- Steve

  


-- Steve
