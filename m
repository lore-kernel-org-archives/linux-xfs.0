Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39365 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdICHs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:48:29 -0400
Date: Sun, 3 Sep 2017 00:48:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Rename progname as it is provided by libc
Message-ID: <20170903074828.GC8351@infradead.org>
References: <20170902215451.29265-1-raj.khem@gmail.com>
 <20170902222003.GD10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902222003.GD10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Khem Raj <raj.khem@gmail.com>, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 08:20:03AM +1000, Dave Chinner wrote:
> On Sat, Sep 02, 2017 at 02:54:51PM -0700, Khem Raj wrote:
> > Rename local variable progname to avoid a clash with libc
> > global symbols
> 
> What libc is causing this problem?
> 
> And why is it considered ok for that libc to pollute the global
> variable namespace with it's own internal variables?

I don't think it's libc.  It's our own little mess where we
want to set a global progname for libxfs use in the tools.

The right interface is to have a private libxfs_progname routine
that isn't accessible by the tools..
