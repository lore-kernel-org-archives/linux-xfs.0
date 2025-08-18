Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F37263F43;
	Mon, 18 Aug 2025 04:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755492036; cv=none; b=rMOmdt136aqh0zd9oqzg+BY7N7cFyr9Qmy2QMWFX4EzrTEGeb72bn8+5MHQzellVbblpkcXKBx6LTApoKbSu1Nrj1FZRQjpe/dn+4WbDzfkTTRwO0y9CSGIfA1lmhCujhYHfw9WiQ3etm+djPnNoY3LKSpggO+FKF0Xmo83uokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755492036; c=relaxed/simple;
	bh=D/WeudU+4Va31j7z0jhQEFOUn9FhSoxqT121OJCXsL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDj1NSI5jFHjHAskQ9UH7RTz4jjY2S/bPn8/9n507SKZ07brpPvBhspvACaCmsjY5pXKAS15+uiF4flQ4W3z/F0bwE5syuuZ4Iu0dhFtcqNUcL36fei7NQ8mtKJtT7VgXN8eupJ8T17pw8IFvzJGtui8ntF1B5TFdpJ6QA2iziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a9BPeIaV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a9BPeIaV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D/WeudU+4Va31j7z0jhQEFOUn9FhSoxqT121OJCXsL8=; b=a9BPeIaV/Hny5Tj3i99Qic0LIa
	8wDC7iYXd/IGVEuNcobFkTiYTEZaXJ2VzA4dcBUwi662nTrwGFKMGDKq3ob850P3xcGaVL8J/EiY8
	NZP3RX05+HQqtlH96cB/bKfOGoDgOGGuQEtDy+60SdDoSHHozH9R3Zp/jUF+gvDqqJMJB/iX/RbGS
	mTNEXrSAEAsizWnZsmZJwBgXe+y0BzgLdxD4vQ7hGNqFLn9z3Cp1jHV70xCzPBN+N3u85Y8u3EuLV
	1OEOP/LS+lDDJXov+IiJMC+ECv2oKeJK6U7Ajp7nnj7PUqGjZaBGuoj0i4NkXm9FP4ssBOaRs3aj/
	2PZythDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unrfe-00000006U1L-2NjE;
	Mon, 18 Aug 2025 04:40:34 +0000
Date: Sun, 17 Aug 2025 21:40:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING in xfs_trans_alloc
Message-ID: <aKKuwolDhvbEtnOt@infradead.org>
References: <68a28720.050a0220.e29e5.0080.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a28720.050a0220.e29e5.0080.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This should be fixed by:

https://web.git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=647b3d59c768d7638dd17c78c8044178364383ca

which just went into mainline.

