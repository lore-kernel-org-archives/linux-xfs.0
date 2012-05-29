Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4TF1Xbb234973 for <xfs@oss.sgi.com>; Tue, 29 May 2012 10:01:33 -0500
Date: Tue, 29 May 2012 10:07:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120529150715.GB4721@sgi.com>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120525204536.GA4721@sgi.com>
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

On Fri, May 25, 2012 at 03:45:36PM -0500, Ben Myers wrote:
> On Thu, May 24, 2012 at 05:39:52PM -0500, Ben Myers wrote:
> > Anyway, I'll make some time to work on this tomorrow so I can test it over
> > the weekend.
> 
> This is going to spin over the weekend.  See what you think.

I'm reasonably satisfied with the test results over the weekend.  I did end up
hitting an unrelated assert:

[137111.090394] XFS: Assertion failed: (iflags & BMV_IF_DELALLOC) != 0, file: /root/xfs/fs/xfs/xfs_bmap.c, line: 5635

Signed-off-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
