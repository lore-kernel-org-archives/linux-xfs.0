Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7E817F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 09:57:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B87E08F8035
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 07:57:46 -0700 (PDT)
Date: Tue, 22 Oct 2013 07:57:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/19] xfs: unify directory/attribute format definitions
Message-ID: <20131022145743.GA12075@infradead.org>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-6-git-send-email-david@fromorbit.com>
	<20131021231129.GM1935@sgi.com> <20131021233341.GF4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131021233341.GF4446@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Oct 22, 2013 at 10:33:41AM +1100, Dave Chinner wrote:
> I pulled some of the btree specific definitions back into
> xfs_btree.h (key, ptr unions), but I left the bmbt_rec-host
> definitions in the header as I haven't worked out exactly how to
> relocate them without introducing new dependencies everywhere. Hence
> I've cleaned up most of what Christoph asked for, but I'm leaving
> the hard part for a separate patch(set) where it will be (hopefully)
> much clearer what is being moved and what dependencies it
> reintroduces.

Yes, please go ahead with merging it for now, we can sort out any minor
issues later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
