Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275322;
	b=JClQ1+RizHP4Ka0tEO0ayePhFTOZfhxsHRjaAav2f3YEaVaQKZ0UHlbzY6frjy8v5P+T
	 Y3yRLumYDx+a8PrVjse9fUsoAQWTKQKZ6NRsD+CiHNjN8oJbokWFzyTI9H6qtqHQuwikA
	 QrdMPO6V7AKZxPXTs0RLM+oZUNXsy8KmTfO9uY61XcChDr+enlqI4NdBtKu/ZGwlqkVyl
	 vpZey64UtRsrVbWlLn2HMeq4wMRmYQvLz1frEwWIztaj5zPvjGgwTOc6uOzmINx576IlK
	 Bb4NfekvimGAwzr9AuYqSFewAqJHG2okEAJHZjszo2qaF7+TKJiHyrSVZUO6lPJPLkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275322;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=tOmRIEYxWkgPEf8B0slT4zscUlC7y7/EPeg9N719zX8=;
	b=onqTjI+bkZEhmOGq0v8fhPBEATUs66E+GH54UsIJGez6PsdHa3cArVOEEDUGD3oouVDA
	 j6Z+q3slre1X+BHR01+HYkREY9KxVbBNv+WFtEWBQjwMgT3bn0bl1/bfiZwdd5wM1yEs1
	 b4b2zcayS1i5CgKa5U66EtQQnZ3FXQyIFEzC6+SH2cBfv9xhwksBY0DrCuS+A5PinsgHF
	 0YmZsHZvSzyiEdnytMK9MluFkgHzoqvCht5wpg3CmK3KE6JH9PKw9OgDC1rKwG6UEOGbD
	 h9Gqx0le9B179ZVHYBG0d4hefCzMJRYwS0VGsP+1S+algrxQdA/zxj5n6TSZQj8dbDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iJ25NTRS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89AC606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A89AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iJ25NTRS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tOmRIEYxWkgPEf8B0slT4zscUlC7y7/EPeg9N719zX8=; b=iJ25NTRSZwWXzpGte/82R4dq37
	KvUo1Cdev7hLxDoYp0jKRix2nJyE4GEfvOGQyTojDCrHTmSox57Yua6E2gFB/VjEOYDyne9eJZV0J
	sUB64nGPoEYtyZhW/GC3gcnjc7H24xd2H2uNoGA7J9kHVGALwzx74ujvy7rZof+Qy6iYHy5iZp04Y
	Baqyb6TtLRj3yAe/C04FB/4qG6COrcK7qvIYBjvXEjAidpGGrMlPjNXLhcQauvWPfU542Ijss2kNL
	TfuaMuFSzpDzVFMAXB0WWkI10NVECNMo2F3MWK4f/xkY8xkVpepLrI0wh08Wvj7+gOn5FUO68Yn10
	P4/aVimw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMOpV-000000096iB-0InA;
	Thu, 29 Oct 2026 12:02:01 +0000
Date: Thu, 29 Oct 2026 05:02:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 5/8] xfs: remove status parameter from several btree
 insert functions
Message-ID: <auM1uZhCIcH9ePOw@infradead.org>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-6-sandeen@redhat.com>
 <auIZx_UH5UYvYzqU@infradead.org>
 <ce477fd2-2445-4bae-a3ec-3001ef152808@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce477fd2-2445-4bae-a3ec-3001ef152808@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 28, 2026 at 05:35:29PM -0500, Eric Sandeen wrote:
> > Although I agree with Darrick that spelling out the parameters would
> > be helpful.
> > 
> 
> thanks, agree but I dunno, seems like a dedicated patch to change /so many/
> of them would be good instead of hitting this one just because ...

Yes, a separate patch sounds fine.

