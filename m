Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C7334F46F;
	Tue, 28 Jul 2026 06:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785218701; cv=none; b=bnxdl20ZyjRzIhyhomUBF/jC2YJfJqz8rK23IifAIOMqLZLo2RUYaMOnlgb9DDeinsCATGz8QjA2p1uDD8IORBlElC/n/bumVRzGi1FGSXJDuSEHcvAAo2gGQWSm66oNH/0NHP61Zacuyfsi5UgM1q//fhuxLLuc1QvVYW4OnpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785218701; c=relaxed/simple;
	bh=oEimWv8K1K3ln7WKrBGIEcOkiq5bPb/gvdtsNj1QNKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkWhpN89+cHspltFd0RHIG1etNnz5EregCnjq4fDpyPIGLt7/Cs/vt0RBpmVSU9zpLeWcfGUEVisT4qT3Tkg1VZbFpNJJWgt109iX8KDIl3FGptTcxd3SZWn4+SDXcGeQ9G53hw+KnXeesFx6X4v5meODujWmmt0x1WIvOxIe1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IbQOqAH0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IbQOqAH0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7U7NP830ZAVaCC/7rfjR2Me52NPJumwYpUxGKnNuLc=; b=IbQOqAH01OoYOUhngfuVxOYuhQ
	0wS0/vNKVcn+fw1uAMeRqigbbLAAFNWT2pfRLLt6J3qUcXWi91/biRxfibRDZskcN8+BKlReCimVm
	485tdq442YwNBTnJ6+76sSrst097jENlnXbo4zkh279CePG8DwhGSoQ4IQhs1341e0m/JFIMgTWLx
	KmA5PkB803aOf6p+53bJAjhhE82gJXXEAYfPllUFq+KWDt4vsRFlaLnoZpTdA5OmbIeW2XICJf6vo
	0totkO6WNfBphuJbd1ecG2myMQzVi9M74Aj4InGToSrjnAi7toFwg5OCbFj1FL3EOz47NXHNSVM+2
	9rdvqdvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woavw-00000004VKG-14qP;
	Tue, 28 Jul 2026 06:04:56 +0000
Date: Mon, 27 Jul 2026 23:04:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>, Christoph Hellwig <hch@infradead.org>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	djwong@kernel.org, David Sterba <dsterba@suse.com>,
	linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
Message-ID: <amhGiIsvNIni_VAE@infradead.org>
References: <20260724133328.1837318-1-neelx@suse.com>
 <amgfuk12imPN2XJe@infradead.org>
 <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
 <20260728054847.GB99797@sol>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728054847.GB99797@sol>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 27, 2026 at 10:48:47PM -0700, Eric Biggers wrote:
> Please keep sending out the tests along with the kernel patches.  But
> yes, they aren't for immediate merging and should be tagged with RFC,
> and the cover letter should mention that the kernel patches are pending.
> Thanks!

I think the split of the v1 vs v2 policy tests might actually be useful
as-is now, but I'll defer to you.

