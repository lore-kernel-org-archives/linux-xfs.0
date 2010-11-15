Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFKb0qY175006 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 14:37:00 -0600
Subject: Re: [PATCH v2 5/9] xfsrestore: cleanup node allocation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163643.987306372@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163643.987306372@sgi.com>
Date: Mon, 15 Nov 2010 14:38:29 -0600
Message-ID: <1289853509.2199.224.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> plain text document attachment (node_alloc_cleanup)
> Simplify the node allocation code. The current code takes some
> number of nodes from a new segment and links them into the
> freelist whenever the freelist is depleted. There's no reason
> to put the new nodes on the freelist, we can just allocate the
> next available new node as needed. This also saves a trip through
> win_map/win_unmap if there are no nodes on the freelist (the
> common case).

Prior to your change, a node allocated off the "virgin"
segment got zeroed before it gets returned for use. Your
change eliminates that.  Is that OK?

You also dropped a few TREE_DEBUG messages.  Were they
not useful?  (Just curious.)

Otherwise looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
