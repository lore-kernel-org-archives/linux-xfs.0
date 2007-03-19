Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Mar 2007 02:54:23 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2J9sH6p025288
	for <xfs@oss.sgi.com>; Mon, 19 Mar 2007 02:54:18 -0700
Date: Mon, 19 Mar 2007 09:28:28 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: remove duplicated iovec checking code v8
Message-ID: <20070319092828.GA3364@infradead.org>
References: <87slc18yhe.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87slc18yhe.fsf@sw.ru>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, xfs@oss.sgi.com, devel@openvz.org

On Mon, Mar 19, 2007 at 10:49:01AM +0300, Dmitriy Monakhov wrote:
> 
> Where are several places where the same code used for iovec checks.
> This patch just move this code to separate helper function, and replace
> duplicated code with it. IMHO it is better because these are checks that
> we want for all filesystems/drivers that use vectored I/O.

Please move this into the common code path, so it's checked before
entering the filesystem.  This won't cover the calculating count
until we have an iodesc/uio strcuture to pass it down, so feel free
to add a tiny helper for that temporaily.
