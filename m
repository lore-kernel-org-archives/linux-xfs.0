Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 07:55:31 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3OEtQfB008321
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 07:55:27 -0700
Date: Tue, 24 Apr 2007 15:55:25 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: don't block non-blocking writes when frozen
Message-ID: <20070424145525.GA18918@infradead.org>
References: <20070423002616.GY32602149@melbourne.sgi.com> <20070423212715.GF13572@infradead.org> <20070423231337.GN32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423231337.GN32602149@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, gnb@sgi.com, xfs-oss <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:13:37AM +1000, David Chinner wrote:
> So, given the catch-22 you've just presented us can we revisit the
> nfsd non-blocking I/O issue again?  This affects anyone using DM
> snapshots on their NFS servers and has nothing to do with HSMs
> or DMAPI...
> 
> FWIW, you can still do non-blocking userspace I/O to a file, so this
> XFS patch is still valid for mainline (that's how I tested it).

I've been investigating the situation a little bit more, and here's
what's going on:

 - SuS allows for O_NONBLOCK on regular files as per
   http://www.opengroup.org/onlinepubs/007908799/xsh/write.html
 - actually implementing O_NONBLOCK semantics for regular fixes
   breaks userspace when poll/select claims files are ready to
   read/write but they aren't, see http://lkml.org/lkml/2004/10/17/17

So we can't really expose O_NONBLOCK on regular files to userspace,
and we need to make sure in common code this does not happen.

EJUKEBOX on snaphots does make sense, though.  Can you please send
a full patchseries for nfsd, the common code and the xfs writepath
so that this actually gets used and behaviour is consistant for all
(or at least most) filesystems?

Also now that the patch goes to mainline please kill ugly FILP_DELAY_FLAG
and just check the flags directly.  And it should probably only check
O_NONBLOCK.  The only architecture having O_NDELAY different from
O_NONBLOCK is sparc, and it already translates the value for us.
