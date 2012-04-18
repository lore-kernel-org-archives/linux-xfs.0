Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3IIIljT222716 for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 13:18:52 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DC218F804B
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2012 11:18:42 -0700 (PDT)
Date: Wed, 18 Apr 2012 13:14:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
Message-ID: <20120418181407.GC16881@sgi.com>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
	<4F8C22D4.3040908@sgi.com> <20120416235432.GZ6734@dastard>
	<20120417042023.GG6734@dastard> <20120417082633.GH6734@dastard>
	<4F8EBE13.9040207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F8EBE13.9040207@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Apr 18, 2012 at 08:13:55AM -0500, Mark Tinguely wrote:
> On 04/17/12 03:26, Dave Chinner wrote:
> >On Tue, Apr 17, 2012 at 02:20:23PM +1000, Dave Chinner wrote:
> >
> >commit 281627df3eb55e1b729b9bb06fff5ff112929646
> >Author: Christoph Hellwig<hch@infradead.org>
> >Date:   Tue Mar 13 08:41:05 2012 +0000
> >
> >     xfs: log file size updates at I/O completion time
> >
> >That confirms my analysis above - the problem is being exposed by new
> >code in the writeback path that does transaction allocation where it
> >didn't used to.
> >
> >Clearly the problem is not really the new code in Christoph's
> >patches - it's an existing freeze problem that has previously
> >resulted in data writes occuring after a freeze has completed (of
> >which we have had rare complaints about). That sounds pretty dire,
> >except for one thing: Jan Kara's patch set that fixes all these
> >freeze problems:
> >
> >https://lkml.org/lkml/2012/4/16/356
> >
> >And now that I've run some testing with Jan's patch series, along
> >with Christoph's and mine (75-odd patches ;), a couple of my test
> >VMs have been running test 068 in a tight loop for about half an
> >hour without a hang, so I'd consider this problem fixed by Jan's
> >freeze fixes given I could reliably hang it in 2-3 minutes before
> >adding Jan's patch set to my stack.
> >
> >So the fix for this problem is getting Jan's patch set into the
> >kernel at the same time we get the inode size logging changes into
> >the kernel. What do people think about that for a plan?
> >
> >Cheers,
> >
> >Dave.
> 
> Good job.
> 
> Jan's freeze patch set is at v5 and seems to be settling down. What
> is the status of Jan's freeze code getting into the kernel?

The trouble I was having yesterday seems to be related to the i386 box on which
I was running.  Apparently something has regressed badly since 3.3 on that
i386.  Seems to be working fine on another x86_64 machine.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
