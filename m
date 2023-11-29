Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yM2TqBfh"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFA518E
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 22:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vcnvnwIhHdKUXfiUsARsoxwlBX0GL/PgdkT3Mbs5KA8=; b=yM2TqBfhTfkNWIm1J6LcOFgchF
	MMOHZnAS6NRGLcNBKocOMNlEbieENZjUMFxetY3sACxwGR5e3fkJoCg086ndsHKB+17cxQjt6/0rc
	BZvt6VJn1MHYdMqIxV2xhXyVo5pVBsY0ud8C7TXQJaO6pQIttNpYj4yJAaRC2eZK/TEIM7y3g4gIQ
	4S/kCjnwhDGymPqED+ScduLnZxgz2Y4KjUmYtAFcTaPLijP/qrXTPD3SsvKKtUZQwhqkcWdBXpp8f
	WlKyee+nJCg7HYML/jOoVr15N8YXuxqEWrhdVFA1SOGrk76Tf47o8VOVyi7rfhaJ6r0jO06CHuddP
	mnCls4EQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8Dz3-007DWU-2E;
	Wed, 29 Nov 2023 06:23:41 +0000
Date: Tue, 28 Nov 2023 22:23:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <ZWbY7a2ZB8LE0Prh@infradead.org>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
 <20231128233008.GF4167244@frogsfrogsfrogs>
 <ZWbUvcVIBROrHVOh@infradead.org>
 <20231129062155.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129062155.GC361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 10:21:55PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 28, 2023 at 10:05:49PM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 28, 2023 at 03:30:09PM -0800, Darrick J. Wong wrote:
> > > LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
> > > I guess I'll go sort out what's going on there...
> > 
> > I think we should just reject rt device size < rtextsize configs in
> > the kernel and all tools.
> 
> "But that could break old weirdass customer filesystems."
> 
> The design of rtgroups prohibits that, so we're ok going forward.

Well, as you just said it hasn't mounted for a long time, and really
this is a corner case that just doesn't make any sense.  I'd really
prefer to cleanly reject it, and if someone really complains with a good
reason we can revisit the decisions.  But I strongly doubt it's ever
going to happen.
