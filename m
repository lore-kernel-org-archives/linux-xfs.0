Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D969804E
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 15:03:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EEB308F8064
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 13:03:15 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	COEKvkUENUqFpBgK for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 13:03:14 -0800 (PST)
Date: Tue, 5 Mar 2013 08:03:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Message-ID: <20130304210311.GQ23616@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
	<20130223000802.GB26081@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
	<20130223235546.GA5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
	<20130224141017.GC5551@dastard>
	<BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
	<5130CE9E.9080501@sgi.com> <51310E7A.1000905@sgi.com>
	<BAB94DBB0E89D8409949BC28AC95914C47C4C19C@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C4C19C@USMAExch1.tad.internal.tilera.com>
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
Cc: Alex Elder <elder@kernel.org>, Mark Tinguely <tinguely@sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Mon, Mar 04, 2013 at 08:32:45AM +0000, Tony Lu wrote:
> Thanks for you following up.
> 
> My apologize that I just found that it is one change I made before
> that causes this problem. This change forces mkfs.xfs to format
> xfs partitions whose sectorsize were not smaller than 4096 bytes,
> which was due to a bug that earlier versions of xfs used (struct
> *page)->private(long) as a bitmap to represent each block's state
> within a page (the size of a page could be 64K or larger, then it
> needs 128 bit or more to represent each block's state within a
> page).

You do realise that bug doesn't affect x86-64 platforms as they
don't support 64k pages?

> This is reproducible on 2.6.38.6 kernel on X86. But I do not get
> why this change makes the xfs log inconsistent during
> mount/cp/umount operations.

Neither do I, and I don't care to look any further because the
problem is of your own making. In future, please check first that
the bug you are reporting is reproducable on a current upstream
kernel and userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
