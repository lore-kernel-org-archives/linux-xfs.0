Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD8238E122
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772016043; cv=none; b=CNu3OdoHITNhVpcio9V6gllIk0PALmL/ejSd/y+I/mOkNCMeDPvSzd2OSMTuAWZZTfwIq6c89zqVHa7MEIh6bqvfmAUmFus5fENcKzjpI57VBmMJDUSdvpjEriHeKt3lGbFi309z6lE3aOdFv2wTTDCpDv3+LJUj1ZrxqXTQ59c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772016043; c=relaxed/simple;
	bh=fE/KPZvjgyB7I7TQEcYhc404K0HNpg/ZsZaaMzzkBo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRI1K171zXw7q5ws3+qXuSZ7bBHmx/yKap43t7qRSBVdPqLmQYdQtZnVYyZ0VO3rTYKh3xjVQbTKyqPGph1moK+l50453lJDNLZXK8LMQks5GNHQHkbYC6CtgQIShWXBeuUNhF7uVenquOVT/AkyjYADXxRJxN5wfeKOrjfAvhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lN9SuNgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lN9SuNgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CE2C2BCB3;
	Wed, 25 Feb 2026 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772016042;
	bh=fE/KPZvjgyB7I7TQEcYhc404K0HNpg/ZsZaaMzzkBo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lN9SuNgNv++nHwaDp9Bvj+ZJwdLxm6HEIJYZsbnjMZqh/EdqWuek8GGtUQC7Melak
	 IRprZlAegbHGE+Z4/PXH/cuxgy76yULXBtQWN4Y7JDt3mVKm7NKbulxKTf1PEaWWA6
	 gl6Z3nktOG+od1w4VtJfCBGME1Xd4h1tj90tbDEJKo0PQ4Q2ewJjBlQDd6WuixjfBJ
	 N53kisO74mCuQlmHhOkkBqfmwSpLEwZyXp9Drx1PPC+5u3onboyd8LVk4tYNcvfPg3
	 GVxU6Ppn5ratK7DQVNrxFPtOS1AguIfBRmuzcCz348l1JrTX0mlV2MEqG594OoRJmH
	 Sh1s51bmV4m3A==
Date: Wed, 25 Feb 2026 11:40:38 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [patch v4 2/2] xfs: Fix in xfs_rtalloc_query_range()
Message-ID: <aZ7Q6oTr9-WyPQ0r@nidhogg.toxiclabs.cc>
References: <cover.1770133949.git.nirjhar.roy.lists@gmail.com>
 <4215ff7fc2efcf2e147d2d413e5b0505ab332ec3.1770133949.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4215ff7fc2efcf2e147d2d413e5b0505ab332ec3.1770133949.git.nirjhar.roy.lists@gmail.com>

On Wed, Feb 04, 2026 at 08:36:27PM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
> start == end i.e, when the rtgroup size is 1. This causes incorrect
> calculation of free rtextents i.e, the count is reduced by 1 since
> the last rtgroup's rtextent count is not taken and hence xfs_scrub
> throws false summary counter report (from xchk_fscounters()).

This causes a regression in xfstests's generic/475 running on a RT
device.

I'm dropping this patch until I have time to investigate what's wrong.

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
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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
