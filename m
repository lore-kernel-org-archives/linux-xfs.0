Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7KsQs5179043 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 14:54:26 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rdmBCXePL1VDfPVP for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 12:56:23 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TWCfd-0002VR-KN
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 07:56:21 +1100
Date: Thu, 8 Nov 2012 07:56:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] xfs: fixes for 3.7-rc3
Message-ID: <20121107205621.GH6434@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 11:38:38AM +1100, Dave Chinner wrote:
> Hi Ben,
> 
> Here are my current outstanding fixes that are candidates for 3.7.
> Patches 2 and 3 are the initial fixes from the verifier series (real
> bugs) and the other are regressions that I've recently fixed. Some
> need to be sent back to stable kernels as well and are tagged as
> such.

Hi Ben,

What's the status with these? It's been almost a week since I posted
them, and apart from patch 5, they are all good to go to Linus. IMO,
patch 5 is also good to go as well, but I don't mind if that is not
sent immediately as that one is not as critical as the others.

I'm particularly concerned because of the bug that patch 6 fixes -
it's a real corruption bug that users are hitting we need to get it
upstream and back into the stable kernels ASAP. But this patch
hasn't even been committed to the dev tree yet...

Can you please get these upstream ASAP? If you don't have the time
to do it today, let me know so I can send the patches straight to
Linus and get them to the upstream and stable trees that way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
