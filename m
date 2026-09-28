Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A25247AF68;
	Mon, 28 Sep 2026 08:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585502; cv=none; b=ASfW9G0YKI+j1KAb7wwIH2mobR/pGW6ZMUL5WVq0g08qGAuhGutI7cwUaTFNzqes6d0c1rB4nfSDIYkc0WtjCAZyubieyKO8jseH3hampQ3/ibw3YHULCPdFZHjyPlj3kF+YkHCvAP6PYcgkuehAGeJ8fKi5MKKREMma/U0tjsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585502; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/KYwsd3oa3UZTMi/X+XP+6yKYJWtcfFt0TkChruue3XeG/QJUsABhxZ7hc+F15R1evMCADlGvsBgNxif91FPdLSmTSB1KGx1TFjz18E59gjX9wt8eHkQGUs5/j+s5/ZNm8gZ8bj+BWRW3VaH2CwD/Jw77Bdw9c3p+RE8g/RPw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dsfpeBru; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dsfpeBru"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dsfpeBruqBhPouBj9kV1gkAc/9
	ml6DZgFeTrOtjWSm91mT1qMgfXFGHPPJ1cdkXFmvwESj3YTV7+7zGlt0f3sIF1ggmQYI/fTM18TJo
	BB+hRyY3XexMGNhbCRz8Wlm1L15btzx9oiG33BOEkAltU23n5LKGTFTq3h1N6e4ryf4KMIp+qLKAY
	/11AYZqcjMKkdpY7BXpS5/Nn0sY40cJRxLU6864pVjE/ClrUYkQN7eZjgaujtZmWk0fh9f14xi/HN
	9dtrJyrqPtJk6zGxOimjfdH1PP7YXI0rgZMbEhJ6FgS1n9lE+5mOBPeiaLovu1ywaGblML1pzVN0t
	iAy9rNLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB75G-000000009DG-34gs;
	Mon, 28 Sep 2026 08:51:38 +0000
Date: Mon, 28 Sep 2026 01:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <aroqmmWadxFTOGWB@infradead.org>
References: <cover.1790342457.git.parri.andrea@gmail.com>
 <0cbce1012f5333690be36a9adafb3e190fe2ca77.1790342457.git.parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cbce1012f5333690be36a9adafb3e190fe2ca77.1790342457.git.parri.andrea@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

