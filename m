Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFC3280318;
	Thu, 10 Sep 2026 05:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016468; cv=none; b=FGnX7agWoyH39RlD7BvhA52EXGkc7/SSXWgLXy6imjVRlVe+271rblWvdwIaKOA6TC8xnvTH/7eYQX3Aou7sNediHPtCSUS+LUbVjhzuppwYcqwOjNbTQODvWPH+w9F4/ELQhoLNcWP9W97yPR2qtbcKPdUM0A3X67XwC7uGNZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016468; c=relaxed/simple;
	bh=YaqJY6y6ZR4EBtH/dUUMnfziOqMgatmDeQZ9njmGzzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFIm3VOaFrkp7vx10N9Qj4fTIbTSx1OaNahMfeCnGNlU2QDtvyTX0bLPjA57eQGrNt7l78BJb6dsHMFDjYJe25yecLCcv0xh0NMVLA0umBU9bSWSg52nP5kSlQjy7HVEsTDWr2Kq4Z9XSHvehUn2XWXtG7UiEz7y/aGvOVRHVVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9FD9D68BFE; Thu, 10 Sep 2026 07:01:02 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:01:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix rtrmap cross-referencing elision logic
Message-ID: <20260910050102.GC26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936685.4057962.15653638717743353287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936685.4057962.15653638717743353287.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 08, 2026 at 11:05:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xchk_bmap_xref_rmap_cow skips the cross-reference
> if the data-section rmapbt cursor is not present.  However, this is
> broken for realtime file data fork scanning, because they will have an
> rtrmapbt cursor and not an rmapbt cursor.  Fix the behavior by removing
> the cursor checks because xchk_bmap_get_rmap already accounts for that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

