Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7F997F50
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 08:23:35 -0500 (CDT)
Message-ID: <523AFAD4.4040208@sgi.com>
Date: Thu, 19 Sep 2013 08:23:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
	<523A1FBD.4010701@sgi.com> <20130918232409.GF9901@dastard>
In-Reply-To: <20130918232409.GF9901@dastard>
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

On 09/18/13 18:24, Dave Chinner wrote:
> On Wed, Sep 18, 2013 at 04:48:45PM -0500, Mark Tinguely wrote:
>> On 09/08/13 20:33, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> CPU overhead of buffer lookups dominate most metadata intensive
>>> workloads. The thing is, most such workloads are hitting a
>>> relatively small number of buffers repeatedly, and so caching
>>> recently hit buffers is a good idea.
>>>
>>> Add a hashed lookaside buffer that records the recent buffer
>>> lookup successes and is searched first before doing a rb-tree
>>> lookup. If we get a hit, we avoid the expensive rbtree lookup and
>>> greatly reduce the overhead of the lookup. If we get a cache miss,
>>> then we've added an extra CPU cacheline miss into the lookup.
> ....
>>
>> Low cost, possible higher return. Idea looks good to me.
>>
>> What happens in xfs_buf_get_map() when we lose the xfs_buf_find() race?
>
> What race is that?

I am thinking the two overlapping callers to xfs_buf_find() protected by 
the two calls to xfs_buf_find(). But my mistake was where the lookaside 
gets added. It is added correctly on the second call to xfs_buf_find() 
where it make sure that another find did not beat this find. Yes, no 
entry needs to be removed.


--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
