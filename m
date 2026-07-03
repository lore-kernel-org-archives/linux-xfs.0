Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D3E393DF0;
	Fri,  3 Jul 2026 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082434; cv=none; b=TFFezQ+8qi9HstrpIjzRDyJfWUTQ28f0/EmnBNN/1hcGgyKrlaOHppaBDZnle/+C3yYcdKWulPoCU7RHG/DicfDSj1gSCXq14y7UhpvduutLnyo3n0p0rWNikYkIyCYcmySWiroRtqLnOIar27+6prqHF0SoSsA5q9jfTH7KZMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082434; c=relaxed/simple;
	bh=7cUXbrCBsw1H+qVGHgFH+O3Wk3ageTgVBw985gf4Xxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8QCU9+vwNNCzEiuCLlnx8aiWcU4BbNVUhVNKbXoInPXfqA4QqwaznP/XVYjXQ48xPqKkJtdw48RdEwQUeWf8gYKfklxFdYUQcq/CUNEJQ7hPww+tYitIFsmTULX5/aYPDv7xgCDLnKmqjtYszW4fL8iebv0gw3yN0HhRUermds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T90yowTV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T90yowTV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=A9wGX8nTXW8lGUnj40eQqnGa+P4VEkL/Sfdhj5SdBxI=; b=T90yowTV4LxywuUKSMUxfGBg9G
	8D4pu9mlvKDNm1y3HjYZ4YootgWr8PJXdKwdCyk8pLojBd8iOwSN1c4CncoHG/S9XPGyZn1EE4j9h
	Ld4D9RzNATvPWYXJLFSQKQOU8jLSfikhDJzv+7N7mHNlMGgIqgeYvq/8PdTd/QhJ069GWYZAavIOP
	+eawoP1VZj9ww+QYidKIoHXmkoP691qsvfjH8ZBDGYYnAKLxgcvzrpbZZbAkMWYiNeA2zvHa2NAGF
	PJlxDQHqZbRtlF/s1zqTaaHeP+eABXPXTD6AUASAY16zO5oSdj/yf9IeXAAEcj2D2mSdaO1RuxbMd
	i3cEhRpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfdBt-00000006zFU-0ZdG;
	Fri, 03 Jul 2026 12:40:21 +0000
Date: Fri, 3 Jul 2026 05:40:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Christoph Hellwig <hch@infradead.org>, brauner <brauner@kernel.org>,
	djwong <djwong@kernel.org>, ojaswin <ojaswin@linux.ibm.com>,
	dgc <dgc@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	lidiangang@bytedance.com, "pankaj.raghav" <pankaj.raghav@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
Message-ID: <akettUm5gBD8nj56@infradead.org>
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com>
 <akT4tJzFSfrBxqdq@infradead.org>
 <CAJnrk1Y3yPeXBeBNo+DjTt8eRN-mc2F9apBCUn+j=GV7GMzi4g@mail.gmail.com>
 <akZ3GErzJSTtOn-H@infradead.org>
 <CAJnrk1ZijiWYU8YOmRf24xxwX0kH6vCe3ta89LfoX7v7j_JYLQ@mail.gmail.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e3ea485f.90a4.4656.9103.275b1cd29206@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 03, 2026 at 05:13:12PM +0800, changfengnan wrote:
> taken, which introduced some overhead. 
> I implemented some optimizations based on Christoph’s suggestions and
> made some modifications to `iomap_process`; 
> Now, XFS performance is essentially unchanged, while ext4 still shows a
> 1.5% drop; I will continue to investigate the cause..   I’ve attached the patch.
> Actually, I had expected that switching to `iomap_next` would improve
> performance, since it avoids an indirect call.

I don't think it will for you - the direct I/O readers don't have
iomap_end methods, so you still have the same number of indirect
calls.  What could help is to inline the iterator as seen in Joannes'
fist demo series.  We could even look into doing that only for simple
dio in a first step, shifting the burden to use the simple method
to the callers (at least for the POC).
