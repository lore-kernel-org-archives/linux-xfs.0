Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 61EFD7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:57:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A4D4304077
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:57:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	G2D3BlzP1PeHJRGS for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:57:25 -0800 (PST)
Date: Thu, 12 Dec 2013 10:57:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/15] mkfs: validate all input values
Message-ID: <20131211235722.GT10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-5-git-send-email-david@fromorbit.com>
	<20131202170420.GA14935@infradead.org>
	<20131202231202.GA10988@dastard>
	<20131203094207.GB4906@infradead.org> <52A7E9BC.3020905@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A7E9BC.3020905@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 11, 2013 at 12:27:40PM +0800, Jeff Liu wrote:
> Hi, Dave,
> 
> While test this patch, I wonder if we should also validate non-supported
> data block size combine with the system page size or not, as we do such
> kind of checkup for non-supported inode size in mkfs...
> 
> I can simply trigger scary corruption error with backtraces on 4K page
> size machine via: mkfs.xfs -f -b size=8192 /dev/xxx; mount /dev/xxx /xfs

That's the same case as a single bit error, which is somethign we
should catch and warn loudly about. So, no, I don't think we should
change it for this reason.

That said, we do need to improve the verfiers to be able to separate
CRC validation errors from corruption detected by the verifier. This
means we'll need to rework the boiler-plate error handling in all
the verifiers and we should probably address the verbosity issue
of these corruption warnings at that point in time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
