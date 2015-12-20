Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 68B927F75
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 08:03:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5695A8F8037
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 06:02:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BthHwg9z4QBhBNfg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 06:02:58 -0800 (PST)
Date: Sun, 20 Dec 2015 09:02:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFCv4 00/76] xfs: add reverse-mapping, reflink, and dedupe
	support
Message-ID: <20151220140254.GA3618@laptop.bfoster>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 12:56:23AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
...
> Fixed since RFCv3:
> 
>  * The reflink and dedupe ioctls are being hoisted to the VFS, as
>    provided in the first few patches.  Patch 81 connects to this
>    functionality.
> 
>  * Copy on write has been rewritten for v4.  We now use the existing
>    delayed allocation mechanism to coalesce writes together, deferring
>    allocation until writeout time.  This enables CoW to make better
>    block placement decisions and significantly reduces overhead.
>    CoW is still pretty slow, but not as slow as before.
> 
>  * Direct IO CoW has been implemented using the same mechanism as
>    above, but modified to perform the allocation and remapping right
>    then and there.  Throughput is much higher than pushing data
>    through the page cache CoW.  (It's the same mechanism, but we're
>    playing with chunks bigger than a single memory page.)
> 
>  * CoW ENOSPC works correctly now, except in the pathological case
>    that the AG fills up and the rmap btree cannot expand.  That will
>    be addressed for v5.
> 
>  * fallocate will now unshare blocks to prevent future ENOSPC, as
>    you'd expect.
> 
>  * refcount btree blocks are preallocated at mount time to prevent
>    ENOSPC while trying to expand the tree.  This also has the effect
>    of grouping the btree blocks together, which can speed up CoW
>    remapping.
> 

Can you elaborate on how these blocks are preallocated? E.g., is the
tree "preconstructed" in some sense? However that is done, is this the
anticipated solution or a temporary workaround..?

Also, shouldn't the enospc condition be handled by the agfl? I take it
there is something going on here that renders that solution flawed, so
I'm just curious what it is.

(Sorry if this is all explained elsewhere, but I haven't yet had a
chance to take a close enough look at this feature..).

Brian

> Issues: 
> 
>  * The extent swapping ioctl still allocates a bigger fixed-size
>    transaction.  That's most likely a stupid thing to do, so getting a
>    better grip on how the journalling code works and auditing all the
>    new transaction users will have to happen.  Right now it mostly
>    gets lucky.
> 
>  * EFI tracking for the allocated-but-not-yet-mapped blocks is
>    nonexistant.  A crash will leak them.
> 
>  * ENOSPC while expanding the rmap btree can crash the FS.  For now we
>    work around this problem by making the AGFL as big as possible,
>    failing CoW attempts with ENOSPC if there aren't enough AGFL blocks
>    available, and hoping that doesn't actually happen.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> There are also updates for xfs-docs[4] and man-pages[5].
> 
> The patches have been xfstested with x64, i386, and ppc64; while in
> general the tests run to completion, there are still periodic bugs
> that will be addressed by the next RFC.  There's a persistent crash on
> arm64 and ppc64el that I haven't been able to triage.
> 
> This is an extraordinary way to eat your data.  Enjoy! 
> Comments and questions are, as always, welcome.
> 
> --D
> 
> [1] https://github.com/djwong/linux/tree/for-dave
> [2] https://github.com/djwong/xfsprogs/tree/for-dave
> [3] https://github.com/djwong/xfstests/tree/for-dave
> [4] https://github.com/djwong/xfs-documentation/tree/for-dave
> [5] https://github.com/djwong/man-pages/commits/for-mtk
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
