Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754232AbeAHUcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 15:32:31 -0500
Date: Mon, 8 Jan 2018 12:32:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: clarify units in the failed metadata io message
Message-ID: <20180108203225.GV5602@magnolia>
References: <20180108194015.GT5602@magnolia>
 <fb402d1c-c609-77de-8ae8-6cb19aadd448@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb402d1c-c609-77de-8ae8-6cb19aadd448@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Jan 08, 2018 at 02:19:58PM -0600, Eric Sandeen wrote:
> On 1/8/18 1:40 PM, Darrick J. Wong wrote:> From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If a metadata IO error happens, we report the location of the failed IO
> > request in units of daddrs.  However, the printk message misleads people
> > into thinking that the units are fs blocks, so fix the reported units.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_buf.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 1981ef7..582c64a 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1196,7 +1196,7 @@ xfs_buf_ioerror_alert(
> >  	const char		*func)
> >  {
> >  	xfs_alert(bp->b_target->bt_mount,
> > -"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
> > +"metadata I/O error: daddr 0x%llx (\"%s\") error %d numblks %d",
> >  		(uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
> Ok, so I might have nodded in approval on IRC a little early; if "block"
> was misleading, I think "numblks" is too.  So if you change one to
> daddr, I wonder if the other should be changed as well to, um ...
> 
> 
> "metadata I/O error: daddr 0x%llx (\"%s\") error %d count %d"

"metadata I/O error in ("\%s\") at daddr 0x%llx len %d error %d"

also:
"%s: daddr out of range: block 0x%llx, EOFS 0x%llx ", __func__, b_bn, eofs

"%s: no ops on buf for daddr 0x%llx/0x%x", __func__, b_bn, b_length

"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!"

So I guess it's also not consistent how we print buffer length either?
I'll work on something to clean all this up...

--D

> ?  That's a bit vague but at least not misleadingly containing a form of
> "blocks" - whatchathink?  Maybe "len?"  Even "sectors" is a bit overloaded
> now.  :(
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
