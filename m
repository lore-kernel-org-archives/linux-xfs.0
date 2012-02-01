Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11DaK4w251919 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 07:36:21 -0600
Received: from thb-mta-17.emailfiltering.com (thb-mta-17-tx.emailfiltering.com
	[194.116.199.149]) by cuda.sgi.com with ESMTP id
	utZ0tWrq162mdO1B (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 05:36:18 -0800 (PST)
Message-ID: <4F293FCC.7010101@rhul.ac.uk>
Date: Wed, 1 Feb 2012 13:36:12 +0000
From: Tom Crane <T.Crane@rhul.ac.uk>
MIME-Version: 1.0
Subject: xfs_repair segfaults with ag_stride option
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: T.Crane@rhul.ac.uk

Dear XFS Support,
    I am attempting to use xfs_repair to fix a damaged FS but always get 
a segfault if and only if -o ag_stride is specified. I have tried 
ag_stride=2,8,16 & 32.  The FS is approx 60T. I can't find reports of 
this particular problem on the mailing list archive.  Further details are;

xfs_repair version 3.1.7, recently downloaded via git repository.
uname -a
Linux store3 2.6.18-274.17.1.el5 #1 SMP Wed Jan 11 11:10:32 CET 2012 
x86_64 x86_64 x86_64 GNU/Linux


Running with -P and/or -m 9000 did not help.  The host has 10GB memory.  
I built xfs_repair with './configure CFLAGS="-g -O2" && make' Here is 
the log from a gdb session.  Is there any other information/tests that I 
can supply?

Please help.
Many thanks
Tom Crane


> [root@store3 tcrane]# gdb xfsprogs/repair/xfs_repair
> GNU gdb (GDB) Red Hat Enterprise Linux (7.0.1-37.el5_7.1)
> Copyright (C) 2009 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later 
> <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /data/tcrane/xfsprogs/repair/xfs_repair...done.
> (gdb) set arg -n -m 9000 -o ag_stride=2 /dev/mapper/vg0-lvol0
> (gdb) ru
> Starting program: /data/tcrane/xfsprogs/repair/xfs_repair -n -m 9000 
> -o ag_stride=2 /dev/mapper/vg0-lvol0
> warning: no loadable sections found in added symbol-file 
> system-supplied DSO at 0x2aaaaaaab000
> [Thread debugging using libthread_db enabled]
> Phase 1 - find and verify superblock...
> [New Thread 0x40a00940 (LWP 12803)]
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
> [New Thread 0x41401940 (LWP 12804)]
> [New Thread 0x41e02940 (LWP 12805)]
> [New Thread 0x42803940 (LWP 12806)]
> [New Thread 0x43204940 (LWP 12807)]
> [New Thread 0x43c05940 (LWP 12808)]
> [New Thread 0x44606940 (LWP 12809)]
> [New Thread 0x45007940 (LWP 12810)]
> [New Thread 0x45a08940 (LWP 12811)]
> [New Thread 0x46409940 (LWP 12812)]
> [New Thread 0x46e0a940 (LWP 12813)]
> [New Thread 0x4780b940 (LWP 12814)]
> [New Thread 0x4820c940 (LWP 12815)]
> [New Thread 0x48c0d940 (LWP 12816)]
> [New Thread 0x4960e940 (LWP 12817)]
> [New Thread 0x4a00f940 (LWP 12818)]
> [New Thread 0x4aa10940 (LWP 12819)]
> [New Thread 0x4b411940 (LWP 12820)]
> [New Thread 0x4be12940 (LWP 12821)]
> [New Thread 0x4c813940 (LWP 12822)]
> [New Thread 0x4d214940 (LWP 12823)]
> [New Thread 0x4dc15940 (LWP 12824)]
> [New Thread 0x4e616940 (LWP 12825)]
> [New Thread 0x4f017940 (LWP 12826)]
> [New Thread 0x4fa18940 (LWP 12827)]
> [New Thread 0x50419940 (LWP 12828)]
> [New Thread 0x50e1a940 (LWP 12829)]
> [New Thread 0x5181b940 (LWP 12830)]
> [New Thread 0x5221c940 (LWP 12831)]
> [New Thread 0x52c1d940 (LWP 12832)]
> [New Thread 0x5361e940 (LWP 12833)]
> [New Thread 0x5401f940 (LWP 12834)]
> [New Thread 0x54a20940 (LWP 12835)]
> [Thread 0x4820c940 (LWP 12815) exited]
> [Thread 0x4f017940 (LWP 12826) exited]
> [Thread 0x5401f940 (LWP 12834) exited]
> [Thread 0x54a20940 (LWP 12835) exited]
> [Thread 0x48c0d940 (LWP 12816) exited]
> [Thread 0x46409940 (LWP 12812) exited]
> [Thread 0x4780b940 (LWP 12814) exited]
> [Thread 0x46e0a940 (LWP 12813) exited]
> [Thread 0x44606940 (LWP 12809) exited]
> [Thread 0x5361e940 (LWP 12833) exited]
> [Thread 0x50e1a940 (LWP 12829) exited]
> [Thread 0x45a08940 (LWP 12811) exited]
> [Thread 0x52c1d940 (LWP 12832) exited]
> [Thread 0x4c813940 (LWP 12822) exited]
> [Thread 0x41401940 (LWP 12804) exited]
> [Thread 0x5221c940 (LWP 12831) exited]
> [Thread 0x4fa18940 (LWP 12827) exited]
> [Thread 0x4be12940 (LWP 12821) exited]
> [Thread 0x4a00f940 (LWP 12818) exited]
> [Thread 0x43204940 (LWP 12807) exited]
> [Thread 0x5181b940 (LWP 12830) exited]
> [Thread 0x4b411940 (LWP 12820) exited]
> [Thread 0x4e616940 (LWP 12825) exited]
> [Thread 0x41e02940 (LWP 12805) exited]
> [Thread 0x4dc15940 (LWP 12824) exited]
> [Thread 0x50419940 (LWP 12828) exited]
> [Thread 0x42803940 (LWP 12806) exited]
> [Thread 0x4d214940 (LWP 12823) exited]
> [Thread 0x4aa10940 (LWP 12819) exited]
> [Thread 0x43c05940 (LWP 12808) exited]
> [Thread 0x45007940 (LWP 12810) exited]
> [Thread 0x4960e940 (LWP 12817) exited]
>         - 12:58:56: scanning filesystem freespace - 59 of 59 
> allocation groups done
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - 12:58:56: scanning agi unlinked lists - 59 of 59 allocation 
> groups done
>         - process known inodes and perform inode discovery...
> [New Thread 0x54a20940 (LWP 12837)]
> [New Thread 0x5401f940 (LWP 12838)]
> [New Thread 0x41401940 (LWP 12840)]
> [New Thread 0x5361e940 (LWP 12839)]
> [New Thread 0x41e02940 (LWP 12841)]
> [New Thread 0x42803940 (LWP 12842)]
> [New Thread 0x43c05940 (LWP 12844)]
> [New Thread 0x43204940 (LWP 12843)]
> [New Thread 0x44606940 (LWP 12845)]
> [New Thread 0x46409940 (LWP 12849)]
> [New Thread 0x46e0a940 (LWP 12850)]
> [New Thread 0x45a08940 (LWP 12848)]
> [New Thread 0x45007940 (LWP 12847)]
> [New Thread 0x4780b940 (LWP 12851)]
> [New Thread 0x48c0d940 (LWP 12853)]
> [New Thread 0x4820c940 (LWP 12852)]
> [New Thread 0x4a00f940 (LWP 12856)]
> [New Thread 0x4960e940 (LWP 12855)]
>         - agno = 0
> [New Thread 0x4aa10940 (LWP 12858)]
> [New Thread 0x4b411940 (LWP 12857)]
> [New Thread 0x4be12940 (LWP 12859)]
> [New Thread 0x4c813940 (LWP 12861)]
> [New Thread 0x4d214940 (LWP 12860)]
> [New Thread 0x4dc15940 (LWP 12862)]
>         - agno = 4
> [New Thread 0x4f017940 (LWP 12864)]
> [New Thread 0x4e616940 (LWP 12863)]
>         - agno = 2
> [Thread 0x4be12940 (LWP 12859) exited]
> [New Thread 0x4fa18940 (LWP 12866)]
> [Thread 0x43c05940 (LWP 12844) exited]
> [New Thread 0x50419940 (LWP 12867)]
> [Thread 0x46409940 (LWP 12849) exited]
> [Thread 0x4820c940 (LWP 12852) exited]
> [New Thread 0x43c05940 (LWP 12869)]
> [New Thread 0x46409940 (LWP 12868)]
> [Thread 0x4c813940 (LWP 12861) exited]
> [Thread 0x4a00f940 (LWP 12856) exited]
> [New Thread 0x5181b940 (LWP 12871)]
> [New Thread 0x50e1a940 (LWP 12870)]
> [New Thread 0x52c1d940 (LWP 12873)]
> [Thread 0x46e0a940 (LWP 12850) exited]
> [New Thread 0x5221c940 (LWP 12872)]
>         - agno = 6
> [Thread 0x4dc15940 (LWP 12862) exited]
> [Thread 0x5221c940 (LWP 12872) exited]
> [New Thread 0x55421940 (LWP 12875)]
> [Thread 0x4b411940 (LWP 12857) exited]
> [Thread 0x50419940 (LWP 12867) exited]
> [New Thread 0x4be12940 (LWP 12876)]
> [Thread 0x4960e940 (LWP 12855) exited]
> [New Thread 0x50419940 (LWP 12878)]
> [New Thread 0x5221c940 (LWP 12877)]
> [New Thread 0x4c813940 (LWP 12879)]
>         - agno = 10
> [Thread 0x50419940 (LWP 12878) exited]
> [New Thread 0x55e22940 (LWP 12883)]
> [New Thread 0x4dc15940 (LWP 12882)]
> [Thread 0x42803940 (LWP 12842) exited]
> [New Thread 0x56823940 (LWP 12884)]
> [New Thread 0x4960e940 (LWP 12881)]
> [Thread 0x52c1d940 (LWP 12873) exited]
> [Thread 0x43c05940 (LWP 12869) exited]
> [New Thread 0x42803940 (LWP 12886)]
> [New Thread 0x43c05940 (LWP 12885)]
> [New Thread 0x57224940 (LWP 12887)]
>         - agno = 8
> [Thread 0x50e1a940 (LWP 12870) exited]
> [Thread 0x44606940 (LWP 12845) exited]
> [New Thread 0x50419940 (LWP 12888)]
> [New Thread 0x52c1d940 (LWP 12889)]
> [Thread 0x55e22940 (LWP 12883) exited]
> [New Thread 0x50e1a940 (LWP 12891)]
> [New Thread 0x44606940 (LWP 12890)]
> [Thread 0x5221c940 (LWP 12877) exited]
> [Thread 0x4f017940 (LWP 12864) exited]
> [New Thread 0x57c25940 (LWP 12893)]
>         - agno = 3
> [Thread 0x50e1a940 (LWP 12891) exited]
> [Thread 0x4fa18940 (LWP 12866) exited]
> [New Thread 0x4f017940 (LWP 12894)]
> [New Thread 0x58626940 (LWP 12895)]
> [Thread 0x52c1d940 (LWP 12889) exited]
> [New Thread 0x4fa18940 (LWP 12896)]
> [New Thread 0x59027940 (LWP 12897)]
> [New Thread 0x59a28940 (LWP 12898)]
> [Thread 0x4dc15940 (LWP 12882) exited]
> [New Thread 0x5a429940 (LWP 12899)]
> [New Thread 0x4dc15940 (LWP 12900)]
> [Thread 0x48c0d940 (LWP 12853) exited]
> [New Thread 0x5ae2a940 (LWP 12901)]
>         - agno = 5
> [Thread 0x55421940 (LWP 12875) exited]
> [New Thread 0x55e22940 (LWP 12902)]
> [New Thread 0x5221c940 (LWP 12903)]
> [Thread 0x5ae2a940 (LWP 12901) exited]
> [Thread 0x59a28940 (LWP 12898) exited]
> [Thread 0x43c05940 (LWP 12885) exited]
> [Thread 0x4f017940 (LWP 12894) exited]
> [New Thread 0x5ae2a940 (LWP 12904)]
> [Thread 0x56823940 (LWP 12884) exited]
>         - agno = 11
>         - agno = 12
> [Thread 0x4c813940 (LWP 12879) exited]
> [New Thread 0x59a28940 (LWP 12932)]
> [Thread 0x5a429940 (LWP 12899) exited]
> [Thread 0x5221c940 (LWP 12903) exited]
> [New Thread 0x4c813940 (LWP 12933)]
> [Thread 0x5ae2a940 (LWP 12904) exited]
> [Thread 0x59027940 (LWP 12897) exited]
> [Thread 0x4fa18940 (LWP 12896) exited]
> [Thread 0x58626940 (LWP 12895) exited]
> [New Thread 0x50e1a940 (LWP 12952)]
> [Thread 0x50419940 (LWP 12888) exited]
>
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x54a20940 (LWP 12837)]
> 0x000000380ac7b29f in memset () from /lib64/libc.so.6
> (gdb) bt
> #0  0x000000380ac7b29f in memset () from /lib64/libc.so.6
> #1  0x0000000000403998 in process_leaf_attr_block (mp=0x7fffffffe560, 
> leaf=0x2aab2bfb4400, da_bno=0, ino=1718, blkmap=0x2aab280787d0, 
> last_hashval=0,
>     current_hashval=0x54a1fd44, repair=0x54a1fdc4) at attr_repair.c:522
> #2  0x000000000040494b in process_longform_attr (mp=0x7fffffffe560, 
> ino=1718, dip=0x18e4e00, blkmap=0x2aab280787d0, repair=0x54a1fdc4)
>     at attr_repair.c:900
> #3  0x000000000040d971 in process_inode_attr_fork (mp=0x7fffffffe560, 
> agno=0, ino=1718, dino=0x18e4e00, type=5, dirty=0x54a1ffe0, 
> atotblocks=0x54a1fe70,
>     anextents=0x54a1fe60, check_dups=0, extra_attr_check=1, 
> retval=0x54a1fe80) at dinode.c:2301
> #4  0x000000000040f368 in process_dinode_int (mp=0x7fffffffe560, 
> dino=0x18e4e00, agno=0, ino=1718, was_free=0, dirty=0x54a1ffe0, 
> used=0x54a1ffe4,
>     verify_mode=0, uncertain=0, ino_discovery=1, check_dups=0, 
> extra_attr_check=1, isa_dir=0x54a1ffdc, parent=0x54a1ffd0) at 
> dinode.c:2764
> #5  0x000000000040fd0e in process_dinode (mp=0x0, dino=0x0, agno=0, 
> ino=1024, was_free=8192, dirty=0x2000, used=0x54a1ffe4, ino_discovery=1,
>     check_dups=0, extra_attr_check=1, isa_dir=0x54a1ffdc, 
> parent=0x54a1ffd0) at dinode.c:2898
> #6  0x0000000000409361 in process_inode_chunk (mp=0x7fffffffe560, 
> agno=0, num_inos=<value optimized out>, first_irec=0x2aab283c9ef0, 
> ino_discovery=1,
>     check_dups=0, extra_attr_check=1, bogus=0x54a20064) at 
> dino_chunks.c:779
> #7  0x0000000000409a6c in process_aginodes (mp=0x7fffffffe560, 
> pf_args=0x68ea10, agno=0, ino_discovery=1, check_dups=0, 
> extra_attr_check=1)
>     at dino_chunks.c:1018
> #8  0x000000000041c8df in process_ag_func (wq=0x68fb50, agno=0, 
> arg=0x68ea10) at phase3.c:154
> #9  0x000000000042f86d in worker_thread (arg=<value optimized out>) at 
> threads.c:46
> #10 0x000000380b40673d in start_thread () from /lib64/libpthread.so.0
> #11 0x000000380acd44bd in clone () from /lib64/libc.so.6
> (gdb) list
> 522             * doesn't get flushed out if no_modify is set
> 523             */
> 524            mp->m_sb.sb_rsumino = first_prealloc_ino + 2;
> 525        }
> 526   
> 527    }
> 528   
> 529    int
> 530    main(int argc, char **argv)
> 531    {
> (gdb) q

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
