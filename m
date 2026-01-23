Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59C7366DA3
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 09:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769160998; cv=none; b=V5Z5nUS4xUSHWm2uJli3tX/LLBzt+tSGO8CWHdOBWnAIrFYvbBk8xmbHo/ozPRo1nhLzfssi/uqUwOMmTX1NtEkdA0tgdcJK1gOIOXbTLUZ6HC+74DkeE4YaIxaPR0NTMCVuYoGBUj0WL5vW9UAfrZ+RW8BCUkogYwp84KBQP0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769160998; c=relaxed/simple;
	bh=FsXlyiTXIFzIfD1Gako6qA+2/q+hBhpvj8eTNBZdjzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCHxEdP/wOHA1gF6/n71sbXaHBKBmTsOa2Nmc4ACzEn9y9N2jYU5OWn3w7ozAW2JUPIfCfh3U/HaTBDtsoqtQd4BPIsvaCUtt9+t5YjLvOOM08Sx2OR5Boef9dmNxG6YuDTih9uVaeNpIDAasRtJcO/hfThveb7cTJHO05HfZnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oufEqBUp; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oufEqBUp"
Date: Fri, 23 Jan 2026 10:36:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769160980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+raCG8SaitsTIi5zQQn9wM+Kv63F7dcRop2Be2n8BZ8=;
	b=oufEqBUpveKXz9Nh2d6cKlwH+BjDtVHcS9ZSqv9FByEabAX9nSokfXDvQdt95Ox9bbeG1x
	80qcTLshm81T8IUb72glXNWM/Fp0Ac79SH/DLLhbN/zurPao7LVaRJPX/FG5uVsw3onSMr
	x5b+MPob0q36A5jrPwVgaudVpXFf30w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk, 
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net, 
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <qkob3hnekz5wv3fkkjagwr5o2mr3rdplfzzmwutbhjwd34beez@hdgapt3jw7js>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
 <aXEvAD5Rf5QLp4Ma@bfoster>
 <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
X-Migadu-Flow: FLOW_OUT

> > So stepping back it kind of feels to me like the write time hinting has
> > so much potential for inaccuracy and unpredictability of writeback time
> > behavior (for the delalloc case), that it makes me wonder if we're
> > effectively just enabling arbitrary concurrency at writeback time and
> > perhaps seeing benefit from that. If so, that makes me wonder if the
> > associated value can be gained by somehow simplifying this to not
> > require write time hinting at all.
> > 
> > Have you run any experiments that perhaps rotors inodes to the
> > individual wb workers based on the inode AG (i.e. basically ignoring all
> > the write time stuff) by chance? Or anything that otherwise helps
> > quantify the value of per-ag batching over just basic concurrency? I'd
> > be interested to see if/how behavior changes with something like that.
> 
> Yes, inode-AG based routing has been explored as part of earlier
> higher-level writeback work (link below), where inodes are affined to
> writeback contexts based on inode AG. That effectively provides
> generic concurrency and serves as a useful baseline.
> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
> 
> The motivation for this series is the complementary case where a
> single inode’s dirty data spans multiple AGs on aged/fragmented
> filesystems, where inode-AG affinity breaks down. The folio-level AG
> hinting here is intended to explore whether finer-grained partitioning
> provides additional benefit beyond inode-based routing.
> 

One thing that would be useful to see in the cover letter is to see how
these patches work on an aged XFS filesystem as that was the main reason
you moved to a different approach. And given that you have completely
changed the design, it would have been better to see this series as an
RFC as well.

--
Pankaj
