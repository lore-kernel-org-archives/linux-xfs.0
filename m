Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F0237F3F
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 18:02:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DCCB8F8065
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:02:04 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	5ytRAzhmPx7GUi0e for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 16:02:03 -0700 (PDT)
Date: Thu, 10 Oct 2013 16:02:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xfs: fix node forward in xfs_node_toosmall
Message-ID: <20131010230202.GC4301@kroah.com>
References: <20131009000926.GI10553@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131009000926.GI10553@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 07:09:26PM -0500, Ben Myers wrote:
> From: Mark Tinguely <tinguely@sgi.com>
> 
> Commit f5ea1100 cleans up the disk to host conversions for
> node directory entries, but because a variable is reused in
> xfs_node_toosmall() the next node is not correctly found.
> If the original node is small enough (<= 3/8 of the node size),
> this change may incorrectly cause a node collapse when it should
> not. That will cause an assert in xfstest generic/319:
> 
>    Assertion failed: first <= last && last < BBTOB(bp->b_length),
>    file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
> 
> Keep the original node header to get the correct forward node.
> 
> (When a node is considered for a merge with a sibling, it overwrites the
>  sibling pointers of the original incore nodehdr with the sibling's
>  pointers.  This leads to loop considering the original node as a merge
>  candidate with itself in the second pass, and so it incorrectly
>  determines a merge should occur.)
> 
> upstream commit 997def25e4b9cee3b01609e18a52f926bca8bd2b

Applied to the 3.10 and 3.11 stable queues, thanks.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
