Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788A837B416;
	Mon,  9 Feb 2026 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648111; cv=none; b=u3oZ8ezy5E+G2JcdtxGD4UFT3vvDBdZQzwGp6BjiDz+JpVgpC+ayUQ5+wa7HgEWnEGt5FH0SN1zBA4nHzkiD+7tSSu5n/BJiZugpbyb/dl6CKVy4f443K8anIu7fsfCrrxwVrNnlWom0h4N7zg/FPlgDsQV06m3SqnySM5kkNRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648111; c=relaxed/simple;
	bh=ECIPrgRMdV9KCSkzGIVWRamcNFun8z6Q03qvqzBvb9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icmRgJyzZE2RsD7GSjDY+m6EFo2K0qnENvi758ElgmhspKKAc3eLe4oqBO/mC+Ckklctxd4ooHjao+20iMcWg//bJf7o6FADYV54cmLsIIECpJMWCp4lOvnauxlWONxOxHAws733Zig1tkQab8+byzx77dgc6mK5eeqNFTHbxpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 39ECD68D05; Mon,  9 Feb 2026 15:41:47 +0100 (CET)
Date: Mon, 9 Feb 2026 15:41:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Wilfred Mallawa <wilfred.opensource@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <20260209144146.GA16995@lst.de>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com> <aYZquyDjPqZIcKe4@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYZquyDjPqZIcKe4@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Feb 07, 2026 at 09:27:07AM +1100, Dave Chinner wrote:
> Different architectures will have different padding, alignment and
> holes for the same structure (e.g. 32 bit vs 64 bit) resulting in
> different sizes for the same structure across different platforms.
> 
> This is not actually a bug in the UAPI - as long as the
> architecture's userspace and the kernel are using the same structure
> layout, variations in structure size and layout between architectures
> don't matter.

Except for the pointers it generally is a bug in the structure
defintion, and even for pointers the current consensus is moving
towards encoding them as a u64.  So yeah, this will have to skip
some of the older structures, but for anything newer it the right
thing to do, and will catch issues.

