Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p664BPHL065933 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 23:11:25 -0500
Subject: Re: [PATCH 27/27] xfs: avoid a few disk cache flushes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110701094607.799498339@bombadil.infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.799498339@bombadil.infradead.org>
Date: Tue, 5 Jul 2011 23:11:24 -0500
Message-ID: <1309925484.3381.57.camel@doink>
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
Cc: xfs@oss.sgi.com

On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> There is no need for a pre-flush when doing writing the second part of a
> split log buffer, and if we are using an external log there is no need
> to do a full cache flush of the log device at all given that all writes
> to it use the FUA flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
