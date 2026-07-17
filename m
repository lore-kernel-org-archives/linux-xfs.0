Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FD23B9D8B;
	Fri, 17 Jul 2026 08:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277093; cv=none; b=K3pzTPsstRMUB2xCbGOzwZIAdWqtPM0pL7Il/KcGYGnpkszg7YrK/Vyy99WevGGDTnjdKqbPIe9+jonFlQ2f1V1IvMJeln1QdJKNGzP3Kc1fQDl7KN/iQNfd2fKpdZrIwFVuLw1X+eiB7G3MaTJH/+Ym5HQFu695b9ZOSr/o168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277093; c=relaxed/simple;
	bh=qwHVZtzU7KtRAeDihajyacI1svuoSoUS/pG8mI7qZQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7usspys7pFGXOPX3c+xA0Epiqa0Nwup8QquPufetnSpfLA+VJAQeenfCK+LIKrmPY6VqJ3QPIBs56BMwHgjf82IE01ozkysIkr99uY6c6jFY8Tvqyfc3xYR0KIR8yTmO6HSuDpgiQVytWdnIB+s0t07n7F+j4EsR7ednp89LOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A95AB68D09; Fri, 17 Jul 2026 10:31:21 +0200 (CEST)
Date: Fri, 17 Jul 2026 10:31:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260717083120.GA30021@lst.de>
References: <20260629125229.3400726-1-hch@lst.de> <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner> <20260707050433.GA12963@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707050433.GA12963@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 07:04:33AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 30, 2026 at 12:59:38PM +0200, Christian Brauner wrote:
> > On Mon, 29 Jun 2026 14:52:29 +0200, Christoph Hellwig wrote:
> > > iomap: add a separate bio_set for iomap_split_ioend
> > 
> > Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.3.iomap branch should appear in linux-next soon.
> 
> Any chance you could propagates this to vfs.fixes?

Ping again.
