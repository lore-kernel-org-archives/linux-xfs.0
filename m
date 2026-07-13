Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238664252CB;
	Mon, 13 Jul 2026 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949324; cv=none; b=powC0Ra7bVU4x7GGaCftvztfRcR8QOWtm1mEu5scsSdZafk5Ri0CxXJA1qeKY2fdlcNVhvB8/B/9OtUV0LY+2QWpSVZEHL5UpdBdzBr1FeMXo6OyZQX3UNa9vqsiRr7JfOleqofga57JTa3wbewmtXe+3GE2i5a2J479B+MsYWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949324; c=relaxed/simple;
	bh=uhRlB6VHuwSZa3/lNVCqNPJIh60YCKv36/hOkbecbl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjjp7mNh2egoWgPyWOUANE4biGVa8w9JxTzl+3V0bgppHGEn4USEbU9EyLNLS6QsOmr/O3SJc+qVp/ShY4tj0dn14IZ7+6bINwDPp9r0b3egaZzTu+YeOiFM8YjeSn6Vgj/DwC1FL8IXMlyQCJTyZUzym5litwT/eM93AzNMrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E7cUGVrU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E7cUGVrU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2ElgFSqCDKo/YlY7HXgzTLHmuYFu++0ngFU0qaSYCGQ=; b=E7cUGVrUVRbFAupI7nUjixDuTU
	Vct7AgAjwtxLfxBGHG14ak610O2Y7sM8e0N/TsDuQO/eUZhQFdjWlyOs3XLIsZCWqi6XJ3regraJZ
	hL6mwKhmjhxAJA7IppiClPut0Bm7wC3ZxbyyeHDsFK8mgdnt84xAoOjdQRjal2j5AGk1j/zaLTVz/
	JFWBtR0JEzD8nz4sNvVaxphCebYmeWVLWSVwa/NAEkmCnGbYE6CIDDlEIwgmnccptQOO5nKwdyrmh
	/hmKZcMGzo27UggXiZPQO8B4BEsXOv5sOfqBdAk+btgWessPudkjkEYzEP20oCY57XA+3aIY/dmV/
	Z+rkQKOw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjGi6-00000009PDO-30Hn;
	Mon, 13 Jul 2026 13:28:38 +0000
Date: Mon, 13 Jul 2026 06:28:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <alToBmAN_HyeXth9@infradead.org>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> 
> 
> On 7/13/26 17:09, Christoph Hellwig wrote:
> > 
> > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > 
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > >         * duplicate transaction that gets returned.
> > >         */
> > >        error = __xfs_trans_commit(tp, true);
> > > +
> > > +     tp = *tpp;
> > > +     /*
> > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > +      * xfs_trans_free.  Set it again here before doing memory
> > > +      * allocations.
> > > +      */
> > > +     xfs_trans_set_context(tp);
> > 
> > The tp assignment above now returns the incorrect transaction when
> > __xfs_trans_commit fails, so you can't do this.
> > 
> > Otherwise yes, this call should move up.  I don't really see how
> > it fixes the syzbot report, though.
> > 
> 
> Thank you very much for your reply. The tp here is a local variable only
> used for convenience within the function. The caller always gets the new
> transaction through *tpp, which was set by xfs_trans_dup() before the commit
> call. Moving tp = *tpp before the error check doesn't change what the caller
> sees - *tpp still points to the new (dup'd) transaction regardless.

Ah, right.  Tis should be fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

