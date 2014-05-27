Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38CE27F4E
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 05:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBED9AC004
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 03:44:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZOMtRiRHnRj4C8Da (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 03:44:46 -0700 (PDT)
Date: Tue, 27 May 2014 03:44:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: kill xfs_buf_geterror()
Message-ID: <20140527104446.GD1440@infradead.org>
References: <1400802807-19936-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400802807-19936-1-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 09:53:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Most of the callers are just calling ASSERT(!xfs_buf_geterror())
> which means they are checking for bp->b_error == 0. If bp is null in
> this case, we will assert fail, and hence it's no different in
> result to oopsing because of a null bp. In some cases, errors have
> already been checked for or the function returning the buffer can't
> return a buffer with an error, so it's just a redundant assert.
> Either way, the assert can either be removed.
> 
> The other two non-assert callers can just test for a buffer and
> error properly.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
