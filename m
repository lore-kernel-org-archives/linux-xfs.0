Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2FB194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902128; cv=none; b=nrt+1MXGJyfidYdBgl6lJXaLo4XcO5XKqBigxXeVxULBFVCT7GuUaT7f3/XXiA10R/5dgKOGfHnjDfwSG8OI+E0+SGAgYbvHH5N1vDAF2fS1AZnWpgFYCRaEc+wEFSLx6C2hA4v+Hd/r6xeTTh/VqI/H89Nhnaci0dMzQmnvWGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902128; c=relaxed/simple;
	bh=bmaPqRFv/OyWmt0Jgi+qpzfap3HPjSWY6nB6/+v/Kow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtVb4oIMSoURXppXUZSf2iGPi7oL4QRw0hmJFptXvw/QBeow5QX5NE4VABnknEj1kB2Uq8Ih0SHsuBgPXVhgISjO6eOnwXvGyK16fc6vpn0NUujyRjCwGkyTfKkoHR2VzhbRHyCrgNhrF3e5VQHQK54iWAz/mI4vy7PrRapgNAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RreZVoL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RreZVoL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1537C4CED1;
	Fri,  7 Feb 2025 04:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902128;
	bh=bmaPqRFv/OyWmt0Jgi+qpzfap3HPjSWY6nB6/+v/Kow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RreZVoL6ttJHPzuNkq0YP3qlO5C+znFPJD+4h69iY6P511fgz5PRZpcR5cbE1rG1y
	 2lD0vGS7Dq80NwBcJwSWR4r83wF6MvUSW2fXqjZ9eQtNYGdNmhBp2DSl7nhBXMUrei
	 raI0sUsXMMaFeucPviTi4giAtd7x5GuiNWw/7DbtjNS01wxfgffDvBaNdhmcgpcEWC
	 2Ofw+04O/zcL4Gki9RZ6H0KpSgd2ujhfL72u4/XrGOkUCEDr8YtFngzUEM3RpPePTr
	 HqCmwmg2NouqENEoiFeI/bfnHQPoXynFhEhOqaPAGTKacS0vnG+xaQY+r5oo2+vjDt
	 FxflYAMmHlOoA==
Date: Thu, 6 Feb 2025 20:22:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: skip always_cow inodes in
 xfs_reflink_trim_around_shared
Message-ID: <20250207042207.GG21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-5-hch@lst.de>
 <20250206201351.GH21808@frogsfrogsfrogs>
 <20250207041542.GA5467@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207041542.GA5467@lst.de>

On Fri, Feb 07, 2025 at 05:15:42AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 12:13:51PM -0800, Darrick J. Wong wrote:
> > Hmm.  So this is to support doing COW on non-reflink zoned filesystems?
> 
> Yes.
> 
> > How then do we protect the refcount intent log items from being replayed
> > on an oler kernel?
> 
> There are no refcount intent log items for this case.

Er... right, there aren't any refcount log items because there's no
refcount btree.  Looking through the rest of the code, though, the same
question about protection against recovery by old kernels applies to the
bmap intent item logged in xfs_zoned_map_extent.  And I think it has the
same answer -- zoned storage is an incompat feature bit that's newer
than the bmap intent items, so we're protected.

I got there clumsily, but here I am :P
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
