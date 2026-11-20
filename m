Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192581;
	b=2PczHZXhtI5IPeDeKrf3bMJsDSf01FVJbGx0xJe28rdpvkKr363P+4w+4zusN5adFRsl
	 1RPo6iKOMa19QkTteAZLyvktypW/JQeTKHPNMLpDBuI7NT0EYtWZlAqllqtzfxUMACGZn
	 hzexms9r+B7nJ6noeQ1QsfpG0IGNvH9e1/OZ4Y9J+2+tcaVGr3/I1eCgvV2G3N5fLycbN
	 alcSTTqQT1+QLALoZ7QRzCGBBQ9yop1XCLDlB3iJPH604LIymabTkCyvRCqfAyOx/b9QV
	 86z5dlCf/2rPLE2alW47LYk6G6RxlHUbEigbsXGu/ZIu+PudpyOR8lCSBNNxL+LpACA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192581;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=bEP/gW3yKUPJ7sT8MRFDMVTJdPAh/U5Vm3rkc09QDNU=;
	b=CnyROLFY6KCvNmH/AHIJO/K+5IepKIzAd789x56c1heeqVjqpfShbqmzHPExTkYs5eol
	 9ThhhP1ZSClnc4ajxAOTU6uVa8VmS0ie9/Tm004AFzanerBBfFvEVmreIIgFF7mtgHzyB
	 ex2b5eJBnVMnqBqzuX9dQgrtwS7MMz5IW+wZ+8zOG61qFvF6em8qpSfr76MSIt3NyhP2c
	 /RpNLSE7ZLbqfpzn5Uwg6Nmx7dZCp+dubfN8WDJuemOwHkm9yaGrPjppJdlAygfq4r84K
	 Gznfb0WyCflvPPW/RWLeBFb3UQ9bG+8chjBoieupmpq624vzhe9N6c4nGzMFNqnYWeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XnHMA8MB;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444460A2601
	for <linux-xfs@vger.kernel.org>; Fri, 20 Nov 2026 16:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7444460A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=XnHMA8MB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bEP/gW3yKUPJ7sT8MRFDMVTJdPAh/U5Vm3rkc09QDNU=; b=XnHMA8MBe058NQrrqynbyoFRav
	gZ0+yIUZXcI1MAT5c7RRbuTqv9ToEJVFz5QHVEvrU5jDlTFSQbEdDXUeG5mE/ObIjKv+G+AvgKLZT
	3fIKYJUD8kN8TZK53dAYNc/V3c+149BSncACabIU0lE3WOEiFlDP0xY8kNxVDEjqllzWL9lLSsNgH
	BYpTfLwrrCqWdvf0s9B9GOAOkc+D8JjHQGGUZ8Y1Chv1YVcI967nW4VPTUsAnrBgua8ujVbaJqQKx
	TkrgVIFUCscLBnWvc6rZBRgeu0tYrQzHdQ1FvJIi7E4qeWkmyR3I6sGWhSJpK/CAr5jquoY8DPXqD
	RQoFOW/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xURb2-0000000FZSf-3laU;
	Fri, 20 Nov 2026 16:36:21 +0000
Date: Fri, 20 Nov 2026 08:36:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 07/59] xfs: update the rt geometry when recovering a
 superblock change
Message-ID: <awB3BHsu97cNiCki@infradead.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
 <20261116231707.3625263-8-dgc@kernel.org>
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
In-Reply-To: <20261116231707.3625263-8-dgc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 17, 2026 at 10:14:24AM +1100, Dave Chinner wrote:
> Recovering a growfs can change the realtime geometry. Adding the first
> realtime volume can change the realtime extent size. It also brings the rt
> rmap and rt refcount btrees into use. Changing the data device size changes
> the height those btrees can reach. Superblock recovery does not update the
> realtime geometry, the mount features or the realtime btree maximum heights.
> 
> The rest of recovery then runs with the old geometry. New rtgroups are set up
> with the wrong layout. Valid realtime btree blocks can fail verification and
> abort recovery. A realtime device needs to be defined to recover realtime
> metadata. Abort superblock recovery if it adds a realtime volume but no device
> exists.

Do you have a testcase for this?  I'd hate to add all this code without
actually being exercise as that introduces the chance of even more
issues due to untested code.

Otherwise this does look sane.

