Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 01:19:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q8JN0o007164
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 01:19:24 -0700
Date: Thu, 26 Jun 2008 04:20:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Don't assert if trying to mount with blocksize >
	pagesize
Message-ID: <20080626082023.GA23954@infradead.org>
References: <4863056D.3080209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863056D.3080209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 26, 2008 at 12:56:45PM +1000, Lachlan McIlroy wrote:
> If we don't do the blocksize/PAGESIZE check before
> calling xfs_sb_validate_fsb_count() we can assert
> if we try to mount with a blocksize > pagesize.
> The assert is valid so leave it and just move the
> blocksize/pagesize check earlier.

The patch looks good, but the subject is rather misleading, it should
rather be something like:

"move check for blocksize > pagesize later in the mount path"
