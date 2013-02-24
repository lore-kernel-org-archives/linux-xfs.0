Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E7C67F50
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 08:10:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C783304039
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 06:10:27 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EhzTp9JYH0LIausV for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 06:10:25 -0800 (PST)
Date: Mon, 25 Feb 2013 01:10:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130224141017.GC5551@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
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

On Sun, Feb 24, 2013 at 04:46:30AM +0000, Tony Lu wrote:
> >> For example, if xlog_bread_noalign() wants to read blocks from #1
> >> to # 9, in which case the passed parameter blk_no is 1, and nbblks
> >> is 8, sectBBsize is 8, after the round down and round up
> >> operations, we get blk_no as 0, and nbblks as still 8. We
> >> definitely lose the last block of the log data.
> >
> >Yes, I fully understand that. But I also understand how the log
> >works and that this behaviour *should not happen*. That's why
> >I'm asking questions about what the problem you are trying to fix.
> 
> I am not sure about this, since I saw many reads on
> non-sector-align blocks even when successfully mounting good XFS
> partitions.

I didn't say that non-sector align reads should not be attempted by
log recovery - it's obvious from the on disk format of the log that
we have to parse it in chunks of 512 bytes to make sense of it's
contents, and that leads to the 512 byte reads and other subsequent
unaligned reads.

*However*

Seeing that there are unaligned reads occurring does not mean that
the structures in the log should be unaligned. Your test output
indicated a log record header at an unaligned block address, and
that's incorrect. It doesn't matter what the rest of the log
recovery code does with non-aligned IO - the fact is that your debug
implies that the contents of the log is corrupt and that implies a
deeper problem....

> And also there is code in xlog_write_log_records() which handles
> non-sector-align reads and writes.

Yes, it does handle it, but that doesn't mean that it is correct to
pass unaligned block ranges to it.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
