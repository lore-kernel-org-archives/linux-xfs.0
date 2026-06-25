Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596263A1A23
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388831; cv=none; b=HZpkkEtC4c2b1v6xL9QWt2jIFGwSXw0EjYWZXvjlwD5IEzogB93aefWt2gAtlQhwKUBkAXndMi+yDr1N0z5ZqoNUm8oHcKE1pUZ8MTkmoEu0t2/l9gEMp7xw7+GZx9ffIb93vL9X3He2rvkS96abrWqC7stdXggFGJzz7iWsq2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388831; c=relaxed/simple;
	bh=PiFLnCDWzc+44qF1nGHRzgRlDmzzObjMXjrrbQoTNe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwSYOh+Sj1Yt/uREdQkLipfb+dP6s9wGHW2r2pZ8MKznK/o+a2O/bBbqfRspI8oZpp3Cl5ljtcQU+7IZGJ4XZIezfGeGHYY5k/K1Blmj2Ig5bmgJ2VngN4S+i3o+vk1wQYhfJr5W/uYP7tnn8aUvnt6Sg6GWe0b/krJDsF5as2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F23B268B05; Thu, 25 Jun 2026 14:00:27 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:00:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/11] xfs_scrub: report bad file ranges correctly
Message-ID: <20260625120027.GC18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484475.915780.7341195187302132752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484475.915780.7341195187302132752.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:15:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex complains that the "media error at data offset..." message prints
> the wrong information -- err_off is the offset into @map, not the file
> offset; and the length should be constrained by the end of @map.  Fix
> both of these issues.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

