Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:23:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4MuRl013968
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:22:57 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3FA7E7965C
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:24:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id G7BVMFA6eb5okLio for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:24:06 -0700 (PDT)
Date: Tue, 22 Jul 2008 00:24:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] XFS: Remove xfs_iflush_all and clean up
	xfs_finish_reclaim_all()
Message-ID: <20080722042406.GA27123@infradead.org>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-2-git-send-email-david@fromorbit.com> <20080721075826.GC6692@infradead.org> <20080721113302.GD6761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721113302.GD6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 09:33:02PM +1000, Dave Chinner wrote:
> It's not really harmless - it reclaims inodes faster as reclaim
> is now triggered by means other than xfssyncd. I'm not sure I should
> perturb the reclaim behaviour right now (wasn't my intent) so I'll
> change it back to the original code. It doesn't affect the other
> patches in any material way...

Yes, makes sense.

> Fixed patch is below.

Looks good.
