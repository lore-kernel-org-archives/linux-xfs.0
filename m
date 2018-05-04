Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbeEDUWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 16:22:42 -0400
Date: Fri, 4 May 2018 13:22:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] xfs_repair: zap corrupt remote symlink
Message-ID: <20180504202220.GL26569@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401961698.13319.6780338835004190495.stgit@magnolia>
 <95da5fba-4cb6-ddd2-6111-54f8c2cc77e0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95da5fba-4cb6-ddd2-6111-54f8c2cc77e0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, May 04, 2018 at 02:46:35PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If a remote symlink has a corrupted remote block, just zap the symlink.
> > Fixes total lack of repair activity in xfs/382.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Huh.  Yup! Weird omission...
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Though I don't think "symlink remote" means much to an admin, *shrug*
> I suppose it helps us triage.
> 
> > ---
> >  repair/dinode.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > 
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index 9af4f05..ceffc52 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -1330,6 +1330,13 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
> >  				lino, i, fsbno);
> >  			return 1;
> >  		}
> > +		if (bp->b_error == -EFSCORRUPTED) {
> > +			do_warn(
> > +_("Corrupt symlink remote, block %" PRIu64 ", inode %" PRIu64 ".\n"),

Remove comma, pretty please? ^^^

--D

> > +				fsbno, lino);
> > +			libxfs_putbuf(bp);
> > +			return 1;
> > +		}
> >  		if (bp->b_error == -EFSBADCRC) {
> >  			do_warn(
> >  _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
