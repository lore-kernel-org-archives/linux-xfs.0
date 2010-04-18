Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3IHG8ZG149960 for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 12:16:08 -0500
Date: Sun, 18 Apr 2010 13:18:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 4/5] xfs: record log sector size rather than log2(that)
Message-ID: <20100418171805.GA28944@infradead.org>
References: <201004162053.o3GKrrgr025189@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004162053.o3GKrrgr025189@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 16, 2010 at 03:53:53PM -0500, Alex Elder wrote:
> Change struct log so it keeps track of the size (in basic blocks) of
> a log sector in l_sectBBsize rather than the log-base-2 of that
> value (previously, l_sectbb_log).  The name was chosen for
> consistency with the other fields in the structure that represent
> a number of basic blocks.
> 
> (Updated so that a variable used in computing and verifying a log's
> sector size is named "log2_size".  Also added the "BB" to the
> structure field name, based on feedback from Eric Sandeen.  Also
> dropped some superfluous parentheses.)

Looks good.  Eventually we should replace all the "BB" with "bb" in
the log code, but for now this is a good enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
