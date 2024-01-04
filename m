Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C601EB41
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YJaonhT6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Plfo1t/SiY79DBAZ8SrrfuyzLyRLFGw8hTYYMPBeQx0=; b=YJaonhT6BiSSEiNa/zmbb4L48P
	8Ma/EvaXkSmLe1NJivQIQiNkRXvOvfwp3lWWxnTkAW7p9rPacC2bOiP1SCWtsd2bW+i1JJmMWCMU5
	+8bqIyXAFQtoYRWoP+dr/7EAMUdo/iQnrqG1puR6NbjtzSAcNCKKN8Y0vJMsjudOAr/6XtdtfxJrm
	RVz1amnLyM7NT7s0wIPxpZpzNf/GrPryhELmOJZ2AGk1Ylx1QprRzEgqTaIPbCspGAcv6QvVQotYQ
	FDmxS81oT+HmolPalMwBxUHqQqMTuGyj/yJi7NPCBcAUUaCrbkzvAcTlRFYcuA05hPK67fXX5rh/4
	rhNjzJbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLIKc-00D6XA-2g;
	Thu, 04 Jan 2024 07:39:58 +0000
Date: Wed, 3 Jan 2024 23:39:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfile: implement write caching
Message-ID: <ZZZgzneOKn/trcUX@infradead.org>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
 <ZZUfVVJSkvDRHZsp@infradead.org>
 <20240104013356.GP361584@frogsfrogsfrogs>
 <ZZZOMiqT8MoKhba7@infradead.org>
 <20240104072050.GA361584@frogsfrogsfrogs>
 <ZZZeFU9784rD5XsD@infradead.org>
 <20240104073412.GF361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104073412.GF361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:34:12PM -0800, Darrick J. Wong wrote:
> Ok, I'll do that.  Were you planning to send that first series to
> Chandan for 6.8?

If you're fine with that and I get reviews from Hugh for the small shmem
bits I'd like to get it included ASAP.

