Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942C0368D53
	for <linux-xfs@vger.kernel.org>; Wed, 13 May 2026 06:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778655457; cv=none; b=AG0CNSdwpXYeoFS4dhFVe9AqeFhIPUXLif7ORugqE1jfpZCiUkkh29AH67apb1Sh60LZRidiRy5w+O02X5KcVV4cfjpTGIXR3UeuiVqSYnowTnM9m4wBMNkn3JBj4zMdTKwq7LwLJrSqmsqqEfCtr8VoK2U9xsswdgEnJ7cy9TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778655457; c=relaxed/simple;
	bh=sMaVJNPvCK+xeKiir/MbXZq5Vg//ySudakXZS0uPGbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJKf++sqfaK8mbWMisiaXB5nr/+cEgBM6uWvdg2/d+4OMKZIwHFaxIumnzC05huK3a60fW/0v03E+gc/RxMhZho1Xi6NpIP/zcIrGhvrPpqnZWBAepOtSD57/KfmUH1XGJAxDgoHZBDvj+9aVk3mwoaYioWlo/5q5rTtB4BWujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C4B2E68B05; Wed, 13 May 2026 08:57:32 +0200 (CEST)
Date: Wed, 13 May 2026 08:57:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: return -ENOENT for unallocated inodes in
 xfs_imap_lookup
Message-ID: <20260513065732.GC2250@lst.de>
References: <20260513063745.8067-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513063745.8067-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 08:37:45AM +0200, Hans Holmberg wrote:
> as a non-fatal error, but returning -ENOENT from xfs_imap_lookup seems
> like the more right thing to do.
> 
> The check "that the returned record contains the required inode" in
> xfs_imap_lookup also returns -EINVAL and might be worth switching
> over to -ENOENT but I'm leaving that as is I did not hit that case
> in my testing.

I guess you already know my opinion, but I really prefer the consistent
-ENOENT return:

Reviewed-by: Christoph Hellwig <hch@lst.de>

