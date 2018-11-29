Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:19411 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbeK2M4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 07:56:19 -0500
Date: Thu, 29 Nov 2018 12:52:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
Message-ID: <20181129015237.GG19305@dastard>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <20181119052251.GQ2279@dhcp-12-117.nay.redhat.com>
 <20181119104547.GR2279@dhcp-12-117.nay.redhat.com>
 <20181119163809.GX4235@magnolia>
 <20181123073301.GA2299@dhcp-12-149.nay.redhat.com>
 <20181124165921.GE6783@magnolia>
 <20181125161928.GM3889@desktop>
 <20181126203855.GF6783@magnolia>
 <20181128025726.GO3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128025726.GO3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Nov 28, 2018 at 10:57:26AM +0800, Eryu Guan wrote:
> On Mon, Nov 26, 2018 at 12:38:55PM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 26, 2018 at 12:19:28AM +0800, Eryu Guan wrote:
> > > On Sat, Nov 24, 2018 at 08:59:21AM -0800, Darrick J. Wong wrote:
> > > > On Fri, Nov 23, 2018 at 03:33:01PM +0800, Zorro Lang wrote:
> > > > > On Mon, Nov 19, 2018 at 08:38:09AM -0800, Darrick J. Wong wrote:
> > > > > > On Mon, Nov 19, 2018 at 06:45:47PM +0800, Zorro Lang wrote:
> > > > > > > On Mon, Nov 19, 2018 at 01:22:52PM +0800, Zorro Lang wrote:
> > > > > > > > On Tue, Nov 13, 2018 at 03:39:37PM -0800, Darrick J. Wong wrote:
> > > > > > > > > Hi all,
> > > > > > > > > 
> > > > > > > > > This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
> > > > > > > > > copy_file_range.  It adds to fsstress support for copy_file_range.
> > > > > > > > > There are known failures in 4.20-rc2, particularly with copy_file_range,
> > > > > > > > > so these patches provide a fstests base for everyone to start/continue
> > > > > > > > > looking for bugs.
> > > > > > > > 
> > > > > > > > Hi Darrick,
> > > > > > > > 
> > > > > > > > Your patches triggered 2 new failures on g/091 and g/263, refer to [1]. I can't
> > > > > > > > reproduce these failures on original xfstests [2]. I saw you were talking about g/091
> > > > > > > > in #xfs. Are these two failures same issue?
> > > > > > 
> > > > > > Most probably.  Dave and I are still digging through all the new
> > > > > > failures that show up in g/091, g/263, and g/127 once clonerange starts
> > > > > > happening.
> > > > > 
> > > > > Hi Darrick,
> > > > > 
> > > > > I just tried NFS, [1] tested with original xfstests, [2] tested with your
> > > > > patches. Looks like your patches bring in new failures to NFS test:
> > > > > g/075, g/112 and g/127.
> > > > 
> > > > Uh... it would be much more helpful to send along the golden output
> > > > diffs that show where fsx went bad (as well as the nfs configuration),
> > > 
> > > I was testing against a loop-mount nfsv4.2 server. The diff is like
> > > 
> > > @@ -1,3 +1,46 @@
> > >  QA output created by 263
> > >  fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > >  fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
> > > +Seed set to 1
> > > +skipping zero size read
> > > +truncating to largest ever: 0xe400
> > > +copying to largest ever: 0x1f400
> > > +cloning to largest ever: 0x70000
> > > +copy range: 0x4b000 to 0x64000 at 0x2800
> > > +do_copy_range:: Resource temporarily unavailable
> > 
> > Hmm, well, -EAGAIN isn't documented as a valid return code in the
> > manpage, but I guess it wouldn't hurt to retry.  For that matter, I
> > should probably amend do_copy_file_range to use syscall() so that we
> > don't pick up the glibc wrapper by the same name.
> 
> Ah, this is not the error I usually see. A more common pattern I saw is
> do_copy_range fails with EINVAL.
> 
> skipping zero size read
> 3 mapwrite      0x8e7c thru     0x1507f (0xc204 bytes)
> 16 read 0xa5d5 thru     0x1507f (0xaaab bytes)
> 20 mapwrite     0x1a687 thru    0x2151d (0x6e97 bytes)
> 21 read 0x130b5 thru    0x16a8c (0x39d8 bytes)
> 24 read 0x1f899 thru    0x2151d (0x1c85 bytes)
> truncating to largest ever: 0x1abb7
> 25 trunc        from 0x2151e to 0x1abb7
> 26 mapread      0x1731a thru    0x1abb6 (0x389d bytes)
> 31 write        0x371bd thru    0x3dbdd (0x6a21 bytes)
> 35 write        0x3b913 thru    0x3ffff (0x46ed bytes)
> 36 write        0x283af thru    0x3341f (0xb071 bytes)
> 37 mapread      0x29ebb thru    0x35ef6 (0xc03c bytes)
> 38 write        0x25c9 thru     0x63d2  (0x3e0a bytes)
> 39 mapwrite     0x16f57 thru    0x1e75a (0x7804 bytes)
> 42 mapread      0x36992 thru    0x3aa7d (0x40ec bytes)
> 43 mapread      0x1f22b thru    0x23b9f (0x4975 bytes)
> 45 trunc        from 0x40000 to 0x1356b
> 46 write        0xaf3e thru     0x185d3 (0xd696 bytes)
> 48 write        0x1c700 thru    0x20d2c (0x462d bytes)
> truncating to largest ever: 0x1fdbf
> 52 trunc        from 0x20d2d to 0x1fdbf
> copying to largest ever: 0x27a75
> 58 copy from 0x86a9 to 0x12fe2, (0xa939 bytes) at 0x1d13c
> copy range: 0x86a9 to 0x12fe2 at 0x1d13c
> do_copy_range:: Invalid argument

fsx is always going to fail with NFSv4.2 and copy_file_range() right
now, because NFS does not allow copy offload within the same file.
i.e. it only allows copying between different files.


> copy_range on the same file fails with "Invalid argument" but copy to a
> new file succeeds. So I guess NFS doesn't like/support copy_file_range
> if src == dst.

Precisely - this is /currently/ an expected failure on NFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
