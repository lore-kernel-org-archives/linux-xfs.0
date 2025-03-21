Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0D1EE7DD
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 07:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742542524; cv=none; b=IUoHrQRvJXUmfXjzPlzmebSCrTCpboiCpT/8J9inVLl/d7wNhz9pGBdRjcTpRkOW+9/qtKf4DNiCC9b5ncMvzJrK8h8LjtRNDewpH+lyg0TYffZWbquWYbfo8xCfCAcINbhtnrtmFlFNDDxKLT8yayZFHziNYyuAZhV7mv30zTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742542524; c=relaxed/simple;
	bh=1Nih9z773hZu6SPujSVPr8umvpefvvstiXBZVz6vU5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZXZnER1gWHHTooI49Il8LNxIWmtBuGxtHtnko6ZNSTAK8GROhLNyOyLhc7OSCfnXqZhbpT8LEKaWWBd5TZiKXo9kuOGuE9Jr1ML/xUxBOWNp4hm9GuFwPioe6MEu44XYr//Lo6bCRABg3Uj3Tn7vCd4raDhgN00ZP12BpYrPh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kclZvMIV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kclZvMIV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CdBbht36Ea9aa3gaACqFNfOZM2/YF54uGRgou0gUsEQ=; b=kclZvMIVNW8vvO8alM2KELIeJ6
	Nh967RJlbXvBI7N3Jhrp5zlQE+S1Ungx5HCE6RPU6TvD9lfQxzovJ++f9/q2oDBj2+Qe214T4XpzN
	qwlxTPEgui7R6YLcy62xWF5kU6We/+yT4U5mgrgmlQStCUc4RN6vHoOxAJEBKfMhUByXk+8+guxUe
	ZA7a3ZQM66zO01gi8cZxd1KXth9slZlXVAhGCv4kB6dVEeHv4KnC7dr1mD1LpFtXIv53Qydhp0mm2
	SGtnGRblwdXQ0UgroqX071Wqo01YmLc0UKaN0jG71HZtZvTAWW6jG+sT9PswBRIO7YOjWXZzXZzVG
	5ZFoCWgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWuY-0000000E75Y-24ow;
	Fri, 21 Mar 2025 07:35:22 +0000
Date: Fri, 21 Mar 2025 00:35:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: bodonnel@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs_repair: handling a block with bad crc, bad uuid, and
 bad magic number needs fixing
Message-ID: <Z90WuvYsuAxQVjEW@infradead.org>
References: <20250320202518.644182-1-bodonnel@redhat.com>
 <2692c652-bb23-4a5f-be74-bbcea4a91827@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2692c652-bb23-4a5f-be74-bbcea4a91827@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 20, 2025 at 06:28:19PM -0500, Eric Sandeen wrote:
> > -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> > +		if (xfs_has_crc(mp))
> > +			wantmagic = XFS_DIR3_BLOCK_MAGIC;
> > +		else
> > +			wantmagic = XFS_DIR2_BLOCK_MAGIC;
> > +		if (wantmagic == XFS_DIR3_BLOCK_MAGIC) {
> 
> So I guess the prior 5 lines are equivalent to:
> 
> 		/* check v5 metadata */
> 		if (xfs_has_crc(mp)) {
> ...
> 
> and that will force it to check the header, below. And then I think we hit
> the goto out_fix; line, and it moves the contents of this directory to
> lost+found (at least on my custom repro image.)
> 
> Curious to see what others think is the right path through all this.

I'll need some time to actually understand the code, but replacing the
wantmagic logic with just doign the xfs_has_crc check looks right and
muche easier to follow.

