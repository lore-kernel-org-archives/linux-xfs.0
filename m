Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3075D4EE86D
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183644; cv=none; b=ogz8R3t0x22VZ3j5Nk+NjCSe9jxxsEyGXefta7RUVW/JdLVRJRPdPYKziJBRkDLfUtZnrJK9T12hDhS1aDE2FC+POaOE10eMS0VLWuXxH4Q3hffESBu5l85kqsw3NVQtboqvzFqR8McrdOK1KCtAf/vQeMy58Rb3omUi7Zq2Peo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183644; c=relaxed/simple;
	bh=UkHjJljoqiZMBqd+YSP9Az4fe9qsI9dr4rHiTx5AHsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFM2edD0mnBCOSVpbkiMG7t/KE+jhala0NoRrqSKoCX2B37y5xrYYMo2IxVhCNi+7Xl6UYLKJB1XF5AZPEY6ogR8tjgLY2rn7ds66kqd45kQleMa73gWRgznDrR+C87yxJO1ZTAJlt2c67RjPdSO15xndZGjSVx0GLLCEYQAIg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ySo0aqgq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ySo0aqgq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UkHjJljoqiZMBqd+YSP9Az4fe9qsI9dr4rHiTx5AHsM=; b=ySo0aqgqbbEH8xxI7ZMNOcMnql
	Kzp5qwj3JjSRzFyk838N6Ilx3EAcgN2LWLqqnmtvc09uIO5TRCJoYeq/XdS1M5963M3IxvytycG1b
	4oioQpCFethSWLZcnxNdgOYJcrSSY7eUoZKtS3C/mvMrMvlfns3B+RLsqAn7lV2v0aG9zkzy49hHJ
	DSuBVNtwmv7iWR2TD0S5t3JjcDsbA8oRWw0h8Bd0Qayzw89mLTEVs0+J1olfG0u1P8UoO3RsLrjv9
	1CP5CL/hwoVHnWiRiy4uB13f7X71t7Fp1N8MIRDKMGgmmFGrWZFkfdkprKTpThDjXEfFlfKMtDX9h
	myKMFUVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12Fc-00000009TDr-1aim;
	Mon, 31 Aug 2026 13:40:41 +0000
Date: Mon, 31 Aug 2026 06:40:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] libxfs-diff: also compare libxlog against the kernel
Message-ID: <apWEWJyhaEQc62fK@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <7e3d4d82541b0a7520a19d062fc0043e345066ca.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3d4d82541b0a7520a19d062fc0043e345066ca.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 26, 2026 at 10:08:13PM -0700, Chris Wedgwood wrote:
> libxfs/ mirrors the kernel's fs/xfs/libxfs/, and the tool checks that.
> libxlog/ carries files taken from the top level of fs/xfs, and nothing
> checked those, so a divergence there was invisible.

Yeah, I recently ran into that as well recently.

> State the second mapping explicitly rather than searching for a matching
> name, so each directory has one declared kernel counterpart.

What I wonder then is why we don't actually have this code in libxfs.
I didn't get to investigate if there is a good reason for that, but
if we could move the files to libxfs life would be much easier.

