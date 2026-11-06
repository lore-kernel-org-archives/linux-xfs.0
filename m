Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978406;
	b=Ow/DD6zbJ+OWY9wM1qvu+k1ZJCA2njERi/K1wcV+9pp+j54+9E9qm2NcLqabn/yYsTjk
	 QXoOCyVSwwWVxHqOhtJ0KJzNHyfYSY1jtSRuiCj3dOJWJvqeyUBz7uQyCFzdxLx7DsAK8
	 CrOiT5CBB6zOYk+VpVA90gh1nKXh6Y2dmgxq6itMr4AU1gB0fOJt4U2ua7hexytvizAWm
	 txjoF2IkLlAlvsH+ytl/pO6+VvCnl1qh9R4eeEUkLKKkvC0uxvWYGEXq4XaH8Zwr7nD9w
	 rt+0ZxsZEjUnlEFEKMgprZwUXaDiZwY2Agk1NOZDRwFnFiXNRSdmpq4zHD9foCwp76Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978406;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=JlkehWuvNeAqUDDm0lW60pJ1rm2Tezb4uxm9g5ZPK2Y=;
	b=xLdpzsD5Uqea/HNT4PhMc90Y7BYOSSNxltARc2M3TmMKNzeskIWXGYxk7s9ygM5VAUP4
	 Wciaf6OeV60PLJ5IPbY7ZVbxuyEZtizfhk6BLVwI1V9OGtPXqhL6vOEh84LzCTzK8THKL
	 vpK3nPaLe8M2nUnkC6rdJ3c8p0lstsXCG9KmJMzBKEDjvQxAK8J/EiU7c/IlCbirFmusF
	 IKQ9/AMScB1KunDDLxbiQpCSc4RZH+ccICzeNdiDie7t8tmC3z6r9NzI9YBCn7fMggqKI
	 1Zf2K7IvfTKpI6E4SxZiNxagLy4pRSseYnn4jeFPtFCt5E6/w8dyMhmqNainYDJ+bEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NleT4fbb;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4990606D82E;
	Fri,  6 Nov 2026 15:20:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4990606D82E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NleT4fbb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JlkehWuvNeAqUDDm0lW60pJ1rm2Tezb4uxm9g5ZPK2Y=; b=NleT4fbbVCJtudoFYZQqx17+Kf
	qd8Dc4Tc5df3T/fufqZLn3arNky3pqfHKNX4gU1542rMqcTSbnhgjtItY9/iKDq8gu8urp2Ld+uiZ
	SHK2ntWU681pUotk4L9ieyug3skM46z9FEVeDJI/aHEyd4CEvF6Slyc4Itx9vasM2g9klOjqRhJpR
	A/pQKubHyqxD/KMMQod7PRSePZ4sKRjLjFnmok19kaackjreaOgt0cOl6+H8XIZY0DnqRoqMdoF5g
	4YkQDM5x4jDU8rdyCu0A+O1NVDr+n9g8yXmtEWPI+X7/mmiQxl0LOvhKL8PkJwrm5Sh4/0iVspOpY
	Hb5ns+9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xPLjY-0000000Cnlc-0PHR;
	Fri, 06 Nov 2026 15:20:04 +0000
Date: Fri, 6 Nov 2026 07:20:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lauri Gates <lauri.gates@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <au3wJNbRPXQZG5Op@infradead.org>
References: <auudz7Iwm2MrNA-b@dread>
 <20261106122355.16885-1-lauri.gates@gmail.com>
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
In-Reply-To: <20261106122355.16885-1-lauri.gates@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 06, 2026 at 02:23:55PM +0200, Lauri Gates wrote:
> Mirroring XFS_DIFLAG2_REFLINK, the flag would mean "may have shared
> extents", which is all a du tool needs to decide whether to look
> closer. If it helps, I can write the patch.

Please do.  The main question are:

 - do we want it in fileattr_get or as a STATX_ATTR_ in statx.
 - how do we make the query reliable, and do we even need to?

Besides xfs, btrfs and ocfs2 also support reflinks, and nfs (and maybe
cifs?) can export the semanics remotely.  So we really need a way
to indicate if the file system could support reflinks to start with,
and then one that the file could, so we probably need two bits

