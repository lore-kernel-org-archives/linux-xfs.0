Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n128U8v4235110 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 02:30:09 -0600
Message-ID: <4986AEE8.5040609@panasas.com>
Date: Mon, 02 Feb 2009 10:29:28 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org>
	<4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de>
In-Reply-To: <200902020131.04203.arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: mfasheh@suse.com, Eric Sandeen <sandeen@sandeen.net>, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Geert Uytterhoeven <geert@linux-m68k.org>, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Arnd Bergmann wrote:
> On Sunday 01 February 2009, Boaz Harrosh wrote:
>> Christoph Hellwig wrote:
>>> The structures have been defined exactly like that in XFS (and ocfs2)
>>> before, and there are similar cases in other ioctls handlers.
>>>
>>> If anyone feels like changing this in some way feel free to wade through
>>> the endless discussions about the pros and cons for it, but I think
>>> doing it in context of this patch is not helpful.
>> OK so ia64 gcc is broken in regard to __attribute__((packed(1))),
>> and it should not be used.
> 
> No, the compiler is correct, it has to generate more complex code
> if it cannot assume that data is naturally aligned and the architecture
> does not support unaligned loads. If you don't understand this, please
> at least read the list archives about the last five times this came up
> before claiming that the compiler is broken.
> 

Wrong!! Sorry, you guys don't listen.
I'm talking of the case where the structures are EXACTLY the same anyway
you look at them. sizeof(foo) == sizeof(foo_packed) and 
offsetof(foo_memmber) == offsetof(foo_packed_member) for every member of
the structure. foo && foo_packed are declared exactly the same but with
__attribute__((packed(1))) applied to the later.

THEN in ia64 case the compiler is brain dead, because it relates
"unalignment" to packed(1) which are two different things.

>> But clearly the programmer, Like in this patch exactly, should spell
>> out the hole created by padding and spell that hole out and call it
>> __Padding. The porgrammer thought about it, identified there is an hole,
>> please don't drop this information on the floor. Put it in the code so I 
>> don't have to break my head on it.
> 
> Again, you are missing the point. The patch has to leave out the padding
> and whatnot because the idea of the patch is to provide a
> backwards-compatible API for programs written against the legacy XFS
> API. The original definition of the interface was flawed, but unless you
> can travel back in time to complain about this in the initial submission
> of the XFS file system, you should not blame the entirely correct patch now.
> 

Lets make a small test is: sizeof(orig_struct) == sizeof(my_struct)?
offsetof(orig_any_memmber) == offsetof(my_any_memmber)?

Yes because the padding is there if you shove it under the rug or expose
it.

What I'm saying is don't repeat the passed mistakes, spell out the exact
structure layout. So it will compile the same for any <= 64bit machine.
If the way a structure was defined in the passed, produced two or more
memory representations, spell these out with different structure
definitions and choose the one you need at compile time.

Otherwise you have fixed nothing. You are just repeating the same
passed mistake. And down the future some programmer will wish he add
a time machine to go back and fix what we've done today. But bingo, he
did and told me about it, and now it is time to fix that.

> 	Arnd <><

Don't let the compiler have the driver's sit. You do the driving, because
he does not know where you want to go.

Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
