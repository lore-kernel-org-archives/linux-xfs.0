Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAD6929DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:24:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C94C38F8040
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 13:24:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oHBH2nKJbxjgZzIl for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 13:24:49 -0700 (PDT)
Date: Wed, 22 May 2013 06:24:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/11] xfs: fixes for 3.10-rc3
Message-ID: <20130521202445.GO24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<20130521162647.GD19505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521162647.GD19505@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 11:26:47AM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, May 21, 2013 at 06:01:59PM +1000, Dave Chinner wrote:
> > This is my current kernel bug fix patch series. I've updated it
> > against a current xfsdev tree, and contains all the fixes mentioned
> > in the "fixes for 3.10-rc2 (updated)" thread. The first 7 patches
> > are patches from that series. The last 4 are new patches.
> >
> > The first new patch stops CRC enabled filesystems from spamming the
> > log. It currently emits an "Experimental" warning ever time the
> > superblock is written, which is typically every 30s.
> >
> > The second path ("rework remote attr CRCs") is the changes I
> > mentioned in the "fixes for 3.10-rc2 (updated)" thread. The code is
> > far more robust as a result of these changes, and I think we really
> > need to change the format as done in this patch. Once we have
> > decided on the way forward, I'll port this to userspace.
> > 
> > The third patch fixes a remote symlink problem - I didn't hit this
> > until I'd redone the remote attr CRCs and the 1k block size
> > filesystem testing made it passed the attribute tests it was failing
> > on.
> > 
> > Finally, the last patch is another on-disk format change - one that
> > removes the 25 entry limit on ACLs. It doesn't invalidate anything
> > that is already on disk, just allows ACLs on v5 superblock
> > filesystems to store more than 25 ACLs in an xattr. In fact, it
> > allows (65536 - 4) / 12 = 5461 entries to be stored in a single
> > ACL, so I don't see anyone running out on v5 superblocks....
> > 
> > Thoughts, comments?
> 
> I'll look into these but I am concerned that we're starting to get into 3.11
> territory.

The moment we release the first kernel with the format in it, we
need to use feature bits for on-disk format changes, experimental
tag or not. Hence IMO this needs to be fixed before an initial
release.

It's not a huge change from a code perspective, and it's a lot more
reliable in my testing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
