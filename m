Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDE997F55
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 18:27:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC1768F8035
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 16:27:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	v7P3KYCJwCF211oP for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 16:27:23 -0700 (PDT)
Date: Fri, 2 May 2014 09:27:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140501232720.GD22353@dastard>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
	<1398719099-19194-6-git-send-email-david@fromorbit.com>
	<20140429140619.GC59046@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140429140619.GC59046@bfoster.bfoster>
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

On Tue, Apr 29, 2014 at 10:06:19AM -0400, Brian Foster wrote:
> On Tue, Apr 29, 2014 at 07:04:55AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > repair doesn't currently detect verifier errors in AG header
> > blocks - apart from the primary superblock they are not detected.
> > They are, fortunately, corrected in the important cases (AGF, AGI
> > and AGFL) because these structures are rebuilt in phase 5, but if
> > you run xfs_repair in checking mode it won't report them as bad.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > @@ -1312,21 +1302,34 @@ scan_ag(
> >  	validate_agi(agi, agno, agcnts);
> >  
> >  	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
> > +	ASSERT(agf_dirty == 0 || (agf_dirty && !no_modify));
> > +	ASSERT(sb_dirty == 0 || (sb_dirty && !no_modify));
> > +
> > +	/*
> > +	 * Only pay attention to CRC/verifier errors if we can correct them.
> > +	 * While there, ensure that we corrected a corruption error if the
> > +	 * verifier detected one.
> > +	 */
> > +	if (!no_modify) {
> > +		ASSERT(agi_dirty || agibuf->b_error != EFSCORRUPTED);
> > +		ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);
> > +		ASSERT(sb_dirty || sbbuf->b_error != EFSCORRUPTED);
> > +
> > +		agi_dirty += (agibuf->b_error == EFSBADCRC);
> > +		agf_dirty += (agfbuf->b_error == EFSBADCRC);
> > +		sb_dirty += (sbbuf->b_error == EFSBADCRC);
> > +	}
> 
> So we'll detect and correct the CRC error in normal mode, but no longer
> issue the preceding warnings ("would reset bad ...") for CRC errors in
> no_modify mode. Is that desired?

It will still throw a bad CRC error, so the user is still told that
there is a problem.

> I ask because it looks like a departure from previous versions.
> Otherwise, the code looks fine to me.

Slightly, but I don't think it makes much difference...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
