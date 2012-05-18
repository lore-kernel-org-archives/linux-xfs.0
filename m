Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4I9blaX118059 for <xfs@oss.sgi.com>; Fri, 18 May 2012 04:37:47 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AtLUw6Afzi8P0vPw for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 02:37:46 -0700 (PDT)
Date: Fri, 18 May 2012 19:37:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120518093743.GV25351@dastard>
References: <CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507225944.GA5091@dastard> <20120509073507.GQ5091@dastard>
	<4FAADCA8.6030702@sgi.com> <4FAB237D.5050608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FAB237D.5050608@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Juerg Haefliger <juergh@gmail.com>, xfs@oss.sgi.com

On Wed, May 09, 2012 at 09:10:05PM -0500, Mark Tinguely wrote:
> On 05/09/12 16:07, Mark Tinguely wrote:
> 
> I notice in the trace_report_180secs.txt file, lsn (ail_push and the
> ungrants) displays are not correct. It acts like the BLOCK_LSN() is
> shifting too much.

What do you mean by "not correct"?

> Block sequence numbers never make it too far
> above 1100 before incrementing the cycle. I think the problem is the
> trace not the sequence numbers.

The log is only 576 filesystem blocks (which are 1k in size) long,
which means 1152 sectors, so the LSN block number portion will never
go above 1152. It looks correct to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
