Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A11494B9;
	Thu, 11 Jul 2024 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720698073; cv=none; b=mXpcRW4r/+x3TSSYctwRus7ktbozeNy3KhTRlY+dL9c2k9QYbMOBfDirRe6d4rI4wCNrOZkpsiPFNVlGHJ4zxiYeVQeTA7wYp9/OlHM96Qx0x7ye8IM8MNTrd3M7NCp7EHBleleL6394mDguktJ47i8Mx7X2nBX/FzpPxaIitoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720698073; c=relaxed/simple;
	bh=Ua/nLDs+KP1dLarJx6TLx34B/y1nRj1lVYVsmctE1WM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqkfacLLUm33DfojF8wnPnIjlIVTZzZ1BahD6uoTrO56fTO67lWr6B5raU184lJDONaq5D2VgP4FwE3KdOrJILQNisYdWQg6poz6o1nFk+um0VGTM6tLYpyZFDgbYUk7FsbsGhg5CjZzy3cU28KJD8Bi8ymusdI/u8TSDxidJws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WKXk22hMHzxVwc;
	Thu, 11 Jul 2024 19:36:26 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id AB96C140123;
	Thu, 11 Jul 2024 19:41:02 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 11 Jul
 2024 19:41:02 +0800
Date: Thu, 11 Jul 2024 19:52:07 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>, Luis Chamberlain <mcgrof@kernel.org>
CC: <kdevops@lists.linux.dev>, <linux-xfs@vger.kernel.org>,
	<fstests@vger.kernel.org>, <zlang@redhat.com>
Subject: Re: [PATCH kdevops] xfs: add xfs/242 as failing on xfs_reflink_2k
Message-ID: <20240711115207.GA3638@ceph-admin>
References: <20240416235108.3391394-1-mcgrof@kernel.org>
 <Zh9UkHEesvrpSQ7J@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Zh9UkHEesvrpSQ7J@dread.disaster.area>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Wed, Apr 17, 2024 at 02:48:16PM +1000, Dave Chinner wrote:
> On Tue, Apr 16, 2024 at 04:51:08PM -0700, Luis Chamberlain wrote:
> > This test is rather simple, and somehow we managed to capture a
> > non-crash failure. The test was added to fstests via fstests commit
> > 0c95fadc35c8e450 ("expand 252 with more corner case tests") which
> > essentially does this:
> > 
> > +       $XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
> > +               -c "pwrite 0 $block_size" $sync_cmd \
> > +               -c "$zero_cmd 128 128" \
> > +               -c "$map_cmd -v" $testfile | $filter_cmd
> > 
> > The map_cmd in this case is: 'bmap -p'. So the test does:
> > 
> > a) truncates data to the block size
> > b) sync
> > c) zero-fills the the blocksize
> > 
> > The xfs_io bmap displays the block mapping for the current open file.
> > Since our failed delta is:
> > 
> > -0: [0..7]: data
> > +0: [0..7]: unwritten
> 
> That's most likely a _filter_bmap() issue, not a kernel code bug.
> 
> i.e. 'bmap -vp' output looks like:
> 
> EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET          TOTAL FLAGS
>    0: [0..231]:        2076367680..2076367911 18 (6251328..6251559)   232 000000
> 
> and _filter_bmap has two separate regex matches against different
> fields that both trigger "unwritten" output. The first check is
> against field 5 which is actually the AG-OFFSET in this output, not
> field 7 which is the FLAGS field.
> 
> Hence if the ag offset matches '/0[01][01][01][01]/' the filter will
> emit 'unwritten' regardless of what the flags say it actually is.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

I got a similar failure in xfs/242 as follows. It can be easily reproduced
when I run xfs/242 as a cyclic test. The root cause, as Dave pointed out, 
is that _filter_bmap first matches the data in column 5, which may be 
incorrect. On the other hand, _filter_bmap seems to be missing "next" to
jump out when it matches "data" in the 5th column, otherwise it might
print the result twice. The issue was introduced by commit 7d5d3f77154e
("xfs/242: fix _filter_bmap for xfs_io bmap that does rt file properly").
The failure disappeared when I retest xfs/242 by reverted commit 7d5d3f77154e.

The problem is not fixed yet. How about matching the 7th column first
and then the 5th column in _filter_bmap? because the rtdev file only has
5 columns in the `bmap -vp` output.

Best Regards,
Long Li

----------------------------------------------------------------------------

FSTYP -- xfs (debug)
PLATFORM -- Linux/aarch64 localhost 6.6.0+ #84 SMP Tue Jul 9 23:35:56 CST 2024
VMIP -- 192.168.250.78
MKFS_OPTIONS -- -f -m crc=1,rmapbt=0,reflink=0 /dev/sdb
MOUNT_OPTIONS -- /dev/sdb /tmp/scratch

xfs/242 1s ... - output mismatch (see /root/xfstests-dev/results//xfs/242.out.bad)
--- tests/xfs/242.out 2024-06-06 19:08:46.677638130 +0800
+++ /root/xfstests-dev/results//xfs/242.out.bad 2024-07-11 02:24:35.337554580 +0800
@@ -57,8 +57,7 @@
1aca77e2188f52a62674fe8a873bdaba
13. data -> unwritten -> data
0: [0..127]: data
-1: [128..511]: unwritten
-2: [512..639]: data
+1: [128..639]: unwritten
0bcfc7652751f8fe46381240ccadd9d7
...
(Run 'diff -u /root/xfstests-dev/tests/xfs/242.out /root/xfstests-dev/results//xfs/242.out.bad' to see the entire diff)
Ran: xfs/242
Failures: xfs/242
Failed 1 of 1 tests

