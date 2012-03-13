Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DKrjNf070777 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 15:53:45 -0500
Date: Tue, 13 Mar 2012 15:53:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/5] xfs: remove the global xfs_Gqm structure
Message-ID: <20120313205355.GJ7762@sgi.com>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085309.220771186@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313085309.220771186@bombadil.infradead.org>
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

On Tue, Mar 13, 2012 at 04:52:37AM -0400, Christoph Hellwig wrote:
> If we initialize the slab caches for the quote code when XFS is loaded there

s/quote/quota

I'll clean that up.

> is no need for a global and reference counted quota manager structure.  Drop
> all this overhead and also fix the error handling during quota initialization.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks great!

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
