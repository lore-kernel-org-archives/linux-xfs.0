Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83D12AAE8
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714047461; cv=none; b=hgUMVjih1/cxTYsz8maE5/vmQ7Vi3XUQohNoODIdOd7tdeoy8lWhwi/uiiGehAPVuQ7x9oBtttk/EcaFYqo4BIPTfrTQeZE1TNkgM6s5wVkfVTYwrrxw1V/9f1uzdnqFW/3Fq6rq6/B2tnTpXXvwAkBT9SmWxvTRsmDHDmw+Jw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714047461; c=relaxed/simple;
	bh=WG00edXhzUVXFGR+qShUoaqEAtfFPMqHWSRWBlSN7P8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RE4kDtw7qwywtJ0NlPNSk0ZC9p3JrDj8vrrFCUutJ1LN7kYJ+InUtcnWHZIVkf1DgyuUmIQ7VwtHEj78AruP+NWZduWRv5vOyA8VsxFW/k6P74+1EAtqnpA11/UxF6G0NM29OWNN9giTvUoYg4GYbV1jNCU1fomgQ520sZrUT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ce2vmXmQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ce2vmXmQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6WMJdISSG72prTQLmmugdqFKpiwpqa/2tH+s2IGzlDw=; b=ce2vmXmQneqszUdNSv7jcH9rjO
	dZoBoio3ihaMjYMAxYcich1ecA5AfpzbUvXosGhmBpV9i4OXqQ54LaAe/9s24/zL4sbdWPpoEQlnz
	IuzWTHG3Df4ao/h7Lg/Wtik1y14Db2TCILpfBB1ZoRZGsTa+jpD1xu5umSprik2ehKdTTtlNrp5JL
	LMuY1IwXKhMncnQhRV4lXEr1STYW0iBrms2wo8EPGv/xUPuhfbtsi6ri37m7ad07z0nZxPgIyVm1G
	JJmeRGlvkoiJ+MzteVbKZ2svE7C2NC0+N69IZzPbDQ62deG8BuKbDYDshVxLxw700xiz+drxpczsi
	f9KPHVmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rzy2i-00000008BFd-0qVe;
	Thu, 25 Apr 2024 12:17:36 +0000
Date: Thu, 25 Apr 2024 05:17:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Message-ID: <ZipJ4P7QDK9dZlyn@infradead.org>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425120846.707829-2-john.g.garry@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 25, 2024 at 12:08:45PM +0000, John Garry wrote:
> +	struct xfs_inobt_rec_incore __maybe_unused	*irec;

I've never seen code where __maybe_unused is the right answer, and this
is no exception.

Just remove this instance of irec, which also removes the variable
shadowing by the one inside the loop below.

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 730c8d48da2827..86f14ec7c31fed 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -351,7 +351,6 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_inobt_rec_incore	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
 
@@ -361,8 +360,8 @@ xfs_iwalk_run_callbacks(
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(iwag->tp, curpp, agi_bpp, 0);
-	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= iwag->recs[iwag->nr_recs - 1].ir_startino +
+			XFS_INODES_PER_CHUNK);
 
 	if (iwag->drop_trans) {
 		xfs_trans_cancel(iwag->tp);
