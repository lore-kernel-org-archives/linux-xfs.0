Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28EEA7F5D
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 14:22:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7C8CAC004
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 12:22:13 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id KPZ92lezO7n0U3Pc for <xfs@oss.sgi.com>;
	Wed, 06 Mar 2013 12:22:12 -0800 (PST)
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 601CCA3E1C
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 21:22:11 +0100 (CET)
Date: Wed, 6 Mar 2013 21:22:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Pathological allocation pattern with direct IO
Message-ID: <20130306202210.GA1318@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

  Hello,

  one of our customers has application that write large (tens of GB) files
using direct IO done in 16 MB chunks. They keep the fs around 80% full
deleting oldest files when they need to store new ones. Usually the file
can be stored in under 10 extents but from time to time a pathological case
is triggered and the file has few thousands extents (which naturally has
impact on performance). The customer actually uses 2.6.32-based kernel but
I reproduced the issue with 3.8.2 kernel as well.

I was analyzing why this happens and the filefrag for the file looks like:
Filesystem type is: 58465342
File size of /raw_data/ex.20130302T121135/ov.s1a1.wb is 186294206464
(45481984 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0       13          4550656
   1 4550656 188136807  4550668 12562432
   2 17113088 200699240 200699238 622592
   3 17735680 182046055 201321831   4096
   4 17739776 182041959 182050150   4096
   5 17743872 182037863 182046054   4096
   6 17747968 182033767 182041958   4096
   7 17752064 182029671 182037862   4096
...
6757 45400064 154381644 154389835   4096
6758 45404160 154377548 154385739   4096
6759 45408256 252951571 154381643  73728 eof
/raw_data/ex.20130302T121135/ov.s1a1.wb: 6760 extents found

So we see that at one moment, the allocator starts giving us 16 MB chunks
backwards. This seems to be caused by XFS_ALLOCTYPE_NEAR_BNO allocation. For
two cases I was able to track down the logic:

1) We start allocating blocks for file. We want to allocate in the same AG
as the inode is. First we try exact allocation which fails so we try
XFS_ALLOCTYPE_NEAR_BNO allocation which finds large enough free extent
before the inode. So we start allocating 16 MB chunks from the end of that
free extent. From this moment on we are basically bound to continue
allocating backwards using XFS_ALLOCTYPE_NEAR_BNO allocation until we
exhaust the whole free extent.

2) Similar situation happens when we cannot further grow current extent but
there is large free space somewhere before this extent in the AG.

So I was wondering is this known? Is XFS_ALLOCTYPE_NEAR_BNO so beneficial
it outweights pathological cases like the above? Or shouldn't it maybe be
disabled for larger files or for direct IO?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
