Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62375E56A;
	Tue,  7 Apr 2026 05:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775540613; cv=none; b=b5bjBVKHRtsS4i4hW+6yHsaaeoHMJ1sUk2TrxovZg/oqQz4z9FM9IlEGUr6xi+JGyyz4nqohZ3w8P9JslX+cgAr+f6il3aFaNDT8zKQYP3rKSFhDFTfVRF+wlKs2l3Afypw47Y2NUFHnD6FNZO0EpU1xqltzaAA7zWp/8/r+Djg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775540613; c=relaxed/simple;
	bh=Kq9j99vlihk6BLvc+kL+dt1Kvh+X8pe7JMWWCQhMgZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y13tIXTCQJAWU2bRubXdnaTBz9fsLLkzbMHxNoolQe1GbwvpZT848cbn8NhvBJssajoYKpl26P/hQ01x9usJqRDr4wixISBidownBsjThTGa9kxvPqF+f9wZAhbdujCJ8H/soyp9LynKBxErX0z0whUMmknxnvonNnMO8EZeUWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TYU3ayYz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TYU3ayYz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x+42DFPZ8ULgrHQutIzRZwYEFns9pt8l/Mw1UAOJAmg=; b=TYU3ayYzEvIBrZW8cd3Dy/wxHL
	S4/mCLrIWigZ2hi/Q29Hgh+oZteURHm7V79KGQD4t6IhlRHH4NbUSnsUBGBmUZpM19A3tcW/UzDEc
	ElEd3YbqkMeBPIw5r9ZRMFVCMCYnqNNG9VoDMZr1ESPilwEC0rwFGFOmvs6tvYZNUrwNpp3XtkQr3
	r8vWBUchhsRvLxkobTA4cjsZ5h+3w64oC38hcdqrkH5vgiTZPGn2yNFMXJx2ki+QxyX7SbavEwjU7
	UtIPpUlYp4bjT16EAjLLu24xZJmj1ZaLvEWqaYk73kfUDkwoCuL9O9mvYSP+hXLKIXNdH9uqwXo7c
	yHsmET7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9zDm-00000005wMC-3Web;
	Tue, 07 Apr 2026 05:43:30 +0000
Date: Mon, 6 Apr 2026 22:43:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	cem@kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] xfs: reject CRC validation when the log header cannot be
 retrieved
Message-ID: <adSZggVszJXysLzM@infradead.org>
References: <69cebb99.050a0220.2dbe29.0007.GAE@google.com>
 <tencent_4D4CBF27D046DE52D3067D099C6EDDEECC06@qq.com>
 <adO_Rm7EN4vwWaYX@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adO_Rm7EN4vwWaYX@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 06, 2026 at 10:12:22AM -0400, Brian Foster wrote:
> Have you dug into how syzbot triggers this issue?

There is no syzbot reproducer yet.  Unfortunately the patch submitter
has a history of jumping on unverified syzbot reports and then
submitting speculative patches based on wrong conclusions.  I'd
recommend to ignore him when he does that, which means basically
always.  Hopefully we'll eventually get a syzbot reproducer and can
then do an actual analysis.

