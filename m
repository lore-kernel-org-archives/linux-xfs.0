Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAUNuLoD222699 for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 17:56:21 -0600
Date: Wed, 30 Nov 2011 17:56:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111130235641.GX29840@sgi.com>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128081925.981681380@bombadil.infradead.org>
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

Christoph,

I feel that the ordering of the accesses to l_grant_head and the writeq
list may be important in the lockless path, and notice that they used to
be in opposite order.  It could use a comment explaining why (if) it is
ok.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
