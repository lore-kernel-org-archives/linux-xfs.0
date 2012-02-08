Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q185KTsS037001
	for <linux-xfs@oss.sgi.com>; Tue, 7 Feb 2012 23:20:30 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VvPGfELLHQ6rnjD6 for <linux-xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 21:20:27 -0800 (PST)
Date: Wed, 8 Feb 2012 16:20:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair, xfs_metadump trouble with fs
Message-ID: <20120208052025.GG20305@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bpb909x2jm.ln2@goaway.wombat.san-francisco.ca.us>
	<nsa809x68g.ln2@goaway.wombat.san-francisco.ca.us>
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
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-xfs@oss.sgi.com

On Tue, Feb 07, 2012 at 11:33:11AM -0800, Keith Keller wrote:
> Hi XFS list,
> 
> I'm having some strange trouble with xfs_repair and xfs_metadump, which
> I am hoping you can help with.  I have an xfs filesystem which is backed
> by an mdraid/LVM combination.  Recently two drives failed in the RAID6,
> then during the rebuild another disk failed.  I was able to salvage the
> array by using ddrescue to copy the failed drive to a new drive (only
> 8k were lost).  Once I did that, I turned to xfs_repair to check that
> the filesystem was okay.
> 
> So far, it has reported a large number of errors, but consistently gets
> stuck during phase 3.  I have used xfsprogs 3.1.7 as well as the latest
> clone from git, and have also used -P and not used -P, with no luck.  I
> have saved stderr, but it is extremely large.  Nothing obvious
> distinguishes the last stderr messages from previous messages, where it
> might indicate why xfs_repair has stalled.  (I can post stderr or make
> it available by HTTP if it helps.)

.....
> On 2012-02-07, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> >
> > So far, it has reported a large number of errors, but consistently gets
> > stuck during phase 3.
> 
> I am not at all clear on what happened, but xfs_repair is no longer
> stuck.

That sounds like you've got dodgy storage to me (e.g. losing an IO),
or that it just took a long time to process something.

> The downside is, it's finding a huge number of problems on the
> filesystem.  What are the odds that the fs is actually usable when the
> repair completes?  It's hard to imagine a repair that generates ~2GB of
> output on stderr could be good news (so far; granted I did use -v).

Not good if there are lots of problems. Indeed, even losing 8k can
cause serious problems if that 8k is in siginificant indexes and
they are too damaged to be recovered.  That has cascade effects and
usually results in lots of stuff in lost+found.  Without knowing
what the corruption is or seeing the output, that's the best I can
say....

Cheers,

Dave.

> 
> --keith
> 
> 
> 
> -- 
> kkeller@wombat.san-francisco.ca.us
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
