Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:28:03 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4RsNg014741
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:27:54 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A6EF191688D
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:29:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id RjnKaufuobjDSOzT for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:29:03 -0700 (PDT)
Date: Tue, 22 Jul 2008 00:29:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] XFS: remove the mount inode list
Message-ID: <20080722042903.GC27123@infradead.org>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216556394-17529-5-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 20, 2008 at 10:19:54PM +1000, Dave Chinner wrote:
> Now we've removed all users of the mount inode list,
> we can kill it. This reduces the size of the xfs_inode
> by 2 pointers.

Looks good, but xfsidbg needs to be fixed up for this.
