Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28063 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932108AbdDZRpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 13:45:15 -0400
Date: Wed, 26 Apr 2017 10:45:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs_db: don't print arrays off the end of a buffer
Message-ID: <20170426174510.GO5205@birch.djwong.org>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186446737.32572.10101366339282682603.stgit@birch.djwong.org>
 <a7b683c8-54a1-a12b-5f49-35fc743b1d73@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7b683c8-54a1-a12b-5f49-35fc743b1d73@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 12:12:38PM -0500, Eric Sandeen wrote:
> On 4/10/17 5:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Before printing an array, clamp the array count against the size of the
> > buffer so that we don't print random heap contents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/print.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > 
> > diff --git a/db/print.c b/db/print.c
> > index e31372f..0caad8f 100644
> > --- a/db/print.c
> > +++ b/db/print.c
> > @@ -144,6 +144,17 @@ print_flist_1(
> >  			if (fl->flags & FL_OKHIGH)
> >  				count = min(count, fl->high - low + 1);
> >  			if (fa->prfunc) {
> > +				int	fsz;
> > +				int	bitlen;
> > +
> > +				/* Don't read an array off the end of the buffer */
> > +				fsz = fsize(f, iocur_top->data, parentoff, 0);
> > +				bitlen = iocur_top->len * NBBY;
> > +				if ((f->flags & FLD_ARRAY) &&
> > +				    fl->offset + (count * fsz) > bitlen) {
> > +					count = (bitlen - fl->offset) / fsz;
> > +				}
> > +
> >  				neednl = fa->prfunc(iocur_top->data, fl->offset,
> >  					count, fa->fmtstr,
> >  					fsize(f, iocur_top->data, parentoff, 0),
> 
> can we just re-use fsz here in the prfunc call?

Yeah, we could reuse it.

--D

> 
> Otherwise seems fine, and I could do that on commit.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
