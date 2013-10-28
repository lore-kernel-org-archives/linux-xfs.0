Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92E347F3F
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 04:50:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E765AC012
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 02:50:04 -0700 (PDT)
Date: Mon, 28 Oct 2013 02:49:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131028094957.GA19041@infradead.org>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
	<20131024154220.GA19055@infradead.org>
	<20131024164115.GU1935@sgi.com> <20131024212448.GW2797@dastard>
	<20131025112934.GA1585@infradead.org>
	<20131027090409.GA2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131027090409.GA2797@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

Thanks for the explanation Dave.  I suspected a generic bug because
the two places mentioned are generic code.  Turns out only XFS and some
cluster filesystems are affected because other filesystems do not call
those under filesystem locks or i_mutex.

But it seem like AOP_FLAG_NOFS is indeed pointless and we should remove it,
in XFS as part of this patch and everywhere else later after talking
to the maintainers for the few other places using it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
