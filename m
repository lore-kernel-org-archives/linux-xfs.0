Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51801AF0DC;
	Wed, 19 Feb 2025 05:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944723; cv=none; b=vDWQ75W952omZ6ovB6HvBOWiTZXTiDgkK3hVr7gdGnQ9yIbnloxp0IJpbwc1srsKcLF+trOuHmlcF1ZfS8Yw2B98nwOVV5mbs0ix2Xao661+toYlkgXQ7/BzBBxw8ldxmw5+Jl2JQee1ZGlydcxvrVJ0s2xlOtJBTn6ZdrfcSqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944723; c=relaxed/simple;
	bh=Y/I3suDOUU+5HpkoeXRym7D5cxl6WKBQpK/V6Sb2pk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg1kKja1aKVgJMgbwErWH9hqdi9GC30eOhTsUU/hpsW06+GmoN7TG9tw8I+m1AKg/zzC+OjXoYGZSPYPp/3p+diVBC7V2JBrkGHXmMSV65mVK5COfUIsv9jDLKbFSmt9/Vhd6+YaNxiR+XwiSxUiB9qepcK10KdGpmss0qSeH3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A95nEvDd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A95nEvDd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sa4CFKgv5aSluFI8NUVC3iysbiSg/Z+mFuNpM4vQNAE=; b=A95nEvDdnZgosarldroJhGYPol
	/+h7gQDqgDwel+fG5pz8L3f7c3r/yO6KNG0jrYUtRD0nzBSywyDxMdvWC+bV9ua/VL1umJC9mqg9P
	USax3euAPAbbjGB6yKejZbAdFX7BzU2WTTWcPFf/9FT/ncf97MqiJG4m7u6gcrG1pu9GZgeqTF9OX
	WKlWFTuL/VKrZZKOz+Gh1Jvfs/d+6OYnEViQ7v8UvvtCnCkVwKs3rYBdJbnEFxvIUfqfv4kHeMysp
	wGT3WGjL9M/fvuepXDiS6ANt7rk8DSMsRaaaA52zrIJmwIgV7VuTVH5zyvIt23T/hb+WCsOM393nl
	s1Hy8xFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd6Y-0000000AyEn-0oHf;
	Wed, 19 Feb 2025 05:58:42 +0000
Date: Tue, 18 Feb 2025 21:58:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/12] misc: fix misclassification of xfs_repair fuzz
 tests
Message-ID: <Z7VzEog2eLAC74LW@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587514.4078254.13210003661775451613.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587514.4078254.13210003661775451613.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:51:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All the tests in the "fuzzers_repair" group actually test xfs_repair,
> not scrub.  Therefore, we should remove them all from 'dangerous_scrub'
> and put them in the 'repair' group.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

