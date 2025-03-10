Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D9F224246;
	Mon, 10 Mar 2025 09:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741598474; cv=none; b=UaCEtWqbSkGoU408fsblZKlU+Xeik7LqWwmIPWRMR5ia9xsTJz8ISitYXs+zh5udrWSYkUfMcTZw7RdgOTWiCZMC20Vz1g/wQCxQD/AzkxXGrFNCLXDADtb1YVTnQr9u7fhIsgHXZRWHYXY43FpPTk5CgUly/eu8kGTI3ZIb4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741598474; c=relaxed/simple;
	bh=ztxUppw9zVBEmPaw4H/Yu9o22HR5d2xnmrw5n9v+4Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfE4vUG6d/Ut8nAYSZcRt+g5aNwgUPb9RsY7r8fE6N/ktVdv3BZy8krQzP4WmOeqeh1hJSmF2SKgBLXUYKewX1bLuYHe5pzO1I23e9N+Lwat3gE6BCaSpqmR0hyUCQyYG3fl7xkVCoTgu8/5wR2n3M6w++grgVyswWCeogPsVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/c9CNrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/c9CNrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6161CC4CEE5;
	Mon, 10 Mar 2025 09:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741598473;
	bh=ztxUppw9zVBEmPaw4H/Yu9o22HR5d2xnmrw5n9v+4Us=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/c9CNrGsWV2wglMjogxYfzPdjdut1qPxk9AjSExdsLtwnM5pnM3of91JQcuOLwof
	 zMMAz8SnR5l11z50XwUN96JT+DqiwcKdoD00q7CcJ71zVHXOxjgUXrvkaxcNi7Vl84
	 CT4wwA5bEMc7NWEocr51YuWmib2qrBT8y8bz0SOwvUV0rdxUyxd36IsX6I2U0LAmjX
	 RCDfJ+aC8XvHXj3O5JmJXOooAPF69I0daZos12Gx05IbrIhtikv8Y+LU5tebxyk8V5
	 7knUZayf+WOXoSSVPbbu46XJj6RWSpe7RrWYSvZgf46brVWF809k0FppQIdQZFx01f
	 GXyouC/NjmGkQ==
Date: Mon, 10 Mar 2025 10:21:04 +0100
From: Carlos Maiolino <cem@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-xfs@vger.kernel.org
Subject: Re: [xfs-linux:test-merge 13/13] fs/xfs/xfs_file.c:746:49: error:
 too few arguments to function call, expected 4, have 3
Message-ID: <jclah7ezuc723hjwdr3x5u57rypxafy6olq7ig43b2kawcraid@3ghad6tv23ci>
References: <PSt0U3K_mmDGWaUOdQei1VdlAVGOrC5kd15x-0yg_rquOtDV_Mh9rhn6hh7E2UkGEaAkraNnR5S41kzJkAmjMg==@protonmail.internalid>
 <202503090149.Wu0ag7zs-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202503090149.Wu0ag7zs-lkp@intel.com>

On Sun, Mar 09, 2025 at 01:06:40AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git test-merge
> head:   fac04210bb99888fd453db09239bed27436fd619
> commit: fac04210bb99888fd453db09239bed27436fd619 [13/13] Merge branch 'xfs-6.15-atomicwrites' into for-next
> config: i386-buildonly-randconfig-003-20250308 (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250309/202503090149.Wu0ag7zs-lkp@intel.com/reproduce)

Huh? All xfs branches are monitored? This was by no means to be tested.

Carlos

> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202503090149.Wu0ag7zs-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> fs/xfs/xfs_file.c:746:49: error: too few arguments to function call, expected 4, have 3
>      746 |         ret = xfs_file_write_checks(iocb, from, &iolock);
>          |               ~~~~~~~~~~~~~~~~~~~~~                    ^
>    fs/xfs/xfs_file.c:434:1: note: 'xfs_file_write_checks' declared here
>      434 | xfs_file_write_checks(
>          | ^
>      435 |         struct kiocb            *iocb,
>          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      436 |         struct iov_iter         *from,
>          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      437 |         unsigned int            *iolock,
>          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      438 |         struct xfs_zone_alloc_ctx *ac)
>          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> 
> vim +746 fs/xfs/xfs_file.c
> 
> 2e2383405824b9 Christoph Hellwig 2025-01-27  730
> 307185b178ac26 John Garry        2025-03-03  731  static noinline ssize_t
> 307185b178ac26 John Garry        2025-03-03  732  xfs_file_dio_write_atomic(
> 307185b178ac26 John Garry        2025-03-03  733  	struct xfs_inode	*ip,
> 307185b178ac26 John Garry        2025-03-03  734  	struct kiocb		*iocb,
> 307185b178ac26 John Garry        2025-03-03  735  	struct iov_iter		*from)
> 307185b178ac26 John Garry        2025-03-03  736  {
> 307185b178ac26 John Garry        2025-03-03  737  	unsigned int		iolock = XFS_IOLOCK_SHARED;
> 307185b178ac26 John Garry        2025-03-03  738  	unsigned int		dio_flags = 0;
> 307185b178ac26 John Garry        2025-03-03  739  	ssize_t			ret;
> 307185b178ac26 John Garry        2025-03-03  740
> 307185b178ac26 John Garry        2025-03-03  741  retry:
> 307185b178ac26 John Garry        2025-03-03  742  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> 307185b178ac26 John Garry        2025-03-03  743  	if (ret)
> 307185b178ac26 John Garry        2025-03-03  744  		return ret;
> 307185b178ac26 John Garry        2025-03-03  745
> 307185b178ac26 John Garry        2025-03-03 @746  	ret = xfs_file_write_checks(iocb, from, &iolock);
> 307185b178ac26 John Garry        2025-03-03  747  	if (ret)
> 307185b178ac26 John Garry        2025-03-03  748  		goto out_unlock;
> 307185b178ac26 John Garry        2025-03-03  749
> 307185b178ac26 John Garry        2025-03-03  750  	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
> 307185b178ac26 John Garry        2025-03-03  751  		inode_dio_wait(VFS_I(ip));
> 307185b178ac26 John Garry        2025-03-03  752
> 307185b178ac26 John Garry        2025-03-03  753  	trace_xfs_file_direct_write(iocb, from);
> 307185b178ac26 John Garry        2025-03-03  754  	ret = iomap_dio_rw(iocb, from, &xfs_atomic_write_iomap_ops,
> 307185b178ac26 John Garry        2025-03-03  755  			&xfs_dio_write_ops, dio_flags, NULL, 0);
> 307185b178ac26 John Garry        2025-03-03  756
> 307185b178ac26 John Garry        2025-03-03  757  	if (ret == -EAGAIN && !(iocb->ki_flags & IOCB_NOWAIT) &&
> 307185b178ac26 John Garry        2025-03-03  758  	    !(dio_flags & IOMAP_DIO_ATOMIC_SW)) {
> 307185b178ac26 John Garry        2025-03-03  759  		xfs_iunlock(ip, iolock);
> 307185b178ac26 John Garry        2025-03-03  760  		dio_flags = IOMAP_DIO_ATOMIC_SW | IOMAP_DIO_FORCE_WAIT;
> 307185b178ac26 John Garry        2025-03-03  761  		iolock = XFS_IOLOCK_EXCL;
> 307185b178ac26 John Garry        2025-03-03  762  		goto retry;
> 307185b178ac26 John Garry        2025-03-03  763  	}
> 307185b178ac26 John Garry        2025-03-03  764
> 307185b178ac26 John Garry        2025-03-03  765  out_unlock:
> 307185b178ac26 John Garry        2025-03-03  766  	if (iolock)
> 307185b178ac26 John Garry        2025-03-03  767  		xfs_iunlock(ip, iolock);
> 307185b178ac26 John Garry        2025-03-03  768  	return ret;
> 307185b178ac26 John Garry        2025-03-03  769  }
> 307185b178ac26 John Garry        2025-03-03  770
> 
> :::::: The code at line 746 was first introduced by commit
> :::::: 307185b178ac2695cbd964e9b0a5a9b7513bba93 xfs: Add xfs_file_dio_write_atomic()
> 
> :::::: TO: John Garry <john.g.garry@oracle.com>
> :::::: CC: Carlos Maiolino <cem@kernel.org>
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
