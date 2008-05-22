Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 06:28:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MDRqir004466
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 06:27:52 -0700
Date: Thu, 22 May 2008 09:28:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] remove xattr buffer size dependency on page size in
	xfsdump
Message-ID: <20080522132841.GD4972@infradead.org>
References: <20080522061402.GS173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061402.GS173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 04:14:02PM +1000, David Chinner wrote:
> 
> The extended attr buffer size used by xfsdump is based on page size.
> The maximum buffer size the kernel will accept is 64k. On a 64k page
> machine, the default buffer size will be rejected by the kernel, thereby
> breaking dump and restore.
> 
> Limit the buffer size to XATTR_LIST_MAX in dump, restore and libhandle
> so the kernel won't reject otherwise valid requests.

I suspect this will break on non-linux platforms because XATTR_LIST_MAX
is only in the Linux headers.  With a precaution, e.g. by keeping the
old behaviour when XATTR_LIST_MAX is not defined this looks good.
