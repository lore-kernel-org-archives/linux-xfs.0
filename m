Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD233120E
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776894081; cv=none; b=TAJZ6h6lfr2wpDP9+Ysv80Z+fcfi4S2p3FOWUtl9tAbD6IhZF+AvHbojDAa+IKdx+CdQ7kOdhHJ+2+lE9Cc0funl+5mk18nV+L2l2jTN3dN7HhTfOrBmlnCtERbPHTgEiaz6iB/lIxIvOWEu2ti2PrT/1qQ8/51b7PT2uHzklYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776894081; c=relaxed/simple;
	bh=hvDSxO1GAkF55K+3/LttCL2alskyCfjYWOZ+Fm4+ZcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsh8uySjGHSVBX0ire0p9r0WBUpdyp9l9BWlEgai26Z3FR3BQh58RnKFfEGiw/S2Oa2C/73Z/3zf7CqQAdjb139lhzLOiZgTCXYIhgWgYcKpdNAcCLLX5O/t0ZgvDKPHFZlKB1spMLLJYoxG8ru0YZB5bu/b+tJLp8haENP3WCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JF8fwTqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JF8fwTqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807FDC19425;
	Wed, 22 Apr 2026 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776894081;
	bh=hvDSxO1GAkF55K+3/LttCL2alskyCfjYWOZ+Fm4+ZcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JF8fwTqfytddDfNtum6Z/OuD6gKHetzXW1kcGIyUWD3JZeiL70HmlW7jslhAGXQT9
	 SVMStwwtaqLiKel90iFKy9B2r+J3bXh09PqEmkQ+IsUhre+63pffzMyg/J6tCcTK/d
	 xoUmJ9HPYZ2DQDE3ZHdvLr9Kbp3LeuZfIKmJMCSi8dtmOBdz4xnRcmtvo8B9bqyVdP
	 bynXPmTfpJIuhUw4arEb2GLH9sLOfJIfny7qH4bb2D4W6Q4s4V00b2OcrKxdxBIt2F
	 LNzRFENsaaowEJvNCiVIdADe3v5EJxh7+3QMqpCRfKhssWpmzme47uJbQMEP/DiYQ/
	 CuPyQAfhquGoQ==
Date: Thu, 23 Apr 2026 07:41:14 +1000
From: Dave Chinner <dgc@kernel.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ RFC ] xfs: 4K inode support
Message-ID: <aelAeiyiAyFiJUgQ@dread>
References: <20260421094204.A743.409509F4@e16-tech.com>
 <20260421230515.2234-1-wangyugui@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421230515.2234-1-wangyugui@e16-tech.com>

On Wed, Apr 22, 2026 at 07:05:15AM +0800, Wang Yugui wrote:
> use case for 4K inode
> - simpler logic for 4Kn device, and less lock.

Nope, neither of these are true.

There is no change in logic when inode sizes change, and there is no
change in locking as inode size changes.

This is because inodes are allocated in chunks of 64, and they are
read and written in clusters of 32 inodes. Hence all that changing
the size of the inode does is change the size of the inode cluster
buffer.

And therein lies the problem: 32 x 4kB inodes is 128kB. Looking at
xfs_types.h:

/*                                                                               
 * Minimum and maximum blocksize and sectorsize.                                 
 * The blocksize upper limit is pretty much arbitrary.                           
 * The sectorsize upper limit is due to sizeof(sb_sectsize).                     
 * CRC enable filesystems use 512 byte inodes, meaning 512 byte block sizes      
 * cannot be used.                                                               
 */                                                                              
#define XFS_MIN_BLOCKSIZE_LOG   9       /* i.e. 512 bytes */                     
#define XFS_MAX_BLOCKSIZE_LOG   16      /* i.e. 65536 bytes */                   
#define XFS_MIN_BLOCKSIZE       (1 << XFS_MIN_BLOCKSIZE_LOG)                     
#define XFS_MAX_BLOCKSIZE       (1 << XFS_MAX_BLOCKSIZE_LOG)

Yup, XFS defines a maximum block size of 64kB, and inode cluster
buffers are already at this maximum size for 2kB inodes.

> - better performance for directory with many files.

No, it won't make any difference to large directory performance
because they are in block/leaf/node form and all the directory
information is held in extents external to the inode. The size of
the directory inode really does not influence the performance of the
directory once it transitions out of inline format.

In fact, larger inode sizes result in lower performance for
directory ops, because the metadata footprint has increased in
size and so every inode cluster IO now has higher latency and
consumes more IO bandwidth. i.e. the -inode operations- that are
done during directory modifications are slower...

Then there's the larger memory footprint of the buffer cache due to
cached inode cluster buffers - in most cases that's all wasted space
because inode metadata is typically just an inode core (176 bytes),
a couple of extent records (16 bytes each) and maybe a couple of
xattrs (e.g. selinux). So a typical inode will only contain maybe
300 bytes of metadata, yet now they take up 4kB of RAM -each- when
resident in the buffer cache...

> - maybe inline data support later.

That's a whole different problem - it doesn't require inode sizes to
be expanded to implement.

> TODO:
> still crash in xfs_trans_read_buf_map() when mount a 4K inode xfs now.

Good luck with that - there's several issues with on-disk format
constants that need to be sorted out before IO will work. e.g.
you'll hit this error through _xfs_trans_bjoin():

                        xfs_err(mp,
        "buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
                                        map_size,
                                        BBTOB(bp->b_maps[i].bm_len));

and it will shut down with a corruption error. That's indicating
that the on-disk journal format for buffer logging does not support
the buffer size being read. i.e. there's a problem with the inode
cluster size....

IOWs, there are -lots- of complex and cirtical subsystems that
increasing the inode size will break and need to be fixed. Changing
a fundamental on-disk format constant isn't a simple thing to do, an
AI will not be able to tell you all the things you need to change
and test without already knowing where all the architectural
problems are to begin with....

Without an actual solid reason for making fundamental on-disk format
changes and a commitment of significant time and testing resources,
changes of this scope are unlikely to be made...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
