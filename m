Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54871 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdLGWiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 17:38:12 -0500
Date: Thu, 7 Dec 2017 14:38:03 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Lockdep is less useful than it was
Message-ID: <20171207223803.GC26792@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206004159.3755-73-willy@infradead.org>
 <20171206012901.GZ4094@dastard>
 <20171206020208.GK26021@bombadil.infradead.org>
 <20171206031456.GE4094@dastard>
 <20171206044549.GO26021@bombadil.infradead.org>
 <20171206084404.GF4094@dastard>
 <20171206140648.GB32044@bombadil.infradead.org>
 <20171207160634.il3vt5d6a4v5qesi@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207160634.il3vt5d6a4v5qesi@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, byungchul.park@lge.com

On Thu, Dec 07, 2017 at 11:06:34AM -0500, Theodore Ts'o wrote:
> The problem is that if it has too many false positives --- and it's
> gotten *way* worse with the completion callback "feature", people will
> just stop using Lockdep as being too annyoing and a waste of developer
> time when trying to figure what is a legitimate locking bug versus
> lockdep getting confused.
> 
> <Rant>I can't even disable the new Lockdep feature which is throwing
> lots of new false positives --- it's just all or nothing.</Rant>

You *can* ... but it's way more hacking Kconfig than you ought to have
to do (which is a separate rant ...)

You need to get LOCKDEP_CROSSRELEASE off.  I'd revert patches
e26f34a407aec9c65bce2bc0c838fabe4f051fc6 and
b483cf3bc249d7af706390efa63d6671e80d1c09

I think it was a mistake to force these on for everybody; they have a
much higher false-positive rate than the rest of lockdep, so as you say
forcing them on leads to fewer people using *any* of lockdep.

The bug you're hitting isn't Byungchul's fault; it's an annotation
problem.  The same kind of annotation problem that we used to have with
dozens of other places in the kernel which are now fixed.  If you didn't
have to hack Kconfig to get rid of this problem, you'd be happier, right?
