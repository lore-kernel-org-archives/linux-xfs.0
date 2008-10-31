Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 13:20:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VKKR2n018306
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:20:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F49614C2995
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:20:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id tl8Jebnx2RTsqWxq for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 13:20:27 -0700 (PDT)
Date: Fri, 31 Oct 2008 16:20:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] XFS: fix spurious uninitialised variable warning
	in xfs_growfs_rt
Message-ID: <20081031202027.GC20309@infradead.org>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225415729-26514-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 12:15:28PM +1100, Dave Chinner wrote:
> gcc is warning about an uninitialised variable in xfs_growfs_rt().
> This is a false positive. Fix it by changing the scope of the
> transaction pointer to wholly within the internal loop inside
> the function.
> 
> While there, preemptively change xfs_growfs_rt_alloc() in the
> same way as it has exactly the same structure as xfs_growfs_rt()
> but gcc is not warning about it. Yet.

Looks good.
