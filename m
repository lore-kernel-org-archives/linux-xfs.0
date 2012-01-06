Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q063s8G0246316 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 21:54:08 -0600
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Ry5hwXqsWX0a1Ml0 for
	<xfs@oss.sgi.com>; Thu, 05 Jan 2012 19:54:06 -0800 (PST)
Message-ID: <4F067052.8080905@cn.fujitsu.com>
Date: Fri, 06 Jan 2012 11:53:54 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests/071 FAIL with pwrite64: Invalid argument
References: <4EDD8F16.4050402@cn.fujitsu.com> <20111206110533.GD28326@dastard>
	<4EDF2133.7030702@cn.fujitsu.com> <20111207100748.GB14273@dastard>
	<4EE02022.5000403@cn.fujitsu.com>
	<20120104165341.GA21075@infradead.org>
In-Reply-To: <20120104165341.GA21075@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


Christoph Hellwig said the following on 2012-1-5 0:53:
> This still fails in my 32-bit test VM:
> 

yeah:(

This case will exercise IO at large file with as following condition:
  - below upperbound
  - upperbound
  - above upperbound
But in 32-bit, the case cannot satisfy the condition unless upperbound=16.
When upperbound=16, the case will hung.

The following steps will hung.
# uname -a
Linux Fedora-16-x86 3.1.0-7.fc16.i686.PAE #1 SMP Tue Nov 1 20:53:45 UTC 2011 i686 i686 i386 GNU/Linux
# rpm -q xfsprogs
xfsprogs-3.1.5-1.fc16.i686
# mount /dev/sda10 /sda10/
# xfs_info /dev/sda10
meta-data=/dev/sda10             isize=256    agcount=4, agsize=305088 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1220352, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# cd /sda10/
# xfs_io -f -c "pwrite 17592186040320 512" tmp
wrote 512/512 bytes at offset 17592186040320
512.000000 bytes, 1 ops; 0.0000 sec (12.850 MiB/sec and 26315.7895 ops/sec)
# xfs_bmap -v tmp

This will hung:( 
What is wrong with the steps or xfs wrong?

-- 
Best Regards,
Peng

> --- 071.out	2009-05-10 16:48:46.000000000 +0000
> +++ 071.out.bad	2012-01-04 16:47:05.000000000 +0000
> @@ -40,14 +40,14 @@
>  
>   
>  Writing 512 bytes, offset is +0 (direct=false)
> -pwrite64: File too large
> +wrote 512/512 bytes at offset <OFFSET>
>  Reading 512 bytes (direct=false)
> -read 0/512 bytes at offset <OFFSET>
> +read 512/512 bytes at offset <OFFSET>
> 
> and so on
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
