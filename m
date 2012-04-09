Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39Liopd211874 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 16:44:50 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1q1QvbDnKTTkeXbj for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 14:44:49 -0700 (PDT)
Date: Tue, 10 Apr 2012 07:44:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
Message-ID: <20120409214445.GJ18323@dastard>
References: <4F832C25.3080408@netapp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F832C25.3080408@netapp.com>
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
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 09, 2012 at 02:36:21PM -0400, Bryan Schumaker wrote:
> The cleanup function is trapped before _require_scratch() is called, and
> then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"

It doesn't need to clean up the scratch device - tests need to mkfs
it first before using it, so just remove the $tmp* files. The sae
fix is needed for tests 274 and 275.

Also, it shouldn't be using "-rf" to do cleanup - "rm -f $tmp.*" is
sufficient to remove all the tmp files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
