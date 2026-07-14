Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254736A004
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784069707; cv=none; b=rb5YLDHwXny1T4d1LWxuCHh4VzqjlgAbypMszO6qS/FvPGlNIRzAbIlqNU32NCMoqFG0oDnfcVHHSs6hkHztPKW5CSlHxfuhpPTPI7XKVvB3EYJRClHtQT7CTzCS4S4c/ecUJWW2hMoVgU+IGT2QRx4cmJwOLEPjxVXtHtGJ+mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784069707; c=relaxed/simple;
	bh=9PFKAy8sk84dn8y2/weMvZWqWDtDNWEVqqLxbrZNbO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l83rI+TvP46KTQ3K/cqmxms4oRfqvo+lR2ZGbO1Zq0L6j/vAK9m8hwkjSqHo/ObBVj0NvrvhVduZ7HpwTsVl1BP04YINAlcbsyOOgvyGlXX7gCsU8JlCFG1tFdfGYGEhilG+wadMXFrfsWugWzCUCSlZZi3FrxLp19gB5RSiHaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SwvzaJ0e; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SwvzaJ0e"
Date: Tue, 14 Jul 2026 15:54:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784069693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zex7fDtrxgjxYmJUwLrkUDR7R6DM3+vGl+Fsw51hImE=;
	b=SwvzaJ0e32GKnb/IHDdbJGWcQMPFtprKZ5M7WJPOChLZno05mzZGYITi5vokDQfCvVKL9H
	eXnB8MS4Iwszhr0srjYTlYi9B3f60SyohAGHTF+qeacRYU6NebMWPXqoykvRpPQpmCtcT9
	VrpwxW5FXHRxHVx0Xm13USBckm+pZjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dave Chinner <dgc@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, 
	qi.zheng@linux.dev, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <ala6pd9jmPccGjgC@linux.dev>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
 <ala2rDHrFDjql3Qg@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ala2rDHrFDjql3Qg@dread>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 15, 2026 at 08:22:36AM +1000, Dave Chinner wrote:
> On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
> > Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> > in memcg slab shrink") added a check in fs/super.c that skips the
> > ->nr_cached_objects() hook whenever the shrinker is invoked for a
> > non-root memcg, because none of the current implementations (btrfs,
> > xfs, shmem huge) honour sc->memcg.
> 
> I don't see that commit in an upstream tree. I'm guessing I wasn't
> cc'd on it, either, because I don't recall seeing that as a patch,
> either.

https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/
