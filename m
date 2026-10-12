Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D52374E41;
	Mon, 12 Oct 2026 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810491; cv=none; b=Y+NdJekXVQV28YM1+Ojy0o6JMBMy0LeLSygdZGZz9tlRyyP+PL+JtMoTWyPfYl5/5fEruqtHL0PgcVITPaxWIHKiMDtbRKn8TNTiUVBBF+WVFS1iVBZFlzmN971iq4/8rSWWB/I7Ap7Q/t9z/+PpxphnCsdVXDviPLiuEwuy3JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810491; c=relaxed/simple;
	bh=FmzIMJGfW17g2+29HVKyIR1XwPtEuTM2C3OT4Uwko0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tETtI4Qyf/UKGKORl6MpTuqboaGY+Zj6qzqxulqMmH1OOUEt6dv2JwGf8oHDB3Lp911VqTclsHdWiIz+ITgKiWFZvYgO6lTxIWy6ikV+Ldqe7pqjTYl93PgTC3nju2Vh8zoDjBKNWDo0rpu0KRJ+yT2cPUvnz48eypEZ5+wGuoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TTKhbKjF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TTKhbKjF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XQuz+LzFnDypsxPA0f2zq1Jy7CxmgE9IphfM0lLKYc0=; b=TTKhbKjF1vLDgh/4eUWp9Z5QMO
	f43QedblkCvJmuucBTpLexec6tB/Tf5S6rij7/SmZ+NwnxgZ8cSgvumNW8OoXHROms4SLbjl9LKDa
	R4aGhZB8zlJqy9UgiNBZsmjsXTQl01HCYZ5PtcxEBoAEndOCJ6WNGqRw64gl8GpstfXwytQw4yJzM
	/XfUE80MRCIyCNYTCWOL4BS5Z4XXbR6YWi07ZMMbiAb1r5d1avOhVFsw+C+TZN345mvtNn1iuexOy
	r5RQd1hxurb68dY5hRj/US7pK778M7egUIzamHiD5VFvQQkHmJCjMYAga8iONhh59Rh9e6R07/pu+
	442Di7Ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFlB-0000000AX1s-227V;
	Mon, 12 Oct 2026 13:08:09 +0000
Date: Mon, 12 Oct 2026 06:08:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reduce new btree slack factor if free space
 is negative
Message-ID: <aszbuYSyUzTIrlJi@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065281.1058326.11344648618549479599.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065281.1058326.11344648618549479599.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:56:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that if the incore fdblocks counter is negative, the
> assignment to uint64_t will mask this possibly low space situation and
> we don't pack the btree blocks as tightly as we probably ought to.  If
> it's the case that there's some free space and fdblocks is too low due
> to an error in the superblock field, then we can end up failing btree
> rebuilds due to ENOSPC unnecessarily.  This is a corner case, but let's
> fix it anyway.

Should thi simply use xfs_sum_freecounter instead of
xfs_sum_freecounter_raw as the former takes care of the issue
in the more "normal" way?

