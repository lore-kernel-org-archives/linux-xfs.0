Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1898F46AEFA
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330241; cv=none; b=MgZZl73/0HDuoYMNfg4yJ/S4RoQ8QNaIUBuRmPiv+i+1BlLPP9QF7QziP7onJThZCHVrIYvinNnbIfUrM9ukR8LZlDq2L//9UlU35CBA7EWAYOuOi0eRoiz+k3/mulaInNCZUcgoeswiepDNDzQlQWvlP+J6TxeWSp9NqaI9vzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330241; c=relaxed/simple;
	bh=uSVQWQUwNXTSegHSllzQ6EBrE9CLbruegzsHERHdBr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnXWjZGiNYX8JfRYX+++SMAzPbrkxsPmqQNSHHl++SUcF9PeEjFKpC6udLSsLzibswECv+AJ2D76/Cg4tVXbZk38KODZFPqcJp3pY+Kf56kL5/w/TS6eSqt+W2luZBtfnW1K5Ab8QDtH6kWmxM9bK4YBZzphuKFh3sq1hWdiGGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9841C68BFE; Wed, 29 Jul 2026 15:03:54 +0200 (CEST)
Date: Wed, 29 Jul 2026 15:03:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs ioctl handler cleanups
Message-ID: <20260729130354.GA6236@lst.de>
References: <20260729113952.2255638-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729113952.2255638-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Sorry, sending this got interrupted.  The full version has been sent
out now separately.

