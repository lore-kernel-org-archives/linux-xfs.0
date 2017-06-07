Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49252 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdFGNNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2017 09:13:11 -0400
Date: Wed, 7 Jun 2017 06:13:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix spurious spin_is_locked() assert failures on
 non-smp kernels
Message-ID: <20170607131311.GA18098@infradead.org>
References: <1496833017-63787-1-git-send-email-bfoster@redhat.com>
 <20170607112140.GA28606@infradead.org>
 <20170607115454.GA62888@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607115454.GA62888@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Jun 07, 2017 at 07:54:54AM -0400, Brian Foster wrote:
> > Just switch to lockdep_assert_held instead of this mess..
> 
> Seems reasonable, I wasn't aware of that. What about the
> !spin_is_locked() case? Do you want to drop it?

Yes, I would just drop it.
