Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB1492E46;
	Thu,  8 Oct 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460881; cv=none; b=pg0GZTTvjzlmXgy8sLgYjtTcD+tnd2VduFfYR7QWMr/4Mi2ez+qAqjCTvftjZ7rfnsrZvcXeZYKzENUlF0UnG69Am08PrZQcEPOGA5RvZJNy37mI618GRySsrvdHJc+Iuut/1ZTDoAJVkx63Bta9ufIOfKRse1eCqql1wuJx1HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460881; c=relaxed/simple;
	bh=1kRhe84By5tg02tSU3qdrZIADzMmYCIv6hWoHEGF9EY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZRcwAGGllKK9xJFXOwulaHgx8lPfARykQ7/6z6AASFZujoy6b1fX43Qk9l2Dox5Iz9qNEM+4R4SFC3aMYV1x5IWp6TNxXQuR1ePnGKbhZT8gWWjNZMQPpZuHTNW6GKFPi0sneMnTV0OC0fXHhFUyG1PpA80QI1Rw9q9OpgQais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OC8ZHRw5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OC8ZHRw5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6gVNiPImhPu4i+P5lnfo/GV/gq7sAz8faE5mNDLa8T8=; b=OC8ZHRw5vyPHd3BZdR2lRTm2HQ
	n+Dukeele7jVUD2QnGoVulJnCsDzXTSvHpe1S3i14YjGMYeBIqUi+Co6x1Pc2fZydmunkWxOp+XlH
	fPoJEWYq6lYgz689XDTICdwFYk1BdF3w5EWkjVNXplhAwD5WOcatTfWqOVFpeg1CkVUnpGEa+h5t5
	RlQqShycha9IB8X757hPkO2IqydVhQ73ybheX/3vc9eNMDOjpyIRXfg4hV/gMnwAxX7aOzMeZjYhz
	zuepYcFX/ItygJiKUQvHMi4+y2tiirt1lORzorGieslypDXVPDvesNHzpU3reUqBaTYAUzy0i/OSD
	ilGHzA6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmoJ-00000004JRv-1Ij8;
	Thu, 08 Oct 2026 12:01:19 +0000
Date: Thu, 8 Oct 2026 05:01:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: range-check bc_levels array access in scrub
 tracepoints
Message-ID: <aseGD1l24pOP_gll@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521429.2728617.9805637853982654466.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521429.2728617.9805637853982654466.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:56:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed xchk_btree()'s odd habit of passing cur->bc_nlevels to
> xchk_btree_ptr_ok when we're checking the pointer to the root block at
> the start of the btree scan.  This enables us to skip checking the
> pointer for an inode btree's root (since it doesn't have one) but
> doesn't handle per-AG btrees quite correctly.  There isn't a problem for
> __xfs_btree_check_ptr itself, but the corruption tracepoint naively
> walks off the end of bc_level[].  Fix that by adding a helper to do an
> implicit range check.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

