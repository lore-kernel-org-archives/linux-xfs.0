Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o950OXmG125255 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 19:24:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15ABAC2514
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 17:25:34 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	H9t49K8wVUNlh8MJ for <xfs@oss.sgi.com>;
	Mon, 04 Oct 2010 17:25:34 -0700 (PDT)
Date: Tue, 5 Oct 2010 11:25:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.35.6 XFS: Inconsistent lock state
Message-ID: <20101005002531.GK4681@dastard>
References: <20101004224830.GJ30524@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101004224830.GJ30524@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Oct 04, 2010 at 03:48:30PM -0700, Simon Kirby wrote:
> Out of the blue, while running postfix+mailscanner:
> 

False positive - reclaim will never be attempting to lock an active
inode. IIRC The page cache allocation in .36 now uses GFP_NOFS, so
this should go away when you update to a newer kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
