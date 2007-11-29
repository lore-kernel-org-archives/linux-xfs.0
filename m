Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 15:45:08 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lATNj1wC000844
	for <linux-xfs@oss.sgi.com>; Thu, 29 Nov 2007 15:45:04 -0800
Date: Fri, 30 Nov 2007 00:45:05 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
In-Reply-To: <20071125163014.GA17922@infradead.org>
Message-ID: <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Sun, 25 Nov 2007, Christoph Hellwig wrote:
> This patch does exactly that and reverts xfs_file_readdir to what's
> basically the 2.6.23 version minus the uio and vnops junk.

Thanks, works here too (without nordirplus as a mountoption).
Am I supposed to close the bug[0] or do you guys want to leave this
open to track the Real Fix (TM) for 2.6.25?

Again, thank you for the fix!
Christian.

[0] http://bugzilla.kernel.org/show_bug.cgi?id=9400
-- 
BOFH excuse #112:

The monitor is plugged into the serial port
