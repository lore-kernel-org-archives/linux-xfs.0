Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9D9w5Sh162864 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 04:58:05 -0500
Subject: Re: [PATCH 5/5] repair: prevent blkmap extent count overflows
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318208915-14975-6-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-6-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 04:58:00 -0500
Message-ID: <1318499880.3172.13.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-10-10 at 12:08 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix a bunch of invalid read/write errors due to excessive blkmap
> allocations when inode forks are corrupted. These show up some time
> after making a blkmap allocation for 536870913 extents on i686,
> which is followed some time later by a crash caused bymemory
> corruption.
> 
> This blkmap allocation size overflows 32 bits in such a
> way that it results in a 32 byte allocation and so access to the
> second extent results in access beyond the allocated memory and
> corrupts random memory.
> 
> ==5419== Invalid write of size 4
> ==5419==    at 0x80507DA: blkmap_set_ext (bmap.c:260)
> ==5419==    by 0x8055CF4: process_bmbt_reclist_int (dinode.c:712)
> ==5419==    by 0x8056206: process_bmbt_reclist (dinode.c:813)
> ==5419==    by 0x80579DA: process_exinode (dinode.c:1324)
> ==5419==    by 0x8059B77: process_dinode_int (dinode.c:2036)
> ==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
> ==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
> ==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
> ==5419==    by 0xFFF: ???
> ==5419==  Address 0x944cfb8 is 0 bytes after a block of size 32 alloc'd
> ==5419==    at 0x48E1102: realloc (in
> /usr/lib/valgrind/vgpreload_memcheck-x86-linux.so)
> ==5419==    by 0x80501F3: blkmap_alloc (bmap.c:56)
> ==5419==    by 0x80599F5: process_dinode_int (dinode.c:2027)
> ==5419==    by 0x805ABE6: process_dinode (dinode.c:2823)
> ==5419==    by 0x8052493: process_inode_chunk.isra.4 (dino_chunks.c:777)
> ==5419==    by 0x8054012: process_aginodes (dino_chunks.c:1024)
> ==5419==    by 0xFFF: ???
> 
> Add overflow detection code into the blkmap allocation code to avoid
> this problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I still prefer checking for overflow *before* adding
but it's just not that important.

This looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
