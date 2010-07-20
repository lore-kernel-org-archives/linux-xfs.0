Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KNFGlZ046637 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 18:15:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A9B51BE3F74
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:18:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	5S3MnNqDC39QqsPh for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 16:18:15 -0700 (PDT)
Date: Wed, 21 Jul 2010 09:18:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow delete
Message-ID: <20100720231809.GR32635@dastard>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<201007121417.14097@zmi.at> <1279565697.1855.136.camel@doink>
	<201007201304.28490@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007201304.28490@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 01:04:28PM +0200, Michael Monnerie wrote:
> Can someone guess the exact problems that can happen with delayed 
> transaction on a crash?

There should be no difference in behaviour, just that more
operations will appear not to have been executed after crash
recovery.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
