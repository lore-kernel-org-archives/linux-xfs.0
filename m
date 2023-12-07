Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQi9yPFy"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE408D44
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iQi9yPFyF++TEgtSNhNPMr3WKH
	rd1+pLymryfusD/xVr7FA79VcsSqyENoqy5pUCu1DBc19pBUL8JTmrQNHU7eZcob+GrdwV2yjKywx
	o3ZnQZvHr1oBfrLeSuiq6hTztLsKdb94C74WnTkZ+7NpeZWTzN/NVe0/XY+tgnXzX/wa3TZRRabF3
	zMWPR0kPOmItccVRMio+PpRpH05klRl6iCz99rjOP4kHpgl0Ox6YnKEwsFoLWNL4KlvMDALWWIK06
	k3e2UsfSNtOqXUo3L2WVaAl0t45jFaX9JI6hMTpwW/wC5FgUD2GFFRcfPrKbhccTqW+TNkphXRsU3
	K0qagWUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uy-00Btfs-2l;
	Thu, 07 Dec 2023 05:27:24 +0000
Date: Wed, 6 Dec 2023 21:27:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <ZXFXvP+HliVX7qyu@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665241.1180191.959265790041993224.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665241.1180191.959265790041993224.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
