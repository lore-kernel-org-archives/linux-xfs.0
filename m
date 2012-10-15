Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FLYh6B240967 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 16:34:43 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	jwydJiIUj1n8Piad for <xfs@oss.sgi.com>;
	Mon, 15 Oct 2012 14:36:18 -0700 (PDT)
Date: Tue, 16 Oct 2012 08:36:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db
Message-ID: <20121015213616.GD2739@dastard>
References: <CACBF2D716C5104BAC48A16827DE5B1513576996C6@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
	<507C766A.3000400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507C766A.3000400@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Anshul Kundra <anshul.kundra@hcl.com>

On Mon, Oct 15, 2012 at 03:47:38PM -0500, Eric Sandeen wrote:
> On 10/15/12 9:34 AM, Anshul Kundra wrote:
> > Suppose in XFS file system I want to corrupt a inode of my choice,
> > will it be possible using xfs_db
> > 
> > Xfs_db blockget < inode number > blocktrash < seed value and type of
> > block >
> > 
> > In the manuals it is written that it takes a random inodes for the
> > corruption which it does in actual practice, so can I use any
> > specific command to corrupt the inode (131 )
> 
> As the manual says, blocktrash trashes random metadata blocks (possibly
> of specified type).
> 
> You can, however, write whatever you want into various fields of
> inode 131 via xfs_db, there's just no built-in random method to
> do that.

A better question might be: "why do you want to corrupt a specific
inode"? To test repair, or online detection, or something else?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
