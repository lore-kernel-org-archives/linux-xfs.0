Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22A8C7CA7
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 05:36:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D71EF304043
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 03:36:36 -0700 (PDT)
Received: from chinanetcenter.com (mail.chinanetcenter.com [123.103.13.31]) by
	cuda.sgi.com with ESMTP id 3CoiSscTGONMk229 for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2016 03:36:30 -0700 (PDT)
Message-ID: <57CFEDA3.9000005@chinanetcenter.com>
Date: Wed, 07 Sep 2016 18:36:19 +0800
From: Lin Feng <linf@chinanetcenter.com>
MIME-Version: 1.0
Subject: [BUG REPORT] missing memory counter introduced by xfs
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: dchinner@redhat.com

Hi all nice xfs folks,

I'm a rookie and really fresh new in xfs and currently I ran into an issue same 
as the following link described:
http://oss.sgi.com/archives/xfs/2014-04/msg00058.html

In my box(running cephfs osd using xfs kernel 2.6.32-358) and I sum all possible 
memory counter can be find but it seems that nearlly 26GB memory has gone and 
they are back after I echo 2 > /proc/sys/vm/drop_caches, so seems these memory 
can be reclaimed by slab.
But it my box kernel use swap instead reclaim slab until I run echo 2 > 
/proc/sys/vm/drop_caches.

Following memory usage is caught by my shell script, and the slabinfo/meminfo 
pasted at the end of this mail.
-----
before echo 1 > /proc/sys/vm/drop_caches
Analysis: all processes rss + buffer+cached + slabs + free, total Rss: 39863308 K
              total       used       free     shared    buffers     cached
Mem:      65963504   58230212    7733292          0      31284    6711912
-/+ buffers/cache:   51487016   14476488
Swap:      8388600          0    8388600

after echo 1 > /proc/sys/vm/drop_caches
Analysis: all processes rss + buffer+cached + slabs + free, total Rss:
39781110 K

free info:
              total       used       free     shared    buffers     cached
Mem:      65963504   51666124   14297380          0       3376      55704
-/+ buffers/cache:   51607044   14356460
Swap:      8388600          0    8388600

after echo 2 > /proc/sys/vm/drop_caches
Analysis: all processes rss + buffer+cached + slabs + free, total Rss:
65259244 K
              total       used       free     shared    buffers     cached
Mem:      65963504   17194480   48769024          0       7948      53216
-/+ buffers/cache:   17133316   48830188
Swap:      8388600          0    8388600
-----


And according to what David said replying in the list:
David's mail contents quotes start
-----
On Thu, Apr 10, 2014 at 07:40:44PM -0700, daiguochao wrote:
 > Dear Stan, I can't send email to you.So I leave a message here.I hope not to
 > bother you.
 > Thank you for your kind assistance.
 >
 > In accordance with your suggestion, we executed "echo 3 >
 > /proc/sysm/drop_caches" for trying to release vfs dentries and inodes.
 > Really,
 > our lost memory came back. But we learned that the memory of vfs dentries
 > and inodes is distributed from slab. Please check our system "Slab:  509708
 > kB" from /proc/meminfo, and it seems only be took up 500MB and xfs_buf take
 > up 450MB among.

That's where your memory is - in metadata buffers. The xfs_buf slab
entries are just the handles - the metadata pages in the buffers
usually take much more space and it's not accounted to the slab
cache nor the page cache.

Can you post the output of /proc/slabinfo, and what is the output of
xfs_info on the filesystem in question? Also, a description of your
workload that is resulting in large amounts of cached metadata
buffers but no inodes or dentries would be helpful.
-----
David's mail contents quotes end

After some research it seems that after this patch(commit 0e6e847ffe37) we use 
alloc_page in xfs_buf_allocate_memory() instead of original find_or_create_page.
Ps. mainline kernel still uses alloc_page.

So if my  speculation was right, my problem is if there a way to find out how 
much memory that xfs_buf_t->b_pages are using or if xfs has already exported 
such counter to user space.


thanks in advance.
linfeng

-----
commit 0e6e847ffe37436e331c132639f9f872febce82e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Sat Mar 26 09:16:45 2011 +1100

     xfs: stop using the page cache to back the buffer cache

     Now that the buffer cache has it's own LRU, we do not need to use
     the page cache to provide persistent caching and reclaim
     infrastructure. Convert the buffer cache to use alloc_pages()
     instead of the page cache. This will remove all the overhead of page
     cache management from setup and teardown of the buffers, as well as
     needing to mark pages accessed as we find buffers in the buffer
     cache.
...
-             retry:
-               page = find_or_create_page(mapping, first + i, gfp_mask);
+retry:
+               page = alloc_page(gfp_mask);
-----


slabtop info:
  Active / Total Objects (% used)    : 27396369 / 27446160 (99.8%)
  Active / Total Slabs (% used)      : 2371663 / 2371729 (100.0%)
  Active / Total Caches (% used)     : 112 / 197 (56.9%)
  Active / Total Size (% used)       : 9186047.17K / 9202410.61K (99.8%)
  Minimum / Average / Maximum Object : 0.02K / 0.33K / 4096.00K

   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
4383036 4383014  99%    1.00K 1095759        4   4383036K xfs_inode
5394610 5394544  99%    0.38K 539461       10   2157844K xfs_buf
6448560 6448451  99%    0.19K 322428       20   1289712K dentry
1083285 1062902  98%    0.55K 154755        7    619020K radix_tree_node
3015600 3015546  99%    0.12K 100520       30    402080K size-128
4379806 4379430  99%    0.06K  74234       59    296936K xfs_ifork
687640 687144  99%    0.19K  34382       20    137528K size-192
1833130 1833089  99%    0.06K  31070       59    124280K size-64
   1060   1059  99%   16.00K   1060        1     16960K size-16384
    196    196 100%   32.12K    196        1     12544K kmem_cache
   4332   4316  99%    2.59K   1444        3     11552K task_struct
  15900  15731  98%    0.62K   2650        6     10600K proc_inode_cache
   8136   7730  95%    1.00K   2034        4      8136K size-1024
   9930   9930 100%    0.58K   1655        6      6620K inode_cache
  20700  14438  69%    0.19K   1035       20      4140K filp
   3704   3691  99%    1.00K    926        4      3704K ext4_inode_cache
  17005  15631  91%    0.20K    895       19      3580K vm_area_struct
  18090  18043  99%    0.14K    670       27      2680K sysfs_dir_cache
   1266   1254  99%    1.94K    633        2      2532K TCP
    885    885 100%    2.06K    295        3      2360K sighand_cache

/proc/meminfo
MemTotal:       65963504 kB
MemFree:        14296540 kB
Buffers:            3380 kB
Cached:            55700 kB
SwapCached:            0 kB
Active:         15717512 kB
Inactive:         306828 kB
Active(anon):   15699604 kB
Inactive(anon):   268724 kB
Active(file):      17908 kB
Inactive(file):    38104 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8388600 kB
SwapFree:        8388600 kB
Dirty:                72 kB
Writeback:             0 kB
AnonPages:      15966248 kB
Mapped:            33668 kB
Shmem:              3056 kB
Slab:            9521800 kB
SReclaimable:    6314860 kB
SUnreclaim:      3206940 kB
KernelStack:       32680 kB
PageTables:        51504 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    61159400 kB
Committed_AS:   29734944 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      389896 kB
VmallocChunk:   34324818076 kB
HardwareCorrupted:     0 kB
AnonHugePages:    407552 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        5504 kB
DirectMap2M:     2082816 kB
DirectMap1G:    65011712 kB


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
