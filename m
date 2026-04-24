Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A43CA4A3
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038781; cv=none; b=UiiXYnTOwDlR337Rdmw1rCBAFUnllcWwql1XnvghdublEjwmvHdKnI0olAsCP/zrQB50Br7/5NjUi+klfUGJwBAvnkncTIT7fFeeBQ5p86c0NzGM5GTsXe4u1GoA0p+fjH8Rgxy/TdIKISFd9PPxMVbAxGQnmCZsVDcphOlx/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038781; c=relaxed/simple;
	bh=gLmlcrRkCpoxdkbKrHKLzhtCip3cJXmO8Og1V5/jT+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjfO2tNwR510qHCmT07cFnbE0h+ohtqpDwTZHhyILiN3zPQ0ZJSKdj3lI0Z/tz4wt0b8p6alqy2gfRbLLJE1Zgt0IKBwVkrah46NBW6y9+lNNBJ5zK2GSLLxv+Wp+oEnH1Wiobl1YrTmD2/5av/ZTGPlXNmnaxL5QF7RWMezjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uoqdOgm0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uoqdOgm0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kpjXz5WnOsDH45y2FwQf8mKKWpUwHnMe3KcrE7OQC6M=; b=uoqdOgm0pShuh3OmHhQyNE0p7l
	rhAelo5dSTL73W7UzdmoOONRWU7mELvs2Vq3bHnjx2gM7oH+BDhOreHZ+P7kVTLAi4v5+Z7E/aocg
	fnQVd+kWh8+Vvvzef5m9FAlyo6t4C7qfLtjUzejCxVC15DRWzMWLJh8I3bXgkTce4/9PE2j8Eb6ho
	Gn41qMGzssTwZgkeboLTbqKxrL3ouNmbPNN3HKb1iBNsVefylaQeXkz9+nGyquoKtpS0OQjbfiBvI
	WBgF2p/EIh71enibf92Yzmlptm/Q95v0sQB4ckcj1gf2B9znKkBlwcjhdTqAFF/BLIazw3Md/J/lj
	VtiJ01XQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGGxn-0000000DHI9-3wJW;
	Fri, 24 Apr 2026 13:52:59 +0000
Date: Fri, 24 Apr 2026 06:52:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org,
	gost.dev@samsung.com, pankaj.raghav@linux.dev, andres@anarazel.de,
	kundan.kumar@samsung.com, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3 3/3] xfs: add a sysfs entry to enable write zeroes
 even if HW does not support it
Message-ID: <aet1u528eM5jQyCG@infradead.org>
References: <20260420105539.3644999-1-p.raghav@samsung.com>
 <20260420105539.3644999-4-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420105539.3644999-4-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 20, 2026 at 12:55:39PM +0200, Pankaj Raghav wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> Add a xfs sysfs entry that will not return ENOTSUPP for
> FALLOC_FL_WRITE_ZEROES flag in fallocate even if the hardware does not
> support deallocate on write zeroes. This is useful for testing this
> feature independent of the HW underneath.

I don't think it is.  We can easily test this using a loop or scsi_debug
device.  And in fact should by adding an xfstests that uses such
synthetic devices.

