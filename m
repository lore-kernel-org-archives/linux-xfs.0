Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59798 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdILLNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 07:13:11 -0400
Date: Tue, 12 Sep 2017 12:13:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170912111308.GM5426@ZenIV.linux.org.uk>
References: <20170910025712.GC5426@ZenIV.linux.org.uk>
 <20170910211110.GM17782@dastard>
 <20170910211907.GF5426@ZenIV.linux.org.uk>
 <20170910220814.GN17782@dastard>
 <20170910230723.GG5426@ZenIV.linux.org.uk>
 <20170911003113.GO17782@dastard>
 <20170911033222.GI5426@ZenIV.linux.org.uk>
 <20170911064440.GP17782@dastard>
 <20170911200713.GK5426@ZenIV.linux.org.uk>
 <20170912060214.GS17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170912060214.GS17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Tue, Sep 12, 2017 at 04:02:14PM +1000, Dave Chinner wrote:

> > Note that one of the bugs there applies to normal read() as well - if you
> > are reading from a hole in file into an array with a read-only page in
> > the middle, you want a short read.
> 
> And there's another WTF? moment.....
> 
> How do we get a read only page in the middle of an array of pages
> we've been told to write data into? And why isn't that a bug in the
> code that supplied us with those pages?

Sorry, I'd been unclear - I'm talking about read(2) or readv(2) called by
userland with a read-only piece in the middle of a (user-supplied) buffer.
Either due to mprotect() or simply with one of the iovecs passed to readv(2)
having ->iov_base set to some read-only area.

It may be a bug in userland code, but when handling that error is as trivial
as "don't assume iov_iter_zero(to, n) will return n, use the actual return
value", resorting to "the userland code was probably buggy and it's O_DIRECT,
so we can do whatever we want" looks wrong.
