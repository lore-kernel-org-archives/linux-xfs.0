Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 02:14:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L9EdjG030000
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 02:14:40 -0700
Date: Mon, 21 Apr 2008 05:15:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080421091520.GA31070@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083645.799556386@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421083645.799556386@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

The patch looks quite clean, but there still is the fundamental issue
of rejecting perfectly fine UNIX filenames in xfs_unicode_validate,
as discussed in the last round a Unix filename is any valid
NULL-terminated bytestream with only ".", "..", and "/" special-cased
and this patch breaks this assumptions.

In addition to that I think xfs_unicode.[ch] should be split into
a small xfs-specific part for reading the on-disk case-folding table
and implementing the actual nameops, and the generic code for case
folding and compares and case-folded strings should be moved into lib/
as it's quite generic.
