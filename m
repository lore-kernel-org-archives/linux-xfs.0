Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41DC77FF9
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 04:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 215F08F8037
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 02:47:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ElE4bcQ9OaTiGFHT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 02:47:48 -0700 (PDT)
Date: Fri, 26 Sep 2014 02:47:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: fix use of agi_newino in finobt lookup
Message-ID: <20140926094748.GC10692@infradead.org>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
	<1411601863-19594-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411601863-19594-2-git-send-email-david@fromorbit.com>
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

On Thu, Sep 25, 2014 at 09:37:40AM +1000, Dave Chinner wrote:
> Sparse warns that we are passing the big-endian valueo f agi_newino
> to the initial btree lookup function when trying to find a new
> inode. This is wrong - we need to pass the host order value, not the
> disk order value. This will adversely affect the next inode
> allocated, but given that the free inode btree is usually much
> smaller than the allocated inode btree it is much less likely to be
> a performance issue if we start the search in the wrong place.

Looks good.  I'm rather surprised this wasn't noticed earlier.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
