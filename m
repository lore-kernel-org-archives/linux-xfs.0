Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 02:25:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8J9PDYd010094
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:25:14 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DFB145B362
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id CHM059JyUcuIlYcm for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 02:26:46 -0700 (PDT)
Date: Fri, 19 Sep 2008 05:26:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] XFS: Move the AIL lock into the struct xfs_ail
Message-ID: <20080919092645.GE11443@infradead.org>
References: <1221317877-8333-1-git-send-email-david@fromorbit.com> <1221317877-8333-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221317877-8333-6-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 14, 2008 at 12:57:54AM +1000, Dave Chinner wrote:
> Bring the ail lock inside the struct xfs_ail. This means
> the AIL can be entirely manipulated via the struct xfs_ail rather
> than needing both the struct xfs_mount and the struct xfs_ail.

Looks good.
