Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:24684 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbfCQWqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Mar 2019 18:46:02 -0400
Date: Mon, 18 Mar 2019 09:45:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/36] xfs_io: actually check copy file range helper
 return values
Message-ID: <20190317224559.GP23020@dastard>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259746648.31886.15984241616376190830.stgit@magnolia>
 <53e2bd63-6bd1-648a-d9dd-020b42565e6d@sandeen.net>
 <20190315025638.GD4929@magnolia>
 <6d0275dc-cc56-b62d-16df-dbf65951eb20@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d0275dc-cc56-b62d-16df-dbf65951eb20@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>, Christoph Hellwig <hch@lst.de>

On Fri, Mar 15, 2019 at 11:51:56AM -0500, Eric Sandeen wrote:
> 
> 
> On 3/14/19 9:56 PM, Darrick J. Wong wrote:
> > On Thu, Mar 14, 2019 at 09:12:11PM -0500, Eric Sandeen wrote:
> >> On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> We need to check the return value of copy_src_filesize and
> >>> copy_dst_truncate because either could return -1 due to fstat/ftruncate
> >>> failure.
> >>>
> >>> Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> Reviewed-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> >>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>
> >> I see this has reviews already, but I'm not conviced 1 is the right
> >> return on error.
> >>
> >> i.e. the error condition just prior returns 0:
> >>
> >>         fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
> >>         if (fd < 0)
> >>                 return 0;
> >>
> >> but OTOH if copy_file_range_cmd() fails we return nonzero.  Argh.
> >>
> >> Is there a rhyme or reason here that I'm missing?  Is it broken now
> >> so just do a coinflip on the new return for now?
> > 
> > Pretty much. :(
> > 
> > I don't really care if you change the return value, I just thought it
> > was bad form not to check the syscall/helper return values at all.
> 
> Yeah no argument there.  Ok, so this function already returns inconsistently,
> I'll worry about that later (I hope)

I think I've still got a patch sitting around that fixes the
inconsistent return values across most of xfs_io. Oh, I posted it at
one point, too.

https://marc.info/?l=linux-xfs&m=152644986309024&w=2

I guess I should resurrect it at some point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
