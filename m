Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82629277026;
	Thu,  8 Jan 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894164; cv=none; b=t4olgFOwrS34+ocCyJYkWXiikw5PXw/Gs+Rk78GMWITBb6JimxRSuU3JWBf8NSO7e7wLQFuzgdOD5b4DVldZ6bz5PBXL4Far+BXM5ah9ibP/eD2a8tElihxEb9aQctIFEmE4qbUO1VGhTldsXIW0MK9AL4axzGlc7mQ2J1qBQAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894164; c=relaxed/simple;
	bh=pYz7bPQ229+xCZYZnABcoD8uPSXkrI6ezjFjQSAr92s=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LM6V9KeFupfF5JJTXUxl0Easw9MuxrsxpeDreq3sU1XiUVM8KJJ9/xAaLZLiGm9onsWwP+0GWwjElSJbz2uO7oJ9pVp5j/6Nk0gUB5g8xHD+cNoKRRfuU2aXUv4slWFJ981yWqLrPQ4Cy0W1WdJ7G7LtfbGpZgWfqQZvnD89MaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bekqnZbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bekqnZbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C03C116C6;
	Thu,  8 Jan 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767894163;
	bh=pYz7bPQ229+xCZYZnABcoD8uPSXkrI6ezjFjQSAr92s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bekqnZbIcrXqB9BcIe4vXmhaNtQqYGfi/kA97kRwrhH1ZMUT3Ang7sLVamp2ia82A
	 z34Z7pUroFRX4Pifzp5wqvq1ZLv2dCOwU44K3oByK62YNh7ZN6Id8TsaRsEtXTr/Wb
	 vbH++Zgz1ItNnQZYaNsjm01ESNLlBcCvSeow+ldI=
Date: Thu, 8 Jan 2026 09:42:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Carlos Maiolino <cem@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Andy Shevchenko <andy@kernel.org>,
 linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-Id: <20260108094242.8b043d248e7877235f606416@linux-foundation.org>
In-Reply-To: <202601080905.D1CC8CC@keescook>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
	<202601080905.D1CC8CC@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Jan 2026 09:06:49 -0800 Kees Cook <kees@kernel.org> wrote:

> On Thu, Jan 08, 2026 at 07:52:15PM +0300, Dmitry Antipov wrote:
> > Introduce 'memvalue()' which uses 'memparse()' to parse a string
> > with optional memory suffix into a non-negative number. If parsing
> > has succeeded, returns 0 and stores the result at the location
> > specified by the second argument. Otherwise returns -EINVAL and
> > leaves the location untouched.
> > 
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Suggested-by: Kees Cook <kees@kernel.org>
> > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> LGTM, thanks!
> 
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks, I'll add both these to mm.git's mm-nonmm-unstable branch for
testing.

If XFS people would prefer to take [2/2] via the xfs tree then please
lmk and I'll send it over when [1/2] is upstreamed.  Or we can take
both patches via the xfs tree.  Or something.  Sending out an acked-by:
would be simplest!

