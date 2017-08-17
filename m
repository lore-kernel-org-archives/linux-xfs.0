Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14576 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751461AbdHQAA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 20:00:58 -0400
Date: Thu, 17 Aug 2017 10:00:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170817000042.GO21024@dastard>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
 <20170816071649.GA4143@debian.home>
 <20170816133502.GN21024@dastard>
 <20170816193100.GA1216@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170816193100.GA1216@debian.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>

On Wed, Aug 16, 2017 at 04:31:01PM -0300, Ernesto A. Fernández wrote:
> On Wed, Aug 16, 2017 at 11:35:02PM +1000, Dave Chinner wrote:
> > On Wed, Aug 16, 2017 at 04:16:53AM -0300, Ernesto A. Fernández wrote:
> > > On Wed, Aug 16, 2017 at 10:25:11AM +1000, Dave Chinner wrote:
> > > > With that in mind, here's waht I suggested above: set the mode after
> > > > the xattr. I haven't tested it - can you check it solves the problem
> > > > case you are testing?
> > > 
> > > It does. Of course the test still fails, as I said before, now claiming that
> > > the filesystem is inconsistent. But that's a separate issue.
> > 
> > It shouldn't be - what's the error that is being reported?
> 
> xfs_repair, phase 3:
> bad magic number febe in block 512 (14452) for directory inode 131

Hmmmm - that's a magic number for a non-crc DA node. Kinda implies
that it ENOSPC'd in the middle of a tree split.

Can you test on a CRC enabled filesystem and see if there are any
other errors that are detected either at runtime or by repair? If it
does fail, can youpost the full output of xfs_repair?

> It seems to be caused by setting too many extended attributes to a
> file.

Yeah, > 500 blocks in the attribute tree implies at least several
megabytes of xattrs on a file, which is something that pretty much
never happens on production workloads. It's not likely to be a
frequently exercised path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
