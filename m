Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46F747F58
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 16:17:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3606A8F8035
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 14:17:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XwDR339m6tPd2mAq for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2014 14:17:49 -0800 (PST)
Date: Wed, 24 Dec 2014 09:17:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Keep sb_bad_features2 consistent with sb_features2
Message-ID: <20141223221746.GI4521@dastard>
References: <1418848046-11265-1-git-send-email-jack@suse.cz>
	<20141217212255.GZ24183@dastard>
	<20141218095919.GA13705@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141218095919.GA13705@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Dec 18, 2014 at 10:59:19AM +0100, Jan Kara wrote:
> On Thu 18-12-14 08:22:55, Dave Chinner wrote:
> > On Wed, Dec 17, 2014 at 09:27:26PM +0100, Jan Kara wrote:
> > > Currently when we modify sb_features2, we store the same value also in
> > > sb_bad_features2. However in most places we forget to mark field
> > > sb_bad_features2 for logging and thus it can happen that a change to it
> > > is lost. This results in an inconsistent sb_features2 and
> > > sb_bad_features2 fields e.g. after xfstests test xfs/187.
> > > 
> > > Fix the problem by changing XFS_SB_FEATURES2 to actually mean both
> > > sb_features2 and sb_bad_features2 fields since this is always what we
> > > want to log. This isn't ideal because the fact that XFS_SB_FEATURES2
> > > means two fields could cause some problem in future however the code is
> > > hopefully less error prone that it is now.
> > 
> > Actually, I have patches that fix this differently that I'm planning
> > to push for the 3.20 cycle.  They get rid of the "update random SB
> > fields" problem altogether simply by logging and updating the entire
> > SB every time.
> > 
> > http://oss.sgi.com/archives/xfs/2014-09/msg00448.html
>   OK, thanks for info.

FWIW, I'll pull the fixes you have posted and rebase the rework I
have on top of them. That way we have fixes that can be backported
easily without pulling the entire rework in the commit history.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
