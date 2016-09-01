Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E92667CA1
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 16:46:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F3EBAC002
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 14:46:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	L81nzSKwf9VqBqkw for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 14:46:23 -0700 (PDT)
Date: Fri, 2 Sep 2016 07:46:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160901214617.GE30056@dastard>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
	<20160901103955.GD27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160901103955.GD27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 01, 2016 at 06:39:55PM +0800, Eryu Guan wrote:
> On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> > kernel but not with 4.8-rc2
> > 
> [snip]
> >
> > So it's likely a regression introduced in 4.8-rc3, and my bisect test
> > pointed to commit 0af32fb468b4 ("xfs: fix bogus space reservation in
> > xfs_iomap_write_allocate").
> 
> This might be buried in the report, I've bisected this down to
> 
> commit 0af32fb468b4a4434dd759d68611763658650b59
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Aug 17 08:30:28 2016 +1000
> 
>     xfs: fix bogus space reservation in xfs_iomap_write_allocate

*nod*. I did notice that - it's what I based my previous "this is
what I think it causing the warning" email on. i.e. we're dirtying a
AGF/AGFL to update the freelist, then finding we don't have space in
the AG for the data allocation, then we ENOSPC and cancel a dirty
transaction.

I'm not going to back this change out right now, because it does fix
other, much easier to hit issues. I think it has probably uncovered
another "off-by-one" corner case in the "can we use the AG"
calculations, so when I get a chance I'll look through the code
and see what I can find. A faster reproducer would make that a lot
easier, so if you manage to find one, I woul dbe very helpful.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
