Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45207 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932817AbcJQWko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 18:40:44 -0400
Date: Tue, 18 Oct 2016 09:40:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: fix static-lib build
Message-ID: <20161017224041.GW23194@dastard>
References: <20161017191327.16838-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017191327.16838-1-tytso@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>

On Mon, Oct 17, 2016 at 03:13:27PM -0400, Theodore Ts'o wrote:
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Order is important for static libraries, libblkid depends on libuuid.
> We have to pass libuuid after libblkid, otherwise it fails like this:

$ glo -n 1 mkfs/Makefile
9e1c66ca9cee mkfs: fix library ordering
$ git describe --contains 9e1c66ca9cee
v4.8.0-rc1~49
$

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
