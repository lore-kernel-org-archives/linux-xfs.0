Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAF81D514E
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 05:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773637876; cv=none; b=erRYJs41qfRH+LAeEtBLj19+lZhJrnUqcqXosCS8OkWCLN3OxItuCaHFMJ3ui3316ei33gxL0U0/lDaxhrdjh/xWQRym265dWNf2tFncM7wT82auzwJeTf+e3rsjtU60Fu6VTEgO+jJsbw5D2fUTjhoxJFBF0NVfFvAhVs0fOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773637876; c=relaxed/simple;
	bh=kdKOhXmRgYTPYjxYDMv1Yhn1RGnfMUk3rkR6tckbxlw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=YV2MiVNAAQ6u3iqRqY4BGt5aHA+tturIS47iM1cPGWryVzDN0W9gOkrDsnt23wavI83tZ0DT7XDzbjqkXnKHwPzjAj/xi0m/5lEqgXWA9HSpAuvt30iPhoyx/+cyd5mfpwG9ibSbCkySs9VawNiHfpJuTkx3QcC1il2KZivMzIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 34614180F2D5;
	Mon, 16 Mar 2026 06:03:51 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id t/j2AjePt2m1cSUAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 16 Mar 2026 06:03:51 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 16 Mar 2026 07:03:50 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org,
 djwong@kernel.org, p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <abCzhDSVmFx4PtWI@dread>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <abCzhDSVmFx4PtWI@dread>
Message-ID: <f0ee82badefac989866339605b224cfc@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

> Honestly, this "prealloc, set file size, then convert and zero" thing
> seems a bit ... clunky.
> 
> I mean, this is trying to work around an issue with
> xfs_falloc_setsize() operating on written extents beyond EOF to set
> EOF. But why are we even using a generic truncate operation to set
> the EOF when we have already done most of the complex truncate work
> (exclusion, page cache invalidation, extent removal, etc) already?
> 
> My logic:
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_ZERO) will allocate all the
> holes and delalloc extents over the given range as written extents
> that are initialised to contain zeroes.
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT) will convert all the
> unwritten extents over a given range to written extents, but will
> not touch the data in those extents.
> 
> xfs_bmapi_write(off, len, XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO) will
> allocate holes and delalloc extents and convert unwritten extents
> all to written extents, and it will write zeros to all of those
> extents.
> 
> This latter case is exactly what we want, and if gives us zeroes on
> disk to the end of the extent beyond the new EOF. i.e. we've
> completed all the data IO, and so now all we need
> to do is update the file size transactionally, just like we do in
> IO completion.
> 
> Indeed, xfs_iomap_write_unwritten() integrates this size update
> into post-IO unwritten extent conversion. i.e we already have code
> that does exactly what we need, except for tweaking the
> xfs_bmapi_write() flags for the zeroing behaviour we need.
> 
> So, a helper function in fs/xfs/xfs_bmap_util.c such as this:
> 
> /*
>  * This function is used to allocate written extents over holes
>  * and/or convert unwritten extents to written extents based on the
>  * @flags passed to it.
>  *
>  * If @flags is zero, if will allocate written extents for holes and
>  * delalloc extents across the range.
>  *
>  * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do
>  * conversion of unwritten extents in the range to written extents.
>  *
>  * If XFS_BMAPI_ZERO is specified in @flags, then both newly
>  * allocated extents and converted unwritten extents will be
>  * initialised to contain zeroes.
>  *
>  * If @update_isize is true, then if the range we are operating on
>  * extends beyond the current EOF, extend i_size to offset+len
>  * incrementally as extents in the range are allocated/converted.
>  */
> int
> xfs_bmap_alloc_or_convert_range(
> 	struct xfs_inode	*ip,
> 	xfs_off_t		offset,
> 	xfs_off_t		len,
> 	uint32_t		flags,
> 	bool			update_isize)
> {
> 	< guts of xfs_iomap_write_unwritten >
> }
> 
> Then xfs_iomap_write_unwritten() can be factored to a one-liner
> (or replaced altogether), and this new fallocate op pretty much
> becomes:
> 
> 	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
> 			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
> 			new_size ? true : false);
> 
> The name of the function sucks but I can't think of anything better,
> so if you've got a better idea then change it. :)
> 
> -Dave.

When I first start looking into it the xfs_iomap_write_unwritten() was 
first place I was exploring, but did not think of the the above. I 
started working on it but I will be travelling this week so after that 
you may
expect v13.

-- 
-lhe
