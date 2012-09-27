Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RClwco094718 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 07:47:58 -0500
Received: from josefsipek.net (josefsipek.net [64.9.206.49]) by cuda.sgi.com
	with ESMTP id syAgvXlLnOdw4QE8 for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 05:49:17 -0700 (PDT)
Date: Thu, 27 Sep 2012 08:49:15 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20120927124914.GD28852@poseidon>
References: <20120418151139.GC4652@poseidon.cudanet.local>
	<20120418234821.GR6734@dastard>
	<20120419154601.GB8230@poseidon.cudanet.local>
	<20120419225603.GA9541@dastard>
	<20120420135820.GB9189@poseidon.cudanet.local>
	<20120421002932.GG9541@dastard>
	<20120423202441.GD21260@poseidon.cudanet.local>
	<20120423232759.GO9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120423232759.GO9541@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 24, 2012 at 09:27:59AM +1000, Dave Chinner wrote:
...
> So, yes, your hangs are definitely due to inode buffer RMW cycles
> when trying to flush dirty inodes from the cache. I have a few
> ideas on how to fix this - but I'm not sure whether a current TOT
> solution will be easily back-portable. The simplest solution is a
> readahead based solution - AIL pushing is async, and will cycle back
> to inodes that it failed to flush the first time past, so triggering
> readahead on the first pass might work just fine.

Have you had time to look at this?  (We got bitten by this again and I
really don't want to go back to ext4.)  Is there anything I can help with?

Jeff.

-- 
Evolution, n.:
  A hypothetical process whereby infinitely improbable events occur with
  alarming frequency, order arises from chaos, and no one is given credit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
