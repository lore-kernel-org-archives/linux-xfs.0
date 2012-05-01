Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q41DH2Ow140184 for <xfs@oss.sgi.com>; Tue, 1 May 2012 08:17:02 -0500
Message-ID: <4F9FE24B.3090603@sgi.com>
Date: Tue, 01 May 2012 08:16:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/10] xfs: separate buffer indexing from block map
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-3-git-send-email-david@fromorbit.com>
	<4F9EE7EC.4030203@sgi.com> <20120430232410.GP7015@dastard>
In-Reply-To: <20120430232410.GP7015@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/30/12 18:24, Dave Chinner wrote:
> On Mon, Apr 30, 2012 at 02:28:44PM -0500, Mark Tinguely wrote:
>> On 04/24/12 01:33, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> To support discontiguous buffers in the buffer cache, we need to
>>> separate the cache index variables from the I/O map. While this is
>>> currently a 1:1 mapping, discontiguous buffer support will break
>>> this relationship.
>>>
>>> However, for caching purposes, we can still treat them the same as a
>>> contiguous buffer - the block number of the first block and the
>>> length of the buffer - as that is still a unique representation.
>>> Also, the only way we will ever access the discontiguous regions of
>>> buffers is via bulding the complete buffer in the first place, so
>>> using the initial block number and entire buffer length is a sane
>>> way to index the buffers.
>>>
>>> Add a block mapping vector construct to the xfs_buf and use it in
>>> the places where we are doing IO instead of the current
>>> b_bn/b_length variables.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> ...
>>> +struct xfs_buf_map {
>>> +	xfs_daddr_t		bm_bn;	/* block number for I/O */
>>> +	int			bm_len;	/* size of I/O */
>>> +};
>>> +
>>>   typedef struct xfs_buf {
>>>   	/*
>>>   	 * first cacheline holds all the fields needed for an uncontended cache
>>> @@ -107,7 +114,7 @@ typedef struct xfs_buf {
>>>   	 * fast-path on locking.
>>>   	 */
>>>   	struct rb_node		b_rbnode;	/* rbtree node */
>>> -	xfs_daddr_t		b_bn;		/* block number for I/O */
>>> +	xfs_daddr_t		b_bn;		/* block number of buffer */
>>>   	int			b_length;	/* size of buffer in BBs */
>>
>> Looks good.
>> Do you plan to eventually remove b_bn and b_length from xfs_buf?
>
> No. b_bn is a fast way of identifying unique buffers for cache
> lookups and is located in the same cacheline as the tree node so we
> don't take an extra cache miss on every buffer we traverse during
> tree walks in _xfs_buf_find(). Also, b_length is used so often it is
> much cleaner to keep it around than it s to iterate over all the
> maps to calculate it every time it is needed.
>
> Cheers,
>
> Dave.

Thanks for the reply. I was thinking that maybe the "inline" map could 
do both of those things. It is not used if there are multiple maps and 
is the same value as the original variables if there is only one map.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
