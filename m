Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02D21EB56
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721661105; cv=none; b=tONox1rsmuSMPDqN0f3D06puG7clDNdB4VcH8FIOckV5Ts6x4cJ05ytvg8nB9+ueqp/WDc8EIc/A2n+MUP6Aqz491QQZPy2WUp91XMc/P+0kDOeJX6LEUF26KLvSc8Bs+IRnf1GtKRlA7X6u99AVgvSEEaApqf+SQ54svpSuOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721661105; c=relaxed/simple;
	bh=m+lRA/Dkb+NSHV1hDXGxt/3PlraFJyuw5DG55BU72Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=siqQoV/vBPJBE84mNkFuezSAys5vSoKObjYxodNd3ztbsvlxT9KyVuBK2GoxczoxvZU9RgTetzG1fBhHlSL+9Aur99j/BWXEN9gn+ahCgPSfZmyKco9AEpCsKrH4PMz3XESVSwqD+4kBH5t1Hr7gyaCa8TPvI5ujOwCihjlS3RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JtGxp0sp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JtGxp0sp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x7j9Gl+4paKPRNt3BijGnzgoUNPBybaKXBmB+tcHNZQ=; b=JtGxp0sp1yBBPqbhtqmC8pLGbd
	nTOQN6kt2Z7eiKsYTi4vQKzarRMc4W59QB3na5gDctKbQdMJWcZPJt4VT3VOdj1lCu5JoqZlCBd4t
	HrpXpxY0a4mt5xKMhe8UkvDE2J82y5KM7qQL7xmeFajdqDDHVF1JLO+amla02tmADnJj5iyXSCaAi
	Nknky3wtk78gJWPjjda0NlKTUI4bN/du9v2ogMN+ny/h14Vao5YqN7D6VpIlumvFrNLpO2gy8BiYu
	MHwdaqRDDRwKNk/dyHEJK5PeOWydA6uY7N6mOINI9zpSJreTLRj5Pc95GjWFw70bScUeFYw7u1vOa
	arDuLp7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sVuhT-00000009tj3-1xFv;
	Mon, 22 Jul 2024 15:11:43 +0000
Date: Mon, 22 Jul 2024 08:11:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow SECURE namespace xattrs to use reserved pool
Message-ID: <Zp52r8TBTQjJP-M-@infradead.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <Zp5vq86RtodlF-d1@infradead.org>
 <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 22, 2024 at 10:05:03AM -0500, Eric Sandeen wrote:
> Ok, I thought the local var was a little prettier but *shrug* can do it
> either way.
> 
> To be honest I'm not sure why it was done for ROOT; dchinnner mentioned
> something about DMAPI requirements, long ago...
> 
> It seems reasonable, and it's been there forever but also not obviously
> required, AFAICT.
> 
> What would your explanation be? ;) 

Based on your explanation it's probably ACLs for the same reason it
applies to the security attributes.

