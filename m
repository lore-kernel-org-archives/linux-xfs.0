Received: from out28-83.mail.aliyun.com (out28-83.mail.aliyun.com [115.124.28.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B5219ABC6
	for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 01:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776906240; cv=none; b=Ll0jWGfJp76vfPDLGbQjzyt9G69V12RAS1nKKiuMwZIEuYDNAzxLMedzFDN9BxJcrWBpWj3XtrQysrWV67BVWUNOO9sc7obEck57524iip+R1fBA1h1+F1bpiitsfxBNjLG7DQrjJnbrUglIJGbnO4Oz3GP/ZxNrmBFolpPKddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776906240; c=relaxed/simple;
	bh=7ebH368/fGyf+pfrCFCi17nkTgKvgKDYZOLZTta7EmQ=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=I7qJg9VvZzQD5tgU5tv5MfR26dgxnQfNHJ5mTHwYgYp9p9UqtGVy+S0OGkk7FxOWHvvguvsnwnRktyMC4zRmTYHIUyx/2B+ow3rLVVGwwOwZ7g/sDLZuNYM6WpI1Z+0+WYY4M5GrXOT9RsQnM6/j+PVZVbMawBNNKE/Q9eAOL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436532|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.356775-0.0126591-0.630566;FP=14178217100912973106|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037032089;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.hICBEv-_1776898946;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.hICBEv-_1776898946 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 23 Apr 2026 07:02:26 +0800
Date: Thu, 23 Apr 2026 07:02:27 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Dave Chinner <dgc@kernel.org>
Subject: Re: [ RFC ] xfs: 4K inode support
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <aelAeiyiAyFiJUgQ@dread>
References: <20260421230515.2234-1-wangyugui@e16-tech.com> <aelAeiyiAyFiJUgQ@dread>
Message-Id: <20260423070227.B2C6.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.02 [en]

Hi,

> On Wed, Apr 22, 2026 at 07:05:15AM +0800, Wang Yugui wrote:
> > use case for 4K inode
> > - simpler logic for 4Kn device, and less lock.
> 
> Nope, neither of these are true.
> 
> There is no change in logic when inode sizes change, and there is no
> change in locking as inode size changes.
> 
> This is because inodes are allocated in chunks of 64, and they are
> read and written in clusters of 32 inodes. Hence all that changing
> the size of the inode does is change the size of the inode cluster
> buffer.
> 
> And therein lies the problem: 32 x 4kB inodes is 128kB. Looking at
> xfs_types.h:
> 
> /*                                                                               
>  * Minimum and maximum blocksize and sectorsize.                                 
>  * The blocksize upper limit is pretty much arbitrary.                           
>  * The sectorsize upper limit is due to sizeof(sb_sectsize).                     
>  * CRC enable filesystems use 512 byte inodes, meaning 512 byte block sizes      
>  * cannot be used.                                                               
>  */                                                                              
> #define XFS_MIN_BLOCKSIZE_LOG   9       /* i.e. 512 bytes */                     
> #define XFS_MAX_BLOCKSIZE_LOG   16      /* i.e. 65536 bytes */                   
> #define XFS_MIN_BLOCKSIZE       (1 << XFS_MIN_BLOCKSIZE_LOG)                     
> #define XFS_MAX_BLOCKSIZE       (1 << XFS_MAX_BLOCKSIZE_LOG)
> 
> Yup, XFS defines a maximum block size of 64kB, and inode cluster
> buffers are already at this maximum size for 2kB inodes.
> 
> > - better performance for directory with many files.
> 
> No, it won't make any difference to large directory performance
> because they are in block/leaf/node form and all the directory
> information is held in extents external to the inode. The size of
> the directory inode really does not influence the performance of the
> directory once it transitions out of inline format.
> 
> In fact, larger inode sizes result in lower performance for
> directory ops, because the metadata footprint has increased in
> size and so every inode cluster IO now has higher latency and
> consumes more IO bandwidth. i.e. the -inode operations- that are
> done during directory modifications are slower...
> 
> Then there's the larger memory footprint of the buffer cache due to
> cached inode cluster buffers - in most cases that's all wasted space
> because inode metadata is typically just an inode core (176 bytes),
> a couple of extent records (16 bytes each) and maybe a couple of
> xattrs (e.g. selinux). So a typical inode will only contain maybe
> 300 bytes of metadata, yet now they take up 4kB of RAM -each- when
> resident in the buffer cache...
> 
> > - maybe inline data support later.
> 
> That's a whole different problem - it doesn't require inode sizes to
> be expanded to implement.
> 
> > TODO:
> > still crash in xfs_trans_read_buf_map() when mount a 4K inode xfs now.
> 
> Good luck with that - there's several issues with on-disk format
> constants that need to be sorted out before IO will work. e.g.
> you'll hit this error through _xfs_trans_bjoin():
> 
>                         xfs_err(mp,
>         "buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",
>                                         map_size,
>                                         BBTOB(bp->b_maps[i].bm_len));
> 
> and it will shut down with a corruption error. That's indicating
> that the on-disk journal format for buffer logging does not support
> the buffer size being read. i.e. there's a problem with the inode
> cluster size....
> 
> IOWs, there are -lots- of complex and cirtical subsystems that
> increasing the inode size will break and need to be fixed. Changing
> a fundamental on-disk format constant isn't a simple thing to do, an
> AI will not be able to tell you all the things you need to change
> and test without already knowing where all the architectural
> problems are to begin with....
> 
> Without an actual solid reason for making fundamental on-disk format
> changes and a commitment of significant time and testing resources,
> changes of this scope are unlikely to be made...
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

Thanks a lot for these info.

the basic logic is that, for 4Kn device, the min io size is already 4K. 
and 4Kn device(SSD and RAID) because more common now.

On a 4Kn device, we can I/O one single inode of 4K size without interaction with
other inode? so mabye better performance for high speed ssd such as pcie gen5/gen6?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/04/23


