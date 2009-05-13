Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4DLmZsb176421 for <xfs@oss.sgi.com>; Wed, 13 May 2009 16:48:35 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 538861D30550
	for <xfs@oss.sgi.com>; Wed, 13 May 2009 14:48:41 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id DdNLU5o9aFvGimKg for <xfs@oss.sgi.com>;
	Wed, 13 May 2009 14:48:41 -0700 (PDT)
Message-ID: <4A0B4037.70402@sandeen.net>
Date: Wed, 13 May 2009 16:48:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: file preallocation without unwritten flag being set
References: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
	<4A0A0E76.6000701@sandeen.net>
	<618437.93111.qm@web65601.mail.ac4.yahoo.com>
	<4A0A55E0.4010202@sandeen.net>
	<705795.15734.qm@web65604.mail.ac4.yahoo.com>
In-Reply-To: <705795.15734.qm@web65604.mail.ac4.yahoo.com>
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
To: p v <pvlogin@yahoo.com>
Cc: xfs@oss.sgi.com

p v wrote:
> doesn't seem to work - I tried to clear the extflg in the versionnum
> of the superblock (in every copy of it as well) but it doesn't work.
> The flag is still set on all extents.
> 
> xfs_db> version versionnum [0xb4a4+0x8] =
> V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2 xfs_db> version
> 0xa4a4 0x8 versionnum [0xa4a4+0x8] =
> V4,NLINK,ALIGN,DIRV2,LOGV2,MOREBITS,ATTR2
> 
> typeset -i agcount=$(xfs_db -c "sb" -c "print" /dev/sda | grep
> agcount) typeset -i i=0 while [[ $i != $agcount ]] do xfs_db -x -c
> "sb $i" -c "write versionnum 0xa4a4" /dev/sda i=i+1 done
> 
> And once I make the file xfs_repair complains and resets the sb flag
> - my guess is that in the extent allocation path it is hardcoded for
> the version 4 - any extent allocated beyond file size will get the
> flag ...

Oh, you'd probably need to do this when there are no files already with
the flag, i.e. on a fresh fs I think.

> Also - 2 questions -
> 
> 1) what is inode64 and where can I find out all of the undocumented
> mkfs/mount options (it's unfortunate that such a good fs doesnt' have
> a correspondingly good documentation)

all options for mkfs should be doc'd in the mkfs.xfs manpage

inode64 is also doc'd in my mount manpage:

       inode64
              Indicates  that  XFS  is  allowed to create inodes at any
              location in the filesystem, including  those  which  will
              result  in  inode  numbers occupying more than 32 bits of
              significance.  This is provided for backwards compatibil-
              ity,  but  causes  problems  for backup applications that
              cannot handle large inode numbers.

> 2) why is the largest extent size limited to xxx blocks(can't find
> out thenumber

... various containers that may limit the max size, I don't remember offhand

 - when does the inode get finally flushed? ls -i
> reports 19 as the inode number but even after unmounting inode 19 in
> xfs_db still shows a free inode - is it still only in the log???) ? I
> assumed that xfs_bmap gets me the correct number of extents but now
> looking at the inode with xfs_db it's obvious that xfs_bmap reports
> contiguous ranges rather than actual extents in the blockmap tree

hm, some cut & paste examples might be good here to show us exactly what
you're seeing.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
