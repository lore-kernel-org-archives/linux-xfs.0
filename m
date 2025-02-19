Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00FD25760
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943444; cv=none; b=k1XnSU7m5lIwiTp39EdASUrEpVrahJQcBAUk5E+zpLGVfrTsNeUDzbPY8P4KW6IePl5R7AjDyc61OcowSdCsDhPaQdU29vx0DkPOnR442d1gkPVaRP1QbSZLBPYSfyGG4oUB9aH+hl/CZGXMRE3zvWx19ezvBFdcAc+hqzfd3DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943444; c=relaxed/simple;
	bh=bqHtc94Haigr+7hZcXBQ/0FIFy48UEm+rGYC96Vb6eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TuoLCATO7I4OQY0IqHWL9Cz+pTeuTEE0ToOs84nGSYCj9UDV+cQnRycrVM8DPBKPfJo+BB31CEDA6yvJOs8RwGS/2NMUsm+E6z/bwij5TeakWClHtrAIbKoJ5C1GzkDFTBrMC7YphSWj9zJe7XJggWCZzSsNs0IfuBjBke35hRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 65BA867373; Wed, 19 Feb 2025 06:37:18 +0100 (CET)
Date: Wed, 19 Feb 2025 06:37:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/2] mkfs,xfs_repair: don't pass a daddr as the flags
 argument
Message-ID: <20250219053717.GD10173@lst.de>
References: <20250219040813.GL21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219040813.GL21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 18, 2025 at 08:08:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> libxfs_buf_get_uncached doesn't take a daddr argument, so don't pass one
> as the flags argument.  Also take the opportunity to use
> xfs_buf_set_daddr to set the actual disk address.

Should it take a daddr argument?  I've been wondering that a bit as the
interface that doesn't pass one seems a bit odd.

The patch itself looks fine, although I don't really see the point in
the xfsprogs-only xfs_buf_set_daddr (including the current two callers).
