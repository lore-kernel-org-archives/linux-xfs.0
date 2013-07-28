Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75E157F5F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 20:07:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 557D0304053
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 18:07:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VnngBGx8iK6cSW5q for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 18:07:48 -0700 (PDT)
Date: Sun, 28 Jul 2013 11:07:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/49] xfs: minor cleanups
Message-ID: <20130728010744.GW13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-23-git-send-email-david@fromorbit.com>
	<51F40ACA.40601@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F40ACA.40601@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 27, 2013 at 01:00:42PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:24, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >These come from syncing the shared userspace and kernel code. Small
> >whitespace and trivial cleanups.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> okay, minor clean-ups
> 
> Don't understand the change from min_t to min:
> 
> >diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> >index 13a0ed9..b42926a 100644
> >--- a/fs/xfs/xfs_attr_remote.c
> >+++ b/fs/xfs/xfs_attr_remote.c
> >@@ -251,7 +251,7 @@ xfs_attr_rmtval_copyout(
> >  		int hdr_size = 0;
> >  		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
> >
> >-		byte_cnt = min_t(int, *valuelen, byte_cnt);
> >+		byte_cnt = min(*valuelen, byte_cnt);

min_t is only needed when the types being compared are different.
I.e. it ensures the comparison is done with the appropriate casts on
the items being compared. However, both variables being compared
here are of the same type (int) and so the type casting of min_t is
not necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
