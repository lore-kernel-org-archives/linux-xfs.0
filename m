Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B38C12EBCE
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713290350; cv=none; b=EiUO1azBdySs4MhVgWbMmryDbfZJfMQYHQK2HCsAs+SvrfnGq7HDNxBhaAEz4YiisxI43K1J4D6tIrruqmXm/g91Q8xrpipwLuJqinr/kDIlEfm0yZ7Qtamny5WH27+pIWIh79LJZft+eX7ifAjoSQam8gl5IkjVzvVLgYgsaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713290350; c=relaxed/simple;
	bh=AU2W58tEj2k9dUPw9KT5/DUspqRQhoRYXNfquu2wbVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7RSuvLVqMGOZDho9Ou/cWtghGTIo5aJJ2hmGwvYkVg+prxi2XeEfPWByfmUfN1sWwgQVJx08z4/I/QakfGdIptHEl/MBN9vYsHgDck9IBo6Tclt/w/PEjIqamEGXabwIVwt78puy7E3J8/wK/jBMb44q7LYGstmXUyo9V8so/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlkiAX0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlkiAX0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB3FC113CE;
	Tue, 16 Apr 2024 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713290349;
	bh=AU2W58tEj2k9dUPw9KT5/DUspqRQhoRYXNfquu2wbVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UlkiAX0hFkUE/AXjQ4ATI2rzi46HwBKTlXM/O1g2eKOX59jP9V3PByIQ6Z8BfCAHY
	 guq1Z8jszZG8yl7qDxaOOxwEU7ncdTbCZeN3p8d8rRfA1WAu2Z59AfroxO/6wwRQqT
	 nMYwFiTrHyMq8/9vt/NnGP5kvq8x4EanfoUePdsrlM4S3ZkppELgFn4kDXpQkOCjii
	 T2JTu0n49CAAUNzor5N6dMkGx+kadDFGM3Ly9qjtttR459FUvPgV9RndOXope3cBwO
	 xqeAyHx/GC3632O/RxQhFnUjDRmgaOAsk33I05LRFQXBfASNmbbHJhHry+rlQw9RYL
	 pBb9EH4C18wfw==
Date: Tue, 16 Apr 2024 10:59:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH 26/31] xfs: add parent pointer ioctls
Message-ID: <20240416175908.GU11948@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
 <171323028211.251715.6240463208868345727.stgit@frogsfrogsfrogs>
 <Zh4Kv9kTzBbgBxKC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4Kv9kTzBbgBxKC@infradead.org>

On Mon, Apr 15, 2024 at 10:21:03PM -0700, Christoph Hellwig wrote:
> > +	if (memcmp(&handle->ha_fsid, mp->m_fixedfsid, sizeof(struct xfs_fsid)))
> > +		return -ESTALE;
> > +
> > +	if (handle->ha_fid.fid_len != xfs_filehandle_fid_len())
> > +		return -EINVAL;
> 
> Maybe we should just stash the fid without the fsid?  The check for a
> match fsid when userspace already had to resolve it to even call the
> ioctl is a bit silly.

Remember a few revisions ago when this ioctl only returned the raw fid
information?  At the time, I didn't want to bloat struct parent_rec with
the full handle information, but then I changed it to export a full
handle.  When I went to update libfrog/getparents.c, I realized that
giving full handles to userspace is a much better interface because any
code that's trying to walk up the directory tree to compute the file
path can simply call getparents again with the handle it has been given.

It's much more ergonomic if userspace programs don't need to know how to
construct handles from partial information they has been given.  If a
calling program wants to open the parent directory, it can call
open_by_fshandle directly:

	struct parent_rec	*rec = ...;

	fd = open_by_fshandle(&rec->gpr_handle, sizeof(rec->gpr_handle),
			O_RDWR);

vs:

	struct parent_rec	*rec = ...;
	struct xfs_handle	*hanp;
	size_t			hlen;

	fd_to_handle(child_fd, &hanp, &hlen);
	hanp->ha_fid.fid_ino = rec->gpr_ino;
	hanp->ha_fid.fid_gen = rec->gpr_gen;

	fd = open_by_fshandle(hanp, hlen, O_RDWR);

--D
