Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13LHi2o160943 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 15:17:44 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 2bZHNyuknyFKS1DQ for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 13:17:43 -0800 (PST)
Date: Fri, 3 Feb 2012 21:17:41 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120203211741.GA2592@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131141604.GB46571@nsrc.org>
	<20120131202526.GJ9090@dastard> <20120203184723.GA2261@nsrc.org>
	<20120203190304.GA11809@infradead.org> <20120203210114.GD2479@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120203210114.GD2479@nsrc.org>
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

On Fri, Feb 03, 2012 at 09:01:14PM +0000, Brian Candler wrote:
> I created a fresh filesystem (/dev/sdh), default parameters, but mounted it
> with inode64.  Then I tar'd across my corpus of 100K files.  Result: files
> are located close to the directories they belong to, and read performance
> zooms.

Although perversely, keeping all the inodes at one end of the disk does
increase throughput with random reads, and also under high concurrency loads
(for this corpus of ~65GB anyway, maybe not true for a full disk)

-- original results: defaults without inode64 --

 #p  files/sec  dd_args
  1      43.57  bs=1024k
  1      43.29  bs=1024k [random]
  2      51.27  bs=1024k 
  2      48.17  bs=1024k [random]
  5      69.06  bs=1024k 
  5      63.41  bs=1024k [random]
 10      83.77  bs=1024k 
 10      77.28  bs=1024k [random]

-- defaults with inode64 --

 #p  files/sec  dd_args
  1     138.20  bs=1024k 
  1      30.32  bs=1024k [random]
  2      70.48  bs=1024k 
  2      27.25  bs=1024k [random]
  5      61.21  bs=1024k 
  5      35.42  bs=1024k [random]
 10      80.39  bs=1024k 
 10      45.17  bs=1024k [random]

Additionally, I see a noticeable boost in random read performance when using
-i size=1024 in conjunction with inode64, which I'd also like to understand:

-- inode64 *and* -i size=1024 --

 #p  files/sec  dd_args
  1     141.52  bs=1024k 
  1      38.95  bs=1024k [random]
  2      67.28  bs=1024k 
  2      42.15  bs=1024k [random]
  5      79.83  bs=1024k 
  5      57.76  bs=1024k [random]
 10      86.85  bs=1024k
 10      72.45  bs=1024k [random]

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
