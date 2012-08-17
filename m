Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7H1hM3g227810 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 20:43:22 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4Og7bThUDCuQ2y2S for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 18:43:20 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1T2BaG-0004a1-K1
	for xfs@oss.sgi.com; Fri, 17 Aug 2012 11:42:44 +1000
Date: Fri, 17 Aug 2012 11:42:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Make inode64 a remountable option
Message-ID: <20120817014244.GA2877@dastard>
References: <1345142110-6412-1-git-send-email-cmaiolino@redhat.com>
	<502D56B9.9080606@redhat.com>
	<20120817012030.GB16013@orion.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120817012030.GB16013@orion.usersys.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Aug 16, 2012 at 10:20:30PM -0300, Carlos Maiolino wrote:
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > I do have a question though... do we care about the remount from inode64
> > to non-inode64 case?
> > 
> I thought about it, but, once we enable inode64 option, remounting it back to
> inode32 may create problems to access inodes greater than (1<<32) - 1, so, I
> don't think we should make inode32 a remountable option.

You can still read, modify and unlink inodes w/ numbers greater than
32 bits when inode32 is active - you just can't allocate new inodes
in those AGs. Hence going back the other way would still be safe to
do on remount, I think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
