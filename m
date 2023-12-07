Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P0RzGclh"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BA4D4A
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=txEUS6Y96ff3eRRoRNY7MNWlfgQD/PNyIq0pRwp7XMo=; b=P0RzGclh95vVDVYIFxn2E+N5zS
	aF5S0RVVemx2kgaQb1sHZjpjZh38i5DNpDIwRu2gRWIRYvd6meVQp5dNz+pc8y8Kq66RHlN9iHSKx
	BjjN1ymApSlsxtEr5hTsDfZDJ3VmHrgH34r3OWwIfPpRpBE4tIHAfG2eDoze1TFWSmEgfVyXSrgP6
	hBFWxd/0JiDD3H2kMMocwJqcBG10pN3KNrEfaMScanEewqxXHXPuA63pHzvcjpY0GalI3emJTD4yj
	sNOb75iTbPVEoZB3VRy9f1pRKrsZjKGwJTi5AKvcZgujo1xn/auyomzQK7E6mbSFVjapa4/K1/Rj5
	//DTxCpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7aC-00BxHJ-11;
	Thu, 07 Dec 2023 06:10:00 +0000
Date: Wed, 6 Dec 2023 22:10:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: repair obviously broken inode modes
Message-ID: <ZXFhuNaLx1C8yYV+@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I really do not thing turning an unknown mode, which means potentially
user controlled data in regular files or symlink bodies into file system
metadata in directories is ever a good idea.  Quite contrary, I think
it is a security risk waiting for exploits.  So for anything that takes
an unknown inode and turns it into a directory or block/char special
file: NAK.

