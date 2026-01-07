Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69923EABB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766849; cv=none; b=bEXCapjAnhETTvgnLKJBP4gDVILAD/ts/S57EUThVUOFn4OOe+ccUYAoiRZBheKdCKpvndNKQmi0ngspAZTdVPkvBfmMjevg5j637SHtlRZQz1WOFL022v8Ymd+V3u+md+JWjTgBpdmXsaA9fKCGZ73R3XIeHqGa6nUagRZ/8Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766849; c=relaxed/simple;
	bh=um8pD+dboAMc4+AohGbqpa7siSJ0rQywd6GHse1Eqdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FzMCXHRNSyCTMMQ601pZPEjsYBaIMXk+4n2z2EJNUxmoN6dNEMWfWo/Ebv0g3meEwsVy5WzhaYIGUWMgB8Li83p7xHD2ONDjqt9ziV2QkvxdLCfdXiNUFCxq+hNOgz/DS4Aw4nFDtwoMn43MsTqqhCDlG5JvsOETGJOc7gGzRCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D5F7227AA8; Wed,  7 Jan 2026 07:20:43 +0100 (CET)
Date: Wed, 7 Jan 2026 07:20:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 1/6] libxfs: add missing forward declaration in
 xfs_zones.h
Message-ID: <20260107062042.GA15430@lst.de>
References: <20251220025326.209196-1-dlemoal@kernel.org> <20251220025326.209196-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Dec 20, 2025 at 11:53:21AM +0900, Damien Le Moal wrote:
> Add the missing forward declaration for struct blk_zone in xfs_zones.h.
> This avoids headaches with the order of header file inclusion to avoid
> compilation errors.
> 
> Fixes: 48ccc2459039 ("xfs: parse and validate hardware zone information")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

This needs to go into the kernel first.  And yes, I can't blame new
contributors for not knowing what files are shared..

