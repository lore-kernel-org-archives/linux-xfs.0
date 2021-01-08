Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA560C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 20:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 859C523A7F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 20:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbhAHUpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 15:45:47 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:54731 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727055AbhAHUpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 15:45:47 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A9CBA85E8;
        Sat,  9 Jan 2021 07:45:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kxyd4-004R9x-Sr; Sat, 09 Jan 2021 07:45:02 +1100
Date:   Sat, 9 Jan 2021 07:45:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org
Subject: Re: Disk aligned (but not block aligned) DIO write woes
Message-ID: <20210108204502.GJ331610@dread.disaster.area>
References: <20ce6a14-94cf-c8ef-8219-7a051fb6e66a@scylladb.com>
 <20210104150601.GA130750@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210104150601.GA130750@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=8nJEP1OIZ-IA:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=XKtqyQ745IcFWCLiatoA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 04, 2021 at 10:06:01AM -0500, Brian Foster wrote:
> On Mon, Dec 28, 2020 at 05:57:29PM +0200, Avi Kivity wrote:
> > I observe that XFS takes an exclusive lock for DIO writes that are not block
> > aligned:
> > 
> > 
> > xfs_file_dio_aio_write(
> > 
> > {
> > 
> > ...
> > 
> >        /*
> >          * Don't take the exclusive iolock here unless the I/O is unaligned
> > to
> >          * the file system block size.  We don't need to consider the EOF
> >          * extension case here because xfs_file_aio_write_checks() will
> > relock
> >          * the inode as necessary for EOF zeroing cases and fill out the new
> >          * inode size as appropriate.
> >          */
> >         if ((iocb->ki_pos & mp->m_blockmask) ||
> >             ((iocb->ki_pos + count) & mp->m_blockmask)) {
> >                 unaligned_io = 1;
> > 
> >                 /*
> >                  * We can't properly handle unaligned direct I/O to reflink
> >                  * files yet, as we can't unshare a partial block.
> >                  */
> >                 if (xfs_is_cow_inode(ip)) {
> >                         trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos,
> > count);
> >                         return -ENOTBLK;
> >                 }
> >                 iolock = XFS_IOLOCK_EXCL;
> >         } else {
> >                 iolock = XFS_IOLOCK_SHARED;
> >         }
> > 
> > 
> > I also see that such writes cause io_submit to block, even if they hit a
> > written extent (and are also not size-changing, by implication) and
> > therefore do not require a metadata write. Probably due to "|| unaligned_io"
> > in
> > 
> > 
> >         ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> >                            &xfs_dio_write_ops,
> >                            is_sync_kiocb(iocb) || unaligned_io);
> > 
> > 
> > Can this be relaxed to allow writes to written extents to proceed in
> > parallel? I explain the motivation below.
> > 
> 
> From the above code, it looks as though we require the exclusive lock to
> accommodate sub-block zeroing that might occur down in the dio code.
> Without it, concurrent sector granular I/Os to the same block could
> presumably cause corruption if the data bios and associated zeroing bios
> were reordered between two requests.
> 
> Looking down in the iomap/dio code, iomap_dio_bio_actor() triggers
> sub-block zeroing if the associated range is unaligned and the mapping
> is either unwritten or new (i.e. newly allocated for this write). So as
> you note above, there is no such zeroing for a pre-existing written
> block within EOF. From that, it seems reasonable to me that in principle
> the filesystem could check for these conditions in the higher layer and
> further restrict usage of the exclusive lock.

Yuck, no.

> That said, we'd probably
> have to rework the above code to acquire the shared lock first,
> read/check the extent state for the start/end blocks of the I/O and then
> cycle out to the exclusive lock in the cases where it is required.

Yes, that requires mapping lookups above the iomap layer, then
repeating them again in the iomap layer and having to juggle the
locking to ensure the iomap code gets the same result.  This also
requires taking the ILOCK to decide how to lock the IOLOCK, which
inverts all the IO path locking in nasty, bug prone ways. We tried
very hard to get rid of all those layering violations and lock
dances in the IO path with iomap - the old DIO code was a never
ending source of locking bugs because we had to play locking games
like this....

>
> It's
> not immediately clear to me if we'd still want to set the wait flag in
> those unaligned-but-no-zeroing cases. Perhaps somebody who knows the dio
> code a bit better can chime in further on all of this..

As I explained quickly on #xfs over xmas/ny time - because it seems
like 4 or 5 people all asked for this at the same time - I suspect
we can do this with IOMAP_NOWAIT directives for unaligned IO under
shared locking.

That is, if the unaligned dio is going to require allocation or
sub-block zeroing or would otherwise block, the filesystem mapping
code returns EAGAIN to iomap_apply() which propagates back to the
filesystem submitting the DIO which can then take exclusive lock and
resubmit the unaligned DIO, this time without the nowait semantics.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
