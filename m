Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNqucVpN"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC3AD
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TRm++4c8rA5R1rEPEDByHTQkVxmOq40MRif0n1HGxEk=; b=WNqucVpNVI5c0nHQvZmVtjkrKE
	+EjGqsbgCRAdhkVdoA2xIH6UAxHzMl/8HsTZ2ezOGmlteXSiHaGHlUtUFGLzjDsocogqhc+7buvJw
	8UX2wjJRdINjopYQFNREr1n7UZ9CbhPkukKxhl/m87sLcc1lN4E2o7O3Tnknhb4kB7UOsQnMRG8wZ
	qm3iFKq8OJePV3h75e+UWFCp8KRReWcALvxmTFrX5txaW7hTeIiS8g0vi74MjPbXKtb+GfRd2YPvC
	Szd7VJoRmqsSVLebnGSZMDcWs6GF5i38eKoapTpfgLv8IKb82zqjNFkcWfPh9+rwZ3SFpCGswjVFt
	Hbkf8V5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63QQ-003w4Q-2B;
	Thu, 23 Nov 2023 06:42:58 +0000
Date: Wed, 22 Nov 2023 22:42:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Message-ID: <ZV70cjzx7Dg5Px5Q@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
 <ZV70YNvPWauYckC4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV70YNvPWauYckC4@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 10:42:40PM -0800, Christoph Hellwig wrote:
> Nit: overly long line.  Trivially fixable by just inverting the
> conditions :)

s/invert/reorder/

