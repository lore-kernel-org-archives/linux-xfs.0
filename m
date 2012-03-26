Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QIbQgx052812 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 13:37:26 -0500
Date: Mon, 26 Mar 2012 13:37:36 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: trace xfs_name strings correctly
Message-ID: <20120326183736.GW7762@sgi.com>
References: <20120228110140.GA20760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228110140.GA20760@infradead.org>
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

On Tue, Feb 28, 2012 at 06:01:40AM -0500, Christoph Hellwig wrote:
> Strings store in an xfs_name structure are often not NUL terminated,
> print them using the correct printf specifiers that make use of the
> string length store in the xfs_name structure.
> 
> Reported-by: Brian Candler <B.Candler@pobox.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
