Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0AIWa5s034371 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 12:32:37 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH,
	updated]  xfs: Ensure we force all busy extents inrange to disk
Date: Sun, 10 Jan 2010 12:28:08 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6941@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100109193514.GA12372@infradead.org>
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
> Looks good,

Thanks, I will publish this today.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>>  TRACE_EVENT(xfs_alloc_busysearch,
>>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
>> -		 xfs_extlen_t len, int found),
>> -	TP_ARGS(mp, agno, agbno, len, found),
>> +		 xfs_extlen_t len, int found, xfs_lsn_t lsn),
>> +	TP_ARGS(mp, agno, agbno, len, found, lsn),
> 
> The found argument to this tracepoint can be dropped - with the new loop
> style it doesn't work anymore, and a non-zero lsn provides the same
> information.

I agree with that, and have now removed that argument
from the tracepoint, with the net effect that the lsn
argument simply replaces it.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
