Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UELZE6260943 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 09:21:35 -0500
Date: Mon, 30 Apr 2012 09:24:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/37] xfs: current 3.4 patch queue
Message-ID: <20120430142431.GK16881@sgi.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<20120423180123.GH16881@sgi.com> <20120423232936.GP9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120423232936.GP9541@dastard>
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

Dave,

On Tue, Apr 24, 2012 at 09:29:36AM +1000, Dave Chinner wrote:
> On Mon, Apr 23, 2012 at 01:01:23PM -0500, Ben Myers wrote:
> > On Mon, Apr 23, 2012 at 03:58:30PM +1000, Dave Chinner wrote:
> > > I haven't been able to reproduce Ben's CIL commit
> > > sequence assert failure from the async log flushing patch (patch
> > > 12/37), so whatever the cause of that problem is is still unknown.
> > > 
> > > [ Actually, as I wrote this I had a concurrent rm -rf just trip this
> > > assert, so the problem is real and I've obviously got more work to
> > > do on this one.... ]
> > 
> > I just hit it again, looks like in test 273.
> > [ 6587.548841] XFS: Assertion failed: push_seq > 0 && push_seq <= ctx->sequence, file: /root/xfs/fs/xfs/xfs_log_cil.c, line: 405
> > 
> > This time I have a dump.  ;)
> 
> Try version 2 of the patch (#12)....

Yep, with version 2 I haven't seen this in awhile.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
