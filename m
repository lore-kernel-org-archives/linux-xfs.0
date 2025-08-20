Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1358D1E9B08
	for <linux-xfs@vger.kernel.org>; Wed, 20 Aug 2025 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755678213; cv=none; b=Jif5nLoC+RHJrSfnUevCdo3KreLLnVRULwEGwMlpaSO0GC3uHU7LvdKW6+1q0ElC/b6qc1elV77CXgYqHwrBGOZumm4uzDX41dX2s42OeRgk3XGrpEQXuBJDl9GiJ5O/ROLOcNq1likof3bsmWeoOTpFfLKpzimD5p7wDklYaJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755678213; c=relaxed/simple;
	bh=XIucl+0OhN44TSbsf/6F9kAqiqY1YUKnJrc6wmF/y10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwsBia01Em3huwAsKc0ZT5iVZ8b9uSVXN9iqxNt2uxuUh5GKfdCxRXnylYXJDIL1Ke8wLSWuWQGPKHvlgFdM5u2PNbzXT1lrZ/7L17WQk6T7BWjYbdnfkwmErn4D92QloUGzXAGHF6s9oZNBzsDT1mG5qdNGdhbMqD3KuBmwzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aC7W57la; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aC7W57la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EA4C113D0;
	Wed, 20 Aug 2025 08:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755678211;
	bh=XIucl+0OhN44TSbsf/6F9kAqiqY1YUKnJrc6wmF/y10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aC7W57laMqNowbfQaj4jhkL3iZ+D8EwiosHo9ObBd5N2tY0XQ2++lUY+K6X0Mbcu+
	 BzutsIcfZnSSKxzD5HRD8hKq48QCNNCQVkgXIb/Vdp8llHRNemVE+5A5214UA2iuRW
	 43M8BgYDYY9r5ZIVO/4q3QSTl8S2rkfxNmynPy8wHEnUnrngUNA1+2Ej3K2zbkrg3I
	 uzHswGmcB8HtHdOF1UaSYFXFbT12uswLmORidt5Grr8m9vIDGr+6KTk4l5ZWdFwFm8
	 WvMdNsznqxz9qtzmNC7aNTNgmVT3kVX0O9EAyiTsiWmPFn7Bh7GbLeDm0P3wEyp1Sp
	 sGgZ27O9wgExw==
Date: Wed, 20 Aug 2025 10:23:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
Message-ID: <bcwk3ezkikdmkgisfhukyxk3ojtkmbeonnepaxt3pmzof662b6@iddfobua7bme>
References: <9aG8Tf3X2d-4A9_uy7q50gPfuQH-xjOf3Bdbw4mJ5ITHbBXXDwYG2uqAYoSKE-pRy5iYgqRbd79paOGW-Sk_SA==@protonmail.internalid>
 <20250818051348.1486572-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818051348.1486572-1-hch@lst.de>

On Mon, Aug 18, 2025 at 07:13:43AM +0200, Christoph Hellwig wrote:
> Use the direct I/O alignment reporting from ->getattr instead of
> reimplementing it.  This exposes the relaxation of the memory
> alignment in the XFS_IOC_DIOINFO info and ensure the information will
> stay in sync.  Note that randholes.c in xfstests has a bug where it
> incorrectly fails when the required memory alignment is smaller than the
> pointer size.  Round up the reported value as there is a fair chance that
> this code got copied into various applications.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e1051a530a50..21ae68896caa 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1209,21 +1209,24 @@ xfs_file_ioctl(
>  				current->comm);
>  		return -ENOTTY;
>  	case XFS_IOC_DIOINFO: {
> -		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +		struct kstat		st;
>  		struct dioattr		da;
> 
> -		da.d_mem = target->bt_logical_sectorsize;
> +		error = vfs_getattr(&filp->f_path, &st, STATX_DIOALIGN, 0);
> +		if (error)
> +			return error;
> 
>  		/*
> -		 * See xfs_report_dioalign() for an explanation about why this
> -		 * reports a value larger than the sector size for COW inodes.
> +		 * The randholes tool in xfstests expects the alignment to not
> +		 * be smaller than the size of a pointer for whatever reason.
> +		 *

Do we need to keep this comment that tied to an userspace tool? It just
looks weird to have a comment about alignment constraints changes for a single
tool.

The issue with randholes is that it uses posix_memalign, and the pointer
size constraint comes from that.

I couldn't find any details on why this is required, but I'm assuming
it's to keep posix_memalign architecture/implementation independent?!

So, perhaps instead of being 'randholes' specific, it should specify to
be posix compliant or because posix requires this way?


Otherwise it looks good to me
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> +		 * Align the report value to that so that the dword (4 byte)
> +		 * alignment supported by many storage devices doesn't trip it
> +		 * up.

>  		 */
> -		if (xfs_is_cow_inode(ip))
> -			da.d_miniosz = xfs_inode_alloc_unitsize(ip);
> -		else
> -			da.d_miniosz = target->bt_logical_sectorsize;
> +		da.d_mem = roundup(st.dio_mem_align, sizeof(void *));
> +		da.d_miniosz = st.dio_offset_align;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> -
>  		if (copy_to_user(arg, &da, sizeof(da)))
>  			return -EFAULT;
>  		return 0;
> --
> 2.47.2
> 
