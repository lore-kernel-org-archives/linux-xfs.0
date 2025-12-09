Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113452FFFB1
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765297614; cv=none; b=YblBZbym2c0KvmaiblHy+I8WQZ0zdcHxB3zd0yNPOhIpUGKxidvUW1jsRbuPU3sCcztKFBPEfSb+j8MDRffGeEmC0w8eKYIEgkZWmiWV9Hfa8DQENJ+DPO2GwqPi7z6d47pL/2xq8c9arLRfiz9Bq659a1o7NNVpMCLKAuvAwrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765297614; c=relaxed/simple;
	bh=ykKgiQvn+WP3uH5sd90dIFGfxL53PBg0xTlm3atyohI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6o4DlONuiGKT63hhP1J6NCoXcgQPY1yuP1RtyXAPOlfkbQzQtHVplad6CF8kMWaUcK1qQixOvnrYLpPnAV/pVl+C179dAFD1Xy12BWPrSU/klPajxquGYOXj70cQLGuR18lLGBPfP9IHiNp8ncIZ8BvkxYzFNmW6NXWzwjGk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZPLTPDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZPLTPDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC0EC4CEF5;
	Tue,  9 Dec 2025 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765297613;
	bh=ykKgiQvn+WP3uH5sd90dIFGfxL53PBg0xTlm3atyohI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tZPLTPDF3lsT0leqmYyBbynyzEGJT/Q3erLcBnqPAbBTrV4+kPs5wjCtdW+bmKDqH
	 7Q/2sx1xE6WeTsvXj6YFMhqbvmB+FFdWdTpXe0omvwOKMZSbiLYJhfbe8eGCzWT+LB
	 7m5nogzS0j+1pEJUEFEdHQ/yXN2jn0BNygJNyrL688dy1NSR6kslekVevUJ+275WCt
	 8VyBZwujt2i3kbjrelgRcRwedsCLj2sCJ8u1MHALIG2Z/PofnDtiU/iDBSkSRX6GFu
	 fq1qz2OtON8evkKoP5yEUaRdR61xCl9M9SKS7oPlv1bhQmN1MkvE1dD9imm80Uj0dU
	 0A+IZokNs5CEA==
Date: Tue, 9 Dec 2025 08:26:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_ constants
Message-ID: <20251209162653.GW89472@frogsfrogsfrogs>
References: <20251208071128.3137486-1-hch@lst.de>
 <20251208071128.3137486-3-hch@lst.de>
 <20251209155907.GU89472@frogsfrogsfrogs>
 <20251209162008.GA8744@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209162008.GA8744@lst.de>

On Tue, Dec 09, 2025 at 05:20:08PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 07:59:07AM -0800, Darrick J. Wong wrote:
> > > +_("size of %s inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"),
> > > +				xr_ino_type_name[type], lino,
> > 
> > The %s parameter still needs to call _() (aka gettext()) to perform the
> > actual message catalog lookup:
> 
> Ah, right.
> 
> > 
> > 				_(xr_ino_type_name[type]), lino,
> > 
> > With this and the printf below fixed,
> 
> Where the printf below is the other one printing the array?

Yes.

--D
