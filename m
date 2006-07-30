Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 16:09:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6UN95DW021228
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 16:09:16 -0700
Date: Mon, 31 Jul 2006 09:08:15 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH] kill no-op buf macros
Message-ID: <20060731090815.B2280998@wobbly.melbourne.sgi.com>
References: <44CC2A55.6030207@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44CC2A55.6030207@sandeen.net>; from sandeen@sandeen.net on Sat, Jul 29, 2006 at 10:41:09PM -0500
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, dgc@sgi.com
Cc: xfs@oss.sgi.com

On Sat, Jul 29, 2006 at 10:41:09PM -0500, Eric Sandeen wrote:
> It looks like these macros are not particularly interesting... this patch kills 
> them.

Hmm, I'm not sure about some of these..

> #define XFS_BUF_BUSY(bp)	do { } while (0)
> #define XFS_BUF_ISBUSY(bp)	(1)

This ones used on 2.4, I'd like to get Daves thoughts on whether
we do the right thing here based on his buffer cache fu.

> #define XFS_BUF_SHUT(bp)	do { } while (0)
> #define XFS_BUF_UNSHUT(bp)	do { } while (0)
> #define XFS_BUF_ISSHUT(bp)	(0)

Ditto (not used on 2.4 though, but still maybe we should be doing
something here).

> #define XFS_BUF_ISUNINITIAL(bp)	(0)

This can go, unwritten extents don't use this interface on Linux.

> #define XFS_BUF_BP_ISMAPPED(bp)	(1)

*nod* - looks like it should go.

(could you regen the patch with just these two for now?  they are
pretty much self-contained changes, and nice 'n small)

> #define XFS_BUF_SET_START(bp)			do { } while (0)

Not sure what this used to do - Dave?

> #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
> #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
> #define XFS_BUF_SET_REF(bp, ref)		do { } while (0)

These ones should probably be implemented properly, not removed.
We currently treat all metadata buffers with an equal ranking when
we're delwri flushing them to try to reclaim memory, this was a
scheme to indicate some are more precious than others... we have
a (currently ignored) priority passed into xfsbufd_wakeup that we
could start honouring and improve our low memory handling there..
d'ya want to hack something up there?

cheers.

- 
Nathan
