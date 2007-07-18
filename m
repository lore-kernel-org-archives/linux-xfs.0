Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 13:10:48 -0700 (PDT)
Received: from bycast.com (bycast.com [209.139.229.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IKAebm007913
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 13:10:42 -0700
Received: from [192.168.110.101] (account mmontour HELO [192.168.110.101])
  by bycast.com (CommuniGate Pro SMTP 4.3.9)
  with ESMTPA id 2068343 for xfs@oss.sgi.com; Wed, 18 Jul 2007 12:10:39 -0700
Message-ID: <469E65AF.4080003@bycast.com>
Date: Wed, 18 Jul 2007 12:10:39 -0700
From: Mike Montour <mmontour@bycast.com>
MIME-Version: 1.0
Subject: Re: Allocating inodes from a single block
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org> <469D7035.2020507@sandeen.net> <1184724090.15488.553.camel@edge.yarra.acx> <20070718035012.GA12413810@sgi.com>
In-Reply-To: <20070718035012.GA12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

David Chinner wrote:
> The issue here is not the cluster size - that is purely an in-memory
> arrangement for reading/writing muliple inodes at once. The issue
> here is inode *chunks* (as Eric pointed out).
>
> [...]
> The best you can do to try to avoid these sorts of problems is
> use the "ikeep" option to keep empty inode chunks around. That way
> if you remove a bunch of files then fragement free space you'll
> still be able to create new files until you run out of pre-allocated
> inodes....
>   

What would it take to add an option to mkfs.xfs (or to create a
dedicated tool) that would efficiently[1] pre-allocate a specified
number of inode chunks when a filesystem is created? I know that XFS's
dynamic inode allocation is usually considered a "feature" relative to
filesystems like ext3, but there are cases where it's important to know
that you will not run out of inodes due to free-space fragmentation.
Note that "df -i" will still report a large number of "free inodes" when
this happens, so it's hard for a userspace application to know why it
got an error:

linux:~# df -i
Filesystem Inodes IUsed IFree IUse% Mounted on
/dev/cciss/c0d1p1 28353238 1873216 26480022 7% /mnt

linux:~# df
Filesystem 1k-blocks Used Available Use% Mounted on
/dev/cciss/c0d1p1 429977152 377017108 52960044 88% /mnt

gn1-a-1:~# xfs_db -r /dev/cciss/c0d1p1 -c "freesp -s"
   from to extents blocks pct
      1 1 128231 128231 0.97
      2 3 223964 555531 4.20
      4 7 400255 2113089 15.97
      8 15 838820 10436529 78.86
     16 31 8 128 0.00
total free extents 1591278
total free blocks 13233508
average free extent size 8.31628

This filesystem was created with "-i maxpct=0,size=2048", so a new chunk
of 64 inodes would require an extent of 128 KiB (32 * 4KiB blocks).

1. "efficiently" = significantly faster than a userspace script to
'touch' a few million files and then 'rm' them.
