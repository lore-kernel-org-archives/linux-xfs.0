Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5312E7CB9
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:54:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23D8D30408D
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:54:14 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id SDxXsqire38ps5vo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:54:11 -0800 (PST)
Date: Mon, 22 Feb 2016 09:54:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [lkp] [xfs] fbcc025613: -5.6% fsmark.files_per_sec
Message-ID: <20160222085409.GA19493@lst.de>
References: <87vb5lqunb.fsf@yhuang-dev.intel.com>
	<20160219064932.GX14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160219064932.GX14668@dastard>
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
Cc: kernel test robot <ying.huang@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, lkp@01.org, Christoph Hellwig <hch@lst.de>

On Fri, Feb 19, 2016 at 05:49:32PM +1100, Dave Chinner wrote:
> That doesn't really seem right. The writeback should be done as a
> single ioend, with a single completion, with a single setsize
> transaction, adn then all the pages are marked clean sequentially.
> The above behaviour implies we are ending up doing something like:
> 
> fsync proc		io completion
> wait on page 0
> 			end page 0 writeback
> 			wake up page 0
> wait on page 1
> 			end page 1 writeback
> 			wake up page 1
> wait on page 2
> 			end page 2 writeback
> 			wake up page 2
> 
> Though in slightly larger batches than a single page (10 wakeups a
> file, so batches of around 100 pages per wakeup?). i.e. the fsync
> IO wait appears to be racing with IO completion marking pages as
> done. I simply cannot see how the above change would cause that, as
> it was simply a change in the IO submission code that doesn't affect
> overall size or shape of the IOs being submitted.

Could this be the lack of blk plugs, which will cause us to complete
too early?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
