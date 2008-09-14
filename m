Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 06:23:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8EDN4vK002469
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:23:04 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54A2E126E65C
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:24:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Ij6oogo2BuSsWEJ8 for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:24:35 -0700 (PDT)
Date: Sun, 14 Sep 2008 09:24:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] XFS: clean up sync code
Message-ID: <20080914132434.GD14266@infradead.org>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 11:57:00PM +1000, Dave Chinner wrote:
> xfs_sync and xfs_syncsub are multiplexed interfaces that
> shares relatively little code between callers. because it is
> a multiplexed interface, it's hard to tell what is executed
> in each context it is called.
> 
> Factor out the sync code and explicitly call the sync functions
> needed rather than the multiplexed interfaces. Once this is
> done, we can remove xfs_syncsub and xfs_sync altogether.

The whole series looks good to me.
