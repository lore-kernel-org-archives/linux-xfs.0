Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD51F7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 14:21:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D50FD304051
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 12:21:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HKLdLif77AmwGTBm for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 12:21:25 -0800 (PST)
Date: Tue, 9 Feb 2016 07:21:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20160208202123.GL27429@dastard>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20160208073631.GA1789@infradead.org>
	<20160208075403.GA29242@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208075403.GA29242@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Feb 07, 2016 at 11:54:03PM -0800, Christoph Hellwig wrote:
> On Sun, Feb 07, 2016 at 11:36:31PM -0800, Christoph Hellwig wrote:
> > FYI, I recently started testing this series again after a trivial
> > rebase to 4.5-rc2, and this patch seems to cause reproducible failures
> > of generic/311 (fsync tester)
> 
> And by coincidence you posted a new version the night before I posted
> this mail.  It still shows that same failure.

What is your test config? The only failures I've had recently of
generic/311 were caused by a bug in the fsync-tester application.
This was fixed by commit 9165a84 ("fsync-tester: reopen files with
correct flags") that was pushed out in the fstests update I did
yesterday.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
