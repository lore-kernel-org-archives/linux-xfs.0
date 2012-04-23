Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NNTd1W253816 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 18:29:39 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8N6vY2XV5Q3rqsNT for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 16:29:38 -0700 (PDT)
Date: Tue, 24 Apr 2012 09:29:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120423232936.GP9541@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120423180123.GH16881@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120423180123.GH16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 01:01:23PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, Apr 23, 2012 at 03:58:30PM +1000, Dave Chinner wrote:
> > I haven't been able to reproduce Ben's CIL commit
> > sequence assert failure from the async log flushing patch (patch
> > 12/37), so whatever the cause of that problem is is still unknown.
> > 
> > [ Actually, as I wrote this I had a concurrent rm -rf just trip this
> > assert, so the problem is real and I've obviously got more work to
> > do on this one.... ]
> 
> I just hit it again, looks like in test 273.
> [ 6587.548841] XFS: Assertion failed: push_seq > 0 && push_seq <= ctx->sequence, file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 405
> 
> This time I have a dump.  ;)

Try version 2 of the patch (#12)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
