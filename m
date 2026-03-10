Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00F238B7C9
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141783; cv=none; b=WvOUZFPtjHUBl6tgqDyG/FgvgNs9QAy42SfEjB7S+0Br8eyNCMgWdEEMRP6+kHwuwIkPxpB9UBfTFSuE4UQTjgzUpztOY67cs2WZkDz2lyMkUdp+P2XV7+039MpomrnA6zB55BnpIn9pCOL1ZCktGdhex4cdZ38R7Fx0eR3WVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141783; c=relaxed/simple;
	bh=+sc8Etx1KhXKX2VyPiUtK0VHpbDqwev2QceBw6ed5qQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=kxp1sGtC19hGS7zKGVPZUq7LAyD+sxjvDarcZU1jGKgD7RAf2DaFzYrS6yu4oq1ua8VqEMGPqA/q4WvpTR3rylFTIRNCqidIuIA+mG8hTfOPUa5lKAAGNSfMOfY4y7gJISlgEZ/lTitc6tx9D7s6iApMi7NJQHFY45Enko8ABZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 4D00A180F14A;
	Tue, 10 Mar 2026 12:22:54 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id n8rnDA7/r2mqwx4AKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 10 Mar 2026 12:22:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 10 Mar 2026 12:22:54 +0100
From: Lukas Herbolt <lukas@herbolt.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 cem@kernel.org, hch@infradead.org, p.raghav@samsung.com
Subject: Re: [PATCH v11 2/2] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <j2nfikz4ugqs6u25jpf7mlxhvzpiochp7eu4yslm6tjpwprcmu@e33c7htr3cd3>
References: <20260309181235.428151-2-lukas@herbolt.com>
 <20260310004400.GU6033@frogsfrogsfrogs>
 <j2nfikz4ugqs6u25jpf7mlxhvzpiochp7eu4yslm6tjpwprcmu@e33c7htr3cd3>
Message-ID: <db573faa5330e7cc8ad31ca86333227f@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-10 11:10, Pankaj Raghav (Samsung) wrote:
>> 	if (xfs_is_always_cow_inode(ip) ||
> 
> Why should we check for this here but we don't do this check in 
> xfs_falloc_zero_range()?
> 
> There is a comment in xfs_falloc_allocate_range():
> 
> 	/*
> 	 * If always_cow mode we can't use preallocations and thus should not
> 	 * create them.
> 	 */
> 	if (xfs_is_always_cow_inode(XFS_I(inode)))
> 		return -EOPNOTSUPP;
> 
> Don't we also use preallocations in xfs_falloc_zero_range()?
> 

For the xfs_falloc_zero_range we return 0 on COW from 
xfs_alloc_file_space and that
results in creating a hole in the file instead of having preallocated 
extents as shown
bellow.

But for the xfs_falloc_write_zero_range(), we want fail as soon as 
possible as possible.

Feel free to correct me if I am wrong.

int
xfs_alloc_file_space(
         struct xfs_inode        *ip,
         xfs_off_t               offset,
         xfs_off_t               len)
{
         xfs_mount_t             *mp = ip->i_mount;
         xfs_off_t               count;
         xfs_filblks_t           allocatesize_fsb;
         xfs_extlen_t            extsz, temp;
         xfs_fileoff_t           startoffset_fsb;
         xfs_fileoff_t           endoffset_fsb;
         int                     rt;
         xfs_trans_t             *tp;
         xfs_bmbt_irec_t         imaps[1], *imapp;
         int                     error;

         if (xfs_is_always_cow_inode(ip))
                 return 0;


root@build-00:/mnt# dd if=/dev/urandom of=/mnt/test.bin bs=10M 
oflag=direct count=1
1+0 records in
1+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.167452 s, 62.6 MB/s
root@build-00:/mnt# xfs_bmap -vp  test.bin
test.bin:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..20479]:      192..20671        0 (192..20671)     20480 000000
root@build-00:/mnt# strace -e fallocate fallocate -zl 2M  test.bin
fallocate(3, FALLOC_FL_ZERO_RANGE, 0, 2097152) = 0
+++ exited with 0 +++
root@build-00:/mnt# xfs_bmap -vp  test.bin
test.bin:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..4095]:       hole                                  4096
    1: [4096..20479]:   4288..20671       0 (4288..20671)    16384 000000
root@build-00:/mnt# dd if=/dev/urandom of=/mnt/test.bin bs=1M 
oflag=direct count=1 conv=notrunc
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0172151 s, 60.9 MB/s
root@build-00:/mnt# xfs_bmap -vp  test.bin
test.bin:
  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
    0: [0..2047]:       192..2239         0 (192..2239)       2048 000000
    1: [2048..4095]:    hole                                  2048
    2: [4096..20479]:   4288..20671       0 (4288..20671)    16384 000000
root@build-00:/mnt# cat /sys/fs/xfs/debug/
always_cow          bload_node_slack    larp                mount_delay
bload_leaf_slack    bug_on_assert       log_recovery_delay  
pwork_threads
root@build-00:/mnt# cat /sys/fs/xfs/debug/always_cow
1


-- 
-lhe
