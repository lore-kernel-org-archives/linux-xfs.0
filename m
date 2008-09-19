Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:24:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9OrIY010000
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:24:54 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAB7B12E26C0
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id B6fCHRIg7LsSlU88 for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:26 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:26:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] XFS: Allow 64 bit machines to avoid the AIL lock
	during flushes
Message-ID: <20080919092626.GD11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:53AM +1000, Dave Chinner wrote:
> When copying lsn's from the log item to the inode or dquot
> flush lsn, we currently grab the AIL lock. We do this because the
> LSN is a 64 bit quantity and it needs to be read atomically.
> The lock is used to guarantee atomicity for 32 bit platforms.
> 
> Make the LSN copying a small function, and make the function
> used conditional on BITS_PER_LONG so that 64 bit machines don't
> need to take the AIL lock in these places.

Looks good.
