Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42390 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752427AbcJRCOr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 22:14:47 -0400
Date: Mon, 17 Oct 2016 22:14:21 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mkfs.xfs: fix static-lib build
Message-ID: <20161018021420.llkpzrrnjqere5ls@thunk.org>
References: <20161017191327.16838-1-tytso@mit.edu>
 <20161017224041.GW23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017224041.GW23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>

On Tue, Oct 18, 2016 at 09:40:42AM +1100, Dave Chinner wrote:
> On Mon, Oct 17, 2016 at 03:13:27PM -0400, Theodore Ts'o wrote:
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> > 
> > Order is important for static libraries, libblkid depends on libuuid.
> > We have to pass libuuid after libblkid, otherwise it fails like this:
> 
> $ glo -n 1 mkfs/Makefile
> 9e1c66ca9cee mkfs: fix library ordering
> $ git describe --contains 9e1c66ca9cee
> v4.8.0-rc1~49
> $

My bad, I still have a repo which is tracking the xfsprogs git tree on
oss.sgi.com instead of git.kernel.org.

						- Ted
