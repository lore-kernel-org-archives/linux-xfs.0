Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53558DF53
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yRnoJGtE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SLPy5c0W85Uu2C0oJs/lKAT5TFCLYv7FYnX2/DK4NOU=; b=yRnoJGtEpiwWS9n68nRDo94YiN
	JsnqTl+qL8F4LC6mBkxmHC7NDs+FLKEty0DQUs/G8Q4TbzExmSsWWQcx5YyZYeHqrBkSCHuaXbLPz
	wyJDn/iEQ/Z6/snTu/IYJceT1GusLhVrNTFPHPRo2ePAk0VqN4hO3PH+lxcMTERyzRALdX2JWMTKx
	A5BKj8rRXoCCwgrt4IZZuY8mCrh0MaWA6AC2ZR7NBWTiYzGa+sX/dURhuHyARO5D8Hep2+ICsbg5Z
	UswD5nzcW+2zqOFGz6cpKodvl2MtaOFmIkXEXsI+rbD347F6MM4LsWAfoMelXbKfjM0hHi8Ago87g
	+jlKcl9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc5W-007bXe-38;
	Tue, 02 Jan 2024 10:33:34 +0000
Date: Tue, 2 Jan 2024 02:33:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
Message-ID: <ZZPmflimTzsSzH76@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830543.1749286.11160204982000220762.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830543.1749286.11160204982000220762.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:17:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Certain btree flags never change for the life of a btree cursor because
> they describe the geometry of the btree itself.  Encode these in the
> btree ops structure and reduce the amount of code required in each btree
> type's init_cursor functions.

I like the idea, but why are the geom_flags mirrored into bc_flags
instead of beeing kept entirely separate and accessed as
cur->bc_ops->geom_flags which would be a lot easier to follow?

