Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A82F0C74;
	Thu, 11 Jun 2026 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781157472; cv=none; b=bvui2xDC4GSso5wLf1AVkviRbF2NLtcg8ETqpkMYj+XYovu/vsDzLPW9bwfQilv/g9FQ8nFrPIWOQbXHpI1itLCR+uiW+/12HrsB4lPSjlhQ5Th4SaEr1RyAhpwGo5j8XrlFKlqTkBtc+E1V23TptmxBtFb3fCUNaeIkwaXtyrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781157472; c=relaxed/simple;
	bh=wTVWMr869qNxAZImCrP1/AI/tgL3odwId2Js0rwLe5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lznlwX3dcrwm2OWaBSJKPQTGyLzv0iv2bB0JooSKqFdf71ga3r+9AkdV2FvkjbrLyMP2YXXZM/fTn6tieYBJwyBlz0c7iWrWlZ7yI6mK4RTBiuw8BtV/Ek/72zO/UcKo6ll6sxljYhQ0rpwIr2TqFXNsrwUOfJl4NmpvCxqrskE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD53468B05; Thu, 11 Jun 2026 07:57:44 +0200 (CEST)
Date: Thu, 11 Jun 2026 07:57:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: brauner@vger.kernel.org, linux-block@vger.kernel.devel,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <20260611055744.GA18538@lst.de>
References: <20260610145218.141369-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610145218.141369-1-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 10, 2026 at 04:52:11PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> The DIO alignment check has been lifted from iomap layer to rely on the
> block layer to enforce proper alignment when issuing direct IO
> operations. This though, depending on the IO size and buffer address
> passed to the IO operation may lead to user-visible behavior change.
> 
> This has been caught initially by LTP test diotest4 running on
> PPC architecture, where the test fails because a read() operation
> with a supposedly misaligned buffer succeeds instead of an expected
> -EINVAL.
> This has no direct relationship with PPC, but seems to do with the
> IO size crossing page borders or not.

I don't understand the problem here.  Why do we want to insist on a
failure when we can support it?  I think the test is just broken.

> The problematic behavior is reproducible on x86 by reducing the IO size
> to something < PAGE_SIZE, so the misaligned read()s will also be accepted
> by the block layer.

What do you mean with misaligned here?  For a long time the kernel
supports basically arbitrary low memory alignment for diret I/O,
just bounded by the device capabilities (typical 4 byte alignment).

The supported memory alignment is reported in the statx
dio_mem_align.  What does that say compared to the alignment
expectations in this test?
