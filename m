Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CMIirX037790
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 16:18:44 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95D9513A4D69
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:19:57 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id E9DCnl5fCxfATXX5 for
	<linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:19:57 -0800 (PST)
Message-ID: <4B75D40C.4000903@sandeen.net>
Date: Fri, 12 Feb 2010 16:19:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>	<hl438l$bhm$1@ger.gmane.org>
	<4B7594D3.6040304@sandeen.net>
	<2d460de71002121201q224d3bc8xe48089eccdf6f6a@mail.gmail.com>
In-Reply-To: <2d460de71002121201q224d3bc8xe48089eccdf6f6a@mail.gmail.com>
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
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-xfs@oss.sgi.com, Nicolas Stransky <nico@stransky.cx>

Richard Hartmann wrote:
> On Fri, Feb 12, 2010 at 18:50, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> hard to say without knowing for sure what version you're using, and
>> what exactly "this" is that you're seeing :)
> 
> 3.0.4 - I stated that in another subthread so it might have gotten lost.
> 
> 
>> Providing an xfs_metadump of the corrupted fs that hangs repair
>> is also about the best thing you could do for investigation,
>> if you've already determined that the latest release doesn't help.
> 
> http://dediserver.eu/misc/mailstore_metadata_obscured__after_xfs_repair_hang.bz2
> http://dediserver.eu/misc/mailstore_metadata_obscured.bz2
> 
> These logs will stay up for at least a week or three.
> 

Ok it's hung in here it seems:

(gdb) bt
#0  0x0000003df2e0ce74 in __lll_lock_wait () from /lib64/libpthread.so.0
#1  0x0000003df2e08874 in _L_lock_106 () from /lib64/libpthread.so.0
#2  0x0000003df2e082e0 in pthread_mutex_lock () from /lib64/libpthread.so.0
#3  0x00000000004310d9 in libxfs_getbuf (device=<value optimized out>, blkno=<value optimized out>, len=<value optimized out>)
    at rdwr.c:394
#4  0x000000000043110d in libxfs_readbuf (dev=140518781147480, blkno=128, len=-220135752, flags=-1) at rdwr.c:483
#5  0x0000000000413d94 in da_read_buf (mp=0x7fff54dbcb70, nex=1, bmp=<value optimized out>) at dir2.c:110
#6  0x0000000000415b30 in process_block_dir2 (mp=0x7fff54dbcb70, ino=128, dip=0x7fcd14080e00, ino_discovery=1, 
    dino_dirty=<value optimized out>, dirname=0x464619 "", parent=0x7fff54dbca10, blkmap=0x1c19dd0, dot=0x7fff54dbc6fc, 
    dotdot=0x7fff54dbc6f8, repair=0x7fff54dbc6f4) at dir2.c:1697
#7  0x00000000004161ac in process_dir2 (mp=0x7fff54dbcb70, ino=128, dip=0x7fcd14080e00, ino_discovery=1, dino_dirty=0x7fff54dbca20, 
    dirname=0x464619 "", parent=0x7fff54dbca10, blkmap=0x1c19dd0) at dir2.c:2084
#8  0x000000000040e422 in process_dinode_int (mp=0x7fff54dbcb70, dino=0x7fcd14080e00, agno=0, ino=128, was_free=0, dirty=0x7fff54dbca20, 
    used=0x7fff54dbca24, verify_mode=0, uncertain=0, ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0x7fff54dbca1c, 
    parent=0x7fff54dbca10) at dinode.c:2661
#9  0x000000000040e79e in process_dinode (mp=0x7fcd1408d958, dino=0x80, agno=4074831544, ino=4294967295, was_free=28730568, 
    dirty=0x464619, used=0x7fff54dbca24, ino_discovery=1, check_dups=0, extra_attr_check=1, isa_dir=0x7fff54dbca1c, 
    parent=0x7fff54dbca10) at dinode.c:2772
#10 0x0000000000408483 in process_inode_chunk (mp=0x7fff54dbcb70, agno=0, num_inos=<value optimized out>, first_irec=0x1b77930, 
    ino_discovery=1, check_dups=0, extra_attr_check=1, bogus=0x7fff54dbcaa4) at dino_chunks.c:777
#11 0x0000000000408b22 in process_aginodes (mp=0x7fff54dbcb70, pf_args=0x361bae0, agno=0, ino_discovery=1, check_dups=0, 
    extra_attr_check=1) at dino_chunks.c:1024
#12 0x000000000041a4ef in process_ag_func (wq=0x1d65a00, agno=0, arg=0x361bae0) at phase3.c:154
#13 0x000000000041ab55 in phase3 (mp=0x7fff54dbcb70) at phase3.c:193
#14 0x000000000042d5a1 in main (argc=<value optimized out>, argv=<value optimized out>) at xfs_repair.c:712

And you're right, it's not progressing.

The filesystem is a real mess, but it's also making repair pretty unhappy :)

1st run hangs
2nd run completes with -P
next run resets more link counts
run after that segfaults

:(

And just a warning, post-repair about 22% of the files are in lost+found.

It'd take a bit of dedicated time to sort out the issues in repair here,
we need to do it but somebody's going to hav to find the time ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
