Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82MNGEE092503 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 17:23:16 -0500
Subject: Re: [PATCH 05/25] xfs: introduce xfs_bmapi_read()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060641.292341912@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.292341912@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:15 -0500
Message-ID: <1315002195.2069.85.camel@doink>
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
> xfs_bmapi() currently handles both extent map reading and
> allocation. As a result, the code is littered with "if (wr)"
> branches to conditionally do allocation operations if required.
> This makes the code much harder to follow and causes significant
> indent issues with the code.
> 
> Given that read mapping is much simpler than allocation, we can
> split out read mapping from xfs_bmapi() and reuse the logic that
> we have already factored out do do all the hard work of handling the
> extent map manipulations. The results in a much simpler function for
> the common extent read operations, and will allow the allocation
> code to be simplified in another commit.
> 
> Once xfs_bmapi_read() is implemented, convert all the callers of
> xfs_bmapi() that are only reading extents to use the new function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Very nice.  About a third of the uses of XFS_BMAPI_METADATA
were unnecessary because that flag only matters on writes.
That's a good demonstration of how refactoring like this
improves clarity (if the simplicity of the xfs_bmapi_read()
function isn't evidence enough).

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
