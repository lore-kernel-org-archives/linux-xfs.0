Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39254 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbeGYMph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 08:45:37 -0400
Date: Wed, 25 Jul 2018 04:34:21 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 14/15] xfs: drop unnecessary xfs_defer_finish() dfops
 parameter
Message-ID: <20180725113421.GA19399@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-15-bfoster@redhat.com>
 <20180725051143.GG5802@infradead.org>
 <20180725110950.GA57913@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725110950.GA57913@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 07:09:51AM -0400, Brian Foster wrote:
> Hmm, I originally had this as an inline in the header, so it was in
> xfs_trans.h for similar reasons xfs_defer_ops was moved over there (the
> function has to access tp->t_dfops).
> 
> I happened to change this over to a non-inline function in v2, but just
> left it here for whatever reason. I could probably move it, but I don't
> think it's worth it as I already have patches that kill this wrapper off
> by updating the only __xfs_defer_cancel() caller (log recovery) to use
> an empty container transaction instead of the external dfops. That will
> be part of the next set of patches that reduce xfs_defer_ops to a single
> list_head and subsequently eliminate the need for the structure...

Sounds good, that is even better!
