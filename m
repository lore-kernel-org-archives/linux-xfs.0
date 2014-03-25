Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1349E29DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 12:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F21278F8035
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:44:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QTFMoUQPSuyI7gN5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 10:44:19 -0700 (PDT)
Date: Tue, 25 Mar 2014 10:44:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
Message-ID: <20140325174417.GA23300@infradead.org>
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
	<5331A930.9030402@sandeen.net>
	<20140325172508.GA4446@infradead.org> <5331BF53.6000300@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5331BF53.6000300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 25, 2014 at 10:39:31AM -0700, Eric Sandeen wrote:
> so only _xfs_buf_ioend *might* pass something other than 0, and:
> 
>   File      Function           Line
> 0 xfs_buf.c xfs_buf_bio_end_io 1197 _xfs_buf_ioend(bp, 1);
> 1 xfs_buf.c xfs_buf_iorequest  1377 _xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
> 
> At least up until now that was always called with "1"

Right, _was_.  But that changes to one always passing 1, and one passing
0 or one with your patch.  Or one passing always 1 and one always
passing 0 with the suggestion from Brian and me.  Either way we'd still
have versions passing 1.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
