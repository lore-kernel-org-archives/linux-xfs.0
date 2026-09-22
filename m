Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA6133D6F8;
	Tue, 22 Sep 2026 05:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054483; cv=none; b=IPfErTfhOuf/EUGOTmw/XHlEqB6vlX0nNGhgWbjS/I2p6g8c1/mY4HODFCXTYIyO8QLFQsLrZdcSKYPAFGaOtRT/R8qiGz8dhEHKf7Mb39ZPDJmZJonSmQKWNl9zKKZNOgsEVYefE7aco4/j+bBNRkujAa9SejGcik9w7XiCeRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054483; c=relaxed/simple;
	bh=erP8RBJ9p9je4aczfigdp3hsYaKnrJD+6eMDA69Ghzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjSzYU7AYIUKZ+QkZAKRd72M4DamauUPkoQUARDLor13H94I+K6ZdlEqpFFOeGZet2VwzAzDVquAb0IGgvXw/APBYBwria2O8CRuXXJVBzyGs+TUVEiLpIPPCo7FTh55DoqXKDMbBs8pn/v85hbbAFLOpzxxbxdQXWp6O7LPzP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vi7GYTh4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vi7GYTh4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uMrg9wC1zXQFJKpXg9k3lqYqkeYPsLQaMAadLP4IT3I=; b=vi7GYTh4OOoJMnTWyEPTdp4sAZ
	wYf+BhgTV6nE5v02PPPfYs3o17VRiv5bD2avdZtSJro+orgHAO+JMy9674LSZZGybkZcJlQMG9SYY
	SrMv0QAdf/jh/xi96VSmzGGM7AFyDfEG3gFrb9EsJ4ixICgP8fjxkrutvqmzIxqy+MU/M5RjMBQrp
	Pabc+DF1j4ChX63bSRjoQXies9gNNuXFhSQ+o1vi5K76DXqt43KR+OWGDF4KdXe/JFAHcZ5Kcbwfb
	YWo3jEeUdnmaZYS4y3zVH9tsyy6fv1FJFY+AAIt3xCmuzWeA+aYUsEgDXoXYd7v6bWTTpX37Ivkth
	sWVuVEjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8swT-00000004Emy-0kH9;
	Tue, 22 Sep 2026 05:21:21 +0000
Date: Mon, 21 Sep 2026 22:21:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: fix maximum atomic cow length computation
Message-ID: <arIQUbrLZNVv10Mo@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120721.181988.7950955477687457877.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120721.181988.7950955477687457877.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:17:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM says rounddown_pow_of_two acts funny if you pass it 0, so we need
> to catch this possibility because maybe the filesystem doesn't support
> software atomic writes at all.

Can this happen?  Shouldn't the xfs_can_sw_atomic_write() above guard
against this?

