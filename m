Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7502E7F3F
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 02:23:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C80B304048
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 00:23:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7LfWFjRktW6u1PCB for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 00:23:38 -0700 (PDT)
Date: Mon, 11 May 2015 17:23:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs: master branch updated to v3.2.3-rc1
Message-ID: <20150511072335.GC15721@dastard>
References: <20150511005524.GE16689@dastard>
	<20150511053523.GA29703@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150511053523.GA29703@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, May 10, 2015 at 10:35:23PM -0700, Christoph Hellwig wrote:
> On Mon, May 11, 2015 at 10:55:25AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
> > just been updated. This update is the first candidate for a
> > v3.2.3 release, so please test and report any problems you find.
> > 
> > The new head of the master branch is commit:
> > 
> > c8c0837 xfsprogs: update for 3.2.3-rc1 release
> 
> FYI, I don't think enabling v5 file system without at least a minor
> version bump makes sense.  While I'm not fan of release number inflation
> this might even be a case for a major number bump to 4.x.

I don't really think it is necessary. SLES 12 is already using CRCs
as the default XFS configuration for filesystems created by YaST, so
the cat is already out of the bag. And, historically speaking,
changing mkfs defaults has never been considered a compelling reason
to do a major/minor version bump so I haven't even bothered trying
to argue for that as I've never been successful in the past...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
