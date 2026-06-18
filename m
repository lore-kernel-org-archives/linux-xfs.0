Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CAF3CF034
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2026 09:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774919; cv=none; b=SbGvgb/pXf/azSuqcfwi4OUPLVbI4Lzx5Mh4hob1PiJphLjDvqNiopajRugbKPI0ymY7qRhH9RG0RaqMcO5mpS6cbLket0lUKI0ItZWT9VLZuIGC2X5XvSRZfDYnRm+DiBhVJbCoECX9G8Sw+s8v8lu4cxiK8pdczFJOxgLRuqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774919; c=relaxed/simple;
	bh=Imqd3PMwxob70q733lh+Zcw/+83hIq+TAuSRfoyvU2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCqnf0KyMllCPxyXaSj+r/dNAKfRhneKRHJmsv9X4wWK8dww3N4sn+MhoZaQeRpoVGV7qRrzrtWal0iBGPi/v3nD7qDfGBv3Qcy++AQLKecJERg3l5IHvYBPo1zAfluKBI+RwqWCeogImjFcKTboqhX1uxels9/m+pYS5+N5AIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A2Rkn0JF; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A2Rkn0JF"
Date: Thu, 18 Jun 2026 11:28:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781774905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4shRaP6IA88GTRNtOJcUJssU4CN4YUqzVDciqr0Xkg=;
	b=A2Rkn0JFU7ADX30BhVsjhDn7N+Qrd2IDoutoi3fKDjqki/2rKC5IVOjmEMGK9pxjMkscvP
	a1JEkd/g1OBjLB1RM3yPD95foCpDI7dmpLAvqQk/I2E/Rp3y+69M4fYlCh2Ygx7/AobLMS
	0e5YRCk2NSynwVy3XFMtZnNPqKiOCZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org, 
	bfoster@redhat.com, lukas@herbolt.com, "Darrick J . Wong" <djwong@kernel.org>, 
	dgc@kernel.org, gost.dev@samsung.com, andres@anarazel.de, 
	kundan.kumar@samsung.com, cem@kernel.org, Zhang Yi <yi.zhang@huawei.com>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <au3yznolpebvd5vphmzv73fzosdy7bxrb45kv56n734jnwwj3l@43d7sqlef27k>
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
 <ajOzoBt_peOCtNUm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajOzoBt_peOCtNUm@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 18, 2026 at 02:00:16AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 11:44:47AM +0200, Pankaj Raghav (Samsung) wrote:
> > > Maybe we also want xfstests that try unaligned FALLOC_FL_WRITE_ZEROES
> > > and make sure no existing data before the range is lost and the
> > > entire range is zeroed?
> > > 
> > 
> > I added FALLOC_FL_WRITE_ZEROES support to ltp (both fsx and fsstress).
> > For example, generic/363 tests for unaligned writes and checks for any
> > stale data. By default, I think we do unaligned reads, writes and
> > truncate in fsx.
> 
> But I guess not unaligned FALLOC_FL_WRITE_ZEROES?

        -r readbdy: 4096 would make reads page aligned (default 1)
        -t truncbdy: 4096 would make truncates page aligned (default 1)
        -w writebdy: 4096 would make writes page aligned (default 1)

FALLOC_FL_WRITE_ZEROES comes under truncate. So I would assume we also
do that. That is how I also found the issue with offset > EOF. I will
take a look or else, I will add a test case to test this condition!

Thanks.
--
Pankaj
