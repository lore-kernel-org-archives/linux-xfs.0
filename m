Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0942A9D
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721065415; cv=none; b=Gdiioel0XbQ+WITGwDFAVlBQC9V4q09aN2+wo+siWK+zlnGH9iIWfLBRKaMuUIBbsBUorasbc1eeNmzkUZAXOayQfjvGuhrxbmvv8RVDNqDid1Co2gXgrgR644oX1lKQjJDT6db1+gC0VJOoUmspEXsPwkDJeR7QZ/GOwU74YAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721065415; c=relaxed/simple;
	bh=QvGoTkGsQNYWl2Xpx31WqceCg4qAe15x9dh+FO/qAb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWrtMu0VKU+n//t+MiedOLKjgw29cm42N0GgZzk0EoRt8UcSjtO8Yk8Jn1OAeow3/iUfLkc8z8xoeQYvbEsCpDcp0F3bZ2/xOzV4QO+YtGQPsSW1nvugrc4hfDtnmqSsUPfGzaa5N9+Ap7mAemArHhuihFd3+3/0+l4Kfs1zS8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A26168AFE; Mon, 15 Jul 2024 19:43:22 +0200 (CEST)
Date: Mon, 15 Jul 2024 19:43:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cmaiolino@redhat.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: btree blocks are never on the RT subvolume
Message-ID: <20240715174321.GA14855@lst.de>
References: <20240715170915.776487-1-hch@lst.de> <20240715173204.GW612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715173204.GW612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 15, 2024 at 10:32:04AM -0700, Darrick J. Wong wrote:
> Did you actually hit this, or did you find it through code inspection?

I hit this, but only with the per-rtg rt bitmap, with which this caused
an out of bounds access in the new, non-upstream array of RT AVL trees.

> AFAICT for attr forks, the (whichfork != XFS_DATA_FORK) check should
> have been saving us this whole time?  And the (type != XR_INO_RTDATA)
> check did the job for the data fork?
> 
> IOWs, is this merely cleaning out a logic bomb, or is it resolving some
> false positive/customer complaint?

As far as I can tell this is a real bug upstream.  If you have a bmap
btree block number that when interpreted as a RT extent is also otherwise
used you'll get repair finding an incorrect duplicate block.  It just
seems hard enough to trigger so that no one found it despite being there
since day 1 of public xfsprogs releases.
