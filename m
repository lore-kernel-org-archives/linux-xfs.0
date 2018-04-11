Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbeDKD3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 23:29:04 -0400
Date: Tue, 10 Apr 2018 20:28:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
Message-ID: <20180411032858.GX7500@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
 <20180405035241.GB7500@magnolia>
 <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 11:13:03PM -0500, Eric Sandeen wrote:
> On 4/4/18 10:52 PM, Darrick J. Wong wrote:
> > On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
> >> In order to validate the UUID in xfs_dquot_verify, we need
> >> the full xfs_qblk, not just the xfs_disk_dquot_t (which is
> > 
> >           ^^^^^^^^^ xfs_dqblk, right?
> 
> yup
> 
> ...
> 
> >> @@ -192,14 +191,10 @@
> > 
> > Any way you can get your diff generator to add -p to spit out the
> > alleged function this chunk is supposed to land in?  It makes reviewing
> > patches somewhat easier for me. :)
> 
> No doubt ... I don't know why it doesn't do so, sorry.  :/  Will try
> to figure that out.  Sorry about that.
> 
> >>  	 * buffer so corruptions could point to the wrong dquot in this case.
> >>  	 */
> >>  	for (i = 0; i < ndquots; i++) {
> >> -		struct xfs_disk_dquot	*ddq;
> >> -
> >> -		ddq = &d[i].dd_diskdq;
> >> -
> >>  		if (i == 0)
> >> -			id = be32_to_cpu(ddq->d_id);
> >> +			id = be32_to_cpu(d[i].dd_diskdq.d_id);
> >>  
> >> -		fa = xfs_dquot_verify(mp, ddq, id + i, 0);
> >> +		fa = xfs_dquot_verify(mp, &d[i], id + i, 0);
> >>  		if (fa)
> >>  			return fa;
> >>  	}
> 
> ...
> 
> >> @@ -1013,9 +1018,6 @@
> >>  		return -EIO;
> >>  	}
> >>  
> >> -	/* This is the only portion of data that needs to persist */
> >> -	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
> > 
> > About this memcpy() -- isn't the point of this function that we verify
> > the contents of the in-core q_core and only memcpy the contents into the
> > xfs_buf if it actually passes validation?
> 
> yeah, but if it fails here we release the buffer & shut down the filesystem ;)
> 
> > I guess the _dquot_verify
> > function needs the entire on-disk buffer so that it can validate the crc
> 
> narrator:  xfs_dquot_verify doesn't verify the crc ;)

Sorry, my brain was all discombobulated last week. :(

> > and the uuid on a read, but we update the crc on dqflush and
> > (presumably) can set the uuid on write (quotacheck) or fail the dquot
> > read everywhere else, right?
> > 
> > Put another way, why not have xfs_dquot_buf_verify check the uuid?
> > xfs_dquot_repair seems to reset the uuid if it's garbage.
> 
> Well, the above path (xfs_qm_dqflush) isn't going to do repair...
> 
> But OK, xfs_dquot_buf_verify does the entire dqblk; it iterates over
> each dquot calling xfs_dquot_verify.  I figured the easiest way to
> get uuid validation was to put it into xfs_dquot_verify.
> 
> But I guess you're suggesting a separate uuid check in xfs_dquot_buf_verify 
> to validate the uuid, given that it has the full on-disk dquot?  Ok that
> might make sense...

Eh, now that I've figured out what all these patches are trying to do
(and figured out what hunks are modifying which functions) this is a lot
clearer to me.  The UUID check should be in the structure verifier, not
the crc verifier, as you point out.

So the more I reread this series the more I think they're ok, though you
might want to fix the things Christoph pointed out on this patch.

(I'll review the repair side of things whenever you get to that.)

--D

> Thanks,
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
