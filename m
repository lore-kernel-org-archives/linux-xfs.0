Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C792580EE;
	Wed, 15 Apr 2026 06:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233671; cv=none; b=H/yEGJYxfJpPBZ0Jvq5GP64mxR0/tDNBAyYAV/Tr3pmVgWCEqlLaz+vfFzIYjlkHS9kLx/JUiJ2qEWXJYQGdqqg7NRfNZjQ2c2BksvyFKp8o3kgmqyFuKEXy04+lPeS3XK8E3Tx4e3aclsZxOdg08lGNARIiGb3WjVBCTYhIhXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233671; c=relaxed/simple;
	bh=JyZxADwNDYtuDAi592cm6iOOnMnsZ3l1mZuR48oDh/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/uzVoPAHGfe+FVa/uv0dleOLF8Cy7hIwiKc4Z9fIVtvixNMmhbZzDV0sU7lGZOIBFJY/pNE/Bdvsb27inCvGqjgRQalgMm23ZjSjvbD9Tvu7pV1y7lv6avIvkY7XoEr+mXz/PpMxJU4Wg2tJm+G3lIqJRPkVGlsGXgN2OpZrHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 67D4B68BFE; Wed, 15 Apr 2026 08:14:23 +0200 (CEST)
Date: Wed, 15 Apr 2026 08:14:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Message-ID: <20260415061423.GA27588@lst.de>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 09, 2026 at 12:15:42AM +0530, Ojaswin Mujoo wrote:
> @@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
>   *
>   * This incoherency between the folio's dirty flag and xarray tag is
>   * unfortunate, but it only exists while the folio is locked.
> + *
> + * For some cases we might not want to do mkclean, eg, if we've already taken
> + * care of it, hence pass the should_mkclean flag to indicate if its needed.
>   */

The kerneldoc should move down to the exported version. 

