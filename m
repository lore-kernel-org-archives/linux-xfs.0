Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A284DE700
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595139; cv=none; b=hDDoA60bggSb/n856XwH1w3RB+UIIBbuFzNLt/08q/HcGS3hYydxBQKO1QGl4xUr58ZpK0DjGWLW8bOSpUnCOCGjTm4+dvtJGsYesdIPgSV1UoLHQTNmYcWPYr/Pt3UO8tddIje7teJ3FCEKgwFKCi4/8R7/Igxe7LJz2mYCEak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595139; c=relaxed/simple;
	bh=Ub9MeVQWEdhxBkujm10vcCgzGJLmOA1/qZSFLLdX4cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0gOzC0QGGPQqnWggRHgdN8lHwfxY7AWMkGp1NgtAFI4mZUkXyxm39nKJwWeJDrlGsE38YyDbP9mDxEDTeXEQNiQPzAmjSP7iIup4ZDWcBSqCsiEZSbv11+Js8cpgF4kTbpSNzcnesHm6nQ+vf4qqfOeK3C1zipZOG3WgsQsB6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij0eGizj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij0eGizj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD021F000FF;
	Wed, 16 Sep 2026 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789595122;
	bh=r3eGn9llUQqU94NuvWy11xvk28E55bbmLXa5hcGHF4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ij0eGizjIZ7BRncrBFfsv2N28HYlYJtEGbri51Fl5dgSZcvRBJCzI9sdgYVFSgJ1x
	 0++64IHHDsbsIwwVilVyu5oZhS1syeVTRlwMpUGlUdICS6vkWh/BMfwX2Pme+AiFLu
	 XdAstZG3u9QJE2J7Tz9FopL0qZ2DDgT8QP992DAGU+vlH5huAmLujdfSKAxAeTyNk5
	 5lnek2HVUg6/hw5Cw5XwnHD7VaxFNOMK20erDmhG0/bjthSxIh6j2AUnk2v9WY56Y7
	 85pIPestQAlCyqZ1zzVY+k/3cFar72j1KLU7+Ph5zI24pb2aqONWXmhq9ybgIIHapQ
	 PrRf5Gbqy1Qaw==
Date: Thu, 17 Sep 2026 07:45:04 +1000
From: Dave Chinner <dgc@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.garry@linux.dev>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqsN4GOXthkF8rOI@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkP9CTUvlC2YCIb@shinmob>

On Tue, Sep 15, 2026 at 06:34:50PM +0900, Shin'ichiro Kawasaki wrote:
> I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> TCMU fileio devices. Actually I once reported this hang symptom in last October,
> and Darrick and John kindly took some actions [1]. Since then, the hang
> disappeared and I have not observed the hang almost one year. However, my test
> system started reporting the hang again last week.
> 
> [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t
> 
> FYI, here I attache the kernel message [2]. I observed the hang last week with
> the kernel on the xfs/for-next branch at the commit 0ca15a1a1151 ("xfs: remove
> an extra cast in xfs_file_compat_ioctl"). Today, I tried again with the kernel
> at current xfs/for-next branch tip 4266ffdfd7cb ("xfs: remove an extra cast in
> xfs_file_compat_ioctl"), and observed the hang again. The hang can be recreated
> in stable manner by repeating the test case 20 times or so.
> 
> I also tried other test cases in atmoicwrites group, and observed no failure.
> 
>  generic/765        [not run] write atomic not supported by this block device
>  generic/767         11s
>  generic/768         13s
>  generic/769         13s
>  generic/770         32s
>  generic/773        [not run] write atomic not supported by this block device
>  generic/774        (skipped)
>  generic/775         293s
>  generic/776        [notrun] write atomic not supported by this block device
>  generic/778         48s
>  xfs/838            [not run] External volumes not in use, skipped this test
>  xfs/839            [not run] XFS error injection requires CONFIG_XFS_DEBUG
>  xfs/840            [not run] write atomic not supported by this block device
> 
> Action for fix will be appreciated. If I can do anything on my test node, please
> let me know.
.....

A bunch of threads waiting on the ILOCK here:

 down_write_nested+0x1c0/0x1f0
 xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
 xfs_dio_write_end_io+0x4b7/0x650 [xfs]
 iomap_dio_complete+0x140/0xb20
 iomap_dio_complete_work+0x58/0x90
 process_one_work+0x947/0x1760

And the holder:

 schedule+0xe5/0x2e0
 xlog_grant_head_wait+0x175/0xac0 [xfs]
 xlog_grant_head_check+0x312/0x3f0 [xfs]
 xfs_log_regrant+0x380/0x7d0 [xfs]
 xfs_trans_roll+0x2d9/0x420 [xfs]
 xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
 xfs_defer_finish_noroll+0x460/0xe70 [xfs]
 xfs_trans_commit+0xfc/0x180 [xfs]
 xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
 xfs_dio_write_end_io+0x4b7/0x650 [xfs]
 iomap_dio_complete+0x140/0xb20
 iomap_dio_complete_work+0x58/0x90
 process_one_work+0x947/0x1760

is waiting on log space whilst holding the ILOCK.

This looks to me like the test runs out of log space because of all
the IO completions holding transaction reservations waiting on the
ILOCK, whilst the ILOCK holder can't get enough log space to regrant
on transaction roll to continue the transaction.

Oh:

STATIC void
xfs_calc_default_atomic_ioend_reservation(
        struct xfs_mount        *mp,
        struct xfs_trans_resv   *resp)
{
        /* Pick a default that will scale reasonably for the log size. */
        resp->tr_atomic_ioend = resp->tr_itruncate;
}

Which means each reservation is probably holding hundreds of KB to
MB of journal reservation. If the journal is 64MB in size, then a
few dozen o these might be all that is needed to consume all the
reservation space.

Hmmm - there are at least 30 tasks stuck in
xfs_reflink_end_atomic_cow(), another 30 stuck in
xfs_vn_update_time() holding reservations, and significant number
xfs_atomic_write_cow_iomap_begin()->xfs_trans_alloc_inode() holding
tr_write reservations.

IOWs, smells of the journal being run out of reservation space, and
no new space being able to be freed because all the dirty inodes
in the journal that need to be written back to free up space are
locked waiting for journal space to come free....

How big is the journal in the filesystem being tested? If you
increase the size of the journal, does it go away? Can you get a
dump of the transaction reservation sizes for the filesystem in
question (the xfs_db logres command can do this, IIRC) and then run
the math on the reservations held from the dump of all the blocked
tasks holding locks to see if this matches the size of the journal
in the fs?

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
