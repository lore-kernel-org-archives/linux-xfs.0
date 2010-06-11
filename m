Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGYF3c146892 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:34:15 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DCEF15949EB
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:40:00 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 9ARQtnn5bG5zMFbo for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:40:00 -0700 (PDT)
Date: Fri, 11 Jun 2010 18:36:44 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100611163644.GH6864@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org>
	<20100610111052.3DDC5B1A2B@basil.firstfloor.org>
	<20100611162007.GC7556@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100611162007.GC7556@infradead.org>
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
Cc: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 11, 2010 at 12:20:07PM -0400, Christoph Hellwig wrote:
> Most of this looks good to me, but I really don't like the QASSERT
> macro.  If you're fine with it I'll split this up into smaller patches

Why do you not like it? 

The alternative will be likely uglier.

> and resubmit the unmodified parts under your name and redo those bits
> I don't like.

Fine for me.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
