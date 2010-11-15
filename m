Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFM55v3181374 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 16:05:05 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A13BF8F8087
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 14:06:34 -0800 (PST)
Message-ID: <4CE1AEEA.5050403@sgi.com>
Date: Mon, 15 Nov 2010 16:06:34 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/9] xfsrestore: make node lookup more efficient
References: <20101105163500.747192954@sgi.com>	
	<20101105163644.371326494@sgi.com>
	<1289853517.2199.226.camel@doink>
In-Reply-To: <1289853517.2199.226.camel@doink>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 11/15/2010 02:38 PM, Alex Elder wrote:
> On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
>> plain text document attachment (window_lookup_performance)
>> When converting an nh_t to a segment index and relative node index,
>> use shift and bitwise-and instead of division and modulo. Results show
>> this is about 50% faster than the current method.
>>
>>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>
> I have a few comments below.  They are suggestions and
> don't indicate that I've found any real problems in your
> code.  If you think that updating things in response to
> my suggestions is warranted, but want to do it later (as
> a separate change) that's OK with me.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>> ---
>>   restore/node.c |  150 ++++++++++++++++++++++++++++-----------------------------
>>   restore/win.c  |   36 +++----------
>>   restore/win.h  |    6 +-
>>   3 files changed, 87 insertions(+), 105 deletions(-)
>>
>> Index: xfsdump-kernel.org/restore/node.c
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/node.c
>> +++ xfsdump-kernel.org/restore/node.c
>
> . . .
>
>> @@ -173,6 +166,12 @@ typedef struct node_hdr node_hdr_t;
>>   static node_hdr_t *node_hdrp;
>>   static intgen_t node_fd;
>
> The following forward declarations could be eliminated
> if you just move their definitions up in the file.
>
>> +/* forward declarations of locally defined static functions ******************/
>> +static inline size_t nh2segix( nh_t nh );
>> +static inline nh_t nh2relnix( nh_t nh );
>> +static inline void node_map_internal( nh_t nh, void **pp );
>> +static inline void node_unmap_internal( nh_t nh, void **pp, bool_t freepr );
>> +
>>   /* ARGSUSED */
>>   bool_t
>>   node_init( intgen_t fd,
>
> . . .
>
>> @@ -281,6 +280,8 @@ node_init( intgen_t fd,
>>   		winmapmax = min( vmsz / segsz, max_segments );
>>   	}
>>
>> +	relnixmask = nodesperseg - 1;
>> +
>
> Is nodesperseg guaranteed to be a power of 2?  It may
> be, but it's not obvious to me from glancing at this
> block of code.

Yes, just above this hunk nodesperseg is set using a bitshift.

>
>>   	/* map the abstraction header
>>   	 */
>>   	ASSERT( ( NODE_HDRSZ&  pgmask ) == 0 );
>
> . . .
>
>>   void
>> Index: xfsdump-kernel.org/restore/win.c
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/win.c
>> +++ xfsdump-kernel.org/restore/win.c
>> @@ -177,31 +177,16 @@ win_init( intgen_t fd,
>>   }
>>
>>   void
>> -win_map( off64_t off, void **pp )
>> +win_map( size_t segix, void **pp )
>
> It might be nice to have a segix_t or something.
> The point being that what you are passing in here
> is an index value (not a size), which is computed
> from a node handle by figuring out which segment
> that node handle resides in.
>
> I was a little puzzled that nh2segix() took a
> node handle and returned a size_t.
>
> Similarly, a relnix appears to be an index
> value within a segment; an integral typedef
> could be used to clear that up. (and make
> it clear it's different from just a nh_t).
> Again, this suggestion comes out of my
> not understanding the return type of
> nh2relnix().

I agree, these were bad choices. I based them off
the fact that the old code unnecessarily passed
a size64_t to the winmap interface for one of
the params, then just changed it to size_t.

I'll rework this one and resubmit the series.

Bill

>
>>   {
>> -	size_t offwithinseg;
>> -	size_t segix;
>>   	off64_t segoff;
>>   	win_t *winp;
>>
>>   	CRITICAL_BEGIN();
>>
>> -	/* calculate offset within segment
>> -	 */
>> -	offwithinseg = ( size_t )( off % ( off64_t )tranp->t_segsz );
>> -
>> -	/* calculate segment index
>> -	 */
>> -	segix = (size_t)( off / ( off64_t )tranp->t_segsz );
>> -
>> -	/* calculate offset of segment
>> -	 */
>> -	segoff = off - ( off64_t )offwithinseg;
>> -
>>   #ifdef TREE_DEBUG
>>   	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
>> -	     "win_map(off=%lld,addr=%x): off within = %llu, segoff = %lld\n",
>> -	      off, pp, offwithinseg, segoff);
>> +	     "win_map(segix=%lu,addr=%p)\n", segix, pp);
>>   #endif
>>   	/* resize the array if necessary */
>>   	if ( segix>= tranp->t_segmaplen )
>
>
> . . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
