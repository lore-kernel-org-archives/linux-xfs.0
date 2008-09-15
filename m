Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:13:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLDa10032505
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:13:36 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB88E4444DA
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:15:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id xxARgIBPe0LyDWdC for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:15:08 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:15:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] XFS: use the inode radix tree for reclaiming inodes
Message-ID: <20080915211508.GG29743@infradead.org>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221315300-30336-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:14:58AM +1000, Dave Chinner wrote:
> Use the reclaim tag to walk the radix tree and find
> the inodes under reclaim. This was the only user of the
> deleted inode list.

Looks good.
