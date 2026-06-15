Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02D3FFAC2;
	Mon, 15 Jun 2026 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535823; cv=none; b=TEUlBHZx0WffgNxOFQgRTaOkEv2aAtHEu1m0JleeiDweKRa1GcA+o8uelM1aez89CPXj3zueaG2aiKIZCUB1MfEqDqhZLS4RTxkIdKv7C5F+4DIYtDSJKEXDGeZDmwmAZtTITh5PiHjF1fA7nU57NSARm8W2XCym9foHkZKwBrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535823; c=relaxed/simple;
	bh=9vl4XCjHi3rfuzXAQF/1J97R8Imgp5Ocarqt6heTE6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrYISEruDATy3aFwNceF0c1cBTJ/mbuzvPj0MxgWnQNi7VcejB0tiFgLlLltv25Uf6Q7tpQJfrTcItRCgzdO15jT0dQ1okbvHAMo9QYsLHq+BuxvEkcwBvmSL7VGtYEH7x7hj+bvm2WKqPnFDs7+qg4qIs6g1hEEXLLvZYImU7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cap4q1lw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cap4q1lw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L7iD6SgJmlnfJzW46z0M6jHf7x7/EMkLMcl4CvDCtAw=; b=Cap4q1lwt40OXS+CE5tcS9gwKL
	TJ125kghquGVkxpoyJGcX6Cm7SIEP6uRH+czT2ZPdQ/+Hewb6Gkp9Fye8Wxd9TlTH+/sJx+ELfdpn
	0gNEKaClZ01HDCC24gQ5E/VoFze7xnprsG+kVuv24v1sMGg2fBxhj/6VD2v1W8kRQ9djQ6VA5Y6Hd
	IIXQoKkPcqWYLeYrkVy0ZWtAPaoOo3PSQQXzO8XHjtr/RP0R/ynaVpgKcNxVfK1scBx42fXHACmIy
	OET09jEEdCtOYt552KdcOrqxH+5B8PGhWu+HxVI1lx5hAzD7RU6bo/MEZXEbrW/LTJo/jmv+dkQht
	c5/G7NuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZ8qg-0000000ETR1-02F3;
	Mon, 15 Jun 2026 15:03:38 +0000
Date: Mon, 15 Jun 2026 08:03:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] block: revert the iov_iter after a short copy in
 bio_iov_iter_bounce_write()
Message-ID: <ajAUSUEZEcEviOb4@infradead.org>
References: <cover.1781253428.git.wqu@suse.com>
 <ed47077f3d4336b64a177486e74b4f6a460b2392.1781253428.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed47077f3d4336b64a177486e74b4f6a460b2392.1781253428.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 12, 2026 at 07:21:12PM +0930, Qu Wenruo wrote:
> +		copied = copy_from_iter(folio_address(folio), this_len, iter);
> +		if (copied < this_len) {
> +			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len + copied);

Please keep the line below 80 characters.  And maybe add the explanation
for the amount reverted here based on what you wrote above in the commit
log.

