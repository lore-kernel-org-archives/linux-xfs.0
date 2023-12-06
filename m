Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vp/4qeyO"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630A3D44
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 21:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=/DAiLEUW9zD9C61sbK2eTB6T6/2D8KHBxHAtaEU5byA=; b=Vp/4qeyO5+sU+Kho9WTDUxq0Na
	ZZwkP/bdRelUajFjXzLhCPBHhTvAlsDFrDRLRqUCV62n7a4ca4YinCypu9T6zmiQzJrDIznQrqUcL
	/inOM5Qu9u8p7UU7zOzBQRb3DqB+ynJnsQ0FAw/mzcttmH3pahw+D0szkFvNLa+GZg+sNyr0+VjLY
	Bm78BsKW3ehV3O1lo33al8VILLKR94OkfUtVw+6+ik4/iyrhbI6AGEhqa3SF0+mV8bOVBJJbFeeUk
	u+XirEX59ODCi6RYr2adY0dycCp8AETnxrROfD2k59OAg/1H7Ljh8vd4MQNzgk4RwaTifa0u+rGDo
	1X+VcuBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAkGv-0095Ax-0j;
	Wed, 06 Dec 2023 05:16:33 +0000
Date: Tue, 5 Dec 2023 21:16:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: repair inode records
Message-ID: <ZXADsQ7onmKd4u9k@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
 <ZWYek3C/x7pLqRFj@infradead.org>
 <20231128230848.GD4167244@frogsfrogsfrogs>
 <ZWbUAizpezw5fuZW@infradead.org>
 <20231205230843.GO361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231205230843.GO361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 05, 2023 at 03:08:43PM -0800, Darrick J. Wong wrote:
> Hmm.  I suppose a problem with "?" is that question-mark is a valid
> filename, which means that our zapped symlink could now suddenly point
> to a different file that a user created.  "/lost+found" isn't different
> in that respect, but societal convention might at least provide for
> raised eyebrows.  That said, mkfs.xfs doesn't create one for us like
> mke2fs does, so maybe a broken symlink to the orphanage is... well, now
> I'm bikeshedding my own creation.
> 
> May I try to make a case for "🚽"? ;)

Haha..  I suspect not allowing to follow the link at all if is marked
sick is the best idea, i.e. the concept we've talked about for regular
files.  Make that consistent for all file times, and then we need to
look into an expedited on-disk flag for that to make it persistent.

> 
> 	/*
> 	 * data fork blockcount can exceed physical storage if a
> 	 * user reflinks the same block over and over again.
> 	 */

Yup.

> 	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
> 		/* zap it */
> 	}

Perfect.
