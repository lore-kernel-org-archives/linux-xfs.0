Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E32D07F91
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 05:43:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D317E304062
	for <xfs@oss.sgi.com>; Wed,  2 Oct 2013 03:43:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xB8MOHKB14sIObld for <xfs@oss.sgi.com>;
	Wed, 02 Oct 2013 03:42:58 -0700 (PDT)
Date: Wed, 2 Oct 2013 20:42:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault
Message-ID: <20131002104253.GT12541@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
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
To: Viet Nguyen <vietnguyen@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 01, 2013 at 02:12:16PM -0700, Viet Nguyen wrote:
> Hi again,
> Here's the stack trace:
> 
> #0  __xfs_dir3_data_check (dp=<value optimized out>, bp=<value optimized
> out>) at xfs_dir2_data.c:149
> #1  0x0000000000451d32 in xfs_dir3_block_verify (bp=0x94369210) at
> xfs_dir2_block.c:62
> #2  0x0000000000451ed1 in xfs_dir3_block_read_verify (bp=0x94369210) at
> xfs_dir2_block.c:73
> #3  0x0000000000431e2a in libxfs_readbuf (btp=0x6aaca0, blkno=5292504,
> len=8, flags=0, ops=0x478c60) at rdwr.c:718
> #4  0x0000000000412295 in da_read_buf (mp=0x7fffffffe090, nex=1, bmp=<value
> optimized out>, ops=<value optimized out>) at dir2.c:129
> #5  0x0000000000415c26 in process_block_dir2 (mp=0x7fffffffe090,
> ino=8639864, dip=0x95030000, ino_discovery=1, dino_dirty=<value optimized
> out>, dirname=0x472201 "", parent=0x7fffffffdf28, blkmap=0x7ffff0342010) at
> dir2.c:1594
> #6  process_dir2 (mp=0x7fffffffe090, ino=8639864, dip=0x95030000,
> ino_discovery=1, dino_dirty=<value optimized out>, dirname=0x472201 "",
> parent=0x7fffffffdf28, blkmap=0x7ffff0342010) at dir2.c:1993
> #7  0x0000000000411e6c in process_dinode_int (mp=0x7fffffffe090,
> dino=0x95030000, agno=1, ino=0, was_free=0, dirty=0x7fffffffdf38,
> used=0x7fffffffdf3c, verify_mode=0, uncertain=0, ino_discovery=1,
> check_dups=0, extra_attr_check=1, isa_dir=0x7fffffffdf34,
>     parent=0x7fffffffdf28) at dinode.c:2859
> #8  0x000000000041213e in process_dinode (mp=<value optimized out>,
> dino=<value optimized out>, agno=<value optimized out>, ino=<value
> optimized out>, was_free=<value optimized out>, dirty=<value optimized
> out>, used=0x7fffffffdf3c, ino_discovery=1, check_dups=0,
>     extra_attr_check=1, isa_dir=0x7fffffffdf34, parent=0x7fffffffdf28) at
> dinode.c:2967
> #9  0x000000000040a870 in process_inode_chunk (mp=0x7fffffffe090, agno=0,
> num_inos=<value optimized out>, first_irec=0x7fff5d63f320, ino_discovery=1,
> check_dups=0, extra_attr_check=1, bogus=0x7fffffffdfcc) at dino_chunks.c:772
> #10 0x000000000040ae97 in process_aginodes (mp=0x7fffffffe090, pf_args=0x0,
> agno=0, ino_discovery=1, check_dups=0, extra_attr_check=1) at
> dino_chunks.c:1014
> #11 0x000000000041978d in process_ag_func (wq=0x695f40, agno=0, arg=0x0) at
> phase3.c:77
> #12 0x0000000000419bac in process_ags (mp=0x7fffffffe090) at phase3.c:116
> #13 phase3 (mp=0x7fffffffe090) at phase3.c:155
> #14 0x000000000042d200 in main (argc=<value optimized out>, argv=<value
> optimized out>) at xfs_repair.c:749

Looks like an out of range entry count. it's not checked for
validity before it is used. I'll try to whip up a fix
tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
