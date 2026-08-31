Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E669846EF73
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184120; cv=none; b=ap4PqlPGyEeXF3wTpXHW+Hyp4vXuCHbTtOm76m7C7wgb54g9fScFRKxJD8tC2irmogAIisFk2NsFAChQMP9aNycVeYEKuSOvp2oTAdcVG2/kZ4w5oxzT4z13Jjyga4QRMiUXjq0w4jm4LejTuWaG7Frl4zmwksD7XrlJhNYBT8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184120; c=relaxed/simple;
	bh=u7GZ86y4LKEsbzGubw9FjKTsFVojgBtFlVTyHBRg5o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryFcsfZfK12Uq9a/UgnGQxRlEwl4X/IlsR9LtVsl2an/11EbnJAqJue99azZ9sPvslZgIwKC7WRZ/p/1YkzpS+yuNapnvqrhsGLLetvhnH/D4lwzBzDSmzM2Gm+KotT2CLeVln1dTuBL+0IzzTYmPxmMdm/07ubJlCzE0aNfgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qgi3D7yw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qgi3D7yw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PGNy0Cgn4PI61E+4k9UbbvQo6jNGeesg7aJcAPRRp4w=; b=Qgi3D7ywXgAk6QEkGLJUwla/44
	eShpRGbEipdnQZfLS+Xr+/8eeU3uArnmleuwiJlS4ORcAoal2c1KfKHSO6mSBDFlY+5A9mDcNlQQx
	eWzFyS/gU1wD/7qXUVmWV4yhK7O9JJo8bRC4Z8oHGjyRiVS4FZVQrjIW1voisgNBXYk3+pT28W8Cu
	2mijclN+UNX31Xot75fEBT2cM5tkHReCc422Z2g8XKOti5rE2f5VQmT7BuKroHhqK7OWOxtcV24TR
	HrbhNx2T1FQpfaxM1HVMt0Jby2ap0BlJU+u9O6G0f0A/Zcc8UFZdBsqaGnV8RTwhCtvNhDGGHhFMs
	PWEPq2fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12NJ-00000009X0U-0uXI;
	Mon, 31 Aug 2026 13:48:37 +0000
Date: Mon, 31 Aug 2026 06:48:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_repair: add -R to replay a dirty log before
 repairing
Message-ID: <apWGNXp61yD9CM7_@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <ac7ec2c4f9f0a64d2994dd21fd4d620942b2c745.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7ec2c4f9f0a64d2994dd21fd4d620942b2c745.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 26, 2026 at 10:25:44PM -0700, Chris Wedgwood wrote:
> lost+found.  Replay is refused on zoned filesystems, where freeing a
> realtime extent needs the zone allocator rather than a metadata update.

Huh?  This sentence makes grammatical sense, but already fails at the
semantic level.  Deleting zoned RT extents goes through exactly the
same metadata updates for the bmap and rmap tree, but instead of
updating the allocation btrees it just updates a counter in the
rmap inodes.  So it requires a very similar, but smaller metadata
update.

