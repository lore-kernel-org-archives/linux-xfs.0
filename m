Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:25:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9Pn1Y010190
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:25:50 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0225712E26C9
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:27:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 3eaSvoSPsNbiYh7J for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:27:22 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:27:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] XFS: Given the log a pointer to the AIL
Message-ID: <20080919092722.GF11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-7-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:55AM +1000, Dave Chinner wrote:
> When we need to go from the log to the AIL, we have
> to go via the xfs_mount. Add a xfs_ail pointer to the log
> so we can go directly to the AIL associated with the log.

Looks correct, but I wonder what it actually buys us.
