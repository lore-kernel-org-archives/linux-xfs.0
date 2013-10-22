Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48D487F5D
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 19:12:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 373FC30407B
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 17:12:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ACWVSNCvOn9S1zMq for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 17:12:47 -0700 (PDT)
Date: Tue, 22 Oct 2013 11:12:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 128 bits extent bmap for file format 2
Message-ID: <20131022001218.GH4446@dastard>
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
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
To: Pradeep Kumar <praks411@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 22, 2013 at 01:32:22AM +0200, Pradeep Kumar wrote:
> Hi,
> 
> I'm writing a small utility to parse XFS fs image on windows.
> I'm able to fetch the files in the first AG (0).
> However when it comes to the files which are in different AG I'm facing
> some problem in parsing extent bmap 128bits data of file inode (format ==
> 2).

Extents use filesystem block encodings, not disk addresses. Look up
the macros XFS_DADDR_TO_FSB and XFS_FSB_TO_DADDR.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
