Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:13:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLCswn032017
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:12:55 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60DE112A8946
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:14:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id bIFjQEpdZEESBDVN for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:14:26 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] XFS: mark inodes for reclaim via a tag in the
	inode radix tree
Message-ID: <20080915211425.GF29743@infradead.org>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221315300-30336-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:14:56AM +1000, Dave Chinner wrote:
> Prepare for removing the deleted inode list by marking inodes
> for reclaim in the inode radix trees so that we can use the
> radix trees to find reclaimable inodes.

Any reason this is split from patch 4 in the series?  Looks good
otherwise.
