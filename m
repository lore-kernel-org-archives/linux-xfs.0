Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89Nu4KC066558 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:56:04 -0500
Subject: Re: [PATCH 16/25] xfs: move extent records into bmalloca structure
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060643.900337846@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.900337846@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:55:59 -0500
Message-ID: <1315612559.1999.131.camel@doink>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> Rather that putting extent records on the stack and then pointing to
> them in the bmalloca structure which is in the same stack frame, put
> the extent records directly in the bmalloca structure. This reduces
> the number of args that need to be passed around.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Interesting that the only place that uses that
structure (defines an object of that type anyway)
is xfs_bmapi_write().

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
