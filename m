Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40846 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdBUQEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 11:04:08 -0500
Date: Tue, 21 Feb 2017 17:04:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/7] fs, xfs: convert xfs_buf.b_hold and
 xfs_buf.b_lru_ref from atomic_t to refcount_t
Message-ID: <20170221160408.GJ6515@twins.programming.kicks-ass.net>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-3-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487692147-17066-3-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Tue, Feb 21, 2017 at 05:49:02PM +0200, Elena Reshetova wrote:
> @@ -1684,10 +1684,11 @@ xfs_buftarg_isolate(
>  	 * zero. If the value is already zero, we need to reclaim the
>  	 * buffer, otherwise it gets another trip through the LRU.
>  	 */
> -	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> +	if (!refcount_read(&bp->b_lru_ref)) {
>  		spin_unlock(&bp->b_lock);
>  		return LRU_ROTATE;
>  	}
> +	refcount_dec_and_test(&bp->b_lru_ref);
>  
>  	bp->b_state |= XFS_BSTATE_DISPOSE;
>  	list_lru_isolate_move(lru, item, dispose);

This should never have passed testing.. refcount_dec_and_test() has a
__must_check.

Furthermore the above seems to suggest thingies can live with a 0
refcount, so a straight conversion cannot work.
