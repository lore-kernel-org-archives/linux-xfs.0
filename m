Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596FD322A00;
	Thu, 26 Mar 2026 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774493056; cv=none; b=HXW6E7XC1zsjlKyW44gFqgr53y7kp7H3IBcJURqGjSUmDmhGCOwhsoZVUbjkn94BoHLN9YotQlV38jbU7pPLqJiOz9Uw0voLHQ3awckiMerTYRKCcV1uqPfMk7AceyQNTbP92aRuQ5HAW0SFe0mc9OpQkmnP2w+TDFm8fdC2YtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774493056; c=relaxed/simple;
	bh=LrDa74kusD0Qs5ckOdznuE3nf+2ULrBRJxIuPhAify8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sOrvuuQlY0G1oSkT64UnU5wZ4/EwNmdlN80sv9EUbp+7ayxRDo7HshksUAkuT1HGtyKq2md2OBFZsnCErHhU/VbZm5Kw42cmimbACWKd+6zP1N2Ti5nflSpfMEyhhyR+CHYHvxYOcwwk8zL6Iof+Vk+DRRUDZ9Z/aeRBV6dEBs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uA9xM8Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uA9xM8Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1330C4CEF7;
	Thu, 26 Mar 2026 02:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774493056;
	bh=LrDa74kusD0Qs5ckOdznuE3nf+2ULrBRJxIuPhAify8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uA9xM8TlDA8Ri8x9xtA0d+L2RRzbXKmjjjzhGNTc1Xmkp1rJJZvxU+MF5rSM4+e2V
	 LyjN8vd5EhgmoQU54pxXJs5H39ssW6qbiajuGgeXnKnQjVWx9hGcvOS+CI0010hwhy
	 RqcCkc2gFnywy+C38Md08UQ3eg1RgGoV+dyeC+S86RzrUYav/qJYTLzZZEE0ciByZa
	 RBN80Boij9Tox2W52kPQxb7EWFazDbYgc3I4R+JQHVL/7EMIgzXIf4TgeUkpys/6XE
	 Kqn1gOvDx87rM/a8YeY+Ka8fp83zg4DnvbrjWcvtKrztj+TPHLcp1Nw9hAFLWZPJ3s
	 SKICNvt3skN/w==
Date: Thu, 26 Mar 2026 13:44:03 +1100
From: Dave Chinner <dgc@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acSdcwclPGXLGwBx@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acRE8pp6HxjK7Z74@dread>
 <acRH-fWPKkFFXcLZ@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRH-fWPKkFFXcLZ@casper.infradead.org>

On Wed, Mar 25, 2026 at 08:39:21PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 26, 2026 at 07:26:26AM +1100, Dave Chinner wrote:
> > > @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
> > >  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
> > >  	}
> > >  
> > > +	for_each_possible_cpu(i) {
> > > +		struct bio_complete_batch *batch =
> > > +			per_cpu_ptr(&bio_complete_batch, i);
> > > +
> > > +		bio_list_init(&batch->list);
> > > +		INIT_WORK(&batch->work, bio_complete_work_fn);
> > > +	}
> > > +
> > > +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> > > +				NULL, bio_complete_batch_cpu_dead);
> > 
> > XFS inodegc tracks the CPUs with work queued via a cpumask and
> > iterates the CPU mask for "all CPU" iteration scans. This avoids the
> > need for CPU hotplug integration...
> 
> Can you elaborate a bit on how this would work in this context?

It may not even be relevant. I was just mentioning it because if
someone looks at the xfs_inodegc code (as I suggested) they might
wonder why there aren't hotplug hooks for a per-cpu queuing
algorithm and/or why it tracked CPUs with queued items via a CPU
mask...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
