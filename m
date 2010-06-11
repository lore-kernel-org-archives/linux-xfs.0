Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGHZSE146157 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:17:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D62743BF514
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:20:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iQjVoCZjeT5FY2QW for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:20:09 -0700 (PDT)
Date: Fri, 11 Jun 2010 12:20:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100611162007.GC7556@infradead.org>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100610111052.3DDC5B1A2B@basil.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Most of this looks good to me, but I really don't like the QASSERT
macro.  If you're fine with it I'll split this up into smaller patches
and resubmit the unmodified parts under your name and redo those bits
I don't like.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
