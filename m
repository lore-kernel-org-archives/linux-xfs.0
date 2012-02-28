Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SGEQg0201378 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 10:14:26 -0600
Message-ID: <4F4CFD63.8010506@sgi.com>
Date: Tue, 28 Feb 2012 10:14:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] xfs: do not require an ioend for new EOF calculation
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003906.313004161@bombadil.infradead.org>
In-Reply-To: <20120221003906.313004161@bombadil.infradead.org>
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

On 02/20/12 18:38, Christoph Hellwig wrote:
> Replace xfs_ioend_new_eof with a new inline xfs_new_eof helper that
> doesn't require and ioend, and is available also outside of xfs_aops.c.
>
> Also make the code a bit more clear by using a normal if statement
> instead of a slightly misleading MIN().
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
