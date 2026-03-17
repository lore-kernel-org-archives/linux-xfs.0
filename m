Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11C35836F;
	Tue, 17 Mar 2026 09:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738778; cv=none; b=llEzv8y2nqQ6iEjAC57CeOAu2TU789IE378WpxBrQNYNgR5ppc+tgdcx932shpvqaecFYYShAOOu6cFtUATkjjEO9P7NEBpvbxkZEjM7Yn695tHCECyS3rMBMaep5fdTgt0ydTpFhoOv6u+3TtEWnnCDCigW0o4ui185NBzOWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738778; c=relaxed/simple;
	bh=jUm8ZaJLBgG+Muu5qS6r+UYXt4rhu3m7PbKkHZFEDvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLImGSVeg32/qbU87ezhJwKQapRYOGTIfsjRGdJ0lQIRwb75ge6H6Ao2YnSo5mUMBCYavwIhf3co0lUWaecYLKvi94YfggegJomOLUxIhDYEkwi8aUIn1Qio81LTYGssuRuRkzNgt589IGWEODeZv8Y8M68M/LMDfPBZCLuPmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AG/3HAK4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AG/3HAK4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=fJgFDdVVNtRZq/ve183e/9QuXJnpu/Eq4FFwP2YIxlQ=; b=AG/3HAK4O8ayyVuOPZnyB2Uh9P
	tmWEwIZEROjZynpvbdpq+DNRMbvkY2gybeTuDrtfY1/+jnWqz08TGfzJP533FGrx+D8zlGC0KK+eW
	8IUU9Ycke52oz97aq7wtzygtu+Cqrfs3Ky3ics5cWclSxsoLrPtk+otIY8WuqG20IB0coqQmKBkpy
	H5BH34XfTk19Hd1e984MffKBwB6b+R0adtFusadkFbMEY+DB9Ab+WKP4lGH4vJVQxTesd1JJ4hTcP
	7SsXxzngnle7K2ehUDtH+F6iBa2NbXTdiR1u6h3KtK094IoHBra+tjt3/4rg/rhEITBPz3pbbceiH
	L8dxodpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2QTr-00000005ouA-17Aj;
	Tue, 17 Mar 2026 09:12:51 +0000
Date: Tue, 17 Mar 2026 02:12:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	guzebing <guzebing1612@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	guzebing@bytedance.com, syzbot@syzkaller.appspotmail.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Message-ID: <abkbE_zh79iCd5zs@infradead.org>
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
 <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
> > IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
> > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
> Yes, at least for now, there’s no need for a per-CPU.
> It might be better to replace kmalloc with a new cache, but my tests so far
> haven’t shown any performance improvements.  I’ll look into it further.

Does using a kmem_cache help?  That should generally be a nice win
anyway due to keeping the objects together.

