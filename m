Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2029C7F76
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 17:03:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0D2AAC00E
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:03:30 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PN3ERbROlsHpLdPv for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 15:03:28 -0800 (PST)
Date: Fri, 20 Feb 2015 10:02:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
Message-ID: <20150219230229.GA12722@dastard>
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
	<20150219142842.GA2291@laptop.bfoster>
	<54E65878.2000302@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E65878.2000302@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Feb 19, 2015 at 03:41:12PM -0600, Eric Sandeen wrote:
> On 2/19/15 8:28 AM, Brian Foster wrote:
> > On Thu, Feb 19, 2015 at 09:32:20AM +1100, Dave Chinner wrote:
> 
> ...
> 
> >> +	if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
> >> +		bp->b_flags |= XBF_WRITE | XBF_ASYNC |
> >> +			       XBF_DONE | XBF_WRITE_FAIL;
> >> +		xfs_buf_submit(bp);
> >> +		return true;
> 
> so, shouldn't
> 
> 		xfs_buf_ioerror(bp, 0);
> 
> go under this conditional to address Brian's point... ok, you just responded to that. :)
> 
> FWIW, this is re-setting XBF_ASYNC which must already be set, right?

To be sure, to be sure.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
