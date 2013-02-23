Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A62837F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 18:08:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E82D304032
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 16:08:06 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fedQGSW0AyTGqKd2 for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 16:08:04 -0800 (PST)
Date: Sat, 23 Feb 2013 11:08:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130223000802.GB26081@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
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

On Fri, Feb 22, 2013 at 08:12:52AM +0000, Tony Lu wrote:
> I encountered the following panic when using xfs partitions as rootfs, which
> is due to the truncated log data read by xlog_bread_noalign(). We should
> extend the buffer by one extra log sector to ensure there's enough space to
> accommodate requested log data, which we indeed did in xlog_get_bp(), but we
> forgot to do in xlog_bread_noalign().

We've never done that round up in xlog_bread_noalign(). It shouldn't
be necessary as xlog_get_bp() and xlog_bread_noalign() are doing
fundamentally different things. That is, xlog_get_bp() is ensuring
the buffer is large enough for the upcoming IO that will be
requested, while xlog_bread_noalign() is simply ensuring what it is
passed is correctly aligned to device sector boundaries.

So, if you have to fudge an extra block for xlog_bread_noalign(),
that implies that what xlog_bread_noalign() was passed was probably
not correct. It also implies that you are using sector sizes larger
than 512 bytes, because that's the only time this might matter. Put
simply, this:

> XFS mounting filesystem sda2
> Starting XFS recovery on filesystem: sda2 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed

Is not sufficient information for me to determine if you've correctly
analysed the problem you were seeing and that this is the correct
fix for it. I don't even know what kernel you are seeing this on, or
how you are reproducing it.

Note that I'm not saying the fix isn't necessary or correct, just
that I cannot review it based this commit message.  Given that this
code is essentially unchanged in behaviour since the large sector
size support was adding in 2003(*), understanding how it is
deficient is critical part of the reviewi process....

Information you need to provide so I have a chance of reviewing
whether it is correct or not:

	- what kernel you saw this on,
	- what the filesystem configuration was
	- what workload reproduced this problem (a test case would
	  be nice, and xfstest even better)
	- the actual contents of the log that lead to the short read
	  during recovery
	- whether xfs_logprint was capable of parsing the log
	  correctly
	- where in the actual log recovery process the failure
	  occurred (e.g. was it trying to recover transactions from
	  a section of a wrapped log?)

IOWs, please show your working so we can determine if this is the
root cause of the problem you are seeing. :)

(*) http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=f14e527f411712f89178c31370b5d733ea1d0280

FWIW, I think your change might need work - there's the possibility
that is can round up the length beyond the end of the log if we ask
to read up to the last sector of the log (i.e. blkno + blklen ==
end of log) and then round up blklen by one sector....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
