Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D313539CCEB;
	Tue, 13 Oct 2026 07:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791877111; cv=none; b=e4F4Svw5qOKY5hkCH3NHMllufXhcGt+Vf2zMPa77j+gVXWIXwkIoDikJoF8SlUJyXk1BqLybtqKmO7+DQ61QxCDTo2Mqor03hhFQQAEv2B9yfwAWmm90xzxegrfPYi2uHJQME88p7eJrfJphD8Ze7L/1/QLRVKSlaOXi4DE8lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791877111; c=relaxed/simple;
	bh=J8ZpJ7IEUIssWYiGn4JUZV8YSFiAwMHHgkpgEGYWdV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvP2U2NpSpzzQETOeVajckH0Nywz2R2QgQj1krApRoZTORjKHMwQzI9hpegAvwkX0QTaWLhKaXjoR656KlleeQWUkqpZi38OQZ+nKK5+qyBlGg4MgaqY6nyZnzmE/j06mAXV8CHAREbDQN0JJnYga6HEfbN0SosHHakPiSY9zME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lfgaW4Hq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lfgaW4Hq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J8ZpJ7IEUIssWYiGn4JUZV8YSFiAwMHHgkpgEGYWdV8=; b=lfgaW4HqHZr2OMCoLERfsnEWNQ
	bNkTC7v2h25if/yQTTGP8EOcwDNaRtE7J2vtlmKWo/ylvBK1TPcetmDvS7pLHQ34m5ZiSPIrMPhZH
	+9L6t2gZzpI97FHHDAgxJ0GQ9NjCJznJbRZiCdJELf4BMNa2mMh5W8d7we4Qhud3wAzxvZ9ij66kH
	87L3pqLvhdKJHmFI8LB0FeQKFsu6v0ZGsxwakuoWyOSkHMJyAKqoqyTaMPQslS1mi/Ix+LqGeNUXF
	w59Q2r0MpqI6Xm2vz42aha+kDcpO2tFCkB6UCGDuyRYcTfQfEM/TWrt64Bs63VCiavr1T/OgcrPLK
	OKh6EHxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX5h-0000000CESs-37gO;
	Tue, 13 Oct 2026 07:38:29 +0000
Date: Tue, 13 Oct 2026 00:38:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 27/28] xfs: allow remounting read-only after a
 shutdown
Message-ID: <as3f9WNZ1nB_lLvV@infradead.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-27-60743a3dc326@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-27-60743a3dc326@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
