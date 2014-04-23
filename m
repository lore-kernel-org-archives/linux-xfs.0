Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8222C7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 03:11:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 743E2304051
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 01:11:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cI0iBQP0XFvfgFMG for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 01:11:53 -0700 (PDT)
Date: Wed, 23 Apr 2014 18:11:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fragmentation on file append
Message-ID: <20140423081150.GQ18672@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
	<CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
	<20140423054719.GJ15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423054719.GJ15995@dastard>
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
To: Keyur Govande <keyurgovande@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 03:47:19PM +1000, Dave Chinner wrote:
> On Tue, Apr 22, 2014 at 07:35:34PM -0400, Keyur Govande wrote:
> > I noticed that XFS chooses the AG based on the parent directory's AG
> > and only the next sequential one if there's no space available.
> 
> Yes, that's what the inode64 allocator does. It tries to keep files
> in the same directory close together.
> > @@ -517,7 +517,7 @@ xfs_ialloc_ag_select(
> >          * to mean that blocks must be allocated for them,
> >          * if none are currently free.
> >          */
> > -       agno = pagno;
> > +       agno = ((xfs_agnumber_t) prandom_u32()) % agcount;
> >         flags = XFS_ALLOC_FLAG_TRYLOCK;
> >         for (;;) {
> >                 pag = xfs_perag_get(mp, agno);
> 
> Ugh. That might fix the interleaving, but it randomly distributes
> related files over the entire filesystem. Hence if you have random
> access to the files (like a database does) you now have random seeks
> across the entire filesystem rather than within AGs. You basically
> destroy any concept of data locality that the filesystem has.

BTW, the inode32 allocator (it's a mount option) does this. it's no
longer the default because a) it's always had terrible behaviour for
general workloads compared to inode64 and b) we don't care enough
about 32 bit applications failing to use stat64() anymore to stay
with inode32 by default...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
