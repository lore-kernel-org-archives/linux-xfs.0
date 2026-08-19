Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06E12F3C1F;
	Wed, 19 Aug 2026 07:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123555; cv=none; b=pOYfEm9q+iy+A11dDQ3HX45bFEpb1/m3qj5qrgJsHb/1Uai0EM9XsDSGG+VI9CJmjjJoG4LeqwCx5ZJpmZdMCK8Znl2HriKXiFjYVVYBq6MXeXjy89lzZsGAIMS3QpkEINVqPMcYAcLWmK1+y97HfyGLi3ubW5yok7XW9HiVrKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123555; c=relaxed/simple;
	bh=jlweH4gGtwxfRS7wxut2CoqV/h8YaCp/oxz9NwcbXlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULQ7H74LqiZkcw8aKozKW61qLlzicczSwpWZD49wE5voZlxouS32adX99vXTVjWxswBveJx4v3S1tPBUf4pt2YjbsAvKTc7tWr5FqkLCgKEnVs75murBXkd2UHB1QYPJxRv7t3MGsbIaOPnuNjV1i458DGxo0GQxALmGbMbI9MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F5C768CFE; Wed, 19 Aug 2026 09:12:29 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:12:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, hch@lst.de,
	dgc@kernel.org, jack@suse.cz, cem@kernel.org, axboe@kernel.dk,
	kbusch@kernel.org, ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 3/6] xfs: implement write-stream management support
Message-ID: <20260819071229.GE1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c@epcas5p3.samsung.com> <20260717125538.508925-4-joshi.k@samsung.com> <20260721030810.GV7380@frogsfrogsfrogs> <00f6099f-91ae-4685-951d-2ea0ee9a7b11@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00f6099f-91ae-4685-951d-2ea0ee9a7b11@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 31, 2026 at 01:33:04PM +0530, Kanchan Joshi wrote:
> On 7/21/2026 8:38 AM, Darrick J. Wong wrote:
> >> Write streams, filestreams, and write-life-time hints are mutually exclusive;
> >> combining any two of them returns -EINVAL:
> >>    - GET_MAX reports 0 whenever xfs_inode_is_filestream() is true,
> >>      covering both mount-wide filestreams and the per-inode chattr
> >>      flag. Also when the file is on the realtime device.
> >>    - SET refuses to bind a stream to a file that already has a
> >>      write-life-time hint (fcntl F_SET_RW_HINT), is filestream, or is
> >>      on the realtime device.
> >>    - chattr refuses to set the filestream or realtime flag on a file
> >>      that already has a write stream set.
> > These special "files" that represent stream ids could be generic code
> > instaed of in xfs.  AFAICT the only thing you need from xfs is a pointer
> > from struct xfs_inode to struct (xfs_)write_stream, right?
> 
> Right. Is it fine if we come to it when everything else is settled.
> I was hoping to lift common things up when write-stream is applied on 
> another FS.

Yes, I think this really needs to move to common code.  If we can find
a hole in struct inode, moving the write_stream id to that would probably
clean that up a lot.

