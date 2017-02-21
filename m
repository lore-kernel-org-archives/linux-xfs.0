Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752362AbdBUQcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 11:32:51 -0500
Date: Tue, 21 Feb 2017 17:32:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/7] fs, xfs: convert xfs_buf_log_item.bli_refcount from
 atomic_t to refcount_t
Message-ID: <20170221163252.GO6536@twins.programming.kicks-ass.net>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-4-git-send-email-elena.reshetova@intel.com>
 <20170221155922.GI6515@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C4E32A@IRSMSX102.ger.corp.intel.com>
 <20170221162758.GK6515@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221162758.GK6515@twins.programming.kicks-ass.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Tue, Feb 21, 2017 at 05:27:58PM +0100, Peter Zijlstra wrote:
> > True, but in some of this cases WARN might be ok, I think? As soon as
> > functionality is not changed and object is not reused (by doing
> > refcount_inc on it) anywhere later on. 
> 
> No, your conversion should not generate spurious WARN()s.
> 
> And also no, atomic_dec() must not hit 0. If you've been _that_ careful

refcount_dec() obviously, atomic_dec() doesn't care one way or the
other.

> with your reference counting and you absolutely _know_ this is the very
> last one, write something like:
> 
>   WARN_ON(!refcount_dec_if_one());
> 
> 
> Please, stop sending out conversions that haven't been tested. And take
> the time to actually look at your own patches. If I can spot fail just
> looking through them, so can you (or any of the other many people in
> your SoB chain).
> 
> Take a little more time and a little extra care.
