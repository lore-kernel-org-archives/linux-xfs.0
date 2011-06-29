Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T6UDvD061698 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 01:30:13 -0500
Date: Wed, 29 Jun 2011 02:30:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: replace bp->flags usage with predefined macros
Message-ID: <20110629063001.GA12554@infradead.org>
References: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
	<20110629044616.GB1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629044616.GB1026@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Alex Elder <aelder@sgi.com>

On Wed, Jun 29, 2011 at 02:46:16PM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2011 at 05:53:04PM -0700, Chandra Seetharaman wrote:
> > Cleanup: Replace bp->flags usage with predefined macros.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Christoph can correct me if I'm wrong, but I'm pretty sure his long term
> direction is to remove the XFS_BUF_* macros completely.

Yes, at least those that are simpler flags get/set/clear wrappers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
