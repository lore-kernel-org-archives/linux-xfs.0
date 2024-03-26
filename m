Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830C1C6A0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473729; cv=none; b=SMEFRmPj+9SOHziQYSqhpzi3iBF32ESVDYwvYX1eKh4l9YZddJf6ubpSMngNvMkWbpYa/ODKdKrCpCrXfMDpMkNzFC3gRUcjj4NfBPoqfVeUehs/pQSl8mPkKXH+u/NREifQx77o/dDBUSBBzbg+fGwXT3ffSSRshOXk4i8zTBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473729; c=relaxed/simple;
	bh=Zg/7TEksVH14E9xx4P+fOfTfsMByfAWBgrUedEANACM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvllY/wo0e1/0J0kT4mzfA4KhDLn0oVD2W7G/Pb+FvzcaIc9ezCjsL78xBot4rDhm+tISSe+/SA/DbgS+Lq8cFMu2I3zOUGcg54oCEuFPRTeDo7+wm32cuHVJGt17NstLoYoqf3sEotTGBZIlsxVQxlnjKRQ0LJqmMFgAJOx3AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OErgXflt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OErgXflt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDCBC433F1;
	Tue, 26 Mar 2024 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711473729;
	bh=Zg/7TEksVH14E9xx4P+fOfTfsMByfAWBgrUedEANACM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OErgXflt3hmhZoya4FiAqeaN6DWaMtwczpZcGruhKKoQXvNMWNHFYfUvnk7khPgMw
	 UYeIwTQQWtwEhM/rGyj4EyltsnHF/slILdEhHN/35C+ZXygVzVRRnUYLZL5LiClQNR
	 3NZHfL87SWuqoTbjoC10Wh4gV2KuIbu99NX6wKfSGdaqOWjOaXaJgUpOm9N2c/eSJz
	 MhhEm7XAaI46X2BwBL7sjMhwGIBXuKt8fUYqOvep/Add51CyCErLyjTGKp3xL+gwn+
	 BiyM4/+v40rLgwK7C0y+arnfRk7roQlJExHOR4g9rrWCtPOe8ZY+5QbHD4LqGgnBUg
	 HbRCEwlD/sNLQ==
Date: Tue, 26 Mar 2024 10:22:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_repair: compute refcount data from in-memory
 rmap btrees
Message-ID: <20240326172208.GQ6390@frogsfrogsfrogs>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134722.2220026.9096244249718663362.stgit@frogsfrogsfrogs>
 <ZgJjQgFM6ei1Cknr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJjQgFM6ei1Cknr@infradead.org>

On Mon, Mar 25, 2024 at 10:55:14PM -0700, Christoph Hellwig wrote:
> > +#define RMAP_NEXT(r)	((r)->rm_startblock + (r)->rm_blockcount)
> 
> Maybe kill this just like we did in the kernel?

It goes away in patch 3 of the next patchset.

> Otherwise this looks fine.  Note that it looks very similar but not the
> same as the kernel code.  I guess sharing more code was considered but
> didn't work out for some reason?  Mabye document that in the commit
> log?

Ok.  The rcbag btree in xfs_repair has a different record format than
the one in the kernel because we store owner numbers so that xfs_repair
can compute the bitmap of files that need to have the reflink iflag set.

I'll make a note of that in "xfs_repair: define an in-memory btree for
storing refcount bag info".

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
