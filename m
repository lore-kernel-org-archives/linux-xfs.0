Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5775714EC73
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740532826; cv=none; b=lFo1Dk+CyFAoOvSmF1lpy1pZ9+QNJnEmKHvPDCtCb1cgbG4z0aCbgzO73aS8KAmQIRyxTJweD+S/q1xmbGIIKly4c78F/kJn3uZQBST9Wx5KXEpHUlFxyg2ylT0pwtNl3QQRfwalxVdybY9l1q7gNbTvJli51SMz9Pr3fi3i6pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740532826; c=relaxed/simple;
	bh=2TOAyo7GnVjxsrtguI+lpqp5ZelF71Y8+d6SB+aHbOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bl+QOTyRYYReMhAg9+d+ceggWJBfSrr8MyJrH+Iso8YjLYNNkbh1bnreK6GtusFNAiaCKP6D5hZPu7ZO1gQB9QzF+nTD7cE8JNBmCUV9LFBDDih82oYoko2J7V5MRJy2SX9R5j6Btrk8C7phzeFzTLrmuHJIZn0wM6tzdZOTnRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8B47868AFE; Wed, 26 Feb 2025 02:20:20 +0100 (CET)
Date: Wed, 26 Feb 2025 02:20:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/45] xfs: support reserved blocks for the rt extent
 counter
Message-ID: <20250226012020.GA27642@lst.de>
References: <20250218081153.3889537-1-hch@lst.de> <20250218081153.3889537-4-hch@lst.de> <20250225180556.GI6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225180556.GI6242@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 25, 2025 at 10:05:56AM -0800, Darrick J. Wong wrote:
> Because otherwise we can end up "restoring" 8192 extents into
> XC_FREE_RTEXTENTS even though we don't actually have reserved free
> rtextents yet.  I /think/ this fixes the frextents accounting errors
> that I saw while trying to bisect to figure out the fdblocks accounting
> errors.

I've instead squashed the two patches together and given Hans a
co-developed credit for it.

