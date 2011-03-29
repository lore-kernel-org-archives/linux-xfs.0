Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2TJ1SJa243815 for <xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:01:28 -0500
Subject: Re: [PATCH 5/5] xfs: update busy extent tracing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110328210915.396135841@bombadil.infradead.org>
References: <20110328210614.832613417@bombadil.infradead.org>
	<20110328210915.396135841@bombadil.infradead.org>
Date: Tue, 29 Mar 2011 14:04:31 -0500
Message-ID: <1301425471.3026.250.camel@doink>
Mime-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Mon, 2011-03-28 at 17:06 -0400, Christoph Hellwig wrote:
> Add new tracepoint for the new busy extent handling helpers, and update the
> existing ones to use a common class.  Also drop the busysearch tracepoint
> now that a plain busylist search only happens in a debug assert and the
> FITRIM handler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
