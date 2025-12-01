Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D73A2749C9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 06:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570234; cv=none; b=QLN/J4erOuZlI6LirJTmwit/YfMTicR3zk46K4MXLdoQSRffwHP99rQ4i5ChCOCXOQ+vNKz84Mo4qWDkpDL1+LggZavGwd7DJ3dyQhbz8M9NZ5PFUItMnZ6O+lLb0U9fXk/9HO9qHaJCvH/it9qitEUwx9cul61mnJJJ+9FH/8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570234; c=relaxed/simple;
	bh=3TUFhcArbRJLW4ivXGSMAsnR15WcuUOI55kLmQI/Ssc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chJKy4CCnb1zR3hUjHA8Pzi2f+85jxXr4ZWdTuQcKN+WIEYY9hjLnnQ8xj7+gWm9OaRXzeiMkBwr30YyhqAQG4ivf3ubtDNBMvZjlf566yMNXtq8f89izW804Yl7Y/bvWuL0cxVgrV87XoaJu8oDyZLnAXIZjXJQA6u/hP+3Q2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5396368AA6; Mon,  1 Dec 2025 07:23:50 +0100 (CET)
Date: Mon, 1 Dec 2025 07:23:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: enhance process_dinode_metafile
Message-ID: <20251201062349.GC19310@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <FocUxB56pg--lstcef8fdjrK3tXU6Zpiq7PPbxOAEXYZ8ffiPGJUVWzjDosLu2WcNrdFBQKwUHSfbfrsunWl1A==@protonmail.internalid> <20251128063719.1495736-5-hch@lst.de> <e5ldi3iunbxl4buq7v6cotylxfd22uhdq2lf2pldyrm55b2ou3@7sq2uv5u7v2o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ldi3iunbxl4buq7v6cotylxfd22uhdq2lf2pldyrm55b2ou3@7sq2uv5u7v2o>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 28, 2025 at 09:15:34AM +0100, Carlos Maiolino wrote:
> 		Perhaps worth adding an assertion to catch a pre-metadir
> 		reaching here for whatever reason and zapping RT
> 		bitmap and summary?

inodes with the metafile flag on non-metadir file systems are caught
by the inode buffer verifier.

