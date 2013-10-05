Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 260497F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 22:22:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 105B7304064
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 20:22:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TWTlrVscBS6Fwcgy for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 20:22:04 -0700 (PDT)
Date: Sat, 5 Oct 2013 13:21:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RESEND: xattr issue with 3.11 kernel
Message-ID: <20131005032112.GM4446@dastard>
References: <ED5C1C84-614E-4EBB-A966-BBCD9CE89373@inktank.com>
	<20131004210411.GJ4446@dastard>
	<6ECC8063-935A-4DD6-A460-4B7D8AE24271@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6ECC8063-935A-4DD6-A460-4B7D8AE24271@inktank.com>
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
To: David Zafman <david.zafman@inktank.com>
Cc: ceph-devel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 04, 2013 at 03:16:05PM -0700, David Zafman wrote:
> 
> Dave,
> 
> The 3.12-rc3 kernel passed my test.  Thanks for the quick response.

Good to hear.

....

> > You are probably hitting the problem fixed in commit 997def2 ("xfs:
> > fix node forward in xfs_node_toosmall") which went into 3.12-rc3.
> > Can you test that this fixes your problem, ad if so, we'll need to
> > push it back to -stable kernels..

Ben, can you push this fix back to the -stable kernels
that require it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
