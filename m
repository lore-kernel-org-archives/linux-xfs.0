Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC53B95F8;
	Tue, 26 May 2026 06:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779776906; cv=none; b=gcvN9g7lPn+gy7iJSFwdebaiD+NycUYGh5+JG5zt36uvS6J92dczK0DyXEbLXyKEPcFCHCQI5nJS4zKmC9B2IPULLWpqFS1Hm/xcOMxkQ2oNOdd1GGOJWCmRG49OnzEbmCDjUT477PZgel8Q5wnP1RYSzuP+4fhR9fpDnqe2b0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779776906; c=relaxed/simple;
	bh=eJ7jRwehY73ImatYjxu/aEAlJNNAbkN9PtVeqywRRB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4eoE/OHmeIiOQUQkrh7HThnd4dNXNgF4yPeaexRiF063G7YWFnEAjf95UUeuyXS790jAFhI6vx4Rpo0m/BlaTdWaWCnNj+mcuBiA8xxBbIemIUjEPEw0TovVq7i0/vDUPmy2hWs4/ZcJs3A3UE/INN48xV53gfTwbC7oT1cIN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=44e8K56X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="44e8K56X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xNnhllXN4PH1PswmwIq+byFVY0ywT1w/V53Mn+v+WME=; b=44e8K56XCbSzl9XMYBQBY825Vr
	Rg9NFcfIL43/WxtRvCAoufWkGF9IWtVVWufHwA58SFNZg0svF8KrVO7Gkr0fN2rM5TqPjR84UWmHP
	wdVWRfvZ74ad4XNAMQ1/VYb8ov+VUR0SG8nQN1rVODEgntDLHaXe+acrKQhTdIu5jfIDh2+4uxxe6
	9b665vhyJMBSq0kT8GNuFt8cjTqoqAUWzUe1++evbfOTntPBLRSTAbjKrIMM/i639htOtr4Ett6fQ
	cvHDmv2Q10owx/Qc2r6fFkasj9dV2kuuvlfBe6KPy0Kn6zxs7lCKDP6+otJcLs7rkx2zakdc6X8+D
	f6oWgP1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRlH4-00000001ANo-3qjV;
	Tue, 26 May 2026 06:28:22 +0000
Date: Mon, 25 May 2026 23:28:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	amir73il@gmail.com, zlang@redhat.com
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
Message-ID: <ahU9hpwrXyZChw9X@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
 <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 04:35:58PM +0800, Anand Jain wrote:
> > Also any reason to rely on the obsolete inotify instead of fsnotify?
> 
> fsnotify is exercised in patch 4/10.
> IMO, exercising inotify ensures we don't break legacy stuff.

fanotity and inotify use exactly the same backends, so I'm not sure
why testing both matters.  Not that I care very strongly, I'm just a
bit confused.

