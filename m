Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A0878001
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 05:22:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07CE98F8039
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 03:22:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id BrWRAXoZ28N2LP2i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 03:22:07 -0700 (PDT)
Date: Fri, 26 Sep 2014 03:22:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/11] xfs: simplify xfs_zero_remaining_bytes
Message-ID: <20140926102206.GG22194@infradead.org>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411648461-29003-12-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 10:34:21PM +1000, Dave Chinner wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> xfs_zero_remaining_bytes() open codes a log of buffer manupulations
> to do a read forllowed by a write. It can simply be replaced by an
> uncached read followed by a xfs_bwrite() call.
> 
> [Christoph, can I get your sign-off for this?]

Sure,

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
