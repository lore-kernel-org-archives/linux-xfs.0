Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UPtVyAoo"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0DF110
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 22:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ddecu0jNmt0iaz52H2+Mj22ldshdlfHfO4cFfgAgz5o=; b=UPtVyAooA/1gnyP++t0z6Adt45
	vvhKNpQ2aL5bojOhcmVGM6CntoQ9EHoCyXcr1zieAtTkLMDMavmDGTWFzZ5dFnVcHEE+D2whV08fb
	Q+1AYF8u4zAMM7Ngol2pGT2HoDKZadtsVMJj5Pb+cQzQlUD1WKmI4VtieRfVbCaICVm+V1BA2MlsQ
	ANmFyaindadKhhwfGH0VDWO24VQ4VJmpmWPxzgAolNd0aPkDfVXG1rAG7g7i1TL+3TU4i5Vfuevr9
	JmpvRBjjoMFAM7n7/XOl7AT/GU1X1RC3VJMVcFy9LfdjPdMyc5pARAD56tbx3R9aib9c4bDrcdcxh
	uAFwvi8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7RV-00Bwg6-1V;
	Thu, 07 Dec 2023 06:01:01 +0000
Date: Wed, 6 Dec 2023 22:01:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: zap broken inode forks
Message-ID: <ZXFfnaaPBBjTEW4S@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666188.1182270.114932269965181078.stgit@frogsfrogsfrogs>
 <ZXFfeW715AvqptIq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFfeW715AvqptIq@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 10:00:25PM -0800, Christoph Hellwig wrote:
> Looks good, although as mentioned on the next patch having the health
> flag first would seem better.

And I guess this means:

Reviewed-by: Christoph Hellwig <hch@lst.de>
