Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275294;
	b=qMZ84KZY+m2aHkSZyZ3KHVTF5DuecxCSV0KCZBmVemmgvOY76z1ck9t8bDl36ZGkdKdj
	 Alv4rYb1Bf2kdaImsYMjGeneFcJym69x9UtR9FeR2HMdR1T/L7X5ygIPulPUzqAyq/w/F
	 dXX8PNYHgYimH6wZHQurQ/wuDXC7shh2HRX9IjXxf0oLq/Ca7djbiv/J9nKj5bVq4m66s
	 bqHX0UGq9eK8ctUI6CXKGaGjot5neqotTaTeghoYxE2GLILnZcxRwEpTUvSYtIsrp8uaF
	 4/crUw5qeXCwuKIi4zT6kmjbsi1BiU06fYSCcEZ2sOQQAapkzj5rOSz671kSevm9wGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275294;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-SRS-Rewrite;
	bh=g/MfhPFo345OEBPKf9YzTxZBUSGNafZSfrPGubFu2Qk=;
	b=rOjssHYqDzpBAfLzHjmPGrTBGAQVv6f5ZwIG2jajKZw05yUJ8NQc+ULCH5/QAFJxHbxG
	 TXIsD6VEQHPb5875i0VZ/HjO3mCaP2ABsjP/X7+miFCF0G3nCqErXQ3qfGedrCzC3EzWI
	 Yq0i2oG0GYg5vzSv81BuSwaH8FmIYjT9vEVRq+fXgaD8zBOqgLb76Oe7AI1EZzjTUReSa
	 WkF7oOwOnAFZ8i4Dhted8oVuiIBScZTSdJVZ+QlMAJNbZHW+y3ejq213RQ0qNxmeEp3ZE
	 147vQUfKqNdlHUYAdjrA3UknUKTcVi7uUgnYz16lOKjXiT+CT0iMWF3K/Q78HABynRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=flrpJOW2;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD5606A31A;
	Thu, 29 Oct 2026 12:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4AD5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=flrpJOW2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=g/MfhPFo345OEBPKf9YzTxZBUSGNafZSfrPGubFu2Qk=; b=flrpJOW2EYTfJAYLCxnD8ieB2V
	esMKkeOcT65CtaYMBNT1borNZQcX28H4W8jqTtwNp7eLURlwcv4MdWNb4KpWH5BV25WA13ccPenPw
	uC1jWywXAozRuHV8/YybyhnVwPz+M+Nd0kMyQIaMnaILgMMZ+VJzzpVJ9kpZ50BxJg23vb5UB0aN3
	PcDhsXhYpEqBRoZV4NV6DSr4NJCPEq9LAX4MSXL539uqsX03VlIRQYeJ3FDQVslRGSxCRAnD56B4z
	HpFa7spV04CUxJxYystgEdKhcHLrxoQzlO5r3FOwHCTKvZu3FpuArhtjuxB7mFBgw5CeSPTBpbbIi
	xCNEYsnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMOp1-000000096gS-1lzZ;
	Thu, 29 Oct 2026 12:01:31 +0000
Date: Thu, 29 Oct 2026 05:01:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Pankaj Raghav(Samsung)" <pankaj.raghav@linux.dev>
Subject: Re: [PATCH v3] iomap: only follow dio alignment requirement if
 specified
Message-ID: <auM1m0fflCf_JNw9@infradead.org>
References: <1559d839fc32f47db7e8da8c8b2a5ea9b63afb46.1793143679.git.wqu@suse.com>
 <auIUEwEzpgilJn_z@infradead.org>
 <69074a82-05d3-4a51-b266-b74a23b39eb7@gmx.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69074a82-05d3-4a51-b266-b74a23b39eb7@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 29, 2026 at 07:04:57AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/10/29 01:56, Christoph Hellwig 写道:
> > Can you please write a normal commit log for this?  I.e. explain the
> > problem and the highlevel fix in short sentences.  No need for [] tags
> > or xfstests output.
> 
> I think this is really up to personal tastes.

To a minor point, yes.  But there's also plenty of fully objective
reasons against this style.  One is that is inconsistent with the rest of
the iomap commit message.  Please stick to the style of the surrounding
code, and that includes the commit message style.

The second is that this style is not good for bisecting or understanding
the code.  It takes 2 and half pages of scrolling before getting to any
useful information.  There is way to much information in here that
does not help understanding the change.

> I understand that too detailed commit message is slowing down the review,
> but if someone else in the future needs to re-check this commit, I guess
> they would prefer more details than less.

Quite to the contrary.

