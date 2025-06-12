Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C881DED49;
	Thu, 12 Jun 2025 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749753975; cv=none; b=lPQFn+kupjfZfJq81+wbu9AJZMhxza0OyOax4S4mkHIjhflNduqzvx2UYLPDPsgr+G1jS451uJj3atUdxw0hwoAPx5mapQVKS7/Q5GU8/8zM+dKNBntOq3BMhtdScUkF3Beo31w1yQspVWSxFSXOgibWZ8uCgpl0/IAFYvp8AuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749753975; c=relaxed/simple;
	bh=/H9i4+0JZXYBeLsLAGfFJ2L0/J3aSZVDyLNzZIJUV1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGB9sQFr4jHcQyz97lSHy5gzTsuvhzKUbBQvw1qhL+cdlxgUFL8/Hk4wFkmlERsxLvy2Fg2QtnW7MsQNx1cosPN6ddm5/ceDnthdQzFSDNeVt2B0l4LTU8frUp6RqRthqa5EuZP3LtbApl4kVnRB5wDo7lhtf2BR6XpBd7nNtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BB3F1A178F;
	Thu, 12 Jun 2025 18:46:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id A1B812F;
	Thu, 12 Jun 2025 18:46:09 +0000 (UTC)
Date: Thu, 12 Jun 2025 14:46:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Carlos
 Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612144608.525860bc@batman.local.home>
In-Reply-To: <20250612174737.GM6179@frogsfrogsfrogs>
References: <20250612131021.114e6ec8@batman.local.home>
	<20250612131651.546936be@batman.local.home>
	<20250612174737.GM6179@frogsfrogsfrogs>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1B812F
X-Stat-Signature: duorc8ay8zkp4zsqmk3wa4cnp3nuyqy6
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+FrPMhahetRh/AQCGHFoz0rx1Z+zXcy5I=
X-HE-Tag: 1749753969-439561
X-HE-Meta: U2FsdGVkX18QtXp1s0JHtR2VaRPyjGJviGIaUeclJ2my7tP7AQ3AoNR85Np4dinTv0o+C3F/4qsmb2fr4ZcUQjzadoh1UU+ROf2k/n25xotdNjQjfkzxaSMatc3Cgb0/KSCwwbIKc4eTC7yy+WlLqy1L8FT2fRK+SzbY2tMJnZXKfCjmJ2Wp/tr/6cion6uejKsX+QAqTAtIO9HYqTIS8CmUaVVZJeIClPTIpOCR1113RWs/S5l1Yb4gsDfqYz68mJ6ICyMmYm8ZfQwF7oCVJL2lEAGV3j946rwDYBMc//d3352Pyc3XRiz8VBREAn0VdbTdsq/OHXgAt7ww3eon9lP1Wd9wkY96

On Thu, 12 Jun 2025 10:47:37 -0700
"Darrick J. Wong" <djwong@kernel.org> wrote:

> On Thu, Jun 12, 2025 at 01:16:51PM -0400, Steven Rostedt wrote:
> > I also found events: xfs_metadir_link and xfs_metadir_start_link are
> > defined in fs/xfs/libxfs/xfs_metadir.c in a #ifndef __KERNEL__ section.
> > 
> > Are these events ever used? Why are they called in !__KERNEL__ code?  
> 
> libxfs is shared with userspace, and xfs_repair uses them to relink old
> quota files.
>

Does this userspace use these trace events? If so, I think the events
need to have an:

 #ifndef __KERENL__

around them too.

-- Steve
