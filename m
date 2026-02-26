Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD853033F1;
	Thu, 26 Feb 2026 21:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772141380; cv=none; b=Jc2pH+3ATpDxYkcUJx4S7gVCrbfPrTU1KYfH547HMFvvUz2DVlADKiCmuKtq6qhWi361hi+LNRgn+ZLdPLyi/1SBGixzdP/+dHNUm6/rcIu8ly2VU7uDUgt2mMzPBkbtfJA28K2+HmmeVNgRyox26KfIRW5xvMjz8tu2xjIbgdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772141380; c=relaxed/simple;
	bh=9ckRV+OLR/aOo6gVvy0Wg955dcXglzxjZo5NmWMIgzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qm311OxLUb9bF/VhZ8yDOdLZz/CFHI4O6UOc2WR79wa/xF1+OBrhFwz2YajXPvt441eSQcUyaGWiFAIixmCqOAawpnWlYnoryrXEFp54BlRFEfE5chnZDYvMQqrkT27EaO5LnU+ZXp0vLoum/jCBsNyvxxYh7/HKi575lhPXGAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DOT5KqM8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DOT5KqM8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YAzETrMWpNv8Il3AKKoxjA2qqKJfEZVApbLAMoBg+Lo=; b=DOT5KqM8Gj/GhV9O0o7vnh0rWL
	LTZ2LrU6G2igVMVqAv4wX48ge/w41kNndcjc2KS0Q8l0x5Y0rVXfMvre+UHTTkf2d2sk66550O6jf
	/Ti3w9ZzQA7l86Y26F4IPZf/oLSsP3CIyaDGQzl46nL/Qb858dgqXbPhyLuOcurNf2UGZCv6GdKcA
	E813dNWG1+eA6WMerN91xUT/pUWaCWgInKEhEDzq0zETTSqsDsNoUl4rLNG38wG9q+/7++c6R562a
	+tKAe7AdmZYyRuICjr7BeLKfVhzr/6bohEgh9A44VYqtkVj6/i3963YVJBZi6K1X11Pof3iTCxmQL
	MxA3Ia2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvivR-00000007FVc-2Abj;
	Thu, 26 Feb 2026 21:29:37 +0000
Date: Thu, 26 Feb 2026 13:29:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] iomap: reject delalloc mappings during writeback
Message-ID: <aaC7QX9slCI3jN7l@infradead.org>
References: <20260226180058.GF13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226180058.GF13853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 26, 2026 at 10:00:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filesystems should never provide a delayed allocation mapping to
> writeback; they're supposed to allocate the space before replying.
> This can lead to weird IO errors and crashes in the block layer if the
> filesystem is being malicious, or if it hadn't set iomap->dev because
> it's a delalloc mapping.
> 
> Fix this by failing writeback on delalloc mappings.  Currently no
> filesystems actually misbehave in this manner, but we ought to be
> stricter about things like that.

Maybe switch to to explicitly listing the acceptable types and rejecting
the rest instead?

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index e4d57cb969f1..2dd49677905f 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -169,17 +169,18 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
 
 	switch (wpc->iomap.type) {
-	case IOMAP_INLINE:
-		WARN_ON_ONCE(1);
-		return -EIO;
+	case IOMAP_UNWRITTEN:
+		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
+		fallthrough;
+	case IOMAP_MAPPED:
+		break;
 	case IOMAP_HOLE:
 		return map_len;
 	default:
-		break;
+		WARN_ON_ONCE(1);
+		return -EIO;
 	}
 
-	if (wpc->iomap.type == IOMAP_UNWRITTEN)
-		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
 	if (folio_test_dropbehind(folio))
