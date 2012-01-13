Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DKAj9i158235 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 14:10:46 -0600
Message-ID: <4F108FC6.60901@sgi.com>
Date: Fri, 13 Jan 2012 14:10:46 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Re: [PATCH 06/12] repair: use recursive buffer locking
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174742.106589485@bombadil.infradead.org>
	<20111213022208.GZ14273@dastard>
	<20111218225445.GB20578@infradead.org>
In-Reply-To: <20111218225445.GB20578@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> On Tue, Dec 13, 2011 at 01:22:08PM +1100, Dave Chinner wrote:
>>>   	if (use_xfs_buf_lock) {
>>> -		if (flags&  LIBXFS_GETBUF_TRYLOCK) {
>>> -			int ret;
>>> +		int ret;
>>>
>>> -			ret = pthread_mutex_trylock(&bp->b_lock);
>>> -			if (ret) {
>>> -				ASSERT(ret == EAGAIN);
>>> -				cache_node_put(libxfs_bcache, (struct cache_node *)bp);
>>> -				return NULL;
>>> +		ret = pthread_mutex_trylock(&bp->b_lock);
>>> +		if (ret) {
>>> +			ASSERT(ret == EAGAIN);
>>> +			if (flags&  LIBXFS_GETBUF_TRYLOCK)
>>> +				goto out_put;
>>> +
>>> +			if (pthread_equal(bp->b_holder, pthread_self())) {
>>> +				fprintf(stderr,
>>> +	_("recursive buffer locking detected\n"));
>>
>> "Warning: recursive buffer locking @ bno %lld detected"
>>
>> might be more informative, especially to do with the severity of the
>> issue.
>
> Ok, I'll make it print the block number.
>
>>
>>> +				bp->b_recur++;
>>> +			} else {
>>> +				pthread_mutex_lock(&bp->b_lock);
>>>   			}
>>> -		} else {
>>> -			pthread_mutex_lock(&bp->b_lock);
>>>   		}
>>> +
>>> +		bp->b_holder = pthread_self();
>>
>> That should probably only be written in the branch where the lock is
>> taken not every time through here.
>
> We actually should return the buffer just after incrementing the
> recursion count, else we might add it to the global list of buffers
> twice.
>
>

I liked the patch the way it was.

I thought the placement of the setting of b_holder is correct because it 
covers the pthread_mutex_trylock and the pthread_mutex_lock attempts.

I did not see anything in cache_node_get_priority() nor
cache_node_set_priority() that would add this to a list.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
