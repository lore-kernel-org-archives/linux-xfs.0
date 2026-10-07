Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A6F46D566
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380482; cv=none; b=UNk4xY4voX5XX6S4YlRx79eYkjIsnXBCftuuFW1Ta5DNrtBIbcROvqCZ8LmkBUm9YrNLQwhYfXWSQsK2vXtHj8Vl8+vEY1nZxbf7CSeidqpNn2/RDcRTHUwsgBQFYsdvArXUk5q+Kv3jT2v+JQWQ/ifQDjOECWQD+EroZMLVKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380482; c=relaxed/simple;
	bh=LM4J3rjcG+JOMt8cLKDNk9lgWNR2h4ikUaylqa7CjG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0oHJD1kHEYIo/+6g8USkEz1WCSRXuB7UsXMKC0S21g9GbBXfvJh5Duu8PBZZFg5AjNkv0VzKl4Dr7Lm/fProMVXuKzGe9TL/ddGlXI1AMzfI22PkLou0ixUlaYQIEEDk5qwBCBR9JNH7ASLwDu5CPxEo6xOaiQNCHhvJRFnjRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 563B5227A88; Wed,  7 Oct 2026 15:41:05 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:41:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] libxfs: use xfs_trans.h from the kernel source
Message-ID: <20261007134105.GA507@lst.de>
References: <20261005125637.1340355-1-hch@lst.de> <20261005125637.1340355-13-hch@lst.de> <20261005214939.GR2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005214939.GR2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 05, 2026 at 02:49:39PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 05, 2026 at 02:56:22PM +0200, Christoph Hellwig wrote:
> > Replace the the existing xfs_trans.h with a copy of the kernel versions.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Much nicer to have the same header, though I wonder if we ought some day
> to move the kernel xfs_trans.h into libxfs/ ?

That's what the:

    small cleanups to help code sharing with xfsprogs

kernel series sent on Sep 25th does.  It got your reviews, so maybe it's
time to just merge it.

