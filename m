Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116B611187
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 05:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727848033; cv=none; b=ErxLn+3V8T5yC1zWtnAxU91PT3U5bG4qNQIszppj6kiwxoHmqEaMRhjjGYMj/nYceuOEpTmKx/ucarWr+ot7wOSuBZ3tyNT83IJaQTbnsnDQyihL04XuBv5LpgU+7911fOsb9XeSwV90rUDVPWzYUuBRC26fUZWqY/I5FOuu2qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727848033; c=relaxed/simple;
	bh=zFNGSUIbIXKSgYLUhBZETOccdBXYLmYpoFFL9ZyB4Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNXqdqJDUT+KPqPGMIO5HrjmUsZOyWJBQWNSoeHWz4TbWa0BrBfYhJM/jyBCNAhiZVqBxV+OVLllHWcFMMfH5fIzWjFFqkitdXYwfM3rL9vmV2wTQHbiCreBLhl+iloqxwjnlI9ID4Tdwz/EDI1KFBJpWnVMbL22o/D9ljdfiag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JAZX2DXN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JAZX2DXN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mhuzd20kxTFU+gUACeedmEVN0fwhK+fCG0jnE0paLcQ=; b=JAZX2DXNbBwFVTi5SQpdtR6CdB
	lmPT8XvVbQKNhP1vNqDoLmP2K4WJoKp+xJr2VY+qVQ+u3lEAj0c3LZrwKaE/0QIgKzloQuS9nymCD
	dNy7sF9ILu8CPZfnu33cHnmapxiO1/64Djl1+9bqZmYgOVeVW2agXVtqw1uZ5P4rjhP/Rtwvh++c8
	uxsI7Zc7JDaYIScXINNERC72UKVkUEtqwkzDDDEacKP7LvCHOVEu8oIL1znFy1lmxJtFUVdakyyoK
	GWj90MPDB5t13cXg0VugiMHuYq2YQUCTYY9tGmi2+0JFBp9nXtFPmXQimser3px7rg8sJiRXbzqzp
	rZrKV+dQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsCc-00000004rfr-3dzx;
	Wed, 02 Oct 2024 05:47:11 +0000
Date: Tue, 1 Oct 2024 22:47:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, cem@kernel.org, Bastian Germann <bage@debian.org>,
	Zixing Liu <zixing.liu@canonical.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/6] xfsprogs: Debian and Ubuntu archive changes
Message-ID: <ZvzeXgVENM7yjBzp@infradead.org>
References: <20241002010022.GA21836@frogsfrogsfrogs>
 <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 01, 2024 at 06:04:26PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Hi,
> 
> I am forwarding all the changes that are in the Debian and Ubuntu
> archives with a major structural change in the debian/rules file,
> which gets the package to a more modern dh-based build flavor.

Looks sensibel to me, but my Debian packaging skill have rusted so
much that I don't feel like an actual review would have any meaning
here :)

