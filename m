Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:5374 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932936AbeCBWFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 17:05:03 -0500
Date: Sat, 3 Mar 2018 09:04:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2] mkfs.xfs: add mkfs.xfs.conf parse support using
 libini_config
Message-ID: <20180302220459.GU30854@dastard>
References: <20180302203228.9622-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302203228.9622-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 12:32:28PM -0800, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> Although mkfs.xfs already uses sensible defaults this adds a configuration
> option for parsing defaults settings for mkfs.xfs parsed prior to processing
> input arguments from the command line.
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> different types of configuration files, if none is specified we look for
> the default type, /etc/mkfs.xfs.d/default, and you can override with -t.
> For instance if you specify:
> 
> 	mkfs.xfs -t experimental -f /dev/loop0

I haven't looked at the code at all, but I'll just make this initial
comment now: please don't use "-t" with mkfs.xfs.

"-t <type>" is a reserved flag used by the mkfs multiplexor to
specify the filesystem type, and so cannot be passed to filesystem
specific mkfs binaries. Hence we should not be using it in the
mkfs.xfs binary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
