Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 02:13:49 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B9Dibm000703
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 02:13:46 -0700
Date: Wed, 11 Jul 2007 09:57:21 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: fix truncate vs null files issues
Message-ID: <20070711085721.GB18038@infradead.org>
References: <20070709073826.GO31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070709073826.GO31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 09, 2007 at 05:38:26PM +1000, David Chinner wrote:
> 
> When we change the file size via xfs_setattr(), we log the
> new, in-memory file size in the transaction. We do this without
> having flushed any dirty data so if we have previously extended
> the file we change the on disk file size without having written
> the data first.
> 
> This is a problem for both growing the file and truncating the
> file. The truncate case is partially hidden by the VTRUNCATE
> code, but if the file has not been closed before a crash has
> occurred we can still get NULLs appearing in files. 
> 
> The following patch fixes this problem by flushing the range
> between the on-disk filesize and the new file size as long
> as the new file size is larger than the on disk file size.
> 
> Comments?

Looks good.

> +		    (ip->i_size != ip->i_d.di_size) &&
> +		    (vap->va_size > ip->i_d.di_size)) {

And if I'd really want to get picky I'd say please remove all the superflous
braces here..
