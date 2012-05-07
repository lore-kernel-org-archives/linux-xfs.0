Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47K5IBw148423 for <xfs@oss.sgi.com>; Mon, 7 May 2012 15:05:18 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id WGO9ypATpK4yAgBw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 13:05:17 -0700 (PDT)
Message-ID: <4FA82B07.1020102@profihost.ag>
Date: Mon, 07 May 2012 22:05:27 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
In-Reply-To: <4FA7FA14.6080700@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 07.05.2012 18:36, schrieb Stan Hoeppner:
> This shows what I originally suspected.  Notice how top heavy this
> histogram is.  Over half of your free space sits on little islands of
> 8MB or less.  17% is in islands of 60KB or less.  This is heavily
> fragmented free space.  Contrast this with an XFS from the opposite end
> of the aging spectrum that is only 1/3rd full and has seen very few
> deletes as it has aged:
...
>
> Notice how it is very bottom heavy, and that 85% of the free space is in
> large islands of 16GB to 24GB.
This totally makes sense too me. Thanks for this explanation.

> Stefan, at this point in your filesystem's aging process, it may not
> matter how much space you keep freeing up, as your deletion of small
> files simply adds more heavily fragmented free space to the pool.  It's
> the nature of your workload causing this.
This makes sense - do you have any idea or solution for this? Are 
Filesystems, Block layers or something else which suits this problem / 
situation?

> What I would suggest is doing an xfsdump to a filesystem on another LUN
> or machine, expand the size of this LUN by 50% or more (I gather this is
> an external RAID), format it appropriately, then xfsrestore.  This will
> eliminate your current free space fragmentation, and the 50% size
> increase will delay the next occurrence of this problem.  If you can't
> expand the LUN, simply do the xfsdump/format/xfsrestore, which will give
> you contiguous free space.
But this will only help for a few month or perhaps a year.

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
