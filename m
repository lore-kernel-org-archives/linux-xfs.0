Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q635rVam061214 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 00:53:32 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vZjER8WAzDqmkO3j for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 22:53:31 -0700 (PDT)
Date: Tue, 3 Jul 2012 01:53:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: xfs_btree_cur leak with 3.5-rc4
Message-ID: <20120703055324.GA7129@redhat.com>
References: <20120702191412.GA3617@redhat.com> <20120703002611.GW19223@dastard>
	<20120703012628.GA5710@redhat.com> <20120703032136.GZ19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703032136.GZ19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

On Mon, Jul 02 2012 at 11:21pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Jul 02, 2012 at 09:26:28PM -0400, Mike Snitzer wrote:
> > On Mon, Jul 02 2012 at  8:26pm -0400,
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Mon, Jul 02, 2012 at 03:14:12PM -0400, Mike Snitzer wrote:
> > > > I get kmemleak reports against XFS when I run the thinp-test-suite
> > > > against 3.5-rc4.  I didn't see any XFS leaks with 3.4.
> > > 
> > > Already fixed in 3.5-rc5:
> > > 
> > > 76d0953 xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
> > 
> > Odd, I already have that fix (as it was included in 3.5-rc4).
> 
> I misread the git describe as saying it was included after -rc4. My
> mistake. That indicates that the above fix wasn't quite correct...
> 
> Try the patch below.

Looks good.  Thanks.

Tested-by: Mike Snitzer <snitzer@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
