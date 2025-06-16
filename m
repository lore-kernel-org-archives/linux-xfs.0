Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134C2216E26;
	Mon, 16 Jun 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085912; cv=none; b=Jj064MVyT+kCRzUf51jQv4V2OdEZ17vrTCVH+z9N9fbpLnpdJHXhnMDeRmYjtACzLJ2xsJHjX7u3IiNPIV6Z/M08KKUvynPreYJAAuvieKQ+8+2qwGRCLt2x2PhN0/XlmRFUdQ34PJmevWU7nBke9d3RJVw9INTW64PO5dNvmYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085912; c=relaxed/simple;
	bh=wIdiZPYyli2N4szu69CA2U7XhLnv02tXx97AcQ5lBKk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1cmxOMJoYvIRPmjwRC7fe4EcvD2MBVYdMKJqfrSz31RRHhBy6VS+9ETOb3dhBrgOp3bh/nloolO/we2UO8GCyVOs3jG5SZY8vGt+viOYORBctlXEUGw8/Vaa2O8og1Ie2g3lfZDWMGBe9t8Cmk+klKvnaEChpL5wlsesfCMBps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 425EB59CCB;
	Mon, 16 Jun 2025 14:58:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 237CC20034;
	Mon, 16 Jun 2025 14:58:20 +0000 (UTC)
Date: Mon, 16 Jun 2025 10:58:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 00/14] xfs: Remove unused trace events
Message-ID: <20250616105819.4d37b83a@batman.local.home>
In-Reply-To: <20250616053119.GD1148@lst.de>
References: <20250612212405.877692069@goodmis.org>
	<20250613150855.GQ6156@frogsfrogsfrogs>
	<20250613113119.24943f6d@batman.local.home>
	<20250616053119.GD1148@lst.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 237CC20034
X-Stat-Signature: xrtt3cne15mpszeso61c3wd1iqzm4pfr
X-Rspamd-Server: rspamout05
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19hESC1G4pzjZZdZ9uHr9kQMXh3gtnL9xU=
X-HE-Tag: 1750085900-926499
X-HE-Meta: U2FsdGVkX193XZgjGdRK5j8nHlonQUe7QYiUVCQinh20elGdhOpp7c9hBPTtm5JJvTcbS6ldHLC9sbPCyryypjBGvpBDVZTRyqY6aSqmsqGX8RgyTMQRew3KOtRbz44Ssm6cDa1nhpy1kvsyLnwEXnPHc/Wl2q2iiV0gg+OdXBl9tTiyo79whbeqEcAMxUhRlKhyjxG1ZiINHlBzkHblOiFX6YI41WsbBFKzRnurU8Vt4O3bcR5X21qvWkiDwuqVsk1cdotXm2Vt0bvpVK8HGfdsZXy7TltjDrMcdDqu/qKaALWntfOpgYVkSbn1TCR81H27Gmk8wgv7TLGDJAdRDZbXi0my8FFs

On Mon, 16 Jun 2025 07:31:19 +0200
Christoph Hellwig <hch@lst.de> wrote:

> > I just did an analysis of this:
> > 
> >   https://lore.kernel.org/lkml/20250613104240.509ff13c@batman.local.home/T/#md81abade0df19ba9062fd51ced4458161f885ac3
> > 
> > A TRACE_EVENT() is about 5K, and each DEFINE_EVENT() is about 1K.  
> 
> That's really quite expensive.  And you only measured the tezt/data/bss

Yes. This is something I've spent a bit of time over the years trying
to address. With moving a bunch of code into trace_event.c with the
added expense that trace events do function calls.

It looks like it's still growing as the last time I checked it was just
under 5K (something around 4800 bytes) and now it's over 5K, and the
tracepoint code grew 4x. I'll start looking into "why" later when I
have more time to deal with this. My time budget for removing unused
events has pretty much dried up.

> overhead and not even the dynamic memory overhead, which is probably
> a lot more.

Yes, and this is another area I look to make better. It was the
motivation for eventfs which saved over 20 megs of memory by having
trace event files dynamically created instead of being permanent.

-- Steve
