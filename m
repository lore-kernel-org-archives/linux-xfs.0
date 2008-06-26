Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 00:40:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q7eL68002380
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:40:21 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E18E283283
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:41:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id O2zYFo1LfJYdFyDG for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:41:22 -0700 (PDT)
Date: Thu, 26 Jun 2008 03:41:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] Replace the XFS buf iodone semaphore with a
	completion
Message-ID: <20080626074113.GA7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:15PM +1000, Dave Chinner wrote:
> The xfs_buf_t b_iodonesema is really just a semaphore
> that wants to be a completion. Change it to a completion
> and remove the last user of the sema_t from XFS.

Looks good and I've been running with an equivalent patch in my tree
for a while.
