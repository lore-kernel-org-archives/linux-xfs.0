Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 04:49:16 -0800 (PST)
Received: from smtp123.sbc.mail.sp1.yahoo.com (smtp123.sbc.mail.sp1.yahoo.com [69.147.64.96])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAECn3Vg008079
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 04:49:04 -0800
Date: Wed, 14 Nov 2007 03:49:07 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: 2.6.24-rc2 XFS nfsd hang --- filldir change responsible?
Message-ID: <20071114114907.GA31466@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114070400.GA25708@puku.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, Christian Kujau <lists@nerdbynature.de>

On Tue, Nov 13, 2007 at 11:04:00PM -0800, Chris Wedgwood wrote:

> With 2.6.24-rc2 (amd64) I sometimes (usually but perhaps not always)
> see a hang when accessing some NFS exported XFS filesystems.  Local
> access to these filesystems ahead of time works without problems.
>
> This does not occur with 2.6.23.1.  The filesystem does not appear
> to be corrupt.

After some bisection pain (sg broken in the middle and XFS not
compiling in other places) the regression seems to be:

    commit 051e7cd44ab8f0f7c2958371485b4a1ff64a8d1b
    Author: Christoph Hellwig <hch@infradead.org>
    Date:   Tue Aug 28 13:58:24 2007 +1000

	[XFS] use filldir internally

There have been a lot of changes since this so reverting it and
retesting as-is won't work. I'll have to see what I can come up with
after some sleep.

I'm not building/testing with dmapi --- perhaps that makes a
difference here?  I would think it would have broken with xfsqa but
the number of bug reports seems small so far.
