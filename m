Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GNHJW9022929 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 18:17:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8E717C221
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 16:18:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	W1wJW2tu3lWTPjC2 for <xfs@oss.sgi.com>;
	Thu, 16 Sep 2010 16:18:07 -0700 (PDT)
Date: Fri, 17 Sep 2010 09:18:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sector size warning at mount time
Message-ID: <20100916231803.GH24409@dastard>
References: <4C92641F.7080504@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C92641F.7080504@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 16, 2010 at 01:38:23PM -0500, Eric Sandeen wrote:
> On ppc64 I'm tripping this warning:
> 
>         if (verbose &&
>             (PAGE_CACHE_SIZE / BITS_PER_LONG) > sectorsize) {
>                 printk(KERN_WARNING
>                         "XFS: %u byte sectors in use on device %s.  "
>                         "This is suboptimal; %u or greater is ideal.\n",
>                         sectorsize, XFS_BUFTARG_NAME(btp),
>                         (unsigned int)PAGE_CACHE_SIZE / BITS_PER_LONG);
>         }
> 
> and it's telling me I should have 1024-byte sectors...
> 
> If the kernel is going to complain at mount, should we get it right
> at mkfs time?  I'm not even quite sure why it's recommending this?

Because it requires 128 bits to track each sector in page when the
buffer cache is has to use sub-page buffers. That's all the
test/set_region garbage that it has.

The don't-user-the-page-cache part of my buffer cache rework fixes
this bug, so I probably wouldn't bother changing anything else at this
point in time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
