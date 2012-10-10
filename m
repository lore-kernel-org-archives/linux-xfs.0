Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ANZabZ193099 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 18:35:36 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zZiiE5CxU4uDtj0D for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 16:37:07 -0700 (PDT)
Date: Thu, 11 Oct 2012 10:37:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance degradation over time
Message-ID: <20121010233704.GC23644@dastard>
References: <20121010105142.148519ca@booking.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121010105142.148519ca@booking.com>
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
To: Marcin Deranek <marcin.deranek@booking.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 10, 2012 at 10:51:42AM +0200, Marcin Deranek wrote:
> Hi,
> 
> We are running XFS filesystem on one of out machines which is a big
> store (~3TB) of different data files (mostly images). Quite recently we
> experienced some performance problems - machine wasn't able to keep up
> with updates. After some investigation it turned out that open()
> syscalls (open for writing) were taking significantly more time than
> they should eg. 15-20ms vs 100-150us.

Which is clearly an IO latency vs cache hit latency.

> Some more info about our workload as I think it's important here:
> our XFS filesystem is exclusively used as data store, so we only
> read and write our data (we mostly write). When new update comes it's
> written to a temporary file eg.
> 
> /mountpoint/some/path/.tmp/file
> 
> When file is completely stored we move it to final location eg.
> 
> /mountpoint/some/path/different/subdir/newname
> 
> That means that we create lots of files in /mountpoint/some/path/.tmp
> directory, but directory is empty as they are moved (rename() syscall)
> shortly after file creation to a different directory on the same
> filesystem.
> The workaround which I found so far is to remove that directory
> (/mountpoint/some/path/.tmp in our case) with its content and re-create
> it. After this operation open() syscall goes down to 100-150us again.
> Is this a known problem ?

By emptying the directory, you are making it smaller and likely
causing it to be cached in memory again as new files are added to
it. Over time, blocks will be removed from the cache due to memory
pressure, and latencies will be seen again.

> Information regarding our system:
> CentOS 5.8 / kernel 2.6.18-308.el5 / kmod-xfs-0.4-2

Use a more recent distro. I reworked the metadata caching algorithms
a couple of years ago to avoid these sorts of problems with memory
reclaim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
