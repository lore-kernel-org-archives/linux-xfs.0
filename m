Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE157F75
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:40:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83DB130407E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:40:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id A0yLj5gUEArmgmyR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:40:10 -0800 (PST)
Date: Thu, 5 Dec 2013 12:40:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
Message-ID: <20131205204008.GA7686@infradead.org>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.199565525@bombadil.infradead.org>
	<20131205203115.GA29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205203115.GA29897@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 07:31:15AM +1100, Dave Chinner wrote:
> This now holds the ilock over data IO, which is not allowed to be
> done as data IO completion can require the ilock to be taken. Yes,
> the code specifically avoids all these problems, but the general
> rule is that ilock is only held over metadata IO operations, not
> data IO. If we need data IO serialisation, then we use the iolock.

And we already hold the iolock here.  So yeah, we probably should
just move it to protect the xfs_bmapi_read call only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
