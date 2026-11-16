Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794860650;
	b=TuOraYc1TzZWD9OeY7cEX3PNFrdUIm5ktlzvZGgpc0tS3vBzpYKZ/JUNcwLcr7DeANve
	 SFyv2ZNwzdF8y2H5a4GWK0C/g+wQc3wwOsnow6hsWJ1wtc5LKeBQB4QDAkvtbAp+TTeP8
	 yUol+cZxn9QCSpemffA96J9kekd7ALDuOhmX5Fct5827ULZ/WPIPgByUG0P5qEbWWpjAH
	 0I/O2IaZk/ngXXJXnupqBCsPn68fBdHYAEE8Zhlw+EZ2Kns6piFytemCXeogewylwik9e
	 UF3/fDSJpmB4lD98GC+sIbmmfaLsAMn0NByHDWt7eAH7CX/9lPmM2LgRvqmkyBUMJ1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794860650;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HrlmSbrwQHWwvlWeL6X+hzN4/F5s9LgrGzsG4wxnpcM=;
	b=1NRcF1q2fAXIl9tdE45j8nXqhOlRkMfPEUkGzNsyTHe1tSCqtKF4KMvOjwPwiMdqt+J6
	 SQXuNN1CDToLre0OEbwX2MWhhnU3H2GmdcwNC4ytnzi23HNSXXXQDivaNqQhxC58Znu1S
	 NRd2Y6vtTwsO3iZZfQvnsjRfy3MkrXfYtOBzQOwB7EqAb9uY360b6LXsZSRhJmdh4QLG5
	 W+CZvbrBvO7Y3S59ZGMj/T4pG/4b2KQlCKKmsUK49QU3SzyE4/BzHjsALyLYVAHVRsWgt
	 UhITEsvy/sTpoUYUyIOesj1LqWWz9lXHwzPr9Q/QSjFqjZsB0zFavoiQE5QH4B+P9ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UINgJHJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7716606A331
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 20:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UINgJHJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F11F000C5;
	Mon, 16 Nov 2026 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860650;
	bh=HrlmSbrwQHWwvlWeL6X+hzN4/F5s9LgrGzsG4wxnpcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UINgJHJigXij+94CcPSZSl/DyWvv9HBouaW35NUOOKk22v0Gl4kMpfGv4SKmhdAmw
	 F+sFZ6TEBW/zLHknVds2svu/NDR/DaB0tkbQGLkhM+dTIdn3QY6r6l8sVHLXT+qYhk
	 6YT1VIVvaCXIJjK6lclVunPQpHQLEdm1G9myOt0+tYUDR7cjVSgr4JAeHuqMMb6bNt
	 Y3jHHs7q20CKdJ3agIeo159gq1+9uFPF7j3PJgf3f31QKRMpDK1EX0cL6YGifLi4eg
	 m9zL6fidzif8A7I4ikMeySlaBTTfwfgXquGpIr08U5gETLcr3n6DfQb8tL5aASVH0K
	 psP58c9DohY+Q==
Date: Tue, 17 Nov 2026 07:24:01 +1100
From: Dave Chinner <dgc@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: do not let tr_atomic_ioend raise the minimum log
 size
Message-ID: <avtmYUPn6BMB56AX@dread>
References: <20261113043055.2578595-1-hengyul@cs.unc.edu>
 <260c0d7d-39cb-40ca-9a49-2ae8a3531676@linux.dev>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <260c0d7d-39cb-40ca-9a49-2ae8a3531676@linux.dev>

On Mon, Nov 16, 2026 at 08:54:27AM +0000, John Garry wrote:
> On 11/13/26 04:30, Hengyu Liang wrote:
> > Commit b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
> > added the tr_atomic_ioend reservation and made
> > xfs_log_calc_trans_resv_for_minlogblocks() copy it from the running
> > filesystem.
> > 
> > However, the copy has the current log count of tr_itruncate. On a
> > filesystem with rmapbt and without reflink that count is 4, while the
> > function puts the old count of 2 back for tr_itruncate itself. As of
> > now, the minimum log size of such a filesystem is larger than the one
> > its mkfs.xfs used, and the filesystem does not mount any more when its
> > log has the old minimum size.
> > 
> > The issue can be reproduced with mkfs.xfs from xfsprogs 5.13:
> > 
> >      truncate -s 512M xfs.img
> >      mkfs.xfs -m rmapbt=1,reflink=0 xfs.img
> >      mount -o loop xfs.img /mnt
> > 
> > Before commit b1e09178b73a ("xfs: commit CoW-based atomic writes
> > atomically"), the mount succeeds.
> > 
> > After that commit, it fails with EINVAL:
> > 
> >      XFS (loop0): Log size 878 blocks too small, minimum size is 962 blocks
> >      XFS (loop0): AAIEEE! Log failed size checks. Abort!
> > 
> > This patch will use the old log count for the copy as well. These
> > filesystems have no reflink, so they never use this reservation.
> > 
> > Fixes: b1e09178b73a ("xfs: commit CoW-based atomic writes atomically")
> > Cc: stable@vger.kernel.org # v6.16
> > Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> > ---
> > mkfs.xfs 4.9 to 5.13 give such a log to an rmapbt=1,reflink=0
> > filesystem below 1 GiB, or up to 16 GiB with -d su=256k,sw=4.
> > 
> > Application impact (Ubuntu 26.04 user space): udisks2 2.10.91 is asked
> > to mount a filesystem made as above ("udisksctl mount -b /dev/vda"). On
> > v6.15, it mounts it at /run/media/root/STICK513. On v6.16, it fails
> > with "Error mounting /dev/vda ... wrong fs type, bad option, bad
> > superblock".
> > 
> > Tested on xfs for-next with 45 images made by mkfs.xfs 4.9 to 6.6: 26
> > do not mount without this patch, all mount with it, and the largest
> > reservation is the same as on v6.15.
> > 
> >   fs/xfs/libxfs/xfs_log_rlimit.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> > index 37712b2f8757..9454c91e9fb3 100644
> > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > @@ -128,6 +128,8 @@ xfs_log_calc_trans_resv_for_minlogblocks(
> >   		resv->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> >   		resv->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> >   		resv->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +		/* tr_atomic_ioend starts as a copy of tr_itruncate. */
> > +		resv->tr_atomic_ioend.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> 
> I have to admit that I am not really familiar with this log code. Darrick
> was, but unfortunately he is no involved. The change looks sane, even though
> we are partially overwriting resv->tr_atomic_ioend (from when it is set
> earlier in the same function). Dave Chinner may be able to kindly help
> review.

I'm not sure that it fixes the issue, because the min log
size calculation should not contain the tr_atomic_ioend reservation
size at all, regardless of it's value. The minlogsize calc is for
compatibility with kernels that predate atomic writes completely,
so adding that reservation to the calc just seems wrong.

There are more fundamental problems with the atomic ioend
reservation, though, starting with the 'use truncate as a default'
behaviour, then changing it later.

I've been forced to look at this .... mess over the past couple of
weeks because the journal format validation work I've been doing has
tripped over reservation recalculation issues.  Growfs (and recovery
of growfs op) needs to recalculate a bunch of transaction
reservation values (e.g. all the new rt btree stuff), and the atomic
write reservations are currently not able to be recalculated
atomically and safely on a running filesystem. 

Atomic write reservations are also broken w.r.t. remount based size
changes because running a minlogsize calc on a running filesystem
temporarily changes mount wide constants for the purposes of
recalculating the reservations. Remount doesn't stop reads from
occurring, so various metadata pulled in from disk won't be 
correctly validated whilst the minlogsize calc is being run....

A week ago I changed the atomic write reservation code to replace
the "set default then calculate a different value later" behaviour
with a single calcuation based on the current log size to avoid
user-adjustable atomic write size limits having impact on journal
size limits. I think it will address the above problem, too, but
I'll have to go check...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
