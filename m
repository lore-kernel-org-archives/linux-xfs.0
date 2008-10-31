Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 13:18:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VKIUKW017843
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:18:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7917E12B198D
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:18:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ck4IBo9oPAxELtCS for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:18:31 -0700 (PDT)
Date: Fri, 31 Oct 2008 16:18:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] XFS: fix error inversion problems with data
	flushing
Message-ID: <20081031201830.GA20309@infradead.org>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225415729-26514-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 12:15:25PM +1100, Dave Chinner wrote:
> XFS gets the sign of the error wrong in several places when
> gathering the error from generic linux functions. These functions
> return negative error values, while the core XFS code returns
> positive error values. Hence when XFS inverts the error to be
> returned to the VFS, it can incorrectly invert a negative
> error and this error will be ignored by the syscall return.
> 
> Fix all the problems related to calling filemap_* functions.
> 
> Problem initially identified by Nick Piggin in xfs_fsync().

But this patch is a little more than just the error code inversions..
