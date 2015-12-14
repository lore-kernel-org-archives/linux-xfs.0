Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D9AD7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 04:19:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31D08AC002
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:19:08 -0800 (PST)
Received: from mail1.xortex.at (mail1.xortex.at [95.130.251.167]) by
	cuda.sgi.com with ESMTP id 6REeVSGzJmkl7xIf for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:19:05 -0800 (PST)
From: =?Windows-1252?Q?Georg_Sch=F6nberger?= <g.schoenberger@xortex.com>
Subject: Re: XFS and nobarrier with SSDs
Date: Mon, 14 Dec 2015 10:18:54 +0000
Message-ID: <566E978E.2070502@xortex.com>
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
	<3496214.YTSKClH6pV@merkaba> <566E6524.6070401@xortex.com>
	<3911767.qVqsL1TcMv@merkaba> <20151214095823.GA30662@infradead.org>
In-Reply-To: <20151214095823.GA30662@infradead.org>
Content-Language: de-DE
Content-ID: <42159881-d2be-49c1-b0a6-14e54e2c0cfd>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>, Martin Steigerwald <martin@lichtvoll.de>
Cc: Jens Axboe <axboe@kernel.dk>, Linux FS-Devel <linux-fsdevel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Linux Block mailing list <linux-block@vger.kernel.org>, XFS mailing list <xfs@oss.sgi.com>

On 2015-12-14 10:58, Christoph Hellwig wrote:
> On Mon, Dec 14, 2015 at 09:38:56AM +0100, Martin Steigerwald wrote:
>> Is it safe to use XFS (or any other filesystem) on enterprise SSDs with Power
>> Loss Protection (PLP), i.e. some capacitor to provide for enough electricity
>> to write out all data in DRAM to flash after a power loss, with a reordering
>> I/O scheduler like CFQ?
> If the device does not need cache flushes it should not report requiring
> flushes, in which case nobarrier will be a noop.
OK - that would also mean that mounting with nobarrier should not make a 
performance difference.

> Or to phrase it
> differently:  If nobarrier makes a difference skipping it is not safe.
I do not fully understand that sentence, what do you mean by "makes a 
difference" and "skipping is not safe"?

-Georg
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
