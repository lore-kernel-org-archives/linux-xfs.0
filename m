Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11762 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751464AbeBXWH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 17:07:59 -0500
Date: Sun, 25 Feb 2018 09:07:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180224220757.GC30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 24, 2018 at 07:20:48PM +0100, Gionatan Danti wrote:
> Hi all,
> I have a question on how CoW/reflink works when used on busy files,
> as vm image files, databases, ecc.

Define "busy file", please.

> In short: can reflink-copy be used to create a crash-consistent
> snapshot of, say, a busy vm disk file?

If the file is being actively written, then the clone will not be
consistent.

> Or the db/vm/whatever should
> be quiesced before taking the copy (ie: similarly to how lvm call
> fsfreeze during the snapshot)?

Yes, it's just like any other snapshot process - you have to quiesce
everything that is writing to the file before cloning it. i.e. the
data in the file needs to be in a stable, consistent, unchanging
state if you want the clone to contain consistent data...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
