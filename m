Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0375F7F55
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 08:38:17 -0500 (CDT)
Message-ID: <52404448.7040800@sgi.com>
Date: Mon, 23 Sep 2013 08:38:16 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix node forward in xfs_node_toosmall
References: <20130920220519.585903357@sgi.com> <20130923000824.GK12541@dastard>
In-Reply-To: <20130923000824.GK12541@dastard>
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
Cc: xfs@oss.sgi.com

On 09/22/13 19:08, Dave Chinner wrote:
> On Fri, Sep 20, 2013 at 05:05:08PM -0500, Mark Tinguely wrote:
>> Commit f5ea1100 cleans up the disk to host conversions for
>> node directory entries, but because a variable is reused in
>> xfs_node_toosmall() the next node is not correctly found.
>> If the original node is small enough (<= 3/8 of the node size),
>> this change may incorrectly cause a node collapse when it should
>> not. That will cause an assert in xfstest generic/319:
>>
>>     Assertion failed: first<= last&&  last<  BBTOB(bp->b_length),
>>     file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
>>
>> Keep the original node header to get the correct forward node.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---

...

> Yes, that definitely a bug, but I think that the change doesn't
> scope correctly. The original node header doesn't need to be saved
> like this - the node header decoded in the loop needs a loop-scope
> variable. i.e.:
>
> 	/* start with smaller blk num */
> 	forward = nodehdr.forw<  nodehdr.back;
> 	for (i = 0; i<  2; forward = !forward, i++) {
> +		struct xfs_da3_icnode_hdr thdr;
> +
> 		if (forward)
> 			blkno = nodehdr.forw;
> 		else
> 			blkno = nodehdr.back;
> 		if (blkno == 0)
> 			continue;
> 		error = xfs_da3_node_read(state->args->trans, state->args->dp,
> 					blkno, -1,&bp, state->args->whichfork);
> 		if (error)
> 			return(error);
>
> 		node = bp->b_addr;
> -		xfs_da3_node_hdr_from_disk(&nodehdr, node);
> +		xfs_da3_node_hdr_from_disk(&thdr, node);
> 		xfs_trans_brelse(state->args->trans, bp);
>
> -		if (count - nodehdr.count>= 0)
> +		if (count - thdr.count>= 0)
> 			break;  /* fits with at least 25% to spare */
> 	}
>
> Cheers,
>
> Dave.

Okay thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
