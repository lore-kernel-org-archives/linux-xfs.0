Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495B13B7BE
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712805953; cv=none; b=WKD09SB/VNzYEwp1B/aYkFfSuJ/JdW/HCayZKbisf2dTK02rqCD/lB49I0DPG/LkCsQkO0RvXo1Kgt0Xj0hay7sPiTK0hfhViMNDcUjDqxLUnlT9369MaNNrHOsuMYaq2+X/ndzVx15fDmONa9EZ+I6iiZOZpn/VeU3CVtxc1PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712805953; c=relaxed/simple;
	bh=VJFFV3kxNxYo/bjlKwSyihQ4sJfjkqjjRrIbTJqQQwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ra2l3pvMglfAcc3EciZkvx22QIe1oitLAwIHP8c/a8Wig6ZuZWTwRmaqkUx3f75FnKHPPbhfl905c1g/YG2aYMZyV+txOTKygg4F+3dC9W7CT5Ao+UkOj1vSANr/1LdJtgCp0W+G82dHySvT2P2myYfztmPD/CWe8W72AQfO3aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=drTArDxf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="drTArDxf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WFOV4yA4diyfliVijGFuMmVMbxvlkV/LFvk8kaWIfgM=; b=drTArDxf2YYEv5N66uiC6w6pSi
	jRZUT7ljQfh9w7dyPgK34COSZ0VYEpi4w1R80O5ytaaCtsTDC4k750h1R1kWMZlmXNXn99/mo/wc3
	l4Tc8Sg2MU4/lqMF1+AVIMnoiVwYdB0Cfpk6MCLsTCoUTacCzJXWovmE2AwsvzRnXz6+7BVnhe3Jh
	hzQGDQpCQ2SfG7QKXdWqday0g+3F6XXqYaSQH2CABMfRGJpePYgx7JE8haW9Lqo9R/BVEqNrvtMlM
	4F7/IVz7KIypeCZrdbe+N6ZU7+KcKXCYCTmdzrFLGptltfOaVd3lmV6AiN9GJfWqCfL1r4gyd8ch/
	KSg+dYMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rul4Q-0000000A92E-2TEv;
	Thu, 11 Apr 2024 03:25:50 +0000
Date: Wed, 10 Apr 2024 20:25:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/32] xfs: add parent pointer validator functions
Message-ID: <ZhdYPonmpK-Ck9zK@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969790.3631889.2339349798519269452.stgit@frogsfrogsfrogs>
 <ZhYkHh2TUmhPPdaw@infradead.org>
 <20240410185312.GY6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410185312.GY6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 11:53:12AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 09, 2024 at 10:31:10PM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 09, 2024 at 05:57:09PM -0700, Darrick J. Wong wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > Attribute names of parent pointers are not strings.
> > 
> > They are now.  The rest of the commit log also doesn't match the code
> > anymore.  The code itself looks good, though.
> 
> How about this, then:

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

