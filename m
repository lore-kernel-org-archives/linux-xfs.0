Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE7840B6F0;
	Tue, 12 May 2026 05:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778564326; cv=none; b=YDrEVODsJK3df1SPChBCRA5en0ZSgG0w5Xxbc5Sip563hcYu3faEekprQ0Fmr3bo0rTtlDAxTOIUDMFCCjMe/b6edCkPJ/U4xdjWCanPP/9FHPCYJ1lq9CDhhfScz2TzXecUv6NWYQCxFRvIg9Bq0cqfQ1KDrV1idr8L3jIbhto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778564326; c=relaxed/simple;
	bh=R8pYP2LSzOSiv8SYpUI39kMpvcXSgkDMIm92MTpZSKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOyESpGRbiCNOuKyxOpfUlJE/nQhOgbo6QS5shK+NsX116zFfJFm/vbpuhEEVQgd4xfEoN8CPvimbSDV4IhSdz8LGfc5SK7/UHwzsjAMBo8L/r1dp2n1s0KSMJFrTENg4Kzq9rNJTRk/w3LB0J4u8mtQF2qKMK4zxQKEzau53m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fDX9QKEy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fDX9QKEy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/ZDVCIMAZqs68wwcqWVhh5eJ0cpVPKFSFv2jHmDF8DU=; b=fDX9QKEyVxN/aVQij/SAEAVzh7
	p3Xzo8TxDNzvW7xc8QvsWklkirByJ+tG3rXLE7ugQRg9yAkq1mI0lqUlph64n5brxluQyIIzg33ta
	XPJf6Ag8iEFCR7VypSs0JxUJfXBG6c8ia6rFUQSnIWjnNocNTwY3gf2bLv04pcFPzddXyj0pbZhZc
	Op5SPrgv2gKNxc0Bl+1+1EglEDkxScP+ZTam64lYUHLuImC5BvXupIaqen6tHVMDXbA4OSBDG/w4H
	7BX1r5FYXWtpg12YkrIn/d8wNOMqdEuSjvy+c/bWh79oG+DQMzavOgLb+3XC8s/+D+BYgxp2H3ZsR
	Acqu7TfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfpG-0000000Ffdj-2Si0;
	Tue, 12 May 2026 05:38:38 +0000
Date: Mon, 11 May 2026 22:38:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v4 4/9] fstests: verify fanotify isolation on cloned
 filesystems
Message-ID: <agK83s6NBxpbDREJ@infradead.org>
References: <cover.1777357320.git.asj@kernel.org>
 <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 28, 2026 at 02:42:54PM +0800, Anand Jain wrote:
> Verify that fanotify events are correctly routed to the appropriate
> watcher when cloned filesystems are mounted.
> Helps verify kernel's event notification distinguishes between devices
> sharing the same FSID/UUID.

Do these tests pass with all major file systems?  Or does this reproduce
the previous btrfs issues in this area?

