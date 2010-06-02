Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5259Ov3052037 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:09:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D0DCAAA60E
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:14:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	bOvkKrQDDman5jrz for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:14:11 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:11:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/17] xfs: simplify log item descriptor tracking
Message-ID: <20100602051147.GF7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160900.319050257@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160900.319050257@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, May 31, 2010 at 12:07:33PM -0400, Christoph Hellwig wrote:
> Currently we track log item descriptor belonging to a transaction using a
> complex opencoded chunk allocator.  This code has been there since day one
> and seems to work around the lack of an efficient slab allocator.
> 
> This patch replaces it with dynamically allocated log item descriptors
> from a dedicated slab pool, linked to the transaction by a linked list.
> 
> This allows to greatly simplify the log item descriptor tracking to the
> point where it's just a couple hundred lines in xfs_trans.c instead of
> a separate file.  The external API has also been simplified while we're
> at it - the xfs_trans_add_item and xfs_trans_del_item functions to add/
> delete items from a transaction have been simplified to the bare minium,
> and the xfs_trans_find_item function is replaced with a direct dereference
> of the li_desc field.  All debug code walking the list of log items in
> a transaction is down to a simple list_for_each_entry.
> 
> Note that we could easily use a singly linked list here instead of the
> double linked list from list.h as the fastpath only does deletion from
> sequential traversal.  But given that we don't have one available as
> a library function yet I use the list.h functions for simplicity.
> 
> [the patch applies ontop of Dave's delayed-logging branch]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK - nothing jumps out at me as being incorrect. I'm still
running QA on it, but it looks good so far.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
