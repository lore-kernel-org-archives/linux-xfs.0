Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7C1F7F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 18:41:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7598030404E
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 16:41:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	moN4sN7B0bSl2rOq for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 16:41:40 -0700 (PDT)
Date: Tue, 3 Jun 2014 09:41:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
Message-ID: <20140602234135.GO6677@dastard>
References: <5363B4C9.4000900@sandeen.net> <5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
	<5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538C5E67.6090005@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 02, 2014 at 02:22:15PM +0300, Martin Papik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> 
> >> How can I detect this situation? I mean I didn't see anything in 
> >> /proc/mounts or references to the mount point from /proc/<pid>/*,
> >> so I only managed to correct it (chdir elsewhere) by chance on a
> >> hunch. Would it not be desirable to know that there's a phantom
> >> FS referenced by a number of processes?
> > 
> > lsof.
> 
> No good.

lsof reports such things as belonging to / because it can't find the
correct path for them. Indeed, you can't find them by filtering on
mount point, file or anything else. But they are there.

e.g:

$ sudo mount /dev/vdc /mnt/scratch
$ cd /mnt/scratch
$ sudo umount -l /mnt/scratch
$ sleep 300
$ cd ~
$ ps -ef |grep [s]leep
dave     16341  7432  0 09:27 pts/1    00:00:00 sleep 300
$ sudo lsof |grep sleep
sleep     16341            dave  cwd       DIR             253,32        6         96 /
sleep     16341            dave  rtd       DIR                8,1     4096          2 /
sleep     16341            dave  txt       REG                8,1    31208      32607 /bin/sleep
sleep     16341            dave  mem       REG                8,1  1742520     245384 /lib/x86_64-linux-gnu/libc-2.17.so
sleep     16341            dave  mem       REG                8,1   145160     245381 /lib/x86_64-linux-gnu/ld-2.17.so
sleep     16341            dave  mem       REG                8,1  1607584      98063 /usr/lib/locale/locale-archive
sleep     16341            dave    0u      CHR              136,1      0t0          4 /dev/pts/1
sleep     16341            dave    1u      CHR              136,1      0t0          4 /dev/pts/1
sleep     16341            dave    2u      CHR              136,1      0t0          4 /dev/pts/1

See the first two DIR lines? They have different devices but the
same path (/). That's what you need to look for - the non-root device
with a root path - in this case 253,32:

$ ls -l /dev/vdc
brw-rw---- 1 root disk 253, 32 Jun  3 09:01 /dev/vdc
$

With this knowledge, the simple way:

$ sudo lsof |grep "253,32"
bash       7432            dave  cwd       DIR             253,32        6         96 /
sleep     16341            dave  cwd       DIR             253,32        6         96 /

There's the two processes  holding references to the unmounted
filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
