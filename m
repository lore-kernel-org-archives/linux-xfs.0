Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76F41F0E25;
	Mon, 16 Jun 2025 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085547; cv=none; b=ItwpFTNEnL2UVI3TGd3lR+rmoi6w9ajVwxw/x4T1Y3haLq5zgdEFe6h4eBD/zqbfNjkGSqVFh/zPpRWtdoTWjgGH0tDYrsoV1INxdCCeCHgNNqZo0w4XAZUPtB8JXL2wVAS12Uil2CeHl/O0g4Hga8fW3N0Y3pg9HumnBqS/EW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085547; c=relaxed/simple;
	bh=Suy3rPaHh37l8AvHpOViXVUIT6DIeR8kA/zAftz/reg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxQGiRBMK0QEJSjgwT8max6WqLfrBix8zxQgaB1kdOfg9XxcOvRIQ+vpn9gGSd3+68ukT7AaefDyenqGAzQtTcBhksbeBKVQibTlIbjiUrx7fUEL9llH06rHgpcA0fVNELITgUUzjjyTvGd9VCsl21eHBGsI7k0FRR9e5eGxjSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F5A5805EE;
	Mon, 16 Jun 2025 14:52:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id E07501C;
	Mon, 16 Jun 2025 14:52:15 +0000 (UTC)
Date: Mon, 16 Jun 2025 10:52:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>
Subject: Re: [PATCH 07/14] xfs: ifdef out unused xfs_attr events
Message-ID: <20250616105214.797509de@batman.local.home>
In-Reply-To: <20250616052810.GB1148@lst.de>
References: <20250612212405.877692069@goodmis.org>
	<20250612212635.748779142@goodmis.org>
	<20250616052810.GB1148@lst.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E07501C
X-Rspamd-Server: rspamout08
X-Stat-Signature: c391qf9ww41jcwmifrc4httcndrq1eiy
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19ksHiu6zdx9WjlAgHX4Jo/rVTJ6rdCbUo=
X-HE-Tag: 1750085535-323965
X-HE-Meta: U2FsdGVkX19on+crkbLF4LC+dLCGj6UB4R4j+MWPjetpoeOPaxkRthJx8ESc9zf0Qjob0myZwwOsX6bLlztb7hbEF2xee5ujv7b0T2QYIWulxAe+lb+Q96/8XmqRpGzGBRB3vooQv/9NJ+u3xVyycUEo0IWkNEYsTCnjXvj+8gOwb1tAiHpvnkc2aHPuyctfymuqMBMUmUseQ9WOMKNZgPa00YZo86mt1G1FIYUfqL7Uck1LyZzAYpsC8aCE1rff69h5wKKVG0BApseIotQ0iWl8B4HzXNe4GYZ7bJUTZlbCXfx5D1hxFmthJ36WzL6lsu3MU7vNI38fw5n9TjiS8RZL1dIVollUuU9Mjmb2/Dtn24C/qEBG34/SgzNSZ7IO

On Mon, 16 Jun 2025 07:28:10 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jun 12, 2025 at 05:24:12PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Trace events can take up to 5K in memory for text and meta data per event
> > regardless if they are used or not, so they should not be defined when not
> > used. The events xfs_attr_fillstate and xfs_attr_refillstate are only
> > called in code that is #ifdef out and exists only for future reference.
> > 
> > Ifdef out the events that go with that code and add a comment mentioning
> > the other code.  
> 
> Just drop them entirely, which is what the code using them should
> have done as well.  We can always triviall bring back code from
> git history.

OK. But I'll only send a patch to delete the trace events. I'll let
someone else remove the actual code.

-- Steve
