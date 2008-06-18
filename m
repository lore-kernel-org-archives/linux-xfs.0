Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 12:10:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IJ9vae018352
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 12:09:57 -0700
Received: from zen.pimp.org.za (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2ECFB17E2538
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 12:10:54 -0700 (PDT)
Received: from zen.pimp.org.za (zen.pimp.org.za [70.85.31.111]) by cuda.sgi.com with ESMTP id EIvHGruG43QRehTP for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 12:10:54 -0700 (PDT)
Date: Wed, 18 Jun 2008 20:10:45 +0100
From: Michael-John Turner <mj@mjturner.net>
Subject: Re: Directory mtime update issue (kernel 2.6.25)
Message-ID: <20080618191045.GA10722@aurora.pimp.org.za>
References: <20080618144534.GC11301@aurora.pimp.org.za> <20080618163356.GA6330@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618163356.GA6330@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 12:33:56PM -0400, Christoph Hellwig wrote:
> XFS does indeed updated the mtime too for the case when the source is
> a directory and we get a new parent but just the ctime in all other
> cases, which seems highly dubious to me.

Thanks for the prompt reply and the patch. I'm surprised this hasn't been
mentioned before as every other Unix filesystem I've used has not updated
the moved file's mtime during a rename(2). It's also odd that XFS only
changes the mtime when there's a new parent.

What does everyone else think? Would it be possible to have this patch or a
similar one committed upstream?

-mj
-- 
Michael-John Turner 
mj@mjturner.net      <>  http://mjturner.net/
