Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00423B8BCC
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110969; cv=none; b=tnvva9/vFhyCGn/bxuJ9lFRdo4VEddyee9LzOXCCEQpEIkQR6xYCxSttP/MAHiirdowiM8tDZpyRNwzDxlmtZEAqjspjR0BfN8T9cAVfYVxZ6ErO11q+IyyOUAcOZ567wtYK3JxZT5LDLuHFMgPgXgxegP31KIWC5QOuUGCNPnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110969; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqeOj//e3ZvCtuwL8Ubbf+X0rP+LXT8Y0EHYVHMn9h+fyjRhmrAYGLFbUVkm2bZOsC4emKn//H64r4GvIb4lDK5IhCt894H8G5AylvJsi7wxHY1cNRqHhJYd49crc6Y5Nza24bA/5K7tm31xAIBAJ2dhuTeLcUuvT479wrvPo88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD4E368C7B; Fri, 11 Sep 2026 09:16:02 +0200 (CEST)
Date: Fri, 11 Sep 2026 09:16:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix integer overflows in xbitmap set functions
Message-ID: <20260911071602.GD16914@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162105.174887.5504947439003231517.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162105.174887.5504947439003231517.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

