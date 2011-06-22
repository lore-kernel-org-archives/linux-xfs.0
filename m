Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MHMsmj107259 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 12:22:55 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 115A8DFCB70
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:22:53 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id vxD887TVOiAFRUrI for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:22:53 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5MGpgCM015887
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 12:51:42 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5MHMgui147460 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:22:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5MHMgvI024312 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:22:42 -0400
Message-ID: <4E0224DD.5030501@linux.vnet.ibm.com>
Date: Wed, 22 Jun 2011 10:22:37 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: XFS Test Case:252 - Shows Wrong Output
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
In-Reply-To: <BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On 06/22/2011 03:48 AM, Amit Sahrawat wrote:
> echo "13. data ->  unwritten ->  data"
> rm -f $testfile
> xfs_io -f -c "truncate 20k" -c \
> "falloc 0 20k" -c "pwrite 0k 8k" -c "fsync" -c "pwrite 12k 8k" -c  \
> "fsync" -c "fpunch 4k 12k" -c "fiemap -v" $testfile | $filter_cmd
>
> *Original Output(Taken from 252.out):
> *        13. data ->  unwritten ->  data
> 0: [0..7]: data
> 1: [8..31]: hole
> 2: [32..39]: data
> *Output in my case*
>    13. data ->  unwritten ->  data
> 0: [0..15]: data
> 1: [16..23]: unwritten
> 2: [24..39]: data

Hi there,

I believe the -c "fpunch 4k 12k" is supposed to be what puts the hole 
there.  If I run the command you have above, the fiemap should show you 
a hole.  Something like this:

xfs_io -f -c "truncate 20k" -c "falloc 0 20k" -c "pwrite 0k 8k" -c 
"fsync" -c "pwrite 12k 8k" -c  "fsync" -c "fpunch 4k 12k" -c "fiemap -v" 
somefile

wrote 8192/8192 bytes at offset 0
8 KiB, 2 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)
wrote 8192/8192 bytes at offset 12288
8 KiB, 2 ops; 0.0000 sec (269.397 MiB/sec and 68965.5172 ops/sec)
somefile:
  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    0: [0..7]:          296..303             8   0x0
    1: [8..31]:         hole                24
    2: [32..39]:        328..335             8   0x1

If you do not see the hole there, it could be that your punch hole 
operation is failing for some reason.

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
