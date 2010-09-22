Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MMZlVJ087400 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 17:35:48 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5672291272
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:36:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	H4pkCIANPY5nIFnG for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 15:36:41 -0700 (PDT)
Date: Thu, 23 Sep 2010 08:36:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Contiguous file sequences
Message-ID: <20100922223637.GG2614@dastard>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<20100922205052.GA32059@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922205052.GA32059@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Daire Byrne <daire.byrne@gmail.com>, xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 10:50:52PM +0200, Matthias Schniedermeyer wrote:
> On 22.09.2010 12:01, Daire Byrne wrote:
> > Hi,
> 
> ....
> 
> 
> There is actually a VERY easy solution nowadays. SSD(s)
> 
> It doesn't matter if files are continuous or not, SSDs don't care (at 
> least the better ones)

IO size and alignment still matters for performance on SSDs, just
not as much as for spinning rust.  That is, large sqeuental IOs are
still much faster on SSDs than lots of small random IOs.  Even on a
fusionIO card, large IOs will get 2-3x the _best case_ throughput of
small, random IOs.

> If you care about "worst case" write performance, zap the whole thing 
> before usage (a.k.a.: trim) and write in chunks that are sized and 
> aligned to erase-blocks (or just write in big chunks like 1MB or more). 
> That should be more or less be enough to prevent latency spikes, that 
> CAN plague SSDs.

Which is exactly why filesystem layout still matters with SSDs. If
the filesystem lays out files contiguously, and does IO mostly in
large chunks, then the SSDs age a lot better (as does the
filesystem) and performance shouldn't degrade significntly with
time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
