Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E5687CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 19:48:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA571AC003
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 17:48:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FnyUE4AgZWurxCKL for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 17:48:52 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:48:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/48] libxfs: add crc format changes to generic btrees
Message-ID: <20130725004821.GC11222@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-4-git-send-email-david@fromorbit.com>
	<20130723182648.GI3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130723182648.GI3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 23, 2013 at 01:26:48PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:26AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This patch mostly corresponds to commit ee1a47ab0e, and in some areas it is
> equivalent but slightly different.  There are some other things in here too:
> 
> * Addition of XFS_BUF_DADDR_NULL
> * rename of b_blkno to b_bn in struct xfs_buf
> * rename of b_fsprivate to b_fspriv in struct xfs_buf
> * addition of uuid_copy and uuid_equal, and libuuid to build
> 
> It all looks fine to me, except as below:

I think you'll find they are fixed up in later patches in the
series.

Indeed, I think it's a little late to asking for these patches to be
changed, considering that making significant changes to these first
few patches will mean that I have to rebase a 100 or so subsequent
patches.

For issues that aren't fixed in later patches, I'll add new patches
to the end of the current series to fix them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
