Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 09D5D7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8323DAC005
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 15:12:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7nzZSrpMnGrzBhbr for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 15:12:19 -0700 (PDT)
Date: Fri, 25 Oct 2013 09:11:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstest: fix filtering in 206 for ftype and projid32bit
Message-ID: <20131024221136.GZ2797@dastard>
References: <20131024215652.413619467@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024215652.413619467@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: XFS Community <xfs@oss.sgi.com>

On Thu, Oct 24, 2013 at 04:56:42PM -0500, Mark Tinguely wrote:
> xfs/206 displays the output for mkfs.xfs, xfs_growfs and xfs_info.
> Change the filtering to hide the new output for the field type
> feature.
> 
> While cleaning up the ftype output, also clean up the projid32bit
> output in xfs_growfs and xfs_info.

What about the _filter_mkfs function that other tests use?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
