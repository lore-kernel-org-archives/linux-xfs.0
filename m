Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9S9ruHP145014 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 04:53:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30F9D161DB50
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 02:53:55 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	re57bf8CfmCH5EbP for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 02:53:55 -0700 (PDT)
Date: Fri, 28 Oct 2011 05:53:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 016: Do not discard blocks at the mkfs time,
	more verbose version
Message-ID: <20111028095354.GA1062@infradead.org>
References: <1319625983.3074.28.camel@dhcp-26-208.brq.redhat.com>
	<be02ada1-aee5-406d-84cd-d54dde7ae871@zmail16.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <be02ada1-aee5-406d-84cd-d54dde7ae871@zmail16.collab.prod.int.phx2.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <esandeen@redhat.com>, xfs <xfs@oss.sgi.com>

On Fri, Oct 28, 2011 at 05:38:06AM -0400, Boris Ranto wrote:
> The test 016 fills scratch device with some data and then creates xfs fs
> on the scratch device. Later, the test assumes that the previously
> written data are still written there and checks for them at specific
> locations. On ssd drive this will lead to a failure since the blocks are
> discarded by default when the mkfs command is run.
> This is a more verbose version of the previous patch.
> This simple patch that adds -K to stop the discarding (if the mkfs
> command supports it) fixed the issue for me:
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
