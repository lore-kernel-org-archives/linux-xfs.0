Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27I4U0g137507 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 12:04:30 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id YqZGIAYvcNp0kWWx for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 10:04:27 -0800 (PST)
Message-ID: <4F57A32A.5010704@sandeen.net>
Date: Wed, 07 Mar 2012 12:04:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: df bigger than ls?
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
In-Reply-To: <20120307171619.GA23557@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On 3/7/12 11:16 AM, Brian Candler wrote:
> On Wed, Mar 07, 2012 at 03:54:39PM +0000, Brian Candler wrote:
>> core.size = 1085407232
>> core.nblocks = 262370
> 
> core.nblocks is correct here: space used = 262370 * 4 = 1049480 KB
> 
> (If I add up all the non-hole extents I get 2098944 blocks = 1049472 KB
> so there are two extra blocks of something)
> 
> This begs the question of where stat() is getting its info from?
> 
> Ah... but I've found that after unmounting and remounting the filesystem
> (which I had to do for xfs_db), du and stat report the correct info.
> 
> In fact, dropping the inode caches is sufficient to fix the problem:

Yep.

XFS speculatively preallocates space off the end of a file.  The amount of
space allocated depends on the present size of the file, and the amount of
available free space.  This can be overridden
with mount -o allocsize=64k (or other size for example)

$ git log --pretty=oneline fs/xfs | grep specul
b8fc82630ae289bb4e661567808afc59e3298dce xfs: speculative delayed allocation uses rounddown_power_of_2 badly
055388a3188f56676c21e92962fc366ac8b5cb72 xfs: dynamic speculative EOF preallocation

so:

# dd if=/dev/zero of=bigfile bs=1M count=1100 &>/dev/null
# ls -lh bigfile
-rw-r--r--. 1 root root 1.1G Mar  7 11:47 bigfile
# du -h bigfile
1.1G	bigfile

but:

# rm -f bigfile
# for I in `seq 1 1100`; do dd if=/dev/zero of=bigfile conv=notrunc bs=1M seek=$I count=1 &>/dev/null; done
# ls -lh bigfile
-rw-r--r--. 1 root root 1.1G Mar  7 11:49 bigfile
# du -h bigfile
2.0G	bigfile

This should get freed when the inode is dropped from the cache; hence your cache drop bringing it back to size.

But there does seem to be an issue here; if I make a 4G filesystem and repeat the above test 3 times, the 3rd run gets ENOSPC, and the last file written comes up short, while the first one retains all it's extra preallocated space:

# du -hc bigfile*
2.0G	bigfile1
1.1G	bigfile2
907M	bigfile3

Dave, is this working as intended?  I know the speculative preallocation amount for new files is supposed to go down as the fs fills, but is there no way to discard prealloc space to avoid ENOSPC on other files?

-Eric

> root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 2.0G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> root@storage1:~# echo 3 >/proc/sys/vm/drop_caches 
> root@storage1:~# du -h /disk*/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk10/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk11/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk12/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk1/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk2/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk3/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk4/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk5/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk6/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk7/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk8/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> 1.1G	/disk9/scratch2/work/PRSRA1/PRSRA1.1.0.bff
> root@storage1:~# 
> 
> Very odd, but not really a major problem other than the confusion it causes.
> 
> Regards,
> 
> Brian.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
