Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49007224AF1
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678924; cv=none; b=EYTr1+BBKKwy5Nd3cZsP2RoLqJrzjmKm/L8TR4BfaiS1sp9LLmWqJiBAT4UoZoFdwJDovd2zgaLF6cr2BU+U9og7sEw7bz+NDRu3ZE8hV5uuS5E+8B8yn/aBvLCMJwc3QdPMVEZPg6k4xSNC/6Pk1LEj0jjzPcVXhlqqy2H96LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678924; c=relaxed/simple;
	bh=uJcor8dKgIzlMKnsU5BCxeAmT7BxJbLCaIvsweXo03M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jl61MaaDBhRJnGuxOR8COkbO4TJK9Hi39ngCbu/jHgYpKbPAalkFO3EbUWS5PrZWtRmLna1TIbGKMji/f+JsBQpeiqQ0PI79NcKDyQflh80HsGXP+Dv1BEcRgJP0qXncOsgi1oQxkWIR++xx74AiX8JXatudcZ6f711vvIA+gEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfMJvpgQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfMJvpgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA9B1F000E9;
	Wed, 22 Jul 2026 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784678922;
	bh=zmwpRrht/Jg+oC0CO9NPI/N+TEzWOQx+/RnEBxSnhDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OfMJvpgQdlsin6rhnL7Jn4bvKC7ZO685U7UAQYQji21NhIXouK6acG2h6IA/H6Z95
	 irOt2PeAjSzBE3oNzwuEvYkI2GfckXZJ9632ZQISdklkF1zBTUE44jOkOnWbKIwHBi
	 yQd0il89q62qCZLDNQEVdIxGyLfI7KfuHuXyEe/IC5fvSVu7Yvo+iUiiXkr5EEijKF
	 FXoHTSDewTZr8UqFcSltsI78XFZgtJ3tR5MWNTJLCix3PE+tB4VSq/5ZeD33/07GYj
	 3R1VqUqrAwycWPxHqCtc3qYGV6O/E9FRZxXuBPF7NTjtf4eMVt8iYGc98e26jLJxTS
	 +Zy1+jtVYpDmg==
Date: Wed, 22 Jul 2026 10:08:34 +1000
From: Dave Chinner <dgc@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: improve log context annotations
Message-ID: <amAKAmIoTvoa6SY7@dread>
References: <20260720094609.2191633-1-hch@lst.de>
 <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>

On Tue, Jul 21, 2026 at 11:16:40AM +0200, Carlos Maiolino wrote:
> On Mon, Jul 20, 2026 at 11:45:37AM +0200, Christoph Hellwig wrote:
> > Hi Carlos,
> > 
> > this series improves the lock annotations in the XFS code.
> > 
> > Note that right now this is all mostly unused - the less stringent sparse
> > lock context checks got disabled when the clang version was merged, and
> > we're not quite ready to enable the latter yet due to our conditional
> > locking in the ilock helper and the locking contexts transferred to the
> > transaction for the inode and dquot locks, but I'm working on that.
> > 
> > In the meantime having these corrected at least serves as useful
> > documentation.
> 
> Thanks. Those all look good for me. But I'm adding Dave to the thread as
> he has much more expertise with lockdep than me and I'd appreciate his
> input.

Honestly, I'd prefer to kill the annotations and replace them with
asserts that the lock is held so there's actual runtime validation
that catches errors when they occur. These lock annotations don't
tell you that the locking is correct, just that the function
manipulates a lock.

The sparse annotations have always been more of an annoyance and
reactive, because we only use them sporadically to suppress errors.
We do not use them to prove locking is actually correct, nor can
they function as such.  i.e. They exist purely to shut up a set of
"not smart enough to understand lock context" tooling failures from
a tool that almost nobody ever ran.

Maybe the clang checker will be better, but I still don't see how it
will ever be able to provide any sort of "locking is correct" proof,
nor that it will be something everyone always runs.

Hence this just seems like trying to maintain a technical debt that
doesn't really serve any useful purpose anymore.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
