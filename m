Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF318BC3F
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951155; cv=none; b=rySZ6LRs6U4I2j8LCwhJXKJQfqy4tIY8P0KIVeNHXqbWBZR7lMiHTDkKHOhWg1XXwRfe7UBf0EHptqgsjv+JS/l2yw3hSVD9oKwhSJSj3d+JgKu/r+/tITsoqz1LCjgBs6YEWY4092DiuVjW3TRAMzsyqa/Dee71tOgwYzjGnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951155; c=relaxed/simple;
	bh=RbDbvIcBb65N+PM0lXtvM9eoQC5QkvfQd8Ui1y7kH/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9VpXAdXNMnCaRAuP7UXLImCW4UqY2v8bY4pVzZmcfZaC6+AqUIPkM7A547rU9sZs1HHX4Epk+q7/us8a9AappDCgD15OiZUcn14F+dhtB/O6POavrAL0n7RkxUZa2tGvCc1o6VrGcBwNbRyPNdBSDPBtnoErwtsQHvBXDUaOUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaSH0ZYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaSH0ZYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED45C4CED2;
	Wed, 11 Dec 2024 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733951154;
	bh=RbDbvIcBb65N+PM0lXtvM9eoQC5QkvfQd8Ui1y7kH/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HaSH0ZYPsjQ4IKauTi10b7cSdHR6r+BgOZyG5IBaxZHk3onhhLEKs2Z2Mc42Kj7yL
	 NLgMBIvQBRWdev+FW1gECUCdIv7foruL+qexqdOl29ui3kOdKLpnJ5VptOsIEbp2nX
	 AGZS3P9zRAEzjJmnyQqnyW5gZ99APb64eSkcnn17Ye98Em5AZwIHG9/mXGOCVxSeHO
	 344ndsyFMZPC3ORrx2GN8cAtxtqNg3DZ3d9g1vVpCxD0KKR9fK//GI+ABO/p23IVuZ
	 6k9rStxU8fSJce6bCz8PvI3SDPfDE7vQAk18LIE4NNpe1QKNwu1r6cawIpgtBQzhwl
	 r7zIPQdBi1mpQ==
Date: Wed, 11 Dec 2024 13:05:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/41] xfs_db: display di_metatype
Message-ID: <20241211210554.GK6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748452.122992.5424837513822834189.stgit@frogsfrogsfrogs>
 <Z1fK9ul-gWSabENb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fK9ul-gWSabENb@infradead.org>

On Mon, Dec 09, 2024 at 09:00:38PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 03:43:17PM -0800, Darrick J. Wong wrote:
> > +extern int	fp_metatype(void *obj, int bit, int count, char *fmtstr,
> > +			      int size, int arg, int base, int array);
> 
> No need for the extern here.

Will remove.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
