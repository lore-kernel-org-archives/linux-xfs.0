Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C650727A462;
	Tue, 28 Jul 2026 03:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208473; cv=none; b=YSHDS4D1m+W66zyFNkMUYjfLkRmeCmuJ5GB7BspqOX744B/GuPaOj4UkEdjGtMYZok2UqKOSm1HmbsQJQjXd3xXq1AnAYfZoPDhtVDk2lHSCmoBzJNEc/YJmkSqWYBjrRrCHLj6yHbJoj9I1yFipOD76Z2oDFrJ1ev3lkVw1KRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208473; c=relaxed/simple;
	bh=LkgYUwNnDK3OQqXhdF4RlmW/O0lY7XbRf0eh0AYk1rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dN7mwX0/W1dbaxOJZllJfeD/qdc716aXNbkYL5+B8YzY2ocD+q+4+f5dfxX+pslqbFfsWGFWDqtdXFMIT4CnLnlqg04mvWAmkuD5m+O6SD9yqxvrswFjDK/6PQyieA1els50ttBAX+eBESreHQZZK43nyLgIWyTUU0j/YUyx8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rE04ODUT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rE04ODUT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ITjmaByDSFpGRuO5tLV/V96d9JNbxKNrENNKT2yj7Dc=; b=rE04ODUT1aP9AQbub9BsmNOQM2
	Qnr2EzT/OVuIoqksDaLb/pzhKZ+cpdWQFpW5fyRCU3bPysAx3+zSVxiSFt//y14SjTM2NyVwvaRu8
	DQSYDN4b2AabYXlMDmxB+Iyf2ZGdsP+jVw5AdgtudKlPqbB0+E4SaNpYOQsMoF7NlMZBIgvdX2mbA
	ruhdfrhHQQ86EE/E7vwcraCG8sUaIXFhishEdlz+e8fTQCkEL0YX5mRO6VMcdakkA+KNTs6zn0933
	+xCZeIbFlrK/+3toVR2rlCSMrHYP1VLE2NGpcDqF4FgvRbxJZKgTuZQHiejcCKehspLhYsnrlt5BB
	IALJz7rQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woYGw-00000004JRT-1Sby;
	Tue, 28 Jul 2026 03:14:26 +0000
Date: Mon, 27 Jul 2026 20:14:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	djwong@kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v2] xfs: fix exchange-range reflink flag clearing issue
 with  INO1_WRITTEN
Message-ID: <amgekiNKKoAdACnc@infradead.org>
References: <20260728022310.99955-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728022310.99955-1-jiapenglin@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 28, 2026 at 10:23:03AM +0800, Lin Jiapeng wrote:
> When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
> can move the reflink inode flag from the file that currently has it to
> the other file, as long as exactly one side is marked.  This assumes
> that the file contents, and therefore all shared extents, are exchanged.
> 
> That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
> xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
> from file1, so an exchange can complete without moving every mapping
> that the earlier flag-swap decision accounted for.  In that case the
> post-operation cleanup can clear the reflink flag from an inode that
> still owns shared written extents.  Later writes then take the
> non-reflink write path and may update blocks that should still have
> been protected by CoW, which shows up as data corruption between
> reflink-related files.
> 
> Fix this by disabling the reflink flag exchange whenever
> XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
> proceed; the conservative outcome is that both inodes keep the reflink
> flag.  The regular reflink flag cleanup path can drop the extra flag
> later once the inode no longer has shared extents.

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can you add a test case to fstests for this?

