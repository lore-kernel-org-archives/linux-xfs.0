Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4DL5sN4173269 for <xfs@oss.sgi.com>; Wed, 13 May 2009 16:05:54 -0500
Received: from web65604.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 357B3FA9B26
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 14:10:41 -0700 (PDT)
Received: from web65604.mail.ac4.yahoo.com (web65604.mail.ac4.yahoo.com
	[76.13.9.72]) by cuda.sgi.com with SMTP id pR8V44sdcVzb1KuQ for
	<xfs@oss.sgi.com>; Wed, 13 May 2009 14:10:41 -0700 (PDT)
Message-ID: <705795.15734.qm@web65604.mail.ac4.yahoo.com>
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
Date: Wed, 13 May 2009 14:05:16 -0700 (PDT)
From: p v <pvlogin@yahoo.com>
Subject: Re: file preallocation without unwritten flag being set
In-Reply-To: <4A0A55E0.4010202@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


doesn't seem to work - I tried to clear the extflg in the versionnum of the superblock (in every copy of it as well) but it doesn't work. The flag is still set on all extents.

xfs_db> version
versionnum [0xb4a4+0x8] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
xfs_db> version 0xa4a4 0x8
versionnum [0xa4a4+0x8] = V4,NLINK,ALIGN,DIRV2,LOGV2,MOREBITS,ATTR2

typeset -i agcount=$(xfs_db -c "sb" -c "print" /dev/sda | grep agcount)
typeset -i i=0
while [[ $i != $agcount ]]
do      
        xfs_db -x -c "sb $i" -c "write versionnum 0xa4a4" /dev/sda
        i=i+1
done

And once I make the file xfs_repair complains and resets the sb flag - my guess is that in the extent allocation path it is hardcoded for the version 4 - any extent allocated beyond file size will get the flag ...

Also - 2 questions -

1) what is inode64 and where can I find out all of the undocumented mkfs/mount options (it's unfortunate that such a good fs doesnt' have a correspondingly good documentation)

2) why is the largest extent size limited to xxx blocks(can't find out thenumber - when does the inode get finally flushed? ls -i reports 19 as the inode number but even after unmounting inode 19 in xfs_db still shows a free inode - is it still only in the log???) ? I assumed that xfs_bmap gets me the correct number of extents but now looking at the inode with xfs_db it's obvious that xfs_bmap reports contiguous ranges rather than actual extents in the blockmap tree

thx

Peter Vajgel




----- Original Message ----
From: Eric Sandeen <sandeen@sandeen.net>
To: p v <pvlogin@yahoo.com>
Cc: xfs@oss.sgi.com
Sent: Tuesday, May 12, 2009 10:08:48 PM
Subject: Re: file preallocation without unwritten flag being set

p v wrote:
> 
> 
> I want to avoid any metadata modifications while doing O_DIRECT reads
> (the fs is mounted with noatime). Right now I am doing it mostly for
> testing - I am seeing a performance degradation going from raw to xfs
> on a 10TB filesystem - probably due to my application but I am trying
> to narrow it down so I am starting with running randomio benchmark on
> raw - then 10TB file, then 10 1TB files, then 100 100GB files, ...

you may want to try the inode64 mount option so the allocator is free to
roam your whole 10T ...

> But in general certain applications can definitely take care of the
> preallocated space (db, FB haystack, ...). 

Ok, so it sounds like you do understand the implications and you want to
be able to write into prealloc space without any metadata updates as
they are converted to initialized extents... :)

> What they require is
> minimal fragmentation so they would prefer to preallocate the space
> (fill the whole fs with contigous files) and then maintain in-files
> app specific metadata (such as valid offsets of initialized data,
> ...). What I would really like is to have vxfs equivalent of setext
> options -
> 
> setext -r <reservation> -f chggsize
> 
> And on top of that I would really love to have is vxfs equivalent of
> "nomtime" mount option. Then with O_DIRECT I have raw-like
> performance.
> 
> With the unwritten mkfs option I could get the setext semantics. So
> what's the trick (before I dive into the xfs layout)? I am guessing
> that there is no equivalent for nomtime option?

well, the unwritten=0 option did get removed:
http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=commitdiff;h=8d537733f52a642d471f6781f32f306241dd4308

TBH I'm not entirely sure why.

The unwritten flag is per-filesystem not per-file; you can still clear
that feature bit:

#define XFS_SB_VERSION_EXTFLGBIT 0x1000

by using xfs_db in -x expert mode to rewrite every superblock's
"versionnum" without that bit set.

The xfs_db "version" command will give you a more textual representation
of what is actually set before & after.

You could script the sb rewrites...

For what it's worth, your xfs_db tricks below to preallocate seem a bit
... tricky.

This should suffice:

xfs_io -f /hay/foo
xfs_io> resvsp 0 1024g
xfs_io> truncate 1024g
xfs_io> quit

Oh and you're right, there's no "nomtime" option AFAIK.

-Eric

> Thanks
> 
> Peter Vajgel



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
