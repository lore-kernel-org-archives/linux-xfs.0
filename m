Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9079B7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 16:52:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E7EC8F8071
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:52:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kBVNnsZ6bejIKMe3 for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 14:52:27 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:52:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140415215214.GO15995@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
	<20140415194029.GC3470@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415194029.GC3470@laptop.bfoster>
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

On Tue, Apr 15, 2014 at 03:40:29PM -0400, Brian Foster wrote:
> On Tue, Apr 15, 2014 at 06:24:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > repair doesn't currently detect verifier errors in AG header
> > blocks - apart from the primary superblock they are not detected.
> > They are, fortunately, corrected in the important cases (AGF, AGI
> > and AGFL) because these structures are rebuilt in phase 5, but if
> > you run xfs_repair in checking mode it won't report them as bad.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -1285,7 +1287,7 @@ scan_ag(
> >  			do_warn(_("would reset bad agf for ag %d\n"), agno);
> >  		}
> >  	}
> > -	if (status & XR_AG_AGI)  {
> > +	if (agi_dirty || status & XR_AG_AGI)  {
> >  		if (!no_modify) {
> >  			do_warn(_("reset bad agi for ag %d\n"), agno);
> >  			agi_dirty = 1;
> 
> There are a few asserts a bit further down this function that assume
> *_dirty is set only when in !no_modify mode. E.g.:
> 
> 	ASSERT(agi_dirty == 0 || (agi_dirty && !no_modify));
> 
> You'll probably want to remove those. Or...

I thought I caught all of those...

> 
> > @@ -1295,15 +1297,9 @@ scan_ag(
> >  	}
> >  
> >  	if (status && no_modify)  {
> > -		libxfs_putbuf(agibuf);
> > -		libxfs_putbuf(agfbuf);
> > -		libxfs_putbuf(sbbuf);
> > -		free(sb);
> > -
> >  		do_warn(_("bad uncorrected agheader %d, skipping ag...\n"),
> >  			agno);
> > -
> > -		return;
> > +		goto out_free;
> >  	}
> 
> Would we want to skip the ag, as such, on a CRC error in no_modify mode?
> If so, perhaps we could set the status variable on crc errors and
> bitwise or the value returned from verify_set_agheader().

I figured that for CRC errors we really should try to validate
everything if we can. If nothing else fails the validation, then it
might be a bit flip in an unused portion of the sector and in that
case we can actually continue onwards. IOWs, a CRC error is not
necessarily fatal....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
