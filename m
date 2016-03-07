Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE7CA7CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 10:26:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40662AC001
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 08:26:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id nUjViY02t8Oo4KJI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 08:26:45 -0800 (PST)
Date: Mon, 7 Mar 2016 08:26:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: ioends require logically contiguous file offsets
Message-ID: <20160307162644.GB19784@infradead.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457300990-18300-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

On Mon, Mar 07, 2016 at 08:49:46AM +1100, Dave Chinner wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> We need to create a new ioend if the current writepage call isn't
> logically contiguous with the range contained in the previous ioend.
> Hopefully writepage gets called in order of increasing file offset.

This looks reasonable, but how did we manage to get away without this for
so long?  I think as-is we do not actually require it - for setting
i_size we just care about the highest offset, and for unwritten extent
conversion we just need the lowest and highest offset, and we were
making use of that fact in direct I/O extensively before I rewrote that
code not to use ioends.

So this looks fine to me, but the description could use some better
wording.

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
