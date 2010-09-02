Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o821pXGU175925 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 20:51:33 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67ACA43533
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 18:52:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	s5LglEvTDYesWjIj for <xfs@oss.sgi.com>;
	Wed, 01 Sep 2010 18:52:11 -0700 (PDT)
Date: Thu, 2 Sep 2010 11:52:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: broken XFS filesystem not to be repaired by xfs_repair 3.1.2
Message-ID: <20100902015207.GT705@dastard>
References: <201009010226.46771@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009010226.46771@zmi.at>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 01, 2010 at 02:26:46AM +0200, Michael Monnerie wrote:
> http://zmi.at/x/big.xfs.metadump.bz2
> 
> After I did the big "rm -r" on that 4TB volume, 4 subdirs with a file in 
> each are still left even after 20 "xfsrepair;mount;rm -r;umount" cycles. 
> So I dare to say it can't be repaired here.

Ok, so those inodes have corrupted data/attribute forks - I'd say
they are victims of the xfs_fsr swapext problems with dynamic
attribute forks.

I'll use the image to write a fix for repair to detect and correct
the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
