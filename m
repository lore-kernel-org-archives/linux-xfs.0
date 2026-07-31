Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907744192F7;
	Fri, 31 Jul 2026 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785495093; cv=none; b=j6bGSV6sV/pJ8/lVjqxUHV2mC0UxYpx/RLb36NAulwYPPq285woUgadgRhQsmbIbTvIaZQnNSnr0syDaURYzTsCL74+HSf3EUi9gDwgYAXx7GI8n6JMJ5SBFVoC5844OnzO3qZuEQ3h67c7rZ3TL3dsEZmYprQiJ1jwwZSDso8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785495093; c=relaxed/simple;
	bh=ZFc0pxwpl/D1dqiQa2qPQ4UmiZT/q1PByj6+AUq5ZNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nrwWnigyL+bi4unsbCvZkaVx+LhkE+s9NUdk0d2wexJhrhLQJQnktyiB5spKq9Rc/Ay3M9TvwCYSEECThCk8GxZ6W1+n7JmQTs1DrvxeZ87kgSYyvLOZ+DWcjW0KwWq/J3+ti1JJfCG7m7VbtgUVggfblGG5xx9CIlhbbxpyN2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hC0TZCbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hC0TZCbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91AF1F000E9;
	Fri, 31 Jul 2026 10:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785495086;
	bh=z/Km8KvxrFi4fpxCW+XGRR4YwIXp8EbdsDJ7hxXoS1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hC0TZCbqL6k7+9Ys3wV4KeRrc+KgZ4c3bKa1rThI7WN0BTEtCp4APSz9mIUMk5wU8
	 dHHkC/rsaUxa7WsIo4dR3J71RxMcAnOoZBKpFYbu1Mnm71aAGP6ebmEjC+UoCzTIFm
	 py8FogjSnIjHvDFaG5Bq8DT1gSZctxtijJdUjCSTIeyyCqFIBXwEwFVsPC+eDvxYDd
	 4j4h4GwzO/zzxbffuhUgTVd8Mk65v9nyuLwb2vu1d3gPgZPp+BG8A30EdK5vntk2PC
	 8lr0reTPG2WZXabCDJvpQ3uceCPu5svNPuFO8z8wWSmMBiklfSIdjPSnwSOpzbGcd1
	 4s1iSshPn/qhw==
Date: Fri, 31 Jul 2026 12:51:23 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260731-zunehmen-wagen-hinstellen-533de0902d75@brauner>
References: <20260629125229.3400726-1-hch@lst.de>
 <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner>
 <20260707050433.GA12963@lst.de>
 <20260717083120.GA30021@lst.de>
 <20260731-zuckungen-nennt-jobsuche-5b0ec82d06f9@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731-zuckungen-nennt-jobsuche-5b0ec82d06f9@brauner>

On Fri, Jul 31, 2026 at 11:53:38AM +0200, Christian Brauner wrote:
> On Fri, Jul 17, 2026 at 10:31:20AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 07, 2026 at 07:04:33AM +0200, Christoph Hellwig wrote:
> > > On Tue, Jun 30, 2026 at 12:59:38PM +0200, Christian Brauner wrote:
> > > > On Mon, 29 Jun 2026 14:52:29 +0200, Christoph Hellwig wrote:
> > > > > iomap: add a separate bio_set for iomap_split_ioend
> > > > 
> > > > Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> > > > Patches in the vfs-7.3.iomap branch should appear in linux-next soon.
> > > 
> > > Any chance you could propagates this to vfs.fixes?
> > 
> > Ping again.
> 
> Sorry, didn't see that mail in the tui. Yes, doing that now.

Done and pushed.
-- 
