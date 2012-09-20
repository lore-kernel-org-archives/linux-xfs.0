Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KMbiF0142679 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 17:37:45 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NMbxkNtwwFhV4LHs for <xfs@oss.sgi.com>;
	Thu, 20 Sep 2012 15:38:56 -0700 (PDT)
Date: Fri, 21 Sep 2012 08:38:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions on RAID alignment
Message-ID: <20120920223852.GI31501@dastard>
References: <505AF9EA.7030603@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505AF9EA.7030603@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 01:11:38PM +0200, Spelic wrote:
> Hello list
> a few questions
> 
> 1- Does XFS support alignment to concatenation RAIDs (e.g. linear
> over raid1) similarly to striped ones?

No. It's being considered and I know how to do it, but it's lower
priority than other stuff I'm working on at the moment. 

> I am guessing probably su and
> sw should not be specified and the agcount should be multiple of the
> number of the concatenated devices, is that correct?

If you are concatenating RAID0/5/6, then you shoul duse su/sw as per
the alignment of the volumes being concatenated.

> 2- Can mkfs parameters be altered after creation, e.g. after growing
> a RAID and then growing the XFS fs, can I also alter su, sw, agcount
> somehow?

You can alter su/sw as a mount option if the filesystem was made
with them initially.

> 3- I seem to remember there was an xattr that one could attach to
> /home (if /home was under XFS) so that every user (subdir of /home)
> would get a different AG in a different RAID device. I cannot find
> that information anymore on the internet; could you refresh my mind?

Nothing of the sort. if you are using the inode64 allocator, then
each new directory is placed i a different AG. That's as good as it
gets right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
