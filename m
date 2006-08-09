Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Aug 2006 18:26:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k791PxDW008008
	for <xfs@oss.sgi.com>; Tue, 8 Aug 2006 18:26:10 -0700
Date: Wed, 9 Aug 2006 11:24:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] kill no-op buf macros
Message-ID: <20060809012444.GS2114946@melbourne.sgi.com>
References: <44CC2A55.6030207@sandeen.net> <20060731090815.B2280998@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060731090815.B2280998@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, dgc@sgi.com, xfs@oss.sgi.com

On Mon, Jul 31, 2006 at 09:08:15AM +1000, Nathan Scott wrote:
> On Sat, Jul 29, 2006 at 10:41:09PM -0500, Eric Sandeen wrote:
> > It looks like these macros are not particularly interesting... this patch kills 
> > them.
> 
> Hmm, I'm not sure about some of these..
> 
> > #define XFS_BUF_BUSY(bp)	do { } while (0)
> > #define XFS_BUF_ISBUSY(bp)	(1)
> 
> This ones used on 2.4, I'd like to get Daves thoughts on whether
> we do the right thing here based on his buffer cache fu.

XFS_BUF_ISBUSY() is only ever used in ASSERT() statements, so I
think that can go. On 2.4:

#define XFS_BUF_BUSY(bp) ((bp)->b_flags |= XBF_FORCEIO)

The XBF_FORCEIO affects how we do partial page I/O on 2.4, but is
unused on 2.6. On 2.4, if the flag is set, we ignore the
buffer_uptodate() status of the buffers on the page and re-read all
the buffers in the range specified.  For writes, we always write all
the buffers on the page.

The flag is set when we issue direct I/O or in  xfs_buf_get_noaddr()
which is used to allocate log buffers and buffers for block zeroing.
This seems sane to me given the way we use bufferheads in 2.4....

> > #define XFS_BUF_SHUT(bp)	do { } while (0)
> > #define XFS_BUF_UNSHUT(bp)	do { } while (0)
> > #define XFS_BUF_ISSHUT(bp)	(0)
> 
> Ditto (not used on 2.4 though, but still maybe we should be doing
> something here).

IIRC, these were used to indicate that the buffers we're throwing
away on filesystem shutdown during I/O completion. This   is the
irix mechanism for throwing away delwri buffers on shutdown - we
don't use this on linux so I think we can kill these.

> > #define XFS_BUF_SET_START(bp)			do { } while (0)
> 
> Not sure what this used to do - Dave?

On Irix, that writes the current kernel time in to the buffer so
that the delwri flush code can tell when it is old enough to flush.
Wwe do that differently in linux, so this can be removed, methinks.

> > #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
> > #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
> > #define XFS_BUF_SET_REF(bp, ref)		do { } while (0)
> 
> These ones should probably be implemented properly, not removed.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
