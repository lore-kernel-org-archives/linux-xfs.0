Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MHab4m107751 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 12:36:38 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1D97174AB88
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:36:37 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id RSbcrfae6qULhkwU for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2011 10:36:37 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5MHG0kW032192
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:16:00 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5MHaaFA127568 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:36:36 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5MBaPaA025229
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 05:36:25 -0600
Message-ID: <4E022818.7030406@linux.vnet.ibm.com>
Date: Wed, 22 Jun 2011 10:36:24 -0700
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
>
> Please let me know about the vailidity of this result.

Hi there,

It looks like the "fpunch 4k 12k" is supposed to be what puts the hole 
there.  If I run the command you have above, the fiemap should show a 
hole like this:

xfs_io -f -c "truncate 20k" -c "falloc 0 20k" -c "pwrite 0k 8k" -c 
"fsync" -c "pwrite 12k 8k" -c  "fsync" -c "fpunch 4k 12k" -c "fiemap -v" 
somefile
wrote 8192/8192 bytes at offset 0
8 KiB, 2 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)
wrote 8192/8192 bytes at offset 12288
8 KiB, 2 ops; 0.0000 sec (339.674 MiB/sec and 86956.5217 ops/sec)
somefile:
  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    0: [0..7]:          256..263             8   0x0
    1: [8..31]:         hole                24
    2: [32..39]:        288..295             8   0x1

If you do not see the hole, it could be your punch hole operation is 
failing for some reason.

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
