Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6D25634;
	Tue, 27 Aug 2024 04:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724734257; cv=none; b=s29dF6vXQOp5KhZLbhRWQWsB0g9kmHPpSTcWB+HasXB/bA5rOLShDH3IuXZpA6MUmh8/z8P0jLejWXTfSB1L82cpNsz32ohmrBjsE9GA6C+Jd3gBcthGDsTO0XBXkVbOisjVQjcPDRx8maBoQw6+lnaVgMU+nT1kLIeDaXnAot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724734257; c=relaxed/simple;
	bh=iTw9FtOedjMeXaiGR9+4PUwlaAid47PvXefkLVREIRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mv6575Ylv5YMp3CSnaWeEoZXf1536cK4YyPjeK3yBIippWTaXOnPL5rnyKAhUt9eZHREGBIlLxwZiS1t5XBOyFrX49gLt1vMLSwy6cPGw1Id42yh9zwnONofnkDY7Qfse8MMe+RW37JK3eKCC0EETC57v4yWWrgd8r0RgmiOpOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X+ClhVSF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X+ClhVSF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iTw9FtOedjMeXaiGR9+4PUwlaAid47PvXefkLVREIRU=; b=X+ClhVSFvwu+c5+V8/XT2knjyV
	HmQoJeM/5i4EKwBFc4yBYkhJYIfA6aMlsP+rgDijFQubj0qELjRIB8gebajrs1qmUbLw/HFojEdOh
	6zEO4lDpFtJ8SVQNO63MIU/Jzg37eh3VS0jiIGCtF7tYRVUhM1omAwD/RzMDZOAEYbYmbbAK93GVt
	sfo3xLfYayOIHwn8VXltWC5ImsFPoiQtdTABzW5BKSnK6kHSqM/t6mI/ysQqPAbtp16u2Qe69+mSq
	Owg5wJpU6ifr7dS6uEv/jC7jNML7u5zJ+/PpZCssR+dHEKUGobBe0CgX49/79pVluKs4IMk0zHgQu
	1qvtJJuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sioAR-00000009l83-2Zq0;
	Tue, 27 Aug 2024 04:50:55 +0000
Date: Mon, 26 Aug 2024 21:50:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: regression on generic/351 in 6.11-rc5?
Message-ID: <Zs1bL4H1dR_HVPmT@infradead.org>
References: <20240827020714.GK6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827020714.GK6047@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 07:07:14PM -0700, Darrick J. Wong wrote:
> Has anyone else noticed the following regression in generic/351 between
> 6.11-rc4 and -rc5?

Yes, I'm seeing this with a fresh -rc5 build.

