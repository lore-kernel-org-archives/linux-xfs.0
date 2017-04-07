Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28156 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdDGXfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 19:35:05 -0400
Date: Fri, 7 Apr 2017 16:35:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfsprogs/db: fix a segfault by bailing out the print
 on a corrupted block
Message-ID: <20170407233501.GO4864@birch.djwong.org>
References: <1491551344-5236-1-git-send-email-shan.hai@oracle.com>
 <1491551344-5236-2-git-send-email-shan.hai@oracle.com>
 <563080c2-e716-1685-98d2-857c0660ee25@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <563080c2-e716-1685-98d2-857c0660ee25@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Shan Hai <shan.hai@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 02:31:44PM -0500, Eric Sandeen wrote:
> On 4/7/17 2:49 AM, Shan Hai wrote:
> > The print command of the xfs_db would cause segfault on a corrupted
> > or CRC error block, fix it by bailing out the print when encountered
> > a corrupted or CRC error block, below is an example to reproduce the
> > segfault:
> > 
> > mkfs.xfs -f /dev/sda1
> > xfs_db -r -c "agf 0" -c "addr rmaproot" -c "p" /dev/sda1
> > Metadata CRC error detected at xfs_rmapbt block 0x0/0x1000
> > Segmentation fault (core dumped)
> 
> Simply refusing to print any structure with corruption would
> defeat the purpose of xfs_db, I think - it is difficult to
> analyze a corrupted structure if you cannot examine it.
> 
> Today:
> 
> # xfs_db -x fsfile2
> xfs_db> inode 128
> xfs_db> write -c core.magic 0x4949
> Allowing write of corrupted data and bad CRC
> core.magic = 0x4949
> xfs_db> quit
> 
> # xfs_db -x fsfile2
> xfs_db> inode 128
> Metadata corruption detected at xfs_inode block 0x80/0x2000
> Metadata CRC error detected for ino 128
> xfs_db> p core.magic
> core.magic = 0x4949
> xfs_db> 
> 
> i.e. we can read the structure and print the values even
> if it is corrupted.
> 
> but with your change on the same damaged inode:
> 
> xfs_db> p core.magic
> data corrupted or CRC error
> xfs_db> 
> 
> That's not useful.
> 
> I think you need to find the root cause of the segfault, and handle
> it if possible, instead of refusing to print any corrupted structures.

For corrupted btree blocks, the reason for the segfault is that we call
block_to_bt to find the btree geometry based on the magic number.  If
the block's magic number doesn't match any of the known btree magics, it
returns NULL and btblock_*_offset blow up on the NULL pointer.

The iocursor already knows the supposed type of the thing we're looking
at, so if we don't get a match on the magic number we could try using
the iocursor type to look up the supposed btree geometry, and use that
to print the btblock fields.

Of course once we do that we run into the next problem, which is that
when numrecs is too large, we happily print arrays right off the end of
the buffer and crash.

Eh, having worked all that out I might as well pretty the patches and
send them.

--D

> 
> -Eric
> 
> > Signed-off-by: Shan Hai <shan.hai@oracle.com>
> > ---
> >  db/print.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/db/print.c b/db/print.c
> > index e31372f..08bb39a 100644
> > --- a/db/print.c
> > +++ b/db/print.c
> > @@ -69,11 +69,19 @@ print_f(
> >  	char	**argv)
> >  {
> >  	pfunc_t	pf;
> > +	int err;
> >  
> >  	if (cur_typ == NULL) {
> >  		dbprintf(_("no current type\n"));
> >  		return 0;
> >  	}
> > +
> > +	err = iocur_top->bp->b_error;
> > +	if ((err == -EFSCORRUPTED) || (err == -EFSBADCRC)) {
> > +		dbprintf(_("data corrupted or CRC error\n"));
> > +		return 0;
> > +	}
> > +
> >  	pf = cur_typ->pfunc;
> >  	if (pf == NULL) {
> >  		dbprintf(_("no print function for type %s\n"), cur_typ->name);
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
