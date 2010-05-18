Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I60RDT034283 for <xfs@oss.sgi.com>; Tue, 18 May 2010 01:00:28 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 360F49CB8FE
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 23:03:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	z7EKkaGNY4WcskA2 for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 23:03:43 -0700 (PDT)
Date: Tue, 18 May 2010 16:02:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs crash
Message-ID: <20100518060239.GD2150@dastard>
References: <BE430C874DBA6841A75E65151DCC6E1C04076679@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BE430C874DBA6841A75E65151DCC6E1C04076679@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
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
To: Jabir M <Jabir_M@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Mon, May 17, 2010 at 09:45:23PM -0700, Jabir M wrote:
> 
> Hi all,
> 
> I am using xfs file system on a MIPS based processor having
> linux-2.6.24. when executed a script to copy an mp4 file of 1GB
> upto 30 instances on back ground. xfs crashed displaying the
> following log. Please suggest me a solution.

I'd suggest upgrading your kernel to somethign recent - there were
lots of fixes between 2.6.24 and 2.6.28 for allocation problems
under this sort of workload....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
