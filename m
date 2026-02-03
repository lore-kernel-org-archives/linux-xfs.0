Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BFEEEAB
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770132894; cv=none; b=HLWX7X9JphCOlmnIofJQXL29qqMn4a1Clz9TQMHkQpbedHU4vvtJJTps5qEh4CGGbMjaH1HDv2jpRj/6nOPVzX0POdNNhP/jey4b2BTA1e71B3Bg+hNe8gZvEqBKgPW/24bGfvGxVIm8keWWanuFyLbS8a84XhE2zzHygg14xYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770132894; c=relaxed/simple;
	bh=Egr/aO3OS1Kd8L81Jo//JqFNOvKLO1FmObS06TkBRzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyNeEe9+Zlt6TcjY305SODsopT8EcAftq2lNhgs4nZBrZf27Dp/l/mYwBtshUj5w5I4+26OKXX2huKizvYRg0H2J1C3zsXjIbS/62WGfwOman2eDLPX9S8xsi8BOfNUwfkqY9XFNUzOXWLvswZsJpBlGkHrcBRQhIH1iD0tRXgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lzrw1/Bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lzrw1/Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB1C116D0;
	Tue,  3 Feb 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770132894;
	bh=Egr/aO3OS1Kd8L81Jo//JqFNOvKLO1FmObS06TkBRzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lzrw1/Bjb1Tz2Hqnp31LeBYwgHtYkKvvHJXEW7uqLko38KMRjslWQOXBbT89HdhMN
	 An6a4qgnD+CenPC975FSLoXjyZDqijtEkeeY+GxhsIepX+IYo99pgSxv0Tdfu7ij/P
	 8ljxggfQo5Cnz6ZlPe0fYowgGOqcBDdoWY2rmbjiCzUwO3d0z12hx4dxFQ88brKWZ5
	 z9kqjXGkU95tuetCY7I7I7HZ2VKYdI8XHqbQUJ21EjSmE7HC/kb74b4+gtWfFh82bJ
	 zZrik+zeSp2MeiBtP9eBUABgWI/rqEv9DBwuRDAZUbGzckBHL82SWOZ5L9dq+8l6sC
	 TT7RYbI7E4DTA==
Date: Tue, 3 Feb 2026 07:34:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v3 2/2] xfs: Fix in xfs_rtalloc_query_range()
Message-ID: <20260203153453.GN7712@frogsfrogsfrogs>
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
 <40bb6291838c95582ae967f3e35980923129d7b7.1770121545.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40bb6291838c95582ae967f3e35980923129d7b7.1770121545.git.nirjhar.roy.lists@gmail.com>

On Tue, Feb 03, 2026 at 08:24:29PM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
> start == end i.e, when the rtgroup size is 1. This causes incorrect
> calculation of free rtextents i.e, the count is reduced by 1 since
> the last rtgroup's rtextent count is not taken and hence xfs_scrub
> throws false summary counter report (from xchk_fscounters()).
> 
> A simple way to reproduce the above bug:
> 
> $ mkfs.xfs -f -m metadir=1 \
> 	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
> 	-d size=1G /dev/loop1
> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=1
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>          =                       rgcount=4    rgsize=65536 extents
>          =                       zoned=0      start=0 reserved=0
> Discarding blocks...Done.
> Discarding blocks...Done.
> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
> $ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>          =                       exchange=1   metadir=1
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>          =                       rgcount=4    rgsize=65536 extents
>          =                       zoned=0      start=0 reserved=0
> calling xfsctl with in.newblocks = 262145
> realtime blocks changed from 262144 to 262145
> $ xfs_scrub -n   -v /mnt1/scratch
> Phase 1: Find filesystem geometry.
> /mnt1/scratch: using 2 threads to scrub.
> Phase 2: Check internal metadata.
> Corruption: rtgroup 4 realtime summary: Repairs are required.
> Phase 3: Scan all inodes.
> Phase 5: Check directory tree.
> Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
> Phase 7: Check summary counters.
> Corruption: filesystem summary counters: Repairs are required.
> 125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
> 64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
> 18 inodes counted; 18 inodes checked.
> Phase 8: Trim filesystem storage.
> /mnt1/scratch: corruptions found: 2
> /mnt1/scratch: Re-run xfs_scrub without -n.
> 
> Cc: <stable@vger.kernel.org> # v6.13
> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Nit: no blank lines between Fixes: and the first Reviewed-by:.

Some peoples' commit scanning scripts only look for git trailers from
the end of the commit message backwards to the first blank line.

--D

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 618061d898d4..8f552129ffcc 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
>  
>  	if (start > end)
>  		return -EINVAL;
> -	if (start == end || start >= rtg->rtg_extents)
> +	if (start >= rtg->rtg_extents)
>  		return 0;
>  
>  	end = min(end, rtg->rtg_extents - 1);
> -- 
> 2.43.5
> 
> 
