Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9582913AA2F;
	Wed, 15 Jan 2025 05:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736920525; cv=none; b=gtmqr5K43nrmJnDAzpmP4x5HJi8DwL1OOe0Yq9E6f2oNlOdMvXumiXbZJ0YR2BJW5bpKK1J+7YvDAaCpjw+q+KcPK52+JwW6pILvU2AZiy2UHhQ4MfZFr0dBKfLV3y9a6PuxKJc0Ur7UPGp+1mkmp6nFqMclqtZNlnAu05z1iKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736920525; c=relaxed/simple;
	bh=C9PjXzyIracXrGUGYcqeHEaqLZW38NLIgucIkto8YQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUfXmoetjmuZipyCFvUbRnBpgP2F9RPI0pNuOTqExdd3LYVwN8t7Zh6vwx4HrZgFkS06V18nslME/pjtiVkF6lXsmYSKiF3T7kndHfDLnIwHtIWu32nSGNuopR0R6Cwg0eWjjDWNNQcNKax6E6pUX+Ffiz7SC+bCe8oysJtlxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DbbL/6SS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DbbL/6SS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BkgupXK1cJH9k9iydkm0zaNPL9RUYxkZGLvgG7v6TU4=; b=DbbL/6SSeGt86J6OAkRUnvBtxx
	+2sT4cqB9u9CVHwoGwYE0xRRYB8WD8TN1Xdy4ojj2bP3EaqIhpbD/NgzDiviFxpn8eXcPWoDSdnPE
	q5IGBPPyaMyxfSpOe36x7629B24754aUXg54SsSnfOF0e3+8seM41HYjYbD9qdbJrFX6V+0E/oVRv
	5BWCSGnRmjA7xA18vHhe78Jtk777ScMcAs1KllZY5Nznkl0lT4rKHB6Uj8aEDRq+F/BESULFLzar5
	Irn6cEdiPOAXUxFZdMIY52zvVB2Ounx0dmi6H1HBx044ul+SRmzseD0wfRyqA3nzrjZOB31cNm0VY
	jkuKS1Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tXwN7-0000000Ak5h-2lEK;
	Wed, 15 Jan 2025 05:55:21 +0000
Date: Tue, 14 Jan 2025 21:55:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Chi Zhiling <chizhiling@163.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Dave Chinner <david@fromorbit.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4dNyZi8YyP3Uc_C@infradead.org>
References: <Z3B48799B604YiCF@dread.disaster.area>
 <24b1edfc-2b78-434d-825c-89708d9589b7@163.com>
 <CAOQ4uxgUZuMXpe3DX1dO58=RJ3LLOO1Y0XJivqzB_4A32tF9vA@mail.gmail.com>
 <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4UX4zyc8n8lGM16@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> Sorry if this is out of left field as I haven't followed the discussion
> closely, but I presumed one of the reasons Darrick and Christoph raised
> the idea of using the folio batch thing I'm playing around with on zero
> range for buffered writes would be to acquire and lock all targeted
> folios up front. If so, would that help with what you're trying to
> achieve here? (If not, nothing to see here, move along.. ;).

I mostly thought about acquiring, as locking doesn't really have much
batching effects.  That being said, no that you got the idea in my mind
here's my early morning brainfart on it:

Let's ignore DIRECT I/O for the first step.  In that case lookup /
allocation and locking all folios for write before copying data will
remove the need for i_rwsem in the read and write path.  In a way that
sounds perfect, and given that btrfs already does that (although in a
very convoluted way) we know it's possible.

But direct I/O throws a big monkey wrench here as already mentioned by
others.  Now one interesting thing some file systems have done is
to serialize buffered against direct I/O, either by waiting for one
to finish, or by simply forcing buffered I/O when direct I/O would
conflict.  It's easy to detect outstanding direct I/O using i_dio_count
so buffered I/O could wait for that, and downgrading to buffered I/O
(potentially using the new uncached mode from Jens) if there are any
pages on the mapping after the invalidation also sounds pretty doable.
I don't really have time to turn this hand waving into, but maybe we 
should think if it's worthwhile or if I'm missing something important.

