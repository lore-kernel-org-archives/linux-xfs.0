Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3B907CB1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 08:22:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63CB3AC005
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 06:22:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 692vwR8aVhEyIABD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 06:22:17 -0800 (PST)
Date: Tue, 2 Feb 2016 15:22:12 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Split default quota limits by quota type V3
Message-ID: <20160202142212.GA5630@redhat.com>
References: <1454000266-22541-1-git-send-email-cmaiolino@redhat.com>
	<56AA51B7.7030403@sandeen.net> <20160201095707.GB8141@redhat.com>
	<20160201212238.GV6033@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160201212238.GV6033@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 08:22:38AM +1100, Dave Chinner wrote:
> On Mon, Feb 01, 2016 at 10:57:07AM +0100, Carlos Maiolino wrote:
> > On Thu, Jan 28, 2016 at 11:36:55AM -0600, Eric Sandeen wrote:
> > > On 1/28/16 10:57 AM, Carlos Maiolino wrote:
> > > >  		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
> > > >  
> > > > -		/*
> > > > -		 * The warnings and timers set the grace period given to
> > > > -		 * a user or group before he or she can not perform any
> > > > -		 * more writing. If it is zero, a default is used.
> > > > -		 */
> > > 
> > > Not sure why you removed this comment?
> > > 
> > Regarding this comment, I think it's just redundant with the previous comment, I
> > left it in the code for the V4 though, I believe Dave can rip it off if it is
> > really redundant.
> 
> No, please don't ask me to do make random patch edits on commit -
> it's your job as a patch submitter to get it right. I will sometimes
> do this for simple patches or patches that come from a
> never-seen-before-and-never-seen-again patch submitter, but for a
> regular developer submitting non-trivial patches I won't change the
> patches because the issue hasn't been sorted out during peer review.
> 
Hey, I apologize, I had no intention to give you any extra job :) I meant that
in case you agreed or not with the comment, I thought you could decide by
ripping the comment off or not, I had no intention to actually give you some
unfinished job.

In any case, I sent a V4 of this patch with the comment's change Eric suggested,
adding his review-by too, although, a quick look from him again would be nice,
I'll figure it out with him.

cheers.


> Work it out with Eric, get a reviewed-by tag, and I'll apply it as
> reviewed.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
