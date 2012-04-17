Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H8WEdu034749 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 03:32:14 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1AlALSoyA5TfuLtY for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 01:32:12 -0700 (PDT)
Date: Tue, 17 Apr 2012 18:32:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS blocked task in xlog_cil_force_lsn
Message-ID: <20120417083210.GI6734@dastard>
References: <4F8BC0B9.90604@profihost.ag> <20120416235647.GA6734@dastard>
	<4F8D27A1.2090809@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F8D27A1.2090809@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Philipp Herz - Profihost AG <p.herz@profihost.ag>, stable@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 17, 2012 at 10:19:45AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 17.04.2012 01:56, schrieb Dave Chinner:
> > Your first question should be: is this a known problem?
> > And the answer to that is: I don't think so.
> Sorry absolutely correct.
> 
> > So, is the system actually hung?
> No. The kernel has ended the stalled request.
> 
> > Were there IO errors around this time?
> No.
> 
> > did the system recover and continue to work normally?
> Yes.
> 
> > What's your storage hardware, application, workload, etc?
> It a Raid 10 of 1TB SATA Drives in front of a 3Ware Controller doing
> heavy rsync backups.

Hmmm. It sounds like it is just taking a long time for the IO to
complete, not that there is any other problem. If the IO is realy,
really slow, the a log force is definitely a place it coul dstall
for some time.

Does the RAID controller have a BBWC? What IO scheduler are you
using? Does mounting with nobarriers reduce the stall time? Can you
reduce the IO load so that it doesn't end up in this state?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
