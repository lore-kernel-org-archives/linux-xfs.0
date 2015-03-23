Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 820707F47
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 00:24:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61D658F8037
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:24:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jgAGdLMox9cwwAV0 for <xfs@oss.sgi.com>;
	Sun, 22 Mar 2015 22:24:52 -0700 (PDT)
Date: Mon, 23 Mar 2015 16:24:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use GFP_NOFS argument in radix_tree_preload
Message-ID: <20150323052449.GO28621@dastard>
References: <1427087183-20391-1-git-send-email-sanidhya.gatech@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427087183-20391-1-git-send-email-sanidhya.gatech@gmail.com>
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
To: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: taesoo@gatech.edu, sanidhya@gatech.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, blee@gatech.edu, csong84@gatech.edu, changwoo@gatech.edu

On Mon, Mar 23, 2015 at 01:06:23AM -0400, Sanidhya Kashyap wrote:
> From: Byoungyoung Lee <blee@gatech.edu>
> 
> Following the convention of other file systems, GFP_NOFS
> should be used as an argument for radix_tree_preload() instead
> of GFP_KERNEL.

"convention of other filesystems" is not a reason for changing from
GFP_KERNEL to GFP_NOFS. There are rules for when GFP_NOFS needs to
be used, and so we only need to change the code if one of those
rules are triggered. i.e. inside a transaction, holding a lock that
memory reclaim might require to make progress (e.g. ip->i_ilock,
buffer locks, etc). The context in which the allocation is made will
tell you whether GFP_KERNEL is safe or not.

So while the change probably needs to be made, it needs to be made
for the right reasons. I haven't looked at the code, but I have
a pretty good idea of the context the allocation is being made
under. I'd suggest documenting the call path down to
xfs_mru_cache_insert(), because that will tell you exactly what
context the allocaiton is being made in and hence tell everyone else
the real reason we need to make this change...

Call me picky, pendantic and/or annoying, but if you are looking at
validating/correcting allocation flags then you need to understand
the rules and context in which the allocation is being made...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
