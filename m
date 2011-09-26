Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QCRojR160277 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 07:27:50 -0500
Subject: Re: [PATCH] xfstests: test timestamps before the epoch
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110926112716.GA22382@infradead.org>
References: <4E778C51.7040100@redhat.com>
	<20110926112716.GA22382@infradead.org>
Date: Mon, 26 Sep 2011 07:27:49 -0500
Message-ID: <1317040069.3030.18.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-09-26 at 07:27 -0400, Christoph Hellwig wrote:
> This one actually ends up failing on XFS for me:
> 
> @@ -1,5 +1,5 @@
>  QA output created by 258
>  Creating file with timestamp of Jan 1, 1960
>  -Stat of file yields: -315593940
>  +Stat of file yields: -315615540
>   Remounting to flush cache
>  -Stat of file yields: -315593940
>  +Stat of file yields: -315615540
> 
> Note that we still get the same for both, it just seems XFS rounds it
> a bit different.


I haven't seen this one fail.  Must have to do with
some FS configuration options (like blocksize or
something).

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
