Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CF657CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 01:48:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D3F88F8039
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 23:48:31 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GcwZFvPtZhyxA4F2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 23:48:29 -0800 (PST)
Date: Fri, 12 Feb 2016 23:48:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160213074827.GA11543@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160213023310.GC14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160213023310.GC14668@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sat, Feb 13, 2016 at 01:33:10PM +1100, Dave Chinner wrote:
> > allocate an extent (or rather just a single block) in xfs_alloc_ag_vextent
> > as called from xfs_refcountbt_alloc_block.  The reservation helps us to
> > ensure this block is always available, but we still need to account for
> > that in xfs_trans_reserve(), which we currently don't do for itruncate
> > transactions.  
> 
> Ok, so we may have two different issues with a similar failure
> symptom. As it is, I don't think this is a show stopper - we're
> expecting to find these sorts of issues as we go along (hence the
> experimental tag on the feature) and I think, at this point, getting
> review and an initial merge done is more important...

This triggers 100% reproducible over NFS, and as outlined I'm
also pretty sure about the root cause.  I don't think this is something
to be ignored.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
