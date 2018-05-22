Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43631 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753272AbeEVXcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 19:32:20 -0400
Received: by mail-pf0-f196.google.com with SMTP id j20-v6so9508051pff.10
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 16:32:20 -0700 (PDT)
Date: Tue, 22 May 2018 16:32:18 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 2/5] generic: enable swapfile tests on Btrfs
Message-ID: <20180522233218.GG9536@vader>
References: <cover.1526503000.git.osandov@fb.com>
 <80a5002310ab7f06efd9fed76cf268673e631335.1526503000.git.osandov@fb.com>
 <20180522064145.GQ29080@desktop.hz.ali.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522064145.GQ29080@desktop.hz.ali.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: fstests@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

On Tue, May 22, 2018 at 02:41:45PM +0800, Eryu Guan wrote:
> On Wed, May 16, 2018 at 01:38:46PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Commit 8c96cfbfe530 ("generic/35[67]: disable swapfile tests on Btrfs")
> > disabled the swapfile tests on Btrfs because it did not support
> > swapfiles at the time. Now that we're adding support, we want these
> 
> So currently btrfs has no swapfile support yet, and tests still _notrun
> with current v4.17-rc5 kernel? Just want to make sure that's expected.

Yes, that's correct.

> > tests to run, but they don't. _require_scratch_swapfile always fails for
> > Btrfs because swapfiles on Btrfs must be set to nocow. After fixing
> > that, generic/356 and generic/357 fail for the same reason. After fixing
> > _that_, both tests still fail because we don't allow reflinking a
> > non-checksummed extent (which nocow implies) to a checksummed extent.
> > Add a helper for formatting a swap file which does the chattr, and
> > chattr the second file, which gets these tests running on kernels
> > supporting Btrfs swapfiles.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  common/rc         | 15 ++++++++++++---
> >  tests/generic/356 |  7 ++++---
> >  tests/generic/357 |  6 +++---
> >  3 files changed, 19 insertions(+), 9 deletions(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index ffe53236..814b8b5c 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2222,6 +2222,17 @@ _require_odirect()
> >  	rm -f $testfile 2>&1 > /dev/null
> >  }
> >  
> > +_format_swapfile() {
> > +	local fname="$1"
> > +	local sz="$2"
> > +
> > +	touch "$fname"
> 
> Better to remove $fname first, just in case it's an existing file with
> some blocks allocated, as chattr(1) says
> 
> "Note: For btrfs, the 'C' flag should be set on new or empty files.  If
> it is set on a file which already has data blocks, it is undefined when
> the blocks assigned to the file will be fully stable"

Good point.

> > +	chmod 0600 "$fname"
> > +	$CHATTR_PROG +C "$fname" > /dev/null 2>&1
> 
> It'd be good to have some comments on this chattr +C.

Will do.

> > +	_pwrite_byte 0x61 0 "$sz" "$fname" >> $seqres.full
> > +	mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c "$fname" >> $seqres.full
> 
> Is the label really needed?

Nope, doesn't look like it. Thanks!
