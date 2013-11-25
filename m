Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EF9E7F51
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 07:40:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 793F1304067
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:40:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 8TysqnffI5t3iaDO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 05:40:27 -0800 (PST)
Date: Mon, 25 Nov 2013 05:40:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: defer EFI and EFD log formatting until
	iop_format time
Message-ID: <20131125134027.GC21992@infradead.org>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151534.204073240@bombadil.infradead.org>
	<20131124091830.GA6253@infradead.org>
	<20131125085049.GB8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125085049.GB8803@dastard>
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

On Mon, Nov 25, 2013 at 07:50:49PM +1100, Dave Chinner wrote:
> Yeah, you can't use the freelist structure like that - it's a
> linked, which you copy the freelist structure when logging the
> EFI/EFD, and then free the items on the linked list. Then when
> formatting the structure, you walk the list attached to the copy of
> the freelist structure, which has alreayd been freed.
> 
> Basically, we've got a bunch of nasty life cycle issues around the
> EFI/EFD that need to be fixed. Firstly, the EFD code assumes that
> the EFI always outlives it, but we don't take a reference when we
> connect the EFD to the EFI - the EFI is created with the reference
> for the EFD already added to it. Then in abort cases we simply free
> the EFI, even though there may be an EFD that still references it...
> 
> So I think that this needs to be fixed up before you can even
> consider sharing something like a reference counted freelist
> structure between the EFI/EFD structures....

In fact I was pondering having just a single refcounted structured for
the EFI and EFD, and have two xfs_log_item structures embedded into it,
with the ops modifying the common refcount.  This isn't quite ready
yet but looks feasible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
