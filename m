Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BFB487F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:54:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C2E38F8037
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:54:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	teAzBHhWiuhN40Fd for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:54:33 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:54:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: compat_xfs_bstat does not have forkoff
Message-ID: <20141001225420.GB10298@dastard>
References: <1411954886-12200-1-git-send-email-david@fromorbit.com>
	<20140929104318.GA10847@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140929104318.GA10847@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 29, 2014 at 03:43:18AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 29, 2014 at 11:41:26AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > struct compat_xfs_bstat is missing the di_forkoff field and so does
> > not fully translate the structure correctly. Fix it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_ioctl32.c | 2 ++
> >  fs/xfs/xfs_ioctl32.h | 3 ++-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any chance to get an xfstests test that verifies the forkoff value?
> Even if it would only reproduce this bug when running 32-bit userspace
> on a 64-bit kernel it would be useful I think.

There are already xfs_fsr tests that are dependent on forkoff being
set to correctly defrag a file successfully. The fact that nobody
has noticed that these fail tends to imply nobody runs xfstests with
a 32 bit userspace on 64 bit kernels....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
