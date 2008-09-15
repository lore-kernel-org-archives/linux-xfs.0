Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 14:15:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8FLFWYe000682
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:15:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B34A12A89B8
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:17:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6jpf7QxKzgbVQoAa for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 14:17:03 -0700 (PDT)
Date: Mon, 15 Sep 2008 17:17:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] XFS: kill deleted inodes list
Message-ID: <20080915211703.GH29743@infradead.org>
References: <1221315300-30336-1-git-send-email-david@fromorbit.com> <1221315300-30336-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221315300-30336-6-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:14:59AM +1000, Dave Chinner wrote:
> Now that the deleted inodes list is unused, kill it. This
> also removes the i_reclaim list head from the xfs_inode, shrinking
> it by two pointers.

Looks good.

Any reason this is split from the previous patch?
