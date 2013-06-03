Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29D5E7CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 14:09:51 -0500 (CDT)
Message-ID: <51ACE9FC.9010008@sgi.com>
Date: Mon, 03 Jun 2013 14:09:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: fix remote attribute invalidation for a leaf
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 06/03/13 00:28, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When invalidating an attribute leaf block block, there might be
> remote attributes that it points to. With the recent rework of the
> remote attribute format, we have to make sure we calculate the
> length of the attribute correctly. We aren't doing that in
> xfs_attr3_leaf_inactive(), so fix it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

I scratched my head reading:

in xfs_attr_leaf.h:
/*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
typedef struct xfs_attr_inactive_list {
	xfs_dablk_t	valueblk;	/* block number of value bytes */
	int		valuelen;	/* number of bytes in value */
						     ^^^^^
						     |||||
} xfs_attr_inactive_list_t;

Where "valuelen" is clearly being used as blocks. A more obvious name is
the former "valueblk". Blame commit d7929ff6 for the confusion. Should 
change
the comment and/or variable one of these days ...

Reviewed-by: Mark Tinguely <tinuguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
