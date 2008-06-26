Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 00:46:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q7kBoL003453
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:46:12 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0ADC82830C4
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:47:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id J9Rh6cRcWmQHWbqB for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:47:12 -0700 (PDT)
Date: Thu, 26 Jun 2008 03:47:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] Clean up stale references to semaphores
Message-ID: <20080626074711.GC7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-7-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:17PM +1000, Dave Chinner wrote:
> A lot of code has been converted away from semaphores,
> but there are still comments that reference semaphore
> behaviour. The log code is the worst offender. Update
> the comments to reflect what the code really does now.

Looks good.  
