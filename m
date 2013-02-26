Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9531E7CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:52:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D581AC00C
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 12:52:47 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Vqxs0eMbnJrHXzzi for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 12:52:46 -0800 (PST)
Date: Wed, 27 Feb 2013 07:52:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130226205241.GT5551@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
	<20130224141017.GC5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
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
To: Tony Lu <zlu@tilera.com>
Cc: Alex Elder <elder@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Tue, Feb 26, 2013 at 07:28:19AM +0000, Tony Lu wrote:
> I get a reliable way to reproduce this bug. The logprint and metadump are attached.
> 
> Kernel version: 2.6.38.8

This is important....

....

.... because this:

> 4 umount /dev/sda1 /mnt
> 5 mount /dev/sda1 /mnt
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> Ending XFS recovery on filesystem: sda1 (logdev: internal)

Indicates that the unmount record is either not being written, it is
being written when there log has not been fully flushed or log
recovery is not finding it. You need to copy out the log
first to determine what the state of the log is before you mount the
filesystem - that way if log recovery is run you can see whether it
was supposed to run. (i.e. a clean log should never run recovery,
and unmount should always leave a clean log).

Either way, I'm more than 10,000 iterations into a run of 100k
iterations of this script on 3.8.0, and I have not seen a single log
recovery attempt occur. That implies you are seeing a bug in 2.6.38
that has since been fixed. It would be a good idea for you to
upgrade the system to a 3.8 kernel and determine if you can still
reproduce the problem on your system - that way we'll know if the
bug really has been fixed or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
