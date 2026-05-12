Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39E63AC0C1;
	Tue, 12 May 2026 05:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778564055; cv=none; b=KLuBJWGzwevQ2mp69zJzUY06P4eJnD52hsXlNOi74iFsU/CadLhOa3wqNVjJ4D7QhwYDagbIghO6xbbmg25+p6iX7oWxthDfGY5DbvriI0kYIaLK5AiM28GtcQMX9OoV84cA4h4fzqHA8bJnD7Oe1ngOdXapzw+OzBviwNJgKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778564055; c=relaxed/simple;
	bh=FCH7gTOxA12SA68v/sIkzd6BLPmsEb//w7clXTM1A+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYvOnCi+dVPo4gnoLoI2l1MQ7g05wNnZDKdYI28r0w0EafEnOjNk/7AoZSzX/d9X+vphnzl13qMY5ny4O1i3aMIlLLi5C1Ght1agb+RqDJOrqOANtNSPQWDzeIUc49N3IUV9PD/0AHKOosV09nA/VvxWRwFzVK37GHlmx8pTmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udv5SPwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udv5SPwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22987C2BCB8;
	Tue, 12 May 2026 05:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778564054;
	bh=FCH7gTOxA12SA68v/sIkzd6BLPmsEb//w7clXTM1A+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=udv5SPwcBINb+acnp3C0E8LzQFBT5EoIjPhPt2UDnXivhk0t533KRvwMdGPDsaSWk
	 Lp8hexpqRkBDCRW5DQa9vZMVpk2X37Jiau+/gpH0yAXctaj2sH/dxBrd5Roq+neMH7
	 Z/IpZiAwhiGdrTmkXPIE9uq/d/0CFCjDgvK1Y2mjxiIs3r5H8ok/qc7pKOcZASHnz+
	 9aHg3Mg2rA5RBg+OMAKywY5i3vfCGDZTc0kD/oN3iZbyphzrK9yN8CRn20BLfc82Zk
	 plyIigwT/HZvTKBfYbh6sfH3VUfiiOls+0Wi64/b67hxHf4fUxQlxQWtQtzASMl968
	 iD9N+65Q/jsGw==
Date: Tue, 12 May 2026 15:34:08 +1000
From: Dave Chinner <dgc@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com
Subject: Re: [PATCH] xfs: snapshot current CIL sequence under xc_push_lock
Message-ID: <agK70ItEH4FC8YH4@dread>
References: <20260506015811.3420895-1-zzzccc427@gmail.com>
 <afwJ-eNE-NbSjRU6@dread>
 <CAFRLqsU-_omAuPFk+oXB1WtoH=_GZZFMg4bpXv3EhbzsjLt4VA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRLqsU-_omAuPFk+oXB1WtoH=_GZZFMg4bpXv3EhbzsjLt4VA@mail.gmail.com>

On Thu, May 07, 2026 at 12:34:23PM +0800, Cen Zhang wrote:
> In the past, when I sent more direct/raw reports from my testing, some of
> them were reasonably treated as bot-like reports. Since then I have been
> trying to better understand the reports before sending them, so that I
> can submit more useful and actionable issues or patches. Clearly I still
> got this wrong here.

The important thing is to explain how you found the issue, how it
can be reproduced the impact of the bug being fixed, etc.
Describing a race condition and it's fix purely in theoretical terms
and omitting all other context makes it feel very "bot driven" as
they tend to lack all context other than code analysis and the
change itself...

Think about how you'd describe the impact of the bug to someone, and
how'd they'd diagnose the problem if it were occuring on their
system. A good commit message should allow a user to identify the
problem (and the fix) from it's contents...

> I will take your comments seriously and be more careful in future
> reports, especially when reasoning about subsystem-specific semantics
> such as XFS log/CIL behavior.

You don't need to get it 100% right before you post a fix - it's
often much faster to post an RFC or ask a question and get immediate
feedback than to try to be perfect on the first submission.

> Thanks again for the explanation, and sorry again for the noise.

It's not noise when people are listening and learning - that makes
it time well spent IMO. :)

-Dave,
-- 
Dave Chinner
dgc@kernel.org
