Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C2557F55
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 18:39:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AB2D8F8033
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 16:39:29 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BmE90tgHye24xZa6 for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 16:39:27 -0800 (PST)
Date: Tue, 23 Dec 2014 11:39:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS corruption
Message-ID: <20141223003924.GB4521@dastard>
References: <B97466D39E354AFB808620584A4ABE5C@alyakaslap>
	<54970DD9.6080707@sandeen.net> <20141221230818.GH24183@dastard>
	<20141222144212.GA21897@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141222144212.GA21897@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Dec 22, 2014 at 09:42:12AM -0500, Brian Foster wrote:
> On Mon, Dec 22, 2014 at 10:08:18AM +1100, Dave Chinner wrote:
> > On Sun, Dec 21, 2014 at 12:13:45PM -0600, Eric Sandeen wrote:
> > > On 12/21/14 5:42 AM, Alex Lyakas wrote:
> > > > Greetings,
> > > > we encountered XFS corruption:
> > > 
> > > > kernel: [774772.852316] ffff8801018c5000: 05 d1 fd 01 fd ff 2f ec 2f 8d 82 6a 81 fe c2 0f  .....././..j....    
> > > 
> > > There should have been 64 bytes of hexdump, not just the single line above, no?
> > 
> > Yeah, really need the whole dmesg, because we've got readahead in
> > the picture here so the number of times the corruption error is seen
> > is actually important....
> > 
> > > 
> > > > [813114.622928] IP: [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 [xfs]
> > > > [813114.622928] PGD 0
> > > > [813114.622928] Oops: 0000 [#1] SMP
> > > > [813114.622928] CPU 2
> > > > [813114.622928] Pid: 31120, comm: smbd Tainted: GF       W  O 3.8.13-030813-generic #201305111843 Bochs Bochs
> > > > [813114.622928] RIP: 0010:[<ffffffffa077bad9>]  [<ffffffffa077bad9>] xfs_bmbt_get_all+0x9/0x20 [xfs]
> > > > [813114.622928] RSP: 0018:ffff88010a193798  EFLAGS: 00010297
> > > > [813114.622928] RAX: 0000000000000964 RBX: ffff880180fa9c38 RCX: ffffa5a5a5a5a5a5
> > 
> > RCX implies gotp->br_startblock was not overwritten by the
> > extent search. i.e. we've called xfs_bmap_search_multi_extents()
> > but no extent was actually found.
> > 
> > > > We analyzed several suspects, but all of them fall on disk addresses
> > > > not near the corrupted disk address. I realize that running somewhat
> > > > outdated kernel + our changes within XFSs, points back at us, but
> > > > this is first time we see XFS corruption after about a year of this
> > > > code being exercised. So posting here, just in case this is a known
> > > > issue.
> > > 
> > > well, xfs should _never_ oops, even if it encounters corruption.  So hopefully
> > > we can work backwards from the trace above to what went wrong here.
> > > 
> > > offhand, in xfs_bmap_search_multi_extents():
> > > 
> > >         ep = xfs_iext_bno_to_ext(ifp, bno, &lastx);
> > >         if (lastx > 0) {
> > >                 xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx - 1), prevp);
> > >         }
> > >         if (lastx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
> > >                 xfs_bmbt_get_all(ep, gotp);
> > >                 *eofp = 0;
> > > 
> > > xfs_iext_bno_to_ext() can return NULL with lastx set to 0:
> > > 
> > >         nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
> > >         if (nextents == 0) {
> > >                 *idxp = 0;
> > >                 return NULL;
> > >         }
> > > 
> > > (where idxp is the &lastx we sent in)
> > 
> > > and if we do that, it sure seems like the "if lastx < ...." test will wind up
> > > sending a null ep into xfs_bmbt_get_all, which would do a null ptr deref.
> > 
> > No, it shouldn't because lastx = 0 to get it set that way
> > ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t) must be zero.
> > Therefore, this:
> > 
> > 	if (lastx < (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)))
> > 
> > evaulates as:
> > 
> > 	if (0 < 0)
> > 
> > which is not true, so we fall into the else case:
> > 
> > 	} else {
> >                 if (lastx > 0) {
> >                         *gotp = *prevp;
> >                 }
> >                 *eofp = 1;
> >                 ep = NULL;
> >         }
> >         *lastxp = lastx;
> >         return ep;
> > 
> > Which basically overwrites *eofp and *lastxp, neither of which are
> > NULL.
> > 
> > However, the stack trace clearly shows we've just called
> > xfs_bmap_search_multi_extents() - the "?" before the function name
> > means it found the symbol in the stack, but not in the direct line
> > of the frame pointers the current function stack points to.
> > 
> > That makes me doubt the accuracy of the stack trace, because the
> > only caller of xfs_bmap_search_multi_extents() is
> > xfs_bmap_search_extents() and xfs_bmap_search_extents does not call
> > xfs_bmbt_get_all() directly like the stack trace would lead us to
> > beleive. Hence I don't think we can trust the stack trace to be
> > pointing use at the correct caller of xfs_bmbt_get_all(), which
> > makes it real hard to isolate the cause...
> > 
> 
> What seems strange to me here is why are we searching through extents
> when the bmbt is presumed to be corrupt? I suppose we don't know for
> sure whether the backtrace that panics is on the same inode, but the
> fact that the panic is linked with the corruption errors suggests this
> is likely.
> 
> Digging through the current tot code to see how that might occur, I
> noticed an XFS_ILOCK_EXCL assert in xfs_iread_extents() that doesn't
> exist in 3.18.3. It looks like part of some fixes Christoph made a while
> back, ending with the following commit in the commit log (see some of
> the immediately prior commits as well):
> 
> eef334e5776c xfs: assert that we hold the ilock for extent map access
> 
> ... which suggests some paths were reading in inode extents without the
> proper locking. That would appear to be problematic in its own right
> given how XFS_IFEXTENTS is used. If that is the case, I wonder if
> hitting that problem in combination with a bmbt that happens to be
> corrupted is causing us to go off the rails? Just a theory... and
> another reason it would be really nice to have a metadump. ;)

commit 40194ecc6d78327d98e66de3213db96ca0a31e6f
Author: Ben Myers <bpm@sgi.com>
Date:   Fri Dec 6 12:30:11 2013 -0800

    xfs: reinstate the ilock in xfs_readdir
    
    Although it was removed in commit 051e7cd44ab8, ilock needs to be taken in
    xfs_readdir because we might have to read the extent list in from disk.  This
    keeps other threads from reading from or writing to the extent list while it i
    being read in and is still in a transitional state.
    
    This has been associated with "Access to block zero" messages on directories
    with large numbers of extents resulting from excessive filesytem fragmentation
    as well as extent list corruption.  Unfortunately no test case at this point.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

Seems to match the behaviour being seen.

Alex, what type of inode is the one that is reporting the "access to
block zero" errors?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
