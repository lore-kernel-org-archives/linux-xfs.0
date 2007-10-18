Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 09:16:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IGFxxT008734
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 09:16:01 -0700
Date: Thu, 18 Oct 2007 17:16:01 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Fix dbflush panic in xfs_qm_sync
Message-ID: <20071018161601.GA21492@infradead.org>
References: <4713F7D3.2090201@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4713F7D3.2090201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 16, 2007 at 09:29:23AM +1000, Donald Douwsma wrote:
> The recent behaviour layer removal dropped the check for quotas that have 
> been
> requested at mount time but have subsequently been turned off. This results
> in a panic when accessing m_quotainfo which has been freed.
> 
> This patch adds the check originally made by xfs_qm_syncall() to 
> xfs_qm_sync()

Hmm.  We do the same check just a few lines below, but inbetween
we access ->m_quotainfo to take the lock.  I was under the impression
that's the only safe way to check anyway, but ->m_quotainfo might not
actually be present.  It might me better to move the lock into xfs_mount
directly, but it's embedded into a xfs_dqhash and there's some complex
mess with gazillions of macros around it.

So I suspect restoring it to the original state might be good enough.
