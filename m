Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44A917F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 12:15:13 -0500 (CDT)
Date: Thu, 25 Jul 2013 12:15:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 03/48] libxfs: add crc format changes to generic btrees
Message-ID: <20130725171509.GZ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-4-git-send-email-david@fromorbit.com>
	<20130723182648.GI3111@sgi.com> <20130725004821.GC11222@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725004821.GC11222@dastard>
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
Cc: xfs@oss.sgi.com

Dave,

On Thu, Jul 25, 2013 at 10:48:21AM +1000, Dave Chinner wrote:
> On Tue, Jul 23, 2013 at 01:26:48PM -0500, Ben Myers wrote:
> > On Fri, Jun 07, 2013 at 10:25:26AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > This patch mostly corresponds to commit ee1a47ab0e, and in some areas it is
> > equivalent but slightly different.  There are some other things in here too:
> > 
> > * Addition of XFS_BUF_DADDR_NULL
> > * rename of b_blkno to b_bn in struct xfs_buf
> > * rename of b_fsprivate to b_fspriv in struct xfs_buf
> > * addition of uuid_copy and uuid_equal, and libuuid to build
> > 
> > It all looks fine to me, except as below:
> 
> I think you'll find they are fixed up in later patches in the
> series.
> 
> Indeed, I think it's a little late to asking for these patches to be
> changed, considering that making significant changes to these first
> few patches will mean that I have to rebase a 100 or so subsequent
> patches.

You are mistaken...
 
> For issues that aren't fixed in later patches, I'll add new patches
> to the end of the current series to fix them.

...but I have no objection to taking this approach, so long as my
concerns are addressed.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
