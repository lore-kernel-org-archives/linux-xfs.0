Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B04D7CA2
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2016 00:53:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EEDA304032
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2016 22:53:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rIiAtV8pXzV2zYxK for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2016 22:53:34 -0700 (PDT)
Date: Mon, 19 Sep 2016 15:53:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] libxfs: remove ustat() use, factor mount checks into
	helper function
Message-ID: <20160919055332.GD340@dastard>
References: <ed60d5a2-0343-fd49-236e-52f9442291d2@redhat.com>
	<a4e1e08e-1f5f-82b4-7dc2-52ede960aa39@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4e1e08e-1f5f-82b4-7dc2-52ede960aa39@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 08, 2016 at 09:16:11AM -0500, Eric Sandeen wrote:
> ustat() has been deprecated for a very long time, and newer
> architectures (aarch64, for one) have not implemented it.
> If called, it always returns false, so we can no longer use
> it to determine a device's mounted status.
> 
> We already have another mechanism for determining the mounted
> status of a device in platform_check_iswritable; it iterates
> over getmntent looking for the device, and checks its mount
> options.  We can do the same thing to check for a simple mount,
> and not caring about the "ro" mount option.
> 
> Because the loop is essentially the same, factor it into a
> helper which accepts a VERBOSE flag to print info if the device
> is found in the checked-for state, and a WRITABLE flag which
> only checks specifically for a mounted and /writable/ device.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Dave, up to you if you want to take all this in lieu of the
> fixed-up patch from Felix, or if you'd like me to rebase this
> once you have merged that patch.  Happy to do that if you'd like -
> now that I think about it, that may be the cleaner progression
> of changes.

Rebase, please, as it does not apply to the current tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
