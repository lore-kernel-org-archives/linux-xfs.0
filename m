Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Znn3WtaU"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32D0D6C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/q9m4xow1WeXlE5Qa6w8PHXyZ+AaG9hB49lOKzdK/6c=; b=Znn3WtaUa07pWc01l9kjyuYDqg
	vC211hBrScNTBjI4iDP7E7DGZJFDSrDXlBZ809Te2+Qm4J2jzLdFMe9fzXdbKoBiUHazpsrILaqS5
	sLoxpilmHf+sPX0hTwSx+jqVzDYi0SgANTsmhD+/MG8iXXnuR5oGPro8GNTZfMwCmZteZCKTz+qv3
	/X2GSUi6bDsGBEiA3zDfajG5jbeGXi3Gcn+ywXy2zH3u6MDqFet60BbhWzAxFLfKooKv57r+GZ6EK
	I2xxblkmdU0TFL8ldxQeIgJ8UoZsH1QFPUL51Hd4PVVU97e/pp1NR9IX09m/0tCjOyDlYDt2mxYQL
	QgxngyZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8YzY-009wAq-1i;
	Thu, 30 Nov 2023 04:49:36 +0000
Date: Wed, 29 Nov 2023 20:49:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: repair obviously broken inode modes
Message-ID: <ZWgUYG+Hv/rO3upQ@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927551.2771142.12581005882564921107.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927551.2771142.12581005882564921107.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:52:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Building off the rmap scanner that we added in the previous patch, we
> can now find block 0 and try to use the information contained inside of
> it to guess the mode of an inode if it's totally improper.

Maybe I'm missing something important, but I don't see why a normal
user couldn't construct a file that looks like an XFS directory, and
that's a perfectly fine thing to do?

