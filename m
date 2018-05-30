Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55497 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968664AbeE3HgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 03:36:05 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH v4 3/4] mkfs.xfs: add configuration file parsing support using our own parser
Date: Wed, 30 May 2018 09:36:02 +0200
Message-ID: <2285295.f3V5SjJ2Sg@merkaba>
In-Reply-To: <20180529220603.29420-4-mcgrof@kernel.org>
References: <20180529220603.29420-1-mcgrof@kernel.org> <20180529220603.29420-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

Hi Luis.

Luis R. Rodriguez - 30.05.18, 00:06:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> This adds support for parsing a configuration file to override
> defaults parameters to be used for mkfs.xfs.
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow
> for different configuration files, if none is specified we look for
> the default configuration file, /etc/mkfs.xfs.d/default. You can
> override with -c.  For instance, if you specify:
> 
> 	mkfs.xfs -c experimental -f /dev/loop0

Just two considerations (I am myself not sure ATM whether it makes sense 
to implement them):

Usually for "*.d" directories in /etc all configuration files are 
parsed, yet you parse only one which makes perfect sense for the 
usecase, but may not be what the admin expects. So it may make sense to 
use a different directory name.

Also in case you ever want to implement default mount options or 
whatever… it may make sense to use /etc/xfs as a base directory for 
everything (unless that is taken by something else, but I think X11 font 
server stuff is inside /etc/X11 if at all present).

> The search path for the configuration file will be:
> 
> 	1) $PWD/experimental
> 	2) /etc/mkfs.xfs.d/experimental
> 
> Absolute paths are supported, in which case they will be used directly
> and the mkfs.xfs.d directory is ignored.
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the
> configuration file. The default parameters you can override on a
> configuration file and their current built-in default settings are:
[…]
-- 
Martin


