Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F578246774
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 05:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054520; cv=none; b=XMgJJoetVO68xRx5Fwo16sXOkHMEYO/QqkEAzlH/d6H4zxvd04xN1b1Z2WNcTWBhJOUnUuMzZP58QUZSEfHMZhddTcKFv+ZMDjNvoTW2C0RjbkwrAX/BRwL0+T9uOtHUQnD+zEGRtl5Hjd87YwvQHt9fpRMbUlTy3YkWQLfvOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054520; c=relaxed/simple;
	bh=k6te88wvPM26dekgR0iCO92wd5XkxCEDhzxuKW30qzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCR0RKM94Tk3Dcaj/i56Oqm9yqecDgeM4k1zK0Go0b8EV0zp0DWJXqVrBdheyX1A27rjCuzfWzexlH9q4ZN0YpyN6iu4o0TvnTGCFMYYvVWNbM2DDxb61LIzsexblyQv2PX35ZWvh4KpPv0x4Ygi+QmC9VdAbb9EtJMkCJ4h9e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O3Ih6Mhw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O3Ih6Mhw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mgnfmKh3dQSQeQYd1hcXebHJ/RYmJZw4ch8tq85C+ZE=; b=O3Ih6Mhw07j1921QpAjCiLvdHz
	Adt53uKg1XDlwVPdrgCg2oNDxNqLBeYjW0U0VeAt99X6bkhbrdp6dhFQITSsEIEZl4lQFxCBHx7k7
	C5O34lvRgse3O5l3zSfJTG90mcZDT2OIGnquvblIO57EyXCIvh8+40Js1gi4rX7MGx3hydQ5eOyFl
	5706dMBsY2WiyaFy/HoNIxVFIcQcdjgX2hD2C0MMZ/01R3OeC8ud+R97RRyLvN8XXRvhKR9ey1q1J
	B6anX8bl0fNa4Jz1Myn84iDaPROU35xbHA9KUuB/4RAmy2TMqDQ2SUV0n/Vs2+AjM0mz/ezCad4Vr
	CWCctF0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8sx4-00000004Eoc-1hSu;
	Tue, 22 Sep 2026 05:21:58 +0000
Date: Mon, 21 Sep 2026 22:21:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: add missing healthmon trace strings
Message-ID: <arIQdjrt_Wgx0cZz@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120742.181988.4615087468034246498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120742.181988.4615087468034246498.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:17:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we don't have trace strings for all known healthmon
> types and domains.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(proably another 7.4 candidate..)

