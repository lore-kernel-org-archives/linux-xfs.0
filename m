Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49002701D9;
	Mon, 20 Jul 2026 08:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536786; cv=none; b=a0a4O4eDkgzuAaakhD0/sqqgsmCqg9T4XfxIdhWRR66PJ2itZfVVqsb7aV4ugI/Wm3WGcSd+kC3qH3uQsh/alk0h8mICDtBGySaFezcYD72yAhf2pHHYpCJ3bmUUAijUMCUz8/82A+MwXnW4HVZHD3Ob22Yl8joEO2GgL634zFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536786; c=relaxed/simple;
	bh=pd/kEvtqO4y+zWfiALFn0ZC9DemwaXKFkCM0xoes7WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9mfjLofrVxstJ1JUHuTa9Vp5sccH82GnejXSmfOrNEECnNDKYIN2HLbSvfZbGScpVPeOAcYuNYez6CaPzN4ooCogN7g+cNWyTS/wDAs+CM0yeI6U2MUkC7LCqKYEsSJ8rs66qSh+dU1Ssy4PJ8y1EQ6EZSMvs0pTPMR3ej12lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF25968C7B; Mon, 20 Jul 2026 10:39:40 +0200 (CEST)
Date: Mon, 20 Jul 2026 10:39:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de, willy@infradead.org,
	akpm@linux-foundation.org, hwenwur@gmail.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260720083940.GA21000@lst.de>
References: <20260719095732.1813590-1-yun.zhou@windriver.com> <20260719095732.1813590-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719095732.1813590-3-yun.zhou@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 19, 2026 at 05:57:32PM +0800, Yun Zhou wrote:
> When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
> is cleared but only restored in the success path.  This leaves the
> error path without nofs protection, causing a circular lock dependency
> between xfs_nondir_ilock_class and fs_reclaim:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>   lock(fs_reclaim);
> 
> Fix this by transferring the nofs context from the old transaction to
> the new one in xfs_trans_dup() via memalloc_flags_move(), so it remains
> active throughout the entire roll sequence regardless of commit success
> or failure.

Good find, but we keep adding more magic here that will just lead
to further bugs.  Your previous version was much better, and could
be improved by also removing the hiding under xfs_trans_set_context as
a follow on. 

Having a maze of single or two caller magic macros that modify global
(or rather global-ish as it's per thread) state makes hairy bits like
this really error prone as seen by the bugs now found.
