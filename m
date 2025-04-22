Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0776D1F03D1
	for <linux-xfs@vger.kernel.org>; Tue, 22 Apr 2025 06:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745302506; cv=none; b=k1k0pE1uQoWP3aXDWlgfbx1pGLBWB8s4d2NtO2LDEWLwvqARTbZqz3+VgfnVV8tr05WOMmg9vQGyxCsuFnciQh7m61zdhC/bGn3c2sAskXsZB89L1JCtVFZ/ocDLw8Sx05BDys8q0w6nXDMFS4I6uxrPBBv8gUR0TqQLQTwPUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745302506; c=relaxed/simple;
	bh=+j1BXQ+qnxE4FPGKS+pfqBm6cLPQuErFEqwHJNL7Fo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEU4LW4iDu1EWmaDlQkjE6LyggzPYKtQkFI2v8KMP93PVrs6sOWprGvFinoVpOYOMBNnZP2vdAhh44bJ2DafgcPhL8wYZla8NAbstpHzv4srHAUo5Muej9QiNM05B12NzHKzLNB5x8Q/u6i6Kosklh5XAZp15CjO+Lapy5PCbys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LfSNtjnQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LfSNtjnQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j312oJw07aAKkHQ6wbJESfJlondeVS0Fna/yNpvkh9w=; b=LfSNtjnQDKq7AbxoyJexFp/XY7
	siLIZiDVXnCXgTlWE25IyRZQ5ZOf3+UKJVxKWbsiFrAoFUTpbNFZgzBbAeqL7H6Qumox9fXtXuFcF
	4I1T+Bq6ONEYqxITHPUnPNCCQkjXDfUvhzYI/v/fYpfHpaLJCzlH3godUH2ywCxkymPmwlYI4y7Iy
	wS5mmwD2qvai5r4TfYScQ6eo9gZHwUBB7s3EuUtYaOtnZXPBdZAJiv0ALXvgLi+7NXi5+ogFQ6Y5C
	1/pccVj11QXksL0KpDS5RAZg4g0J0j2puwEZ/klHtuFDw3DH7AbFr+VTS1/ZG5FqtoYGhRMNq0KH+
	4Gg7eV5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u76uO-00000005vYt-2d0z;
	Tue, 22 Apr 2025 06:15:04 +0000
Date: Mon, 21 Apr 2025 23:15:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs_io: catch statx fields up to 6.15
Message-ID: <aAcz6NiFfxJHAHQ5@infradead.org>
References: <20250416052134.GB25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416052134.GB25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 15, 2025 at 10:21:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add all the new statx fields that have accumulated for the past couple
> of years.

I only see a single new field, although I can spot a few flags and
missing printing of a few fields.

Maybe update the commit log a little?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
