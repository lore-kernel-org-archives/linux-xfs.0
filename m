Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38340 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdCIFis (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 00:38:48 -0500
Subject: Re: [PATCH 9/9] mkfs.xfs: add mkfs.xfs.conf parse support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <20170303231316.12716-10-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8753f955-cc54-e51d-53a7-0b62a3a32f96@sandeen.net>
Date: Wed, 8 Mar 2017 23:38:02 -0600
MIME-Version: 1.0
In-Reply-To: <20170303231316.12716-10-mcgrof@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
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

So, a few other points on this, while you look at libconfig?

Thanks for the man pages & updates, but I think they can use a bit
of editing and wordsmithing for clarity; we can work on that if/when
the technical details get sorted.

> User input passed to mkfs.xfs overrides defaults founds through the
> new optional configuration file, by default:
> 
> 	/etc/mkfs.xfs.conf
> 
> To use /etc/ be sure to configure xfsprogs with:
> 
>  ./configure --sysconfdir=/etc/

This should just DTRT by default (today it'd go to /usr/etc by default)

(For what it's worth, xfs_quota just hard-codes "/etc" -

#define PROJID          "/etc/projid"
#define PROJECT_PATHS   "/etc/projects")

> The build system also allows distributions to override the default
> mkfs.xfs.conf defaults with a custom:
> 
> 	etc/mkfs.xfs.conf.custom.in

I'm not a fan of this "drop untracked special files into $XFSPROGS/etc/
and it'll get renamed and then installed."  If you want a custom
config file in etc for the distro, just use the packaging tools to put
it there, IMHO.  Filtering it through the source tree && make install just
adds complexity.

> The default etc/mkfs.xfs.conf.in provides commented out examples.
> You can also override the configuration file used either with the
> MKFS_XFS_CONFIG environment variable or by using the new -c command
> line argument to mkfs.xfs. Only when -c is used will the configuration
> file be required to be present.
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N

I'd prefer to drop the env var handling.  Nothing else in xfsprogs uses
that for production cases; I don't really see a reason for it, and it
only complicates things.   Require -c path if specified, use /etc/ path
if present, otherwise ignore.

Also, printing the config file path at mkfs time will probably break some
scripts that aren't expecting an extra line ...

thanks,
-Eric
 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
