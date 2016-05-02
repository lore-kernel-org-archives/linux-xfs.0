Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 555897CDA
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 13:23:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B97930404E
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 11:23:45 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id kC7xMushWPhDfZYz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 11:23:43 -0700 (PDT)
Date: Mon, 2 May 2016 20:23:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V2
Message-ID: <20160502182341.GA7077@lst.de>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
	<20160413215442.GS567@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160413215442.GS567@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

sorry for taking forever to get back to this - travel to LSF and some
other meetings and a dealine last week didn't leave me any time for
XFS work.

On Thu, Apr 14, 2016 at 07:54:42AM +1000, Dave Chinner wrote:
> Christoph, have you done any perf testing of this patchset yet to
> check that it does indeed reduce the CPU overhead of large write
> operations? I'd also be interested to know if there is any change in
> overhead for single page (4k) IOs as well, even though I suspect
> there won't be.

I've done a lot of testing earlier, and this version also looks very
promising.  On the sort of hardware I have access to now, the 4k
numbers don't change much, but with 1M writes we both increase the
write bandwith a little bit and significantly lower the cpu usage.

The simple test that demonstrates this is this, the runs are from
a 4p VM with 4G of RAM, access to a fast NVMe SSD and a small enough
data size so that writeback shouldn't throttle the buffered write
path:

MNT=/mnt
PERF="perf_3.16"        # soo smart to have tools in the kernel tree..

#BS=4k
#COUNT=65536
BS=1M
COUNT=256

$PERF stat dd if=/dev/zero of=$MNT/testfile bs=$BS count=$COUNT

with the baseline for-next tree I get the following bandwith and
cpu utilization:

BS=4k: ~600MB/s			0.856 CPUs utilized ( +-  0.32% )
BS=1M: 1.45GB/s			0.820 CPUs utilized ( +-  0.77% )

with all patches applied:

BS=4k:	~610MB/s		0.848 CPUs utilized ( +-  0.36% )
BS=1M:	~1.55GB/s		0.615 CPUs utilized ( +-  0.80% )

This is also visible in the walltime

baseline, 4k:

real	0m0.540s
user	0m0.000s
sys	0m0.533s

baseline, 1M:

real	0m0.310s
user	0m0.000s
sys	0m0.313s

multipage, 4k:

real	0m0.541s
user	0m0.010s
sys	0m0.527s

multipage, 1M:

real	0m0.272s
user	0m0.000s
sys	0m0.263s

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
