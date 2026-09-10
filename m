Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348E3ACEE2;
	Thu, 10 Sep 2026 22:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077659; cv=none; b=HbHXMfLslFaOpEHSmiyG8+fbrC4v2dvoN/LZIBvwjTw2KjHGU6yZhWYqn1eQmkSSMER1ELdplr0p99pHsX0ODt4Ra43BBI7RD5gp4gRC/zZWBdKw0/Urad9oeSjQ1Djx6OScHlixZmD7Co2mzD5AGriC9o2nR9ospfQYcMoehj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077659; c=relaxed/simple;
	bh=GXS2REQZfVhwiioAR+tvLzShnfy+wv3gtlYG29uBL3g=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ZRfjy3z/73c9epx8301q+135ab3AEBqyP7fZ0v1soizekHF9q+hTXd5tgSibjLJ6XYaMP2ff2T/CJcY+Nv/I4N13N2z2oOsQbJp+qfrm9Oi9bAekIPFSqkys1Fvk97949ihysUsTdNDP+STLPUn0bSib0e+hozJpUFbkLIEm0G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fK39eLC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fK39eLC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070241F000FF;
	Thu, 10 Sep 2026 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789077657;
	bh=XCbZRJJSfwFq8fSpu5C5V6NUIqHCcbuO98gGM5adtIw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fK39eLC2b0vu1d3w2C5YFr0zE38rwHGnqt1hiqpOiDNabPVcXfSWOoVTWdJa41D3v
	 oii8bg896U7MfHwkeq0lnsDlofLZ2feOp+esT7Y37c0m16NA9v1xAoEe31JU5RQuiQ
	 QCBZ9ehiGjpded5wUGYFHFn8Dg9T+5mk1K6wcsfc=
Date: Thu, 10 Sep 2026 15:00:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
 <dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <djwong@kernel.org>,
 <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
 <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
 <ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
In-Reply-To: <20260910114602.926944-1-dipiets@amazon.it>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 11:46:02 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> 
> On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Is there anything particularly unusual about this test case?
> 
> It is a stock pgbench simple-update PostgreSQL workload on a large
> instance (96 vCPUs), using standard PostgreSQL settings and with no huge
> pages assigned to the database. We deliberately overprovision the
> pgbench clients: 1024 clients over 96 threads. That keeps enough writers
> in the buffered write path concurrently to hit the costly-order
> allocation failure path continuously. The memory fragmentation comes from 
> page tables: PostgreSQL spawns a new process per client, and those page
> tables consume ~40% of memory, which significantly limits the page cache
> and the free memory available.

OK, thanks.

> 
> > > Results (average of 3 runs, TPS):
> > >
> > >   Config                   Avg TPS      % vs Baseline
> > >   baseline (no patch)       59,408       -
> > >   With this patch          155,409      +161.6%
> >
> > Is this back to pre-5d8edfb900d5 performance?
> 
> Yes - fully recovered.

Great.  That's worth mentioning in the changelog.

> 
> > AI review asked a few serious-looking questions:
> > 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
> 
> Thanks for pointing that out. To address them, we can have something
> like the patch below. Performance results are still similar to v4. Happy
> to submit a formal v5 patch with it if you would like.

Yes please, a v5 would be good.


