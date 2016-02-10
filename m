Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C53797CA8
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:07:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE07C8F8050
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 11:07:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bcHripAoJA0JWVaP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 11:07:39 -0800 (PST)
Date: Wed, 10 Feb 2016 11:07:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160210190738.GA13051@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210095010.GC23904@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 01:50:10AM -0800, Darrick J. Wong wrote:
> That's odd... I'd have thought that the AG reservation would always be able
> to handle a refcount btree expansion, since it calculates how many blocks
> are needed to handle the worst case of 1 record per extent.  There's also
> a bug where we undercount the number of blocks already used, so it should
> have an extra big reservation.
> 
> OTOH I've seen occasional ENOSPCs in generic/186 and generic/168 too, so I
> guess something's going wrong.  Maybe the xfs_ag_resv* tracepoints can help?

I'm not seeing an ENOSPC, I run into:

[  640.924891] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 315

Which asserts that the current transaction is using up more blocks from
its reservation than it reserved.  The AG reservation seems to operate
on a different level than that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
