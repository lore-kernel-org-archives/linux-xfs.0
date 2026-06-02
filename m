Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3367B3A7F62
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381935; cv=none; b=WVJeMp7GJKXsobwfwhDW+NoBR+Rca4VV2UazlTE57YSWFe/YbrejSgXoZP2+P8Wv+Y4t7OvPOBESIYr8kI52jYU365FeEo0T02jl+kp8sXJHUongur1wzHysppS7pk0/QD5Zkew0IRWbl2a8/ne/QhxJkyLE4vfXA8n6eclfgVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381935; c=relaxed/simple;
	bh=U3lJk+TzosxuLr7ZoUMrggljeJLJlYussMtZo3ItoNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u88ejyQB+gc4ICs4cxRFRaSY+BfPSg7F4aqzMiiuC0qDdA0FmMluOvMwDk2POx9McxDddEgvJ5imU+VYpZTusiOQrdwSRFqu616QSMMsZEPNwAc88O5/eoTR6y4wbx4vXbAezFVdVBQ06UTNkf1W0ilbd74NtxTZXUCMwBs3slY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE0E268BFE; Tue,  2 Jun 2026 08:32:11 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:32:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/7] xfs_healer: initialize variable here
Message-ID: <20260602063210.GC2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627098.588879.13826546294889049395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627098.588879.13826546294889049395.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:58:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Initialize the event prefix to zeroes so that we don't read bogus stack
> data if the filesystem doesn't support parent pointers.  Found by Codex.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

