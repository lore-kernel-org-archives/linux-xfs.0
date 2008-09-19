Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:24:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9OXEh009879
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:24:34 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A153F91DEFF
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id pnf6unAbrdTZeUdQ for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:06 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:26:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] XFS: move the AIl traversal over to a consistent
	interface
Message-ID: <20080919092605.GC11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-4-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:52AM +1000, Dave Chinner wrote:
> With the new cursor interface, it makes sense to make all the
> traversing code use the cursor interface and make the old one go
> away. This means more of the AIL interfacing is done by passing
> struct xfs_ail pointers around the place instead of struct
> xfs_mount pointers.
> 
> We can replace the use of xfs_trans_first_ail() in
> xfs_log_need_covered() as it is only checking if the AIL is empty.
> We can do that with a call to xfs_trans_ail_tail() instead, where a
> zero LSN returned indicates and empty AIL...

Looks good.
