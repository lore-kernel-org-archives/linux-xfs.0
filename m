Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CF0B7F53
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 20:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3859DAC005
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 18:24:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vGe472Po84DtOIWu for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 18:24:57 -0700 (PDT)
Date: Tue, 9 Jul 2013 11:23:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709012344.GG3438@dastard>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard> <20130709004332.GB23174@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130709004332.GB23174@gmail.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Jul 09, 2013 at 08:43:32AM +0800, Zheng Liu wrote:
> Hi Dave,
> 
> On Mon, Jul 08, 2013 at 10:44:53PM +1000, Dave Chinner wrote:
> [...]
> > So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
> > 3.10-cil kernel I've been testing XFS on):
> > 
> > 	    create		 walk		unlink
> > 	 time(s)   rate		time(s)		time(s)
> > xfs	  222	266k+-32k	  170		  295
> > ext4	  978	 54k+- 2k	  325		 2053
> > btrfs	 1223	 47k+- 8k	  366		12000(*)
> > 
> > (*) Estimate based on a removal rate of 18.5 minutes for the first
> > 4.8 million inodes.
> > 
> > Basically, neither btrfs or ext4 have any concurrency scaling to
> > demonstrate, and unlinks on btrfs a just plain woeful.
> > 
> > ext4 create rate is limited by the extent cache LRU locking:
> 
> I have a patch to fix this problem and the patch has been applied into
> 3.11-rc1.  The patch is (d3922a77):
>   ext4: improve extent cache shrink mechanism to avoid to burn CPU time
> 
> I do really appreicate that if you could try your testing again against
> this patch.  I just want to make sure that this problem has been fixed.
> At least in my own testing it looks fine.

I'll redo them when 3.11-rc1 comes around. I'll let you know how
much better it is, and where the next ring of the onion lies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
