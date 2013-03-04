Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E66407FE2
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:05:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAA748F8035
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 15:05:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2mYmVCDpJIxEvtlQ for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 15:05:28 -0800 (PST)
Date: Tue, 5 Mar 2013 10:05:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: strange behavior of a larger xfs directory
Message-ID: <20130304230527.GM26081@dastard>
References: <4300208.uZ6HVTycB6@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4300208.uZ6HVTycB6@xrated>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

On Mon, Mar 04, 2013 at 05:40:13PM +0100, Hans-Peter Jansen wrote:
> Hi,
> 
> after upgrading the kernel on a server from 2.6.34 to 3.8.1 (x86-32), I 
> suffer from a strange behavior of a larger directory, that a downgrade 
> of the kernel cannot repair.

TL;DR: problem with an old userspace and 64 bit inodes.

> 27177 open("/video/video/", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
> 27177 fstat64(3, {st_dev=makedev(8, 65), st_ino=357, st_mode=S_IFDIR|0775, st_nlink=350, 
>               st_uid=223, st_gid=33, st_blksize=4096, st_blocks=40, st_size=16384, 
>               st_atime=2013/03/04-16:12:37, st_mtime=2013/03/04-16:17:52, 
>               st_ctime=2013/03/04-16:17:52}) = 0
> 27177 getdents64(3, {
>               {d_ino=357, d_off=4, d_type=DT_UNKNOWN, d_reclen=24, d_name="."} 
>               {d_ino=128, d_off=6, d_type=DT_UNKNOWN, d_reclen=24, d_name=".."} 
>               {d_ino=367, d_off=12, d_type=DT_UNKNOWN, d_reclen=56, d_name="%Avatar_-_Aufbruch_nach_Pandora"} 
>               {d_ino=368, d_off=18, d_type=DT_UNKNOWN, d_reclen=56, d_name="%Der_Deutsche_Comedy_Preis_2009"}
>               [...]
>               {d_ino=4303329151, d_off=78, d_type=DT_UNKNOWN, d_reclen=32, d_name="Black_Swan"}

That's a 64 bit inode number right there (0x0x1007F977F), and AFAICT
it's the only one in the directory. That was created when you were
running 3.8.1.

>               [...]}) = 4072
> # note: including items, that are missing later on, probably all
> 
> 27177 _llseek(3, 74, [74], SEEK_SET)    = 0

Smoking gun.  That is effectively setting the directory offset to 74
(XFS masks out the upper 32 bits of the directory position because
it is invalid) and so XFS will take that offset and walk to the next
valid dirent and start filling entries from there on the next
getdents64 call. Your filesystem is doing exactly what userspace is
asking it to do.

Ah, I note that all the stat64() calls that follow stop at the dirent
that is at d_off=74. So it appears that userspace is having some
kind of problem related to the above entry.

> # then it preceeds with getdents64 and fetches already fetched entries
> 
> 27177 getdents64(3, {
>              {d_ino=4303329151, d_off=78, d_type=DT_UNKNOWN, d_reclen=32, d_name="Black_Swan"} 
                                  ^^^^^^^^

And the next valid entry in the directory is offset=78.

So, what it looks like to me is that whatever is parsing the
linux_dirent returned by the getdents64() call is choking on the 64
bit inode number.

Now, given that strace is parsing it correctly, this implies that
whatever is issuing the getdents64 call is not parsing the
linux_dirent64 structure correctly.  In fact, I suspect what is
happening is that userspace is incorrectly using a struct
linux_dirent to parse the results and hence it's seeing
d_off/d_type/d_reclen being invalid due to the resultant structure
misalignment.

Further, this is being seen by multiple different vectors, which
indicates that it is probably the readdir() glibc call that is
buggy, and not any of the applications.

First solution: upgrade to a modern userspace.

Second solution: Run 3.8.1, make sure you mount with inode32, and
then run the xfs_reno tool mentioned on this page:

http://xfs.org/index.php/Unfinished_work

to find all the inodes with inode numbers larger than 32
bits and move them to locations with smaller inode numbers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
