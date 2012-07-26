Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QHr4nE068221 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 12:53:04 -0500
Message-ID: <501183FD.6070502@sgi.com>
Date: Thu, 26 Jul 2012 12:53:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] xfs: refactor xfs_ialloc_ag_select
References: <20120704145444.863203951@bombadil.infradead.org>
	<20120704145616.185221770@bombadil.infradead.org>
In-Reply-To: <20120704145616.185221770@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/12 09:54, Christoph Hellwig wrote:
> Loop over the in-core perag structures and prefer using pagi_freecount over
> going out to the AGI buffer where possible.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>


Looks good

Not your fault, but the "longest" variable is complicated to understand.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
