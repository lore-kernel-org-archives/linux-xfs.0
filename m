Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:27:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9RI7O010989
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:27:19 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A450B12E26E2
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:28:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 8D3ucJ8EaY5dQem5 for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:28:51 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:28:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] XFS: Finish removing the mount pointer from the
	AIL API
Message-ID: <20080919092851.GH11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-9-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:57AM +1000, Dave Chinner wrote:
> Change all the remaining AIL API functions that are passed
> struct xfs_mount pointers to pass pointers directly to the
> struct xfs_ail being used. With this conversion, all external
> access to the AIL is via the struct xfs_ail. Hence the operation
> and referencing of the AIL is almost entirely independent of
> the xfs_mount that is using it - it is now much more tightly
> tied to the log and the items it is tracking in the log than
> it is tied to the xfs_mount.

Looks good.
