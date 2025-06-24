Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9134293C48;
	Tue, 24 Jun 2025 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750771899; cv=none; b=bcifrydTGDnhhOpRT3WBSYA2CdiXV/k7kSNx2KqxqQ+0YAO+8xQSMaltvVPtTx2KgzH2x+U8uY5wCWZyrJflVG3GKhswSZJID9P12kuF+PeNCLpNqRQozrwtPZtiI3Rbx95XZe92fNLk0mpK8pdPGvEfVg5axzeSqhkYlQgVfTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750771899; c=relaxed/simple;
	bh=xErK2eH2IevQvw3kG6zcqm8PCAQ4sY1ntdBn3ZAatFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7WuQHD2Igyafn+X3leffJOD6ZzXgnDi0rW8uIR49JAkaHnwxwKx3ma8j+paxDQ/8NgBTpYh3YaB2nEvdyDZmEDbH9bqkH5xAH09q0ao7gMJemQA824K/hx7ZVMI1OB9iUwSrwz+rW1ByZIz6GBxroLWG/VicuM2eEJY+1mQHLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CF5368BFE; Tue, 24 Jun 2025 15:31:33 +0200 (CEST)
Date: Tue, 24 Jun 2025 15:31:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, miklos@szeredi.hu,
	brauner@kernel.org, djwong@kernel.org, anuj20.g@samsung.com,
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org, gfs2@lists.linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v3 00/16] fuse: use iomap for buffered writes +
 writeback
Message-ID: <20250624133132.GA23173@lst.de>
References: <20250624022135.832899-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624022135.832899-1-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 23, 2025 at 07:21:19PM -0700, Joanne Koong wrote:
> This patchset is composed of two parts:
> a) Christoph's iomap changes (patches 1 to 11) which are taken verbatim
>    from [1]
> b) fuse changes to use iomap (patches 12 to 16)
> 
> Please note the following:
> * this patchset version temporarily drops the CONFIG_BLOCK iomap refactoring
>   patches that will be needed to merge in the series. As of now, this breaks
>   compilation for environments where CONFIG_BLOCK is not set, but the
>   CONFIG_BLOCK iomap changes will be re-added back in once the core changes
>   in this patchset are ready to go.
> * this patchset does not enable large folios yet. That will be sent out in a
>   separate future patchset.

Cool, so the previous series works for fuse.  I'll try to find some
time this week to address the review comments and enable the
!CONFIG_BLOCK build.  It would be great if we could figure out a way to
kill of ->launder_folio for fuse in the meantime, but it looks like that
got stuck a bit.

