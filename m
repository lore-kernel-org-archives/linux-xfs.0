Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B93927F72
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 20:16:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7944B304039
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2014 18:16:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sckFabuZIPeMmtBF for <xfs@oss.sgi.com>;
	Mon, 17 Mar 2014 18:16:37 -0700 (PDT)
Date: Tue, 18 Mar 2014 12:16:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140318011632.GA9192@dastard>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140316022105.GQ18016@ZenIV.linux.org.uk>
	<20140316023931.GR18016@ZenIV.linux.org.uk>
	<20140316205624.GS18016@ZenIV.linux.org.uk>
	<20140317013638.GB7072@dastard> <20140317024305.GD7072@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317024305.GD7072@dastard>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Mon, Mar 17, 2014 at 01:43:05PM +1100, Dave Chinner wrote:
> On Mon, Mar 17, 2014 at 12:36:39PM +1100, Dave Chinner wrote:
> > On Sun, Mar 16, 2014 at 08:56:24PM +0000, Al Viro wrote:
> > > Looks like __xfs_get_blocks() is broken in that respect - I'm definitely
> > > seeing O_DIRECT write() crossing the EOF calling it *once*, getting
> > > ->b_size set to a lot more than what remains until EOF and buffer_head
> > > not getting BH_New on it.
> > 
> > XFS should never do that. It does not mix existing block mappings
> > with newly allocated mappings, and so the newly allocated region
> > beyond EOF should always give a "xfs_get_blocks_alloc" trace, and
> > when that is emitted we always set buffer_new()....
> 
> And so XFS is not mixing extent types, nor is it seeing newly
> allocated blocks beyond EOF, and so it sees it as a single
> extent full of valid data....
> 
> OK, now I understand where the bad mapping problem is coming from,
> and why a changing in speculative prealloc size might be seen as the
> "cause" by a bisect. And it is a pre-existing condition that has
> been there for years - I'd think that testing with
> allocsize=<something large> would expose it easily on old kernels.
> 
> Al, you're right that the code that calculates the mapping size
> needs to split mappings that extend across EOF for direct IO.  I'll
> cook up a patch to fix it after lunch.

Except that this now leaves stale, unreferenced delalloc extents on
the inode, so there's some other problem being masked by this
behaviour and so generic/270 now assert fails. I'll have to look
further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
