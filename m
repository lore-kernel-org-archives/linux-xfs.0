Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0919E7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 17:23:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4F948F8037
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 15:22:57 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wEIK244tbB7AJfjF for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 15:22:52 -0800 (PST)
Date: Fri, 7 Mar 2014 10:22:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/13] repair: phase 1 does not handle superblock CRCs
Message-ID: <20140306232238.GN6851@dastard>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
	<1393923117-9559-14-git-send-email-david@fromorbit.com>
	<20140306160155.GA11842@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140306160155.GA11842@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 06, 2014 at 11:01:55AM -0500, Brian Foster wrote:
> On Tue, Mar 04, 2014 at 07:51:57PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Phase 1 of xfs_repair verifies and corrects the primary
> > superblock of the filesystem. It does not verify that the CRC of the
> > superblock that is found is correct, nor does it recalculate the CRC
> > of the superblock it rewrites.
> > 
> > This happens because phase1 does not use the libxfs buffer cache -
> > it just uses pread/pwrite on a memory buffer, and works directly
> > from that buffer. Hence we need to add CRC verification to
> > verify_sb(), and CRC recalculation to write_primary_sb() so that it
> > works correctly.
> > 
> > This also enables us to use get_sb() as the method of fetching the
> > superblock from disk after phase 1 without needing to use the libxfs
> > buffer cache and guessing at the sector size. This prevents a
> > verifier error because it attempts to CRC a superblock buffer that
> > is much longer than the usual sector sizes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  repair/agheader.c   |  2 +-
> >  repair/globals.h    |  3 ++-
> >  repair/phase1.c     |  5 ++--
> >  repair/protos.h     |  3 ++-
> >  repair/sb.c         | 71 +++++++++++++++++++++++++++++------------------------
> >  repair/xfs_repair.c | 26 +++++++++++---------
> >  6 files changed, 62 insertions(+), 48 deletions(-)
> > 
> > diff --git a/repair/agheader.c b/repair/agheader.c
> > index 53e47b6..fc5dac9 100644
> > --- a/repair/agheader.c
> > +++ b/repair/agheader.c
> > @@ -472,7 +472,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
> >  	int status = XR_OK;
> >  	int status_sb = XR_OK;
> >  
> > -	status = verify_sb(sb, (i == 0));
> > +	status = verify_sb(sbuf->b_addr, sb, (i == 0));
> >  
> >  	if (status != XR_OK)  {
> >  		do_warn(_("bad on-disk superblock %d - %s\n"),
> > diff --git a/repair/globals.h b/repair/globals.h
> > index cbb2ce7..f6e0a22 100644
> > --- a/repair/globals.h
> > +++ b/repair/globals.h
> > @@ -49,7 +49,8 @@
> >  #define XR_BAD_SB_UNIT		17	/* bad stripe unit */
> >  #define XR_BAD_SB_WIDTH		18	/* bad stripe width */
> >  #define XR_BAD_SVN		19	/* bad shared version number */
> > -#define XR_BAD_ERR_CODE		20	/* Bad error code */
> > +#define XR_BAD_CRC		20	/* Bad CRC */
> > +#define XR_BAD_ERR_CODE		21	/* Bad error code */
> >  
> >  /* XFS filesystem (il)legal values */
> >  
> > diff --git a/repair/phase1.c b/repair/phase1.c
> > index 62de211..ec75ada 100644
> > --- a/repair/phase1.c
> > +++ b/repair/phase1.c
> > @@ -70,13 +70,14 @@ phase1(xfs_mount_t *mp)
> >  	ag_bp = alloc_ag_buf(MAX_SECTSIZE);
> >  	sb = (xfs_sb_t *) ag_bp;
> >  
> > -	if (get_sb(sb, 0LL, MAX_SECTSIZE, 0) == XR_EOF)
> > +	rval = get_sb(sb, 0LL, MAX_SECTSIZE, 0);
> > +	if (rval == XR_EOF)
> >  		do_error(_("error reading primary superblock\n"));
> >  
> >  	/*
> >  	 * is this really an sb, verify internal consistency
> >  	 */
> 
> This comment can probably go away now. Otherwise, looks good...
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Ok, thanks. I'll kill the comment in a followup patch that touches
this code again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
