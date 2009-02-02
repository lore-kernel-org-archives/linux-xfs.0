Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n129ZcQa238487 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 03:35:39 -0600
Message-ID: <4986BE07.6090000@panasas.com>
Date: Mon, 02 Feb 2009 11:33:59 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org>
	<4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de>
	<4986AEE8.5040609@panasas.com>
	<Pine.LNX.4.64.0902020942230.11930@anakin>
In-Reply-To: <Pine.LNX.4.64.0902020942230.11930@anakin>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, Eric Sandeen <sandeen@sandeen.net>, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Geert Uytterhoeven wrote:
> On Mon, 2 Feb 2009, Boaz Harrosh wrote:
>> Arnd Bergmann wrote:
>>> No, the compiler is correct, it has to generate more complex code
>>> if it cannot assume that data is naturally aligned and the architecture
>>> does not support unaligned loads. If you don't understand this, please
>>> at least read the list archives about the last five times this came up
>>> before claiming that the compiler is broken.
>>>
>> Wrong!! Sorry, you guys don't listen.
>> I'm talking of the case where the structures are EXACTLY the same anyway
>> you look at them. sizeof(foo) == sizeof(foo_packed) and 
>> offsetof(foo_memmber) == offsetof(foo_packed_member) for every member of
>> the structure. foo && foo_packed are declared exactly the same but with
>> __attribute__((packed(1))) applied to the later.
>>
>> THEN in ia64 case the compiler is brain dead, because it relates
>> "unalignment" to packed(1) which are two different things.
> 
> The natural alignment of a structure is max(alignment(member)), for all
> members. With __attribute__((packed)), the natural alignment of the structure
> is 1, so the compiler cannot assume anything.
> 

No the natural alignment is what it is, after the application of
__attribute__((packed(1))). In a well defined structure that is a no-opt.
But yes in ai64 the gcc programmers got lazy and did not make that analysis
after laying out the structure.

> While the ints in the structure may still be at offsets 0, 4, 8, and so on,
> this doesn't say anything about their actual memory addresses, as the struct
> base address itself may be unaligned.
> 

The base address can be unaligned even if the structure is aligned. In that
case you need the __atrubute__((aligned)) thingy. It is true that if the sizeof(foo_packed)
is though unaligned, the compiler will have to assume unalignment in array operations.
but if the sizeof(foo_packed) is naturally aligned at the output then the compiler
has all the needed information to know that even if I declared __packed, it calculated
and knows that it is well aligned at the end.

> Gr{oetje,eeting}s,
> 
> 						Geert
> 

Please note that I gave up on the compiler and understand that the use of __packed
is dangerous in some cases, sigh. My standing point is to make sure there are no guesses
left, and a BUILD_BUG_ON to make sure of that.

Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
