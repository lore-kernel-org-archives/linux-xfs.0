Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LHnckb086084 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 11:49:38 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfstests: fix format string warnings in locktest.c
Date: Thu, 21 Jan 2010 11:50:17 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B0@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100121173237.GA25322@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Jan 21, 2010 at 10:34:12AM -0600, Alex Elder wrote:
>> Alex Elder wrote:
>>> Christoph Hellwig wrote:
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> 
>>> Looks good.
>>> 
>>> Reviewed-by: Alex Elder <aelder@sgi.com>
>> 
>> By the way, the content of this patch is already incorporated
>> in Dave's patch "[7/8] xfstests: fix printf warnings in loctest.c".
>> http://patchwork.xfs.org/patch/517/
> 
> Dave fixed the warnings not quite correctly, he switched from %d which
> was totally wrong to %lu which is only correct on some 64-bit
> architectures.  %zd is the really correct format.

Ah, yes, you are correct.  So the right fix is a combination
of the two patches.  All I noticed was that when I tried to
apply your patch on top of Dave's it didn't work...

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
