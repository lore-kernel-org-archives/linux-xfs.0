Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OJO+b1q+"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514DAF5;
	Wed, 13 Dec 2023 20:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OJO+b1q+2Vtl8ugsxD9rgfe5Xw
	GyCbUAlC3f/stHjrELUxaxqeCKCDSCBMzL3PFTaN2Gt3VipJxrfMJJLWnKoMiSSHPSgwzBrI8K5cZ
	7LneMP8Vxoy/AWoqRros6tCvtdu/t72ibD5C9+iMuATig6Dj+mrYNmfmlPN7FuZ7ZazvUQGAZNnIc
	zztLpSQPUBdtigWl1eXwLCC+NFyjqz5LGN5uXnFGryrdCKaqGlYcxlWe6RmuxFK8rd9I6dM6YScyG
	RGU4uOrfMVgsKlFRP4qXDbAMH6gdDMCzVMC10RdxZKDnXP/CcMbgONEoiGjbwwh8cXQMYxYrcWuSW
	ViT9ZG1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdaL-00GjN1-27;
	Thu, 14 Dec 2023 04:44:33 +0000
Date: Wed, 13 Dec 2023 20:44:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] generic/410: don't blow away seqres.full during test
Message-ID: <ZXqIMc0CPHcxpXEi@infradead.org>
References: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
 <170250687956.1363584.15519840736150289118.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250687956.1363584.15519840736150289118.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
