Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B254B0CAA
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381018; cv=none; b=dhTZrMBg8BfECEeojhnVty/O8SHnlAwebNpgl/pFVPajy/9grpyvhFegPcwNNPjHUlZewUPzgg9GoqQeTH1ne+/OdCAJtJdNUIPKcFU/ULCt9iT16YxAr8xrtKfdLBIXjH+cl975Sm6/6foxhJ4Ye0Mk3XNHJWEOIeFFdsUZqkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381018; c=relaxed/simple;
	bh=/QYFCq5qnT/HrzLt9bREbPeTSO+Hhd/r6/0XDfNcFGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0dOYtAl0KdMhLC3vtehkC0ZZylyheuabnSovUoYkAVEczVc+zFE8Qfe2Div80L0KRIgKSqP6vok7Qw+llI/iqy7CD9mpykMiKdSBEPtM/eA2HeHgDK53dqBI9MNzZMdqzOxcM829c1N5TmIYRNuL8Jo06mbgfkkxHE1gm3MQHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HcHrs45b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HcHrs45b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/QYFCq5qnT/HrzLt9bREbPeTSO+Hhd/r6/0XDfNcFGw=; b=HcHrs45bnGs8wigQ7DayIGdYEJ
	KKBF1rRvoH3JZyWtOLQrHZzwcmsSjGUkIqu0Vw1QBIWXtDnZhHaROqnyBGCNKk2Kdk64KvNDl4N7a
	yTPnxMUXeF8ComEK2zHtO9RFwFD2ePqGa8Aw6PWJqewO+tNOWsIyYnoZtPsjSUyT48ZDO4aE9uV4s
	WEIUoAgt1+yJuCUq1dPSFBsNE28xHtK6Px/am8T0OiaUN26yb0VixqjKOqzvpxHL8Awi/YkY24xif
	O5AS18JgJNIw2AZEbW2DsliHh+XYQ1RjQJ5JWoHbpzd1k5Wa0N1acLDiG1kP0FJ8otuKY3tVkYhe/
	G3a3yH0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xES22-00000002Yrz-15nN;
	Wed, 07 Oct 2026 13:50:06 +0000
Date: Wed, 7 Oct 2026 06:50:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH 1/3] xfs: factor out xfs_dir2_sf_copy_entries helper
Message-ID: <asZODrYQ7gix9p9z@infradead.org>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002211038.2139655-2-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 02, 2026 at 04:08:09PM -0500, Eric Sandeen wrote:
> xfs_dir2_sf_toino8 and xfs_dir2_sf_toino64 share a dozen or so lines
> of copied code used to move short form directory entries; factor that
> out to eliminate cut and paste.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
