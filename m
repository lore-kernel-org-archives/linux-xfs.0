Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F68483BC8;
	Mon,  5 Oct 2026 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206888; cv=none; b=splthkcPqAZxnMLv/DwT2I/b09T0wGSP3l/KWFI8XEU6UWYpuPwOqk4b6MJ1/GSz7zmgiiNta1IiE7sl50R8bNXwNORY4D3Yb0lv6r3EVxxdhp3nGyMHC6O3T8YpCdOMw+9HOQurxc8SAwB+hwQjjFFfexOcryjt6U0ARhVPUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206888; c=relaxed/simple;
	bh=j9zlFKy2dzNwQ+tv5v1cp1DRU7vWsmuKwlfc/Kq/ZcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubNYil5TsnTgTOxL28m6IhkODGYpoN3Gtf2IZ8HJ4ks+xZ0rEoHU5a5fKUirAF+uRMNo7idkchu2vSTlTfa8cXyhZoJln3XBaYn3I6OCH1wrXFKUEi0GMVMmEZD8La/1596VXxhSZ2dyxwl0QyvQ/WPe707L316U0zk4aTIvzow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E980F68C4E; Mon,  5 Oct 2026 15:27:54 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:27:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs/2307: test checksum handling using corrupted
 checksums
Message-ID: <20261005132754.GB29227@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-13-hch@lst.de> <20260929020509.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929020509.GP2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 07:05:09PM -0700, Darrick J. Wong wrote:
> Want to try something wild and less obvious like ... shrinking one of
> the extent maps so that there's a sparse hole in the rtcsum file?

Sure, if you provide the xfs_db magic to inject it :)

