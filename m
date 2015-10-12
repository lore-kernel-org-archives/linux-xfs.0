Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B686D7F5E
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 16:45:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 529B4AC004
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 14:45:37 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	G1qs9QgcYeLmPtMX for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 14:45:35 -0700 (PDT)
Date: Tue, 13 Oct 2015 08:45:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs_repair: fix unaligned accesses
Message-ID: <20151012214532.GC31326@dastard>
References: <56170906.5090301@redhat.com> <56170974.5020604@sandeen.net>
	<20151011222618.GX27164@dastard> <561C26B4.3080008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561C26B4.3080008@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Oct 12, 2015 at 04:31:32PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/11/15 5:26 PM, Dave Chinner wrote:
> > On Thu, Oct 08, 2015 at 07:25:24PM -0500, Eric Sandeen wrote:
> >> This fixes some unaligned accesses spotted by libubsan in repair.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  repair/dinode.c   |   19 +++++++++----------
> >>  repair/prefetch.c |    4 ++--
> >>  2 files changed, 11 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/repair/dinode.c b/repair/dinode.c
> >> index f78f907..44bbb8f 100644
> >> --- a/repair/dinode.c
> >> +++ b/repair/dinode.c
> >> @@ -960,13 +960,13 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
> >>  		 * btree, we'd do it right here.  For now, if there's a
> >>  		 * problem, we'll bail out and presumably clear the inode.
> >>  		 */
> >> -		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
> >> +		if (!verify_dfsbno(mp, get_unaligned_be64(&pp[i])))  {
> > 
> > I don't understand - when are pointers in the BMBT not 64 bit
> > aligned? The buffers are allocated by memalign to be 64 bit aligned,
> > and all the internal BMBT structures are 64 bit aligned, too. i.e
> > the BMBT block header is 24/72 bytes in length (depending on CRCs),
> > the pointers are 64 bit, and the records are 128 bit.
> > 
> > So where's the unaligned access coming from?
> 
> Ok, so on a recheck, I'm not crazy w.r.t. what gcc said, anyway:
> 
> dinode.c:964:26: runtime error: load of misaligned address 0x7fc4f800ef54 for type 'xfs_bmbt_ptr_t', which requires 8 byte alignment
> 0x7fc4f800ef54: note: pointer points here
>   00 00 00 00 00 00 00 00  00 20 38 5e 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>               ^ 
> 
> with some added printfs, it came from:
> 
>         pp = XFS_BMDR_PTR_ADDR(dib, 1,
>                 xfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0));
>         printf("dib at %p pp at %p\n", dib, pp);
> 
> dib at 0x7fc4f800eeb0 pp at 0x7fc4f800ef54

Ah, ok, it's in extent format in the inode fork, not in btree
format in blocks. Let me go back and look at it again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
