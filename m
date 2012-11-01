Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1D7CU4026463 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 08:07:12 -0500
Message-ID: <5092746B.20805@sgi.com>
Date: Thu, 01 Nov 2012 08:08:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstest 179 ASSERT
References: <50916CBA.7050602@sgi.com> <20121101014910.GO29378@dastard>
In-Reply-To: <20121101014910.GO29378@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/31/12 20:49, Dave Chinner wrote:
> On Wed, Oct 31, 2012 at 01:23:54PM -0500, Mark Tinguely wrote:
>> OSS sources with the xfs: fix buffer shudown reference count mismatch
>> patch and xfstest 179.
>>
>> xfstest 179 started to have various asserts starting with the "move the
>> workers" series, but mostly the b_hold count is zero assert.
>>
>> Now that the b_hold count is fixed, the asert is:
>>
>> XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
>> file: /root/xfs/fs/xfs/xfs_mount.c, line: 273
>
> The only way you are going to track this down is through tracing
> perag gets and puts, and finding the object that is missing a put.
> There are already tracepoints for these and they tell you the caller
> function, so that should be sufficient to find what function has a
> get without a put...
>
> The other possibility is that there are buffers that have not be
> freed properly (or leaked), but IIRC this failure pre-exists
> attaching the perag to buffers....
>
>> mount perag information:
>>    m_perag_tree = {
>>      height = 0x1,
>>      gfp_mask = 0x20,
>>      rnode = 0xffff8803124bb4b1
>>    },
>> crash>  radix_tree_node ffff8803124bb4b0
>> struct radix_tree_node {
>>    height = 0x1,
>>    count = 0x3,
>>    {
>>      parent = 0x0,
>>      callback_head = {
>>        next = 0x0,
>>        func = 0xffffffff812384b0<radix_tree_node_rcu_free>
>>      }
>>    },
>>    slots = {0x0, 0xffff88034fd6f540, 0xffff88034fd6f840,
>> 0xffff88034fd6f240, 0x0,
>>   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> 0x0, 0x0, 0x0,
>>   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> 0x0, 0x0, 0x0,
>>   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> 0x0, 0x0, 0x0,
>>   0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>>    tags = {{0x0}, {0x0}, {0x0}}
>> }
>>
>> The inodes at 0xffff88034fd6f540, 0xffff88034fd6f840, 0xffff88034fd6f240
>> don't look valid.
>
> Those aren't inodes based on the addresses - they are all in the
> same page, so the size is at most 0x300 bytes (768 bytes). An XFS
> inode is larger than this, but a radix tree node is smaller (560
> bytes and fits 7 to a page on my x86_64 machines), so I'm not sure
> what you have there. how big does /proc/slabinfo tell you a radix
> tree node is?
>
> Cheers,
>
> Dave.


I have been spending too much time in earlier versions of XFS.

Last night, I had a good laugh at my mistake when I realized the perag
was not in an array...duh me, this is the radix tree of the perag
structures. I could not do a crash "kmem" command, that would have
given me a clue.

I *think* Ben is also seeing this assert on his 32 bit test machine.
Thanks for the advice, I will do some investigation this weekend.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
