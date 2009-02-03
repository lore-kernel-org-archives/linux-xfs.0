Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n137VqNM044337 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 01:31:52 -0600
Message-ID: <4987F2B8.9070700@panasas.com>
Date: Tue, 03 Feb 2009 09:31:04 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org>
	<4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de>
	<4986AEE8.5040609@panasas.com>
	<Pine.LNX.4.64.0902020942230.11930@anakin>
	<4986BE07.6090000@panasas.com>
	<20090202205102.GG28129@shareable.org>
In-Reply-To: <20090202205102.GG28129@shareable.org>
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
To: Jamie Lokier <jamie@shareable.org>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, Eric Sandeen <sandeen@sandeen.net>, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Geert Uytterhoeven <geert@linux-m68k.org>, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Jamie Lokier wrote:
> Boaz Harrosh wrote:
>> No the natural alignment is what it is, after the application of
>> __attribute__((packed(1))). In a well defined structure that is a no-opt.
>> But yes in ai64 the gcc programmers got lazy and did not make that analysis
>> after laying out the structure.
> 
> No.  That's what you *want* packed to mean, but it doesn't mean that.
> 
> __attribute__ packed on a struct definition means to pack the
> structure _and_ set its assumed alignment to 1.
> 
> This is what the packed attribute historically means, and it cannot be
> changed without breaking existing code.
> 
> If you want to remove padding from a structure, but still keep its
> natural alignment, you do it with two attributes together:
> __attribute__((packed, aligned(4))).  You have to choose the alignment
> you want in that case.
> 
> GCC manual:
>      When used on a struct, or struct member, the `aligned' attribute
>      can only increase the alignment; in order to decrease it, the
>      `packed' attribute must be specified as well.  When used as part
>      of a typedef, the `aligned' attribute can both increase and
>      decrease alignment, and specifying the `packed' attribute will
>      generate a warning.
> 
> It's a counterintuitive, because you must use
> __attribute__((aligned(1))) when declaring a variable to reduce its
> alignment, but you must use __attribute__((packed)) when declaring a
> struct type.  Doing it at the end of a struct typedef is a weird mix
> of semantics, so don't do that.
> 
> By the way, this discussion is why the "-Wpacked" and "-Wpadding"
> options are available.
> 
>> The base address can be unaligned even if the structure is aligned. In that
>> case you need the __atrubute__((aligned)) thingy.
> 
> No, because __attribute__((packed)) on a struct doesn't mean what you
> want it to mean.  Use __attribute((packed,aligned(4))) if that's what
> you want.
> 

OK Thanks I'll use that then. 
(And BUILD_BUG_ON to make sure)

>> Please note that I gave up on the compiler and understand that the
>> use of __packed is dangerous in some cases, sigh. My standing point
>> is to make sure there are no guesses left, and a BUILD_BUG_ON to
>> make sure of that.
> 
> In this code, it's not a bug because it must be backward compatible
> with existing binary code.  "Fixing" the padding breaks
> compatibility, which is pointless for this patch.
> 

That's what I don't like. In compatibility problems situation, we actually
have two kind of structures. I rather that they are spelled out explicitly
and chosen from at the appropriate places. But I'll give up it is probably
just me. (Though proof that it was not me who raised the subject)

I would at least expect a big fat comment explaining what happened to the
structure on what known ARCHs, and how it is expected to look in memory.
And a BUILD_BUG_ON to make sure of that.

> -- Jamie

Thanks, the __attribute((packed,aligned(__WORD_SIZE))) is new for me

Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
