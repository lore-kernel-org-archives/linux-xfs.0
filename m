Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40700 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdH1TfJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 15:35:09 -0400
Date: Mon, 28 Aug 2017 21:35:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170828193507.GA31009@lst.de>
References: <20170828150612.16437-1-hch@lst.de> <20170828183142.GG4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828183142.GG4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:31:42AM -0700, Darrick J. Wong wrote:
> Hmm... this causes at least a couple of xfstests regressions:

Oh.  Looks like I didn't do a rmap run as none of my runs showed
a regression.

> xfs/310, because we no longer merge adjacent bmap records.  I think the
> solution here is to change the extent count check to allow 2 extents.

Yeah.

> xfs/245 because zero-mapping forks are no longer reported as having one
> big "hole" extent; instead zero extents are reported back.  How do we
> want to handle this case?

Hmm.  Looks like that is the COW fork, as even the current code
never reports a hole at then end when there are no extents at all.
It does however when we have at least one extent:

root@brick:/home/hch/work/xfs# uname -a
Linux brick 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64 GNU/Linux
root@brick:/home/hch/work/xfs# truncate --size 10g foo
root@brick:/home/hch/work/xfs# xfs_bmap foo
foo: no extents
root@brick:/home/hch/work/xfs# fallocate -l 10m foo
root@brick:/home/hch/work/xfs# xfs_bmap foo
foo:
	0: [0..20479]: 786860592..786881071
	1: [20480..20971519]: hole

in this case I suspect we should try to treat the COW fork the
same.  But let me take a more detailed look at xfs/245 on what's
going on there.

