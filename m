Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA823ULA085293 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:03:30 -0600
Message-ID: <1320717807.3186.98.camel@doink>
Subject: Re: [PATCH v2 7/8] xfsdump: path lookup cache must be thread specific
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:03:27 -0600
In-Reply-To: <1320699511-12281-8-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-8-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> The xfsrestore path lookup routine (maps an ino + generation number to a
> pathname) contains a cache for fast lookups of consecutive files in the
> same parent directory. This cache either needs to be protected by a lock
> or a cache is needed per thread. I took the latter approach since it
> doesn't add lock contention and it increases the cache hit rate (it's
> relatively unlikely that each stream is processing files in the same
> directory).
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

So you're fixing a bug, and making it work
better at the same time, by simply adding one
keyword.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
