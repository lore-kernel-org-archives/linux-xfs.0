Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DB628B7ED;
	Tue, 22 Jul 2025 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753226923; cv=none; b=k1eNfIo9l6CnMozznoq7eYzS8Ll5R7pW0dlP60amacu13l9KsPMHR0fdBwnCdcDI0ce4LP9mPT8eyxPRB3eHzNeoHxY545eQdAH+c91/HyYRqC86NGbmXeU9XYz+RG84eDgiclryswBbfgFGkf/eDVfQlz8EJnvm+9vEAfRQ4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753226923; c=relaxed/simple;
	bh=NfWlAbo8emHsOzVdyWi3yZFqexjd4Z9Fxp5x8vVpAuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmfUyFkhf8a+XQ2eTC1aoiGOiJ51lkilujkBbJ/qZR539A+WjNoBMOVj2z/W4PuWhR6HU6kFJTrFHVaFZcnj4kZOaJYxIRdAihqyhtO4HfBlpoQUlDuvWYoRuNA+8Gbeognr89OQKXVtw6YVA3qLRRbg5h0ZsDviZjhYhaGiDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqaMGFLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqaMGFLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AA9C4CEEB;
	Tue, 22 Jul 2025 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753226922;
	bh=NfWlAbo8emHsOzVdyWi3yZFqexjd4Z9Fxp5x8vVpAuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqaMGFLw1bXSMKkvYCa20hzuYvhFicL5Loq5D6fdDI/yC2XNXbOREA55DpucN3eVG
	 f0raIK7PUdJfif+3n2UlEDrzw97PvHkwSmQQQuH8eLeRq/nE2xWG5qou5wa2hYJxHp
	 1Y4grPXgP0rFzZa9VzT4IBTSSAaxouwtwomfn2QDtFcskGGYsCgGpJs2D7+XTXvLAx
	 ucyCmfZjXFiollw91AT0kqwatlmOiV2uj2DXrpaIRS/k9OeS8HHNE2rKGKZkRY7vWg
	 BjvU2GfzqKlc1mPdAxFsTIED6m7+uhXwajeAPZNsuua0mnthVwqQ5WWgY0FuGcRN0K
	 lSmetWC0Dk6ug==
Date: Tue, 22 Jul 2025 16:28:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4] xfs: more unused events from linux-next
Message-ID: <20250722232842.GV2672049@frogsfrogsfrogs>
References: <20250722201907.886429445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722201907.886429445@kernel.org>

On Tue, Jul 22, 2025 at 04:19:07PM -0400, Steven Rostedt wrote:
> 
> I reran the unused tracepoint code on the latest linux-next and found more
> xfs trace events. One was recently added but the rest were there before. Not
> sure how I missed them.
> 
> But anyway, here's a few more patches to remove unused xfs trace events.
> 
> Steven Rostedt (4):
>       xfs: remove unused trace event xfs_dqreclaim_dirty
>       xfs: remove unused trace event xfs_log_cil_return
>       xfs: remove unused trace event xfs_discard_rtrelax
>       xfs: remove unused trace event xfs_reflink_cow_enospc

I can directly take responsibility for 1, 3, and 4 -- those aren't going
to come back.  Patch 2 looks like an accidental add, and if anyone wants
it they can always add it back.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> ----
>  fs/xfs/xfs_trace.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
