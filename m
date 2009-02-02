Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n128kSO7235895 for <xfs@oss.sgi.com>; Mon, 2 Feb 2009 02:46:29 -0600
Date: Mon, 2 Feb 2009 09:45:43 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
In-Reply-To: <4986AEE8.5040609@panasas.com>
Message-ID: <Pine.LNX.4.64.0902020942230.11930@anakin>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org>
	<20090201164130.GA32276@infradead.org> <4985D48A.6090007@panasas.com>
	<200902020131.04203.arnd@arndb.de> <4986AEE8.5040609@panasas.com>
MIME-Version: 1.0
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
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, Eric Sandeen <sandeen@sandeen.net>, joel.becker@oracle.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Mon, 2 Feb 2009, Boaz Harrosh wrote:
> Arnd Bergmann wrote:
> > On Sunday 01 February 2009, Boaz Harrosh wrote:
> >> Christoph Hellwig wrote:
> >>> The structures have been defined exactly like that in XFS (and ocfs2)
> >>> before, and there are similar cases in other ioctls handlers.
> >>>
> >>> If anyone feels like changing this in some way feel free to wade through
> >>> the endless discussions about the pros and cons for it, but I think
> >>> doing it in context of this patch is not helpful.
> >> OK so ia64 gcc is broken in regard to __attribute__((packed(1))),
> >> and it should not be used.
> > 
> > No, the compiler is correct, it has to generate more complex code
> > if it cannot assume that data is naturally aligned and the architecture
> > does not support unaligned loads. If you don't understand this, please
> > at least read the list archives about the last five times this came up
> > before claiming that the compiler is broken.
> > 
> 
> Wrong!! Sorry, you guys don't listen.
> I'm talking of the case where the structures are EXACTLY the same anyway
> you look at them. sizeof(foo) == sizeof(foo_packed) and 
> offsetof(foo_memmber) == offsetof(foo_packed_member) for every member of
> the structure. foo && foo_packed are declared exactly the same but with
> __attribute__((packed(1))) applied to the later.
> 
> THEN in ia64 case the compiler is brain dead, because it relates
> "unalignment" to packed(1) which are two different things.

The natural alignment of a structure is max(alignment(member)), for all
members. With __attribute__((packed)), the natural alignment of the structure
is 1, so the compiler cannot assume anything.

While the ints in the structure may still be at offsets 0, 4, 8, and so on,
this doesn't say anything about their actual memory addresses, as the struct
base address itself may be unaligned.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
