Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A122D4F6;
	Tue,  7 Oct 2025 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759819512; cv=none; b=a4M8DnMuvuYd4iCALt9OpCgsCR71VNJQhQntVCoHTQAG/m+cWjzVPiJcyJBH7nGNxVsxzqcqCAxDC0xfe/DXWV9FDtCu6b/+dF+tsDBcM4x72nDEleXc3fBqoVjWnqiOum5FzVVJNYaGKHROjCaaRQb5VKkqfVYD7R85rPgs/XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759819512; c=relaxed/simple;
	bh=Dg+fDc//iqXx6roS8o/mrUIgVewGTijV6CKFwUoWnnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obbkC56YqM/rvuA4KsHqaTmn/Z1Z1NnFHD3JKKjRUKV8gDdQpvlPEzn14gY5jIu8Ea5NprzbLvT2iI50pCcZe/Dj2aNs42EEUQiAaFv14JSAVQ+/FLsiHsObpJMxkDx1oNyCJNii3Un+ARNjBUhShe0jWR7d+zDwUiknCHHKFqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D75C67373; Tue,  7 Oct 2025 08:44:59 +0200 (CEST)
Date: Tue, 7 Oct 2025 08:44:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	kernel test robot <oliver.sang@intel.com>,
	Dave Chinner <dchinner@redhat.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-xfs@vger.kernel.org
Subject: Re: [linus:master] [xfs]  c91d38b57f:  stress-ng.chown.ops_per_sec
 70.2% improvement
Message-ID: <20251007064458.GA19763@lst.de>
References: <202510020917.2ead7cfe-lkp@intel.com> <20251003075615.GA13238@lst.de> <aOJckY5NnB2MaOqj@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOJckY5NnB2MaOqj@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Oct 05, 2025 at 10:54:57PM +1100, Dave Chinner wrote:
> stress-ng puts a fsync() at the end of every ops loop:

Ok, with that the numbers make sense.  Thanks for digging into it.

