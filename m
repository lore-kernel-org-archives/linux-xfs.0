Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88B42D73B6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 06:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770360736; cv=none; b=nuG3kyHm1CUQhm/28vdGZkA5q0OvBt2seH7rWh0+87qcev483+FotNbT8g3KvaLJSNSgqEPUTGonz0nqveXoWIptPESBi7CZEwXRLKGrwmBaxTz311pl2wgP/zgDWG0+qme9GOBc2+Win3QndsuyFkRiIu5XPrdblNLGbqc1PYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770360736; c=relaxed/simple;
	bh=qW2GqSSksn7CPduMlITTJ4plq4VE80nQh+eW2OOe4ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTq5HQBF2mqyU10K01C/44twkUbtUrnVdTZYBLypxvh4kWQbIjOmYLQ+sDtN345Xe3ppMjfh/m2ox1fLz9nppyOYCxwlh8yNJXqzPKjGZ/bkC43GYcatr+u1TdO+ZZMMWwHbau5CckNXB5KLmkmyK1NXhln6dpsOMRMfi4uciJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 414D068D0E; Fri,  6 Feb 2026 07:52:13 +0100 (CET)
Date: Fri, 6 Feb 2026 07:52:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260206065213.GA26772@lst.de>
References: <20260202141502.378973-1-hch@lst.de> <20260202141502.378973-3-hch@lst.de> <20260206064342.GX7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206064342.GX7712@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 05, 2026 at 10:43:42PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok to me, though I wonder slightly about the atomicity of the
> percpu counter inc/decrements.  But it's been that way for a long time
> so

It's not atomic, but the percpu summing is by definition never fully
atomic anyway.  So it might add a bit more of error margin than the
pure summing, but it removes the much larger error margin of having the
metadir inodes accounted in the first place.

