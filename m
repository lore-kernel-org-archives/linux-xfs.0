Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n58NPfxO257572 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 18:25:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AD5A8D0908
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 16:33:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9oGED6YCb2tWqJHf for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 16:33:02 -0700 (PDT)
Date: Mon, 8 Jun 2009 19:25:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: allow more xfs_io tests to be generic
Message-ID: <20090608232559.GA28568@infradead.org>
References: <4A2D4F51.5050906@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2D4F51.5050906@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Jun 08, 2009 at 12:50:09PM -0500, Eric Sandeen wrote:
> What do folks think of this?  These tests just do generic
> reads & writes with xfs_io; if we add a "-F" they will run
> on other filesystems.

Looks good to me.  Btw, I really wonder if we want to keep the -F
flag to xfs_io.  Seems rather pointless to restrict
perfectly normal I/O to a single filesystem type.  And even for XFS
specific ioctls we'd get a good enough error code back to handle it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
