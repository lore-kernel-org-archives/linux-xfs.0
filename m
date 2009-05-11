Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4BKBPSa011504 for <xfs@oss.sgi.com>; Mon, 11 May 2009 15:11:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0341EF8FCE4
	for <xfs@oss.sgi.com>; Mon, 11 May 2009 13:16:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NMB0lmTIkkZSREHh for
	<xfs@oss.sgi.com>; Mon, 11 May 2009 13:16:01 -0700 (PDT)
Date: Mon, 11 May 2009 16:11:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: cleanup ->sync_fs
Message-ID: <20090511201126.GA14195@infradead.org>
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140707.713299000@bombadil.infradead.org>
	<4A07141A.5060303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A07141A.5060303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, May 10, 2009 at 12:51:22PM -0500, Eric Sandeen wrote:
> Is it worth keeping a comment about this still being similar to the
> freeze path?  (xfs_quiesce_data)

Don't think so.  The commonality is in xfs_quiesce_data, and both
calling this functions for the majority of the work makes that quite
obvious.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
