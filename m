Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 02:35:55 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJAZmqw006074
	for <xfs@oss.sgi.com>; Tue, 19 Dec 2006 02:35:50 -0800
Date: Tue, 19 Dec 2006 10:05:06 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] rethink removal of xattr syscall stubs (for now)
Message-ID: <20061219100506.GA22779@infradead.org>
References: <1166490658.5572.89.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166490658.5572.89.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: bnaujok@sgi.com, xfs@oss.sgi.com, agruen@suse.de

On Tue, Dec 19, 2006 at 12:10:58PM +1100, Nathan Scott wrote:
> Hi,
> 
> It turns out (*cough*) that we use an export file with libattr,
> that I completely forgot about, which specifies the *xattr calls
> as part of the ATTR_1 interface.  This patch reverts the syscall
> stub removal patch from before, includes Lennerts patch to fix
> the original problem ARM EABI, and I'll go think some more about
> how to properly fix this (I think we'll need an ATTR_2 interface
> in the end here, Andreas?)
> 
> Please apply as an interim fix to the original problem and to
> the accidental new problems its caused, and I'll push through a
> new patch in the new year.

There is a way to re-export symbols you imported from another
library with symbol versioning.  That how for example libpthread
works on recent Solaris versions.  I'll find out how exactly that
should be implemented.
