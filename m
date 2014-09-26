Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A7057FF1
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 04:44:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7978530408D
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 02:44:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id J6sBCFQpu9HKpARC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 02:44:37 -0700 (PDT)
Date: Fri, 26 Sep 2014 02:44:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: consider freeze levels in xfs_fs_writable()
Message-ID: <20140926094436.GA10692@infradead.org>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-2-git-send-email-david@fromorbit.com>
	<20140925161756.GA25798@infradead.org>
	<20140925210330.GG4945@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925210330.GG4945@dastard>
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

On Fri, Sep 26, 2014 at 07:03:30AM +1000, Dave Chinner wrote:
> I can mention it, but it's so trivial I didn't think it was worth
> it.

It does change behavior, so it should document why that was changed.

> The changelog says "Hence allow the caller to pass in the freeze
> level it is allowed to write" which is exactly what this code is
> doing.

The changelog says the you can pass the argument now.  It doesn't
say that it did change a caller to pass a different argument, and more
importanly why.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
