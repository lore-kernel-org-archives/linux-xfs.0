Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FKD5u9093934 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 14:13:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD846122DA9
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 12:12:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KYeheMNzT8oie8EA for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 12:12:31 -0800 (PST)
Date: Sun, 15 Feb 2009 15:12:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Prevent lookup from finding bad buffers
Message-ID: <20090215201200.GB12161@infradead.org>
References: <4990EAF9.9010607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4990EAF9.9010607@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 10, 2009 at 01:48:25PM +1100, Lachlan McIlroy wrote:
> There's a bug in _xfs_buf_find() that will cause it to return buffers
> that failed to be initialised.

Is there a testcase for this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
