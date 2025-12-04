Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32C2BDC13
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841001; cv=none; b=uc3InxmXlFlP05cg7JyXVdlZ1M9lBl+Y2oiK6x6Eu2bwjg2mEFhgXpxgUF8CwPTYVJyg7NYJFpimJWMhrwVke8+pK1OBsLcqs82LJZxChlzRpscsKoB0FdVJ0onK52uIQBFeGXKGrdo9lrjad6VqHOzGVnpYCpBCW0Hiy3WaF1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841001; c=relaxed/simple;
	bh=4e8Bqik+eeTvNil2ktfC0wPKaorQaPMbRiAYDSydi/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgMKe43xvMup2rfRRCxjgMPUeji/2A47pQazHdDV676S9kjEcr6NqnUMQCL1wmA/jd0pwTZhKPytoFGVwKuarByuwCGX4wY+Ky0FsfygUjosfLK7/y3FkllhvRAyK2awPhu7fyHle8pZtP7/Lap418OSTDj/YOEHnuhkHF6bmzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RBQ+dREC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RBQ+dREC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4e8Bqik+eeTvNil2ktfC0wPKaorQaPMbRiAYDSydi/w=; b=RBQ+dRECg5dXbyAj8Y4sTQHUqY
	wFWdXnKAfe4TfFcWidsFGFqEkAcY3saKbPEw+GhamhT3E21X0N6AZwCedEHRVoR9QxUaK7oBAX0Ji
	m6N4AMCS6k24yUvxrfns+xtjJi1QLut1cp/2hQqofTHD4sf2TyLhrfUeeE97X4/GVas8yZ5QApjoN
	vQyUlvfA8oxqy//6lpgZH2ZcRZIKKQTnf1k1UbKSQXmCUHXm5I3kDagFHo/bIZZE3ucAjoLo0JONq
	70alrIyrYqpD8i84hmjuy+PzLGORsjmWhpPTEoECUYKyhPELw7s6f2ICQghfhXKuFAl7ElRU9fgF+
	UWS1J1fQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR5lO-00000007mAR-1mrN;
	Thu, 04 Dec 2025 09:36:38 +0000
Date: Thu, 4 Dec 2025 01:36:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v1] xfs: Fix xfs_grow_last_rtg()
Message-ID: <aTFWJrOYXEeFX1kY@infradead.org>
References: <1e5fa7c83bd733871c04dd53b1060345599dcef9.1764765730.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e5fa7c83bd733871c04dd53b1060345599dcef9.1764765730.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 03, 2025 at 06:15:45PM +0530, Nirjhar Roy (IBM) wrote:
> The last rtg should be able to grow when the size of the
> last is less than (and not equal to) sb_rgextents.
> xfs_growfs with realtime groups fails without this
> patch. The reason is that, xfs_growfs_rtg() tries
> to grow the last rt group even when the last rt group
> is at its maximal size i.e, sb_rgextents. It fails with
> the following messages:

Please use up all 73 characters of the commit log to improve
readability.

The change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you submit a test case for this to xfstests?

