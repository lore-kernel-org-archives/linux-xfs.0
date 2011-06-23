Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N6KZvG160907 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 01:20:36 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08CFF2737F
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 23:20:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FP1HeV8IJ884kpBT for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 23:20:33 -0700 (PDT)
Date: Thu, 23 Jun 2011 16:20:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Test Case:252 - Shows Wrong Output
Message-ID: <20110623062030.GY32466@dastard>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<4E022818.7030406@linux.vnet.ibm.com>
	<BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com, Allison Henderson <achender@linux.vnet.ibm.com>

On Thu, Jun 23, 2011 at 11:21:26AM +0530, Amit Sahrawat wrote:
> Hi,
> 
> *PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE*
                                         ^^^^^^^^^^^
> 
> The output as per the command mentioned by you:
> [root@localhost xfstests-2011-05-11]# xfs_io -f -c "truncate 20k" -c "falloc
> 0 20k" -c "pwrite 0k 8k" -c "fs
> ync" -c "pwrite 12k 8k" -c "fsync" -c "fpunch 4k 12k" -c "fiemap -v"
> /media/c/newfile
> wrote 8192/8192 bytes at offset 0
> 8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1111 ops/sec)
> command "fs
> ync" not found
> wrote 8192/8192 bytes at offset 12288
> 8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)
> /media/c/newfile:
> * EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..15]:         176..191            16   0x0
>    1: [16..23]:        192..199             8 0x800
>    2: [24..39]:        200..215            16   0x1
> *

The fpunch command did not punch the range out. 

Amit, once again you're testing on a kernel (2.6.31) that does not
support the punch operation. As I suggested previously, you need to
find out why the fpunch command is not returning an error as that is
root cause of your failures.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
