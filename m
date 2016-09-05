Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E3627CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 10:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D147AC004
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 08:05:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jMfddJCMFkOrk1A7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 08:05:01 -0700 (PDT)
Date: Mon, 5 Sep 2016 08:05:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/71] xfs: create a standard btree size calculator code
Message-ID: <20160905150500.GF7662@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216792896.867.711816517859232858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216792896.867.711816517859232858.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 25, 2016 at 04:32:09PM -0700, Darrick J. Wong wrote:
> Create a helper to generate AG btree height calculator functions.
> This will be used (much) later when we get to the refcount btree.
> 
> v2: Use a helper function instead of a macro.
> v3: We can (theoretically) store more than 2^32 records in a btree, so
>     widen the fields to accept that.
> v4: Don't modify xfs_bmap_worst_indlen; the purpose of /that/ function
>     is to estimate the worst-case number of blocks needed for a bmbt
>     expansion, not to calculate the space required to store nr records.
> v5: More minor tweaks to the loop control; move down to reflink patches.

This should move down below the "---" line.

Otherwise the patch looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
