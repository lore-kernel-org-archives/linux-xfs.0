Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B41A97CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 19:24:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D789AC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 17:24:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	q4CuIE5htYejMJJA for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 17:24:22 -0700 (PDT)
Date: Mon, 12 Aug 2013 10:24:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 24/49] xfs: introduce
	xfs_quota_defs.h
Message-ID: <20130812002418.GH12779@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-25-git-send-email-david@fromorbit.com>
	<51FFF856.1050600@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51FFF856.1050600@sgi.com>
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

On Mon, Aug 05, 2013 at 02:09:10PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:44, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >There are a lot of quota flag definitions that are shared by user
> >and kernel space. Move them all to xfs_quota_defs.h so we can
> >unshare xfs_quota.h and remove the __KERNEL__ regions from it.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> 
> xfsprogs equivalent of the for 3.12 kernel patch 09/49.
> 
> move remaining quota shared entries from xfs_quota.h to
> xfs_quota_defs.h - as mentioned in patch 20, xfs_quota.h is now
> kernel-only and removed.
>            ----
> 
>   should shared files have a common name? - so far the ended in -format.X

No. The -format.h suffix is used specifically for on-disk format
definitions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
