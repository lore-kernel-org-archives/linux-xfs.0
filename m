Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34541 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdFGLVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2017 07:21:41 -0400
Date: Wed, 7 Jun 2017 04:21:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix spurious spin_is_locked() assert failures on
 non-smp kernels
Message-ID: <20170607112140.GA28606@infradead.org>
References: <1496833017-63787-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496833017-63787-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2017 at 06:56:57AM -0400, Brian Foster wrote:
> The 0-day kernel test robot reports assertion failures on
> !CONFIG_SMP kernels due to failed spin_is_locked() checks. As it
> turns out, spin_is_locked() is hardcoded to return zero on
> !CONFIG_SMP kernels and so this function cannot be relied on to
> verify spinlock state in this configuration.
> 
> To avoid this problem, update the associated asserts to fail only
> when CONFIG_SMP is enabled in the kernel. Note that this is not
> necessary for one assert that expects a zero return from
> spin_is_locked(). Update this assert anyways for consistency and
> future proofing.

Just switch to lockdep_assert_held instead of this mess..
