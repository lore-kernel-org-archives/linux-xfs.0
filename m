Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C74947CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 22:13:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7409304051
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 20:13:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RaUh8Z12hEAOBVq6 for <xfs@oss.sgi.com>;
	Mon, 03 Jun 2013 20:13:43 -0700 (PDT)
Date: Tue, 4 Jun 2013 13:13:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: fix remote attribute invalidation for a leaf
Message-ID: <20130604031340.GD29466@dastard>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-5-git-send-email-david@fromorbit.com>
	<51ACE9FC.9010008@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51ACE9FC.9010008@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Mon, Jun 03, 2013 at 02:09:48PM -0500, Mark Tinguely wrote:
> On 06/03/13 00:28, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >When invalidating an attribute leaf block block, there might be
> >remote attributes that it points to. With the recent rework of the
> >remote attribute format, we have to make sure we calculate the
> >length of the attribute correctly. We aren't doing that in
> >xfs_attr3_leaf_inactive(), so fix it.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> 
> I scratched my head reading:
> 
> in xfs_attr_leaf.h:
> /*
>  * Used to keep a list of "remote value" extents when unlinking an inode.
>  */
> typedef struct xfs_attr_inactive_list {
> 	xfs_dablk_t	valueblk;	/* block number of value bytes */
> 	int		valuelen;	/* number of bytes in value */
> 						     ^^^^^
> 						     |||||
> } xfs_attr_inactive_list_t;
> 
> Where "valuelen" is clearly being used as blocks.

Yeah, good point.

This is one of the reasons why I dislike comments explaining what
variables in structures mean. I didn't even look at the definition
of the structure, because it's meaning is obvious from the name of
the varaible of the code that uses it.  ;)

> A more obvious name is
> the former "valueblk". Blame commit d7929ff6 for the confusion.
> Should change
> the comment and/or variable one of these days ...

Actaully, a structure that is used once and local to a single
function shouldn't be declared in a header file - if should be local
to the function. I'll fix this in a separate patch for 3.11.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
