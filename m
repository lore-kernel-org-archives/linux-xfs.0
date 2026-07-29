Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C6B44160B;
	Wed, 29 Jul 2026 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313776; cv=none; b=gPBEQ6YxWMVOW1bPj6dEiQtj7LzhCKDGUYvpvbJuyjl7nQW1t4Bw5n+goGXBIoxK56cltXUdwgyowrM7xgzyPkGGzdNYnAYRZ63GNw3Ed+MBn8h5TQ1E09vmb5F5lSQFLq/SpBA8edOvjxFmcwuqHmKG57hndX7Pl24KW6KQG0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313776; c=relaxed/simple;
	bh=DN4z8zQOIgTQ0av4si3gDiQ4htKppXA4TNDQHOITOfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3V/dCllrnD3S0MmHRy3s9WcgxqMDTcF3BriW6H2ShWI3SPse+yDLNhkIXyvl4uQ+aw0jdR1eFrFjH9I4CoNbwB+Odur+pEt+t+vjmfgjmlxlcYEKwios9eTjvdjvKJMp0AMjg42P3v3zW3f/ICfUjEoUeHC7WyhIzWhhTNg3Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uo1xPR9b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uo1xPR9b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5Fj/MjyC0T1Hpz6MegdLj22vnf59FnZxCiC9lfRsovg=; b=Uo1xPR9bjJkXN7Xpu15n3g6XUY
	lb/58clCd7sz4Q6ABhZ4HHDRja54Yhg7YZLnQnoHuzEa+PQeVR7z3NtTQ9I7kj9gk8D9VPOoShey/
	ABw5+XA0uvlbNlMge6viMSxidrdsalURZMh7fqLfyn1FG3Fdp9LpidPQp9IPbTil4IjTNKW2cgSXW
	Gn6N3DkuCol/vty7jKT/TLA5iM6OO/WvgkttnK22KFgf2oXiWEKXB+Q0n95xcIyBxVdfE9/QmNarN
	wj/ntKKPMFu26bmOwAIu58Q1L0Bjb+gEgAkaaRqxm16ALQprBogF1wecAD6CJB1Pk08Jxjs3Gxn6u
	xt0bDgRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wozf7-00000007EdS-4B7Z;
	Wed, 29 Jul 2026 08:29:14 +0000
Date: Wed, 29 Jul 2026 01:29:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: cem@kernel.org, djwong@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com
Subject: Re: [PATCH v2] xfs: check split_sectors validity before bio_split
 call
Message-ID: <amm52bj1VAe24OQG@infradead.org>
References: <20260729073418.63750-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729073418.63750-1-zenghongling@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 29, 2026 at 03:34:18PM +0800, Hongling Zeng wrote:
> Change the split_sectors check from !split_sectors to split_sectors <= 0
> to make the error handling explicit. While bio_split_rw_at() cannot return
> a negative error code for the current GC I/O path (GC I/O doesn't use
> REQ_ATOMIC/REQ_NOWAIT flags and has proper alignment), making the check
> explicit improves code clarity and makes the intent clear.
> 
> This also makes the code more robust for future maintenance if different
> I/O patterns are introduced.
> 
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

