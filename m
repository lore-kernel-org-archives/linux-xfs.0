Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B12947F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 04:34:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68C47304032
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:34:48 -0800 (PST)
Received: from mail1.xortex.at (mail1.xortex.at [95.130.251.167]) by
	cuda.sgi.com with ESMTP id MPsTjqwHxtDvvKHk for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:34:42 -0800 (PST)
From: =?Windows-1252?Q?Georg_Sch=F6nberger?= <g.schoenberger@xortex.com>
Subject: Re: XFS and nobarrier with SSDs
Date: Mon, 14 Dec 2015 10:34:30 +0000
Message-ID: <566E9B36.9080509@xortex.com>
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
	<3496214.YTSKClH6pV@merkaba> <566E6524.6070401@xortex.com>
	<3911767.qVqsL1TcMv@merkaba> <20151214095823.GA30662@infradead.org>
	<566E978E.2070502@xortex.com> <20151214102750.GA29192@infradead.org>
In-Reply-To: <20151214102750.GA29192@infradead.org>
Content-Language: de-DE
Content-ID: <e043d16c-d1e9-48b7-be54-07b68f887cfc>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, XFS mailing list <xfs@oss.sgi.com>, Linux Block mailing list <linux-block@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Linux FS-Devel <linux-fsdevel@vger.kernel.org>

On 2015-12-14 11:27, Christoph Hellwig wrote:
> On Mon, Dec 14, 2015 at 10:18:54AM +0000, Georg Sch?nberger wrote:
>>> Or to phrase it
>>> differently:  If nobarrier makes a difference skipping it is not safe.
>> I do not fully understand that sentence, what do you mean by "makes a
>> difference" and "skipping is not safe"?
> The rule of thumb is: if nobarrier makes your workload run faster you
> should not be using it, aka: don't use it.
OK, thanks for clarification.
Should the XFS FAQ be updated?
*http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
