Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 11:40:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98Idx6O011679
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 11:39:59 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3111013CD523
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 11:41:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id mdv5kMKrTn5CkA4e for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 11:41:38 -0700 (PDT)
Date: Wed, 8 Oct 2008 14:41:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] XFS: rename xfs_get_perag
Message-ID: <20081008184138.GA6823@infradead.org>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> <1223417377-8679-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223417377-8679-2-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 09:09:31AM +1100, Dave Chinner wrote:
> xfs_get_perag is really getting the perag that an inode belongs to
> based on it's inode number. Rename it appropriately so we can use
> xfs_perag_get() to get the perag from a provided ag number. Convert
> a number of sites over to using this interface.

Looks good.
