Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0923B7F54
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:08:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE1CE8F8070
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:08:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 29urAWVWhxAHAHwz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:08:21 -0800 (PST)
Date: Fri, 13 Dec 2013 03:06:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Message-ID: <20131213110608.GC14884@infradead.org>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212232443.GL31386@dastard>
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
Cc: adilger@dilger.ca, linux-nilfs@vger.kernel.org, mfasheh@suse.com, David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Dec 13, 2013 at 10:24:43AM +1100, Dave Chinner wrote:
> I'd prefer to just see the new physical length field always filled
> out, regardless of whether it is a compressed extent or not. In
> terms of backwards compatibility to userspace, it makes no
> difference because the value of reserved/unused fields is undefined
> by the API. Yes, the implementation zeros them, but there's nothing
> in the documentation that says "reserved fields must be zero".
> Hence I think we should just set it for every extent.
> 
> >From the point of view of the kernel API (fiemap_fill_next_extent),
> passing the physical extent size in the "len" parameter for normal
> extents, then passing 0 for the "physical length" makes absolutely
> no sense.

I tend to agree, but the additional complication here is that this is
a change to an existing API.  We'd need another HAVE_PHYS_LEN flag for
non-compressed extents so that userspace can rely on it.  Given that
it's only useful for that case I think the userspace API introduced
is the best we can get.

I think however that we should always pass the phys_len argument in the
kernel API just to make it less confusing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
