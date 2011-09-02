Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82MNC5e092485 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 17:23:12 -0500
Subject: Re: [PATCH 04/25] xfs: factor extent map manipulations out of
	xfs_bmapi
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060641.102703569@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.102703569@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:11 -0500
Message-ID: <1315002191.2069.84.camel@doink>
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

Unfortunately the content of the new xfs_bmapi_update_map()
is as hideous as it was before, but at least it's isolated.
The -1 index values are just awful, even if we do know from
the logic that they're indexing non-negative offsets into the
underlying array.  I do think it's good that you encapsulated
this without changing the existing logic, but someday maybe
this function can be improved.

Reviewed-by: Alex Elder <aelder@sgi.com>

You included no signoff.  I am going to assume it included
this like the rest of the series:

    Signed-off-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
