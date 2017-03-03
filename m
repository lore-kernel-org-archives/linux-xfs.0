Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5734 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752105AbdCCXzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 18:55:06 -0500
Date: Sat, 4 Mar 2017 10:55:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] mkfs.xfs: add mkfs.xfs.conf parse support
Message-ID: <20170303235502.GJ17542@dastard>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <20170303231316.12716-10-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170303231316.12716-10-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Fri, Mar 03, 2017 at 03:13:16PM -0800, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> Although mkfs.xfs already uses sensible defaults this adds a configuration
> option for parsing defaults settings for mkfs.xfs parsed prior to processing
> input arguments.
> 
> User input passed to mkfs.xfs overrides defaults founds through the
> new optional configuration file, by default:
> 
> 	/etc/mkfs.xfs.conf
> 
> To use /etc/ be sure to configure xfsprogs with:
> 
>  ./configure --sysconfdir=/etc/
> 
> The build system also allows distributions to override the default
> mkfs.xfs.conf defaults with a custom:
> 
> 	etc/mkfs.xfs.conf.custom.in
> 
> The default etc/mkfs.xfs.conf.in provides commented out examples.
> You can also override the configuration file used either with the
> MKFS_XFS_CONFIG environment variable or by using the new -c command
> line argument to mkfs.xfs. Only when -c is used will the configuration
> file be required to be present.
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

Why roll our own config file format and parsing code? Why not use
something like libconfig which is quite simple, but is much more
extensible and doesn't require us to reinvent the wheel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
