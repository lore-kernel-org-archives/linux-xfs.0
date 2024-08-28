Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D0AA48
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819746; cv=none; b=sqEVTWQIwF7tzQOjvLwZkgqXCNhMU4j0tA4w2Vl8oSjaTdMHWJ+7I6/iFfK7Af9z1EnJLjDQIdMbP4b8RmK64yGhz4T1J4WBxg8wmwRIGwy6hbeITKPV/bp6dVZsmffIaBrpQTX46aLPUtIWhf0hd6RYTZV97gaD6Qket4mXFGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819746; c=relaxed/simple;
	bh=28r67jT/DJEdVEHAIvIaX4QVpOWszLhRE9Or/XY3DJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izqYP/Ovaype89T/r9arjfPvQvHj5EjqniernwoQMJ4U9AvsOhjFmd+1gkptJktCfjMylBZLEaBH4VRwqdF26rQZRkQFqxZdPR++ySFBHdgRsCREVepXTNkBFPM61WOaMDRYDWoaQyXfbVX95FDP7HNfUb1u18WlmQ7ULOMZBZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ehSxXsJo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ehSxXsJo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nwFU2ZIVze9BkaZARGQUWoEb6qjVZbYsZMFVgfnYL58=; b=ehSxXsJor7IZIlLJ5qTSe2XHeD
	odpcx7oK1qQyy7wt3TssNHBiro4FV6+jzq9lr9GOkhyxfVab2vBZyj7grTEvH5MgiUOlKdB6o9A9e
	Ep4wttNZyOUV9HobS3v/YwFesCBPuLs0JyFu+84j0HqX93jPUi3af7vs0KfP+6MxISAZdKF9oP7IJ
	9duY1aFqHhsJxqpEajMx8Ifl2SlqlWcfE6kSN9pIYNGCB54PRtD2Mgz28kjLc6+5A4NOalRJgt3S7
	8SJplTYG5jmuo13LHvvxBRpvPPQdSDcfGSW1+FEr+cF5WBWP4o26w4xEOzQdb0c9k9vofKAIc1Z8q
	zftSzVTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjAPI-0000000DoOy-0wh3;
	Wed, 28 Aug 2024 04:35:44 +0000
Date: Tue, 27 Aug 2024 21:35:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] scrub: Remove libattr dependency
Message-ID: <Zs6pIFfRmMylXiIS@infradead.org>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-4-cem@kernel.org>
 <Zs3Dr2wwcaAFhMMO@infradead.org>
 <7vjkhxi2jv6mg4k6xle62lhve27myjgxml2batfwmshwkvfekk@jstiohihwa2d>
 <20240827143615.GM865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827143615.GM865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 27, 2024 at 07:36:15AM -0700, Darrick J. Wong wrote:
> > Because I didn't see XFS_ATTR_ROOT and XFS_ATTR_SECURE exists :)
> 
> Well if we're reusing symbols from xfs_fs.h then change these to
> XFS_IOC_ATTR_ROOT and XFS_IOC_ATTR_SECURE.

Ah, yes.  We've got yet another name for those..

