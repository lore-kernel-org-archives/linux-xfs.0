Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Jcr6l093443 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:38:54 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	o8Cz1yq76vIKkaSh for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:40:23 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:40:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] 260: Add another corner case where length is zero
Message-ID: <20121009194019.GJ23644@dastard>
References: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 02:16:52PM +0200, Lukas Czerner wrote:
> This commit adds another corner case to test FITRIM argument handling.
> In this case we set length to zero and we expect the number of discarded
> bytes to be obviously zero, however we've had bug in both ext4 and xfs
> where the internal variable would underflow. This test case will be able
> to catch that in future.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I'd create another test for this, rather than making 260 suddenly
fail for everyone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
