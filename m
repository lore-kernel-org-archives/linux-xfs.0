Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191878;
	b=vNG08YmXoB9mzibXGLvemrlhcw08c8VOG7Xel7ghZEPpfM61EEz//uk9cQv9djwgXLGZ
	 0Q2KLknfU9t5VwMZ7NfflgUuSkOspDX76Ke3UNaM16w+4BuHDtC/ZL9EQb15dZS2I0qog
	 8duGtPq0AlsvdMLQZwpr6RIv6itYxYKjO1mdf27nL8kOPT7ENQHMje3TfW5sNsUgGDAKX
	 iB944xYkEuW5myqwhUTaPi5ZmkOXPh0B4M8Mie0N5QrSKFiCdMkZVRDiq1gKlf7p5NxSx
	 +U94GTclJT2jT0XTtcqQ7RErA3FSA2+Fd9kgmVpOxPs/ckJlvHdayoQPiQSj0ARDEXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191878;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=uSgRzooWOEmqd5/DTLNzENLKgDWTPQQQifi1iVejMuY=;
	b=XggnCRjI3FqrjHjSVhkKKa4CgASRrIDgIyfFjOQBZxTgugePHf91nOy9aOil1JDJM5QN
	 /n/0v3FTDG2E1Q1raMAceqFCJiYOKmPH4KfuTk5l2OUIF7Owzsd83Wo9w+a+KlWaDoQj/
	 mIsjOvpwsfK4fiGGmaGaxqtadINcW0YW42H7lPgTb/IPoKG55oG4jgKC4mDhgsY9cRms4
	 Dnl4XtLh/+jrBDz2a3sqwqEM+gf163q+jCFO3TUhhNC3JfXHTT+Nz36BjUMoUIhKFgMt6
	 TFWUkmrfbCneqNMy0ntVplOsH6hu7SgngRvWhNddlM98asC3kIJgi2QLV3V+YFd/kUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mzq9xopm;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3F0606A330;
	Fri, 20 Nov 2026 16:24:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF3F0606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=mzq9xopm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uSgRzooWOEmqd5/DTLNzENLKgDWTPQQQifi1iVejMuY=; b=mzq9xopmMML85eMYVGtHh/BSu/
	NPK9swukjrGk5twYPSiLxE9l3BS57cYOq0UXcdX1Ehblo4jLcozzfpLHcUNB4HUqApeBIcRgjnufF
	VZRwdx4Kw2G9kEnGUHhHzfObn6hXBKBDgkxtP3ofxD5QAqFTgD5yb/xFdF1i2ginyhtnFxfIZiY/Q
	M2EOns+2TQZzR0mOaDpFVvPgcAalZ1ldBQGPL/vb9fMwwPyaS5kJ1DRUBDlaE0iXqme5IU4E+MM2Y
	fo0guCrGWhcQCsx3ohuvC5Inybzg3P/cCIyzZuIs1Z6ciNbiuxK0HX8uSFReWrlCkeIH3CS9qwR+9
	362rbg+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURPg-0000000FYPz-0qrd;
	Fri, 20 Nov 2026 16:24:36 +0000
Date: Fri, 20 Nov 2026 08:24:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Qing Zhang <diasyzhangqing@gmail.com>, viro@zeniv.linux.org.uk,
	jack@suse.cz, raven@themaw.net, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH] namei: revalidate the symlink dentry before invoking
 get_link in RCU-walk
Message-ID: <awB0RE6WN_v4YBbn@infradead.org>
References: <20261118083945.1449264-1-diasyzhang@tencent.com>
 <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 20, 2026 at 02:59:42PM +0100, Christian Brauner wrote:
> This only makes the window smaller.
> 
> XFS can still reinitialize the inode right after this check and while
> get() is running. Then ->get_link() operates on an inode that is being
> reset underneath it. And the !get check only catches the case where the
> that re-init already finished before we loaded ->get_link.
> 
> RCU pathwalk relies on inode memory not being reused before a grace
> period has passed. XFS itself frees inodes via call_rcu() but the
> recycle path hands the same struct inode out again without waiting for
> existing RCU walkers.
> 
> So that should be fixed in XFS, either by not recycling an inode in
> place while RCU walkers can still see it or by keeping i_op and the link
> state valid across a recycle.

Not recycling the inode really isn't an option, as that means there
would cause duplicate inodes in the xfs inode cache.  Keeping i_op and
state in place sounds a bit more feasibly, but could be iffy as well.

The best thing would be to find a way to keep the inode alive at the VFS
level when XFS marks it reclaimable.  That would be a huge an invasive
change, but it would solve this and many other problems as well.

A good reproducer for the issue would help either way.
