Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B528194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902314; cv=none; b=ZePL+OvA9FVjMwNPhOZjBvrTf+08t80FnK/3LlMTsp1TgcrBC1rwB6Ton85J0fmcJcFRc4W5DfOSXsV9cOZZ5femzLUfoyHnS0PZ6GqodtEGAnZgutRf9SKIGb5P5HE5Ae7rhj/7ehLlQ1eUyRnR6aeU/sqnnyUA2qEzGTLYGUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902314; c=relaxed/simple;
	bh=QXd0Hbavrzqlng8LIe3MnAZuU4CqfTjh247IU7zvBvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFC9a5hK5oIduf1I2hduebtu4G+TiVGxCe295lcZxqyvFh/a5Xg1kz67UmCOJqN9nFXXKqY8HNvdmEIpD3rcK/8qdruEJ5I8ixVIgr4QuxeNl1xWphXqcU7VtzDeLF07vkKXonx+JgXuQYysgNQ4AUWHKV+OSLVDmJsXvzm2HtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE79068C4E; Fri,  7 Feb 2025 05:25:09 +0100 (CET)
Date: Fri, 7 Feb 2025 05:25:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: export zone stats in /proc/*/mountstats
Message-ID: <20250207042509.GH5467@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-42-hch@lst.de> <20250207010224.GF21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207010224.GF21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 05:02:24PM -0800, Darrick J. Wong wrote:
> I'm kinda surprised you didn't export this via sysfs, but then
> remembered that Greg has strict rules against tabular data and whatnot.
> 
> > This gives good insight into data fragmentation and data placement
> > success rate.
> 
> I hope it's worth exporting a bunch of stringly-structured data. ;)
> 
> Past me would've asked if we could just export some json and let
> userspace pick that up, but today me learned about the horrors of json
> and how it represents integers, stumbling over trailing commas, etc.

Yeah, this is really mostly used for human debugging at the moment.

> Is any of this getting wired up into a zone-top tool?

Heh, for that we'd actually need to commit to a stable format.  But
it does sound interesting.  Combine with information from fsmap for
the persistent space usage on disk.
