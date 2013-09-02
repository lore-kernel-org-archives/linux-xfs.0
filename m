Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F87329DFB
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 17:20:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E13DC30406B
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 15:20:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	B76ob2a32W7mh3OZ for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 15:20:40 -0700 (PDT)
Date: Tue, 3 Sep 2013 08:20:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: fix some new memory allocation failures
Message-ID: <20130902222004.GI12779@dastard>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
	<5224C4E9.8080604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5224C4E9.8080604@sgi.com>
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

On Mon, Sep 02, 2013 at 12:03:37PM -0500, Mark Tinguely wrote:
> On 09/02/13 05:52, Dave Chinner wrote:
> >Hi folks,
> >
> >These failures are a result of order-4 allocations being done on v5
> >filesystems to support the large ACL count xattrs. The first patch
> >puts out usual falbback to vmalloc workaround in place. The second
> >patch factors all the places we now have this fallback-to-vmalloc
> >and makes it transparent to the callers.
> >
> >Cheers,
> >
> >Dave.
> 
> Thanks for clean up. Broken record time: Do we really need order
> allocation in the filesystem? Esp in xfs_ioctl.c.

I don't understand your question. Are you asking why we need high
order allocation?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
