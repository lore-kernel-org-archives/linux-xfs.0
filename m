Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p736rwmV138726 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 01:53:58 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15F6C1836E3F
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 23:53:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lK1Rtth5huUE3OJz for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2011 23:53:56 -0700 (PDT)
Date: Wed, 3 Aug 2011 16:53:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Help: XFS failure in AoE environment
Message-ID: <20110803065351.GK12870@dastard>
References: <CAOJJ1Zp9YTKxCr2H-betxrTWSdQ0joWCBQXJFyOQm364RLFHJg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOJJ1Zp9YTKxCr2H-betxrTWSdQ0joWCBQXJFyOQm364RLFHJg@mail.gmail.com>
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
To: Lee Eric <openlinuxsource@gmail.com>
Cc: aoetools-discuss@lists.sourceforge.net, xfs@oss.sgi.com

On Wed, Aug 03, 2011 at 01:31:58PM +0800, Lee Eric wrote:
> Hi,
> 
> I encounter following error when I do rw operate(touch afile) in a
> mounted AoE device.
> 
> [246817.267117] end_request: I/O error, dev etherd/e0.0, sector 2112
> [246817.269673] I/O error in filesystem ("etherd/e0.0p1") meta-data
> dev etherd/e0.0p1 block 0x40       ("xfs_trans_read_buf") error 5 buf
> count 8192
> [246817.271625] xfs_imap_to_bp: xfs_trans_read_buf()returned an error
> 5 on etherd/e0.0p1.  Returning error.
> [246817.273679] aoe: device 0.0 is not up
.....
> It happens several times, is there any way to fix that?

Your AoE setup is broken in some way. Fix that, and then XFS won't
have problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
