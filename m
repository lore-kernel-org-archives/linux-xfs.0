Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BkKtbZMg"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF63E1B5
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 06:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BkKtbZMgUwjwLy/GOORv9Pt8Ff
	8Kh3OFBB/IMdrnRv+CTjbXLNRvI17iJ8EQibwijgE0a9z9INKFmhIMlmjg4o1NjV5lFbDURJmU94p
	juDbO7pa7s6u8O1sFuuhKFSUFl4RjQRHyPaLKEohY8jmHdN3jLkzFGLx7/iN2VOYbYr+Jnjy7z9Ga
	9dKneUR704v8Avy1Hw7aeBQ5mzdFjCMYaAa/0SwxmL6wXHcrWHy1LElIOOYX0v5iMKuMONEf09mZE
	E/RjdRGBPEEPqJoG9eH7kkLwDtDxK+pBItCFC1EExRqncTrtDOjuepCifuEP9AHmPepaxCctFxRoH
	9er6vGdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7yiw-005RSy-2M;
	Tue, 28 Nov 2023 14:06:02 +0000
Date: Tue, 28 Nov 2023 06:06:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: always check the rtbitmap and rtsummary files
Message-ID: <ZWXzyqwq9O4Szwri@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928392.2771542.12213973195389304948.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086928392.2771542.12213973195389304948.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
