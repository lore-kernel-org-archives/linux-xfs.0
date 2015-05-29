Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 279C57F3F
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 17:31:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 082958F8039
	for <xfs@oss.sgi.com>; Fri, 29 May 2015 15:31:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pSpiv8oTKV6kdu9J for <xfs@oss.sgi.com>;
	Fri, 29 May 2015 15:31:30 -0700 (PDT)
Date: Sat, 30 May 2015 08:31:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to cddc116
Message-ID: <20150529223105.GC24666@dastard>
References: <20150528215309.GA15721@dastard> <20150528222109.GC4316@dastard>
	<20150529120549.GA36053@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150529120549.GA36053@bfoster.bfoster>
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

On Fri, May 29, 2015 at 08:05:49AM -0400, Brian Foster wrote:
> On Fri, May 29, 2015 at 08:21:09AM +1000, Dave Chinner wrote:
> > On Fri, May 29, 2015 at 07:53:09AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > The for-next branch of the xfs kernel repository at
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > > 
> > > has just been updated.
> > > 
> > > The new head of the for-next branch is commit:
> > > 
> > > cddc116 xfs: xfs_iozero can return positive errno
> > 
> > Note: i just updated it again with a patch I missed in the
> > xfs-for-linus-v4.1-rc6 branch:
> > 
> > Brian Foster (1):
> >       [22419ac] xfs: fix broken i_nlink accounting for whiteout tmpfile inode
> > 
> 
> Any word on the following two as well?
> 
> http://oss.sgi.com/pipermail/xfs/2015-April/041504.html
> http://oss.sgi.com/pipermail/xfs/2015-May/041582.html

I've got them queued up for the 4.2 cycle (haven't pushed the branch
yet) because I didn't think they were really critical.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
