Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41A01B87C9
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 02:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776910747; cv=none; b=FwU0wcI3resOOpAM9ESNTHBTUpZiwkPuEv1jUMS6SHMjW5Rzy67IA1J6LkOz5X/8gAVDyUacS0HL6PUpxn+a1BUWX6W1IsMnMwbGdZXVEgB1Kdg7iNqSOfSosMd9iS/X7+hA/vC3vQunpgeTdUzVWM7eJDmzj5g8NXKiUX1YEJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776910747; c=relaxed/simple;
	bh=gMkQhECJ20tmW8beDJagjq56KCQvAnVeH7VA0zR433M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLpb0AFmjUTvLM2QTKTKGfYLJpn1f4NaNlh5IQ4f5eHdHmvqP5A0EmnxBOcMFdvBeCvS9cyXwi9zMSts0uQzb3dTiGyLoMBOkHIymRB9vcmQcnyYmPdxp7KimXkWfMsDE9Kn/8kv5fZ1cQooF0xSGjUUcvU/kVPsr8h7UO6wQZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRjxwzEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRjxwzEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4284DC19425;
	Thu, 23 Apr 2026 02:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776910746;
	bh=gMkQhECJ20tmW8beDJagjq56KCQvAnVeH7VA0zR433M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rRjxwzEE1+T0BwmmRifONgRoQDcReR53mQ5rKeMVNL+Xfvh2/BOteFcYnB4ydXZ+B
	 r1UV2qLjh5wSV9N1y7Hcoocp/rBAF3vm/WbJV8x8LEnW0e9hZBGd6g9auouY5NJT56
	 BXS5XIuSORrv+tAhBgnVf5DiubuThlYBlQPDStCQk693InJkiEfr3KK3SSY9wzeHrm
	 zQQshy8NQm/zxMd+CM/TeQZHEbmRxuspOFzKu+luyTqQnaWS5cg0WBaty7ZfxsIcao
	 uxbL7y9gHqo2BKUzz9RTBQOYTD+IGowiGEJBpl0u3eiahbQO+wrnmuGC0udUFB4t4i
	 sD8SXPmq9VjnA==
Date: Thu, 23 Apr 2026 12:18:59 +1000
From: Dave Chinner <dgc@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ RFC ] xfs: 4K inode support
Message-ID: <aemBk-rEnj6Or-76@dread>
References: <20260421230515.2234-1-wangyugui@e16-tech.com>
 <aelAeiyiAyFiJUgQ@dread>
 <20260423070227.B2C6.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423070227.B2C6.409509F4@e16-tech.com>

On Thu, Apr 23, 2026 at 07:02:27AM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Wed, Apr 22, 2026 at 07:05:15AM +0800, Wang Yugui wrote:
> > > use case for 4K inode
> > > - simpler logic for 4Kn device, and less lock.
> > 
> > Nope, neither of these are true.
> > 
> > There is no change in logic when inode sizes change, and there is no
> > change in locking as inode size changes.
> > 
> > This is because inodes are allocated in chunks of 64, and they are
> > read and written in clusters of 32 inodes. Hence all that changing
> > the size of the inode does is change the size of the inode cluster
> > buffer.
.....

> On a 4Kn device, we can I/O one single inode of 4K size without interaction with
> other inode? so mabye better performance for high speed ssd such as pcie gen5/gen6?

Yes, you can do lots of 4kB IOs, but you can move more data in/out
of memory by doing 8kB IOs, yes?

In reality, on-disk inodes are not independent. They are allocated
and freed in contiguous chunks of 64 inodes, and the inode cluster
buffer is used for bulk initialisation, logging unlinked list
changes, etc.

Application operations on inodes often occur in batches, and XFS's
inode allocation algorithms usually provide physical locality of
inodes for a given workload. Hence for typical data set access
patterns, inode clustering usually results in a reduction of inode
IO due to increases in inode cluster buffer cache hit ratios.

If you want to test whether 8kB inode cluster buffers 
result in higher performance than using 32 inodes per buffer,
then you can do that with some tweaks to the sb->sb_inoalignmt
value set by mkfs.xfs. See the xfs_ialloc_setup_geometry() function
for details on how to modify that setting during mkfs to influence
the cluster buffer size the kernel will configure.

If you create a filesytem with 2kB inodes and a 8kB cluster buffer
size, you are going to see a different performance profile compared
to using a 64kB inode cluster buffer. It will very much depend on
the workload  and cache hit patterns as to whether that is a
performance win or a performance degradation.

The typical situation is that smaller cluster buffers reduces cache
hits and so increase both metadata IOPS (read and write) and
per-metadata operation CPU overhead due to needing to manage more
buffers (e.g. inode chunk allocation now has to allocate,
initialise, log and write back 16 buffers instead of 2). 
Workloads that benefit from smaller buffers tend to have large
working sets of inodes (i.e. don't fit in cache) and low
physical locality in their inode access patterns (i.e. random file
access patterns). There aren't a lot of workloads with those
characteristics, espcially with modern servers have hundreds of GBs
to TBs of RAM in them.

So before you start asking us to review code changes, first show us
that we can meaningfully improve application performance by reducing
inode cluster sizes and increasing the number of inode metadata IOPS
needed for any given inode intensive workload....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
