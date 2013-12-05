Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E340E7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 21:59:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE84030408E
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 19:59:44 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kC95irBXQ4FX0ULH for <xfs@oss.sgi.com>;
	Wed, 04 Dec 2013 19:59:42 -0800 (PST)
Date: Thu, 5 Dec 2013 14:59:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131205035938.GJ8803@dastard>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<20131205034034.GI8803@dastard>
	<1423a84e-a9e3-4053-bb7c-fdf2d53eeefc@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423a84e-a9e3-4053-bb7c-fdf2d53eeefc@email.android.com>
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
To: Mike Dacre <mike.dacre@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 04, 2013 at 07:46:06PM -0800, Mike Dacre wrote:
> Hi Dave, 
> 
> My apologies, I completely miscommunicated.  The drive dying was
> unrelated, it happened two months ago. I mentioned it only as
> background info, but I realize now that was stupid. There were no
> drive or RAID problems at all at the time the XFS mount died
> today. The drives are all fine and the RAID log shows nothing
> significant. 

Still could be significant. Do you run periodic media scrubs on that
raid array?

And if it's not significant, then there's nothing that I can sugest
that woul dhave caused the problem. For all we know about the state
of the system at the time the problem occurred, it could have been
caused by a cosmic ray flipping a bit somewhere in the IO path. i.e.
trying to diagnose a failure like this without any other errors
showing and no corrupt filesystem image we can examine is no better
than trying to guess where the needle is in a haystack...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
