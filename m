Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L7JJCN110236 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:19:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74B583EEE4B
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:22:00 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id R3UkqkFxWxGgH7UW for <xfs@oss.sgi.com>;
	Mon, 21 Jun 2010 00:22:00 -0700 (PDT)
Date: Mon, 21 Jun 2010 03:21:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
Message-ID: <20100621072159.GD1361@infradead.org>
References: <1277078341-19087-1-git-send-email-david@fromorbit.com>
	<1277078341-19087-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277078341-19087-4-git-send-email-david@fromorbit.com>
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
Cc: security@kernel.org, xfs@oss.sgi.com

On Mon, Jun 21, 2010 at 09:59:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode numbers may come from somewhere external to the filesystem
> (e.g. file handles, bulkstat information) and so are inherently
> untrusted. Rename the flag we use for these lookups to make it
> obvious we are doing a lookup of an untrusted inode number and need
> to verify it completely before trying to read it from disk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
