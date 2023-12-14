Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RFoDYXwi"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A43106
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zWO84Qq5xYCS1KV20JXR/s3aktB3DlnhpGHZmn22Zq0=; b=RFoDYXwi49I+JOqMp3jpjBhW18
	bHkgiTfL5ReOrB2Emttlmgg7NQ9hfFEU2B0Zgd62hiE9p4Qs3zb/7KNKZ7bsELlg15LgMXhFiHcQh
	ItjirLXU0tqgTm5PeSwli+QtlzVLgbVQ6cy11Q8wp4cpxweiXWs3kuCLwtnHrSf1dvmni9nDIkqAT
	buRZROF0gAZPhGTwh5zjfWnbYPQkOxrDBJOHeaNS7LbzOwBHdOOaq8gdddNxdMGIcCBoJykhuWPkN
	J2Ya1970MAQSPNNL2lCw6CkkN3zry84GfYctg31KX+7NycoMP6jPlPGUDxqiVzWggxfyQb8i1ENs9
	4ms03b3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdoC-00Gl0f-0b;
	Thu, 14 Dec 2023 04:58:52 +0000
Date: Wed, 13 Dec 2023 20:58:52 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: repair inode fork block mapping data structures
Message-ID: <ZXqLjCgzDGfJUNSH@infradead.org>
References: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
 <170250783972.1399452.4797704305570825362.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250783972.1399452.4797704305570825362.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 13, 2023 at 02:56:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use the reverse-mapping btree information to rebuild an inode block map.
> Update the btree bulk loading code as necessary to support inode rooted
> btrees and fix some bitrot problems.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
