Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DMlpKg217715 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 17:47:51 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F5941C851EB
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 15:47:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lRHCnr6qnX3O3qwg for <xfs@oss.sgi.com>;
	Thu, 13 Oct 2011 15:47:48 -0700 (PDT)
Date: Fri, 14 Oct 2011 09:47:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: libxfs: Don't forget to initialize the radix
	tree subsystem
Message-ID: <20111013224744.GO3159@dastard>
References: <201110131850.p9DIoEvU006578@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110131850.p9DIoEvU006578@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 13, 2011 at 01:50:14PM -0500, Alex Elder wrote:
> The libxfs code uses radix tree routines to manage a mount
> point's m_perag_tree.  But the radix tree routines assume
> that radix_tree_init() has been called to initialize the
> height_to_maxindex[] global array, and this was not being
> done.
> 
> This showed up when running mkfs.xfs on an ia64 system.  Since
> it wasn't initialized, the array was filled with zeroes.  The
> first time radix_tree_extend() got called (with index 0), the
> height would be set to 1 and all would seem fine.
> 
> The *second* time it got called (with index 1) a problem would
> arise--though we were apparently "lucky" enough for it not to
> matter.  The following loop would simply reference invalid slots
> beyond the end of the array until it happened upon one that was
> non-zero.  (I've expanded the function radix_tree_maxindex() here.)
> 
>         /* Figure out what the height should be.  */
>         height = root->height + 1;
>         while (index > height_to_maxindex[height])
>                 height++;
> 
> As an example, this looped 1937 times before it found a non-zere
> value that would cause it to break out of the loop.
> 
> Even that *seemed* to be OK.  But at the end of mkfs.xfs, when
> it calls libxfs_umount(), non-initialized "slots" are dereferenced
> and we hit a fault.
> 
> Wow.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

/me wonders why valgrind didn't catch that

Anyway, the fix looks good, and well caught!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
