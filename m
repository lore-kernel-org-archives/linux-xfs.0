Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559C7397E9A;
	Thu, 18 Jun 2026 09:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773220; cv=none; b=lGNckoUgI3QjvCT3IFSHgkgVSIEjtDybZFwMF4ap8z9glOG8ufLqLgw3d/8IUzYwwvRHC4vDA/IOyev8X2Fm0Wu0vSM+EKNeAtAtgK+ZtzPwi36fdNAB02VM2ZQmKFaK1tBuqeOnVLzi3emYhNMo1VpqjUw34j2Fwv8EoXjMS/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773220; c=relaxed/simple;
	bh=4thpqXiI+/KaYlVSSfgLWbkoMMHrBjRxrK/lTyDoiEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bG9m1RdrEFjQx8rBqE+UF0eFHMeuAWN7UthCSZ+6CK+YEp2yjzqT03U/kiZdmmAFQc8GOrLspH4Nv19PI2IU4/BWZboqmbg3E3ggYtJZLPFtywrQOJ2AXt4/zUfOV3UVPPrVvbPmxcjcj22h/zWiRCxHePcDyQFrp1PZypoBFIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yum2TdYC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yum2TdYC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hr9S1EilRp/LxLONMU1xJrds124ZPbEKvRfJfiEygXE=; b=yum2TdYC7M6RMtCUurcoimru5n
	PtHh1azRXWX/evkU8cq1fWcz48qDHABVw4cCyR4B8RWKgnsnY5R6sU5i8dCtXBvr9cYId+MqPpqiX
	mvPJzIHIhmvTERiJtVm5jpuF58TfeF5D38iYkF/1lUiIk8jLCzoX/UxvSniQP6YsRIJ3Uq/FYuUy4
	Yv1PwY4a3A92ztiKKjdH4vx8zT2xV1+rvxB08/LoXPdSXbncRqaLRVTTPiHwF1de957XO9ZLzeCqy
	VSz/UB8v5R6mzES74kTNsR3xTjqomr6Z8cmyu+lt8VW5WeuRYxNWrgMjgHnVfe6KM8EcWIPRHIf6W
	Qxzcw5/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wa8bg-00000000t8f-3nip;
	Thu, 18 Jun 2026 09:00:16 +0000
Date: Thu, 18 Jun 2026 02:00:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
	bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, andres@anarazel.de, kundan.kumar@samsung.com,
	cem@kernel.org, Zhang Yi <yi.zhang@huawei.com>,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v6 3/3] xfs: add support for FALLOC_FL_WRITE_ZEROES
Message-ID: <ajOzoBt_peOCtNUm@infradead.org>
References: <20260611114029.176200-4-p.raghav@samsung.com>
 <ajFQPANpajmFuKpi@infradead.org>
 <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kn5dyqdxmsydibpfcurgpom5vwqtwinrz27oenh4pekks6ybdj@wyi4zkh7mogy>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 17, 2026 at 11:44:47AM +0200, Pankaj Raghav (Samsung) wrote:
> > Maybe we also want xfstests that try unaligned FALLOC_FL_WRITE_ZEROES
> > and make sure no existing data before the range is lost and the
> > entire range is zeroed?
> > 
> 
> I added FALLOC_FL_WRITE_ZEROES support to ltp (both fsx and fsstress).
> For example, generic/363 tests for unaligned writes and checks for any
> stale data. By default, I think we do unaligned reads, writes and
> truncate in fsx.

But I guess not unaligned FALLOC_FL_WRITE_ZEROES?

