Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37988 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752918AbeEUPeO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 11:34:14 -0400
Date: Mon, 21 May 2018 08:33:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180521153354.GH23858@magnolia>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
 <20180520001648.GN23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180520001648.GN23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Sun, May 20, 2018 at 10:16:48AM +1000, Dave Chinner wrote:
> On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
> > On Thu, May 17, 2018 at 10:24:13PM -0500, Eric Sandeen wrote:
> > > On 5/17/18 2:27 PM, Luis R. Rodriguez wrote:
> > > > You may want to stick to specific set of configuration options when
> > > > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > > > reasons, but some other times to ensure systems remain compatible as
> > > > new features are introduced with older kernels, or if you always want
> > > > to take advantage of some new feature which would otherwise typically
> > > > be disruptive.
> > > > 
> > > > This adds support for parsing a configuration file to override defaults
> > > > parameters to be used for mkfs.xfs.
> > > > 
> > > > We define an XFS configuration directory,/etc/mkfs.xfs.d/  and allow for
> > > > different configuration files, if none is specified we look for the
> > > > default configuration file, /etc/mkfs.xfs.d/default. You can override
> > > > with -c.  For instance, if you specify:
> > > > 
> > > > 	mkfs.xfs -c experimental -f /dev/loop0
> > > > 
> > > > The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> > > > file. If you really need to override the full path of the configuration
> > > > file you may use the MKFS_XFS_CONFIG environment variable.
> > > 
> > > I'm swamped under a deadline at work this week so just commenting at a
> > > very high level for now, but I'm curious; why use an env var vs
> > > providing a full path for -c ?  env vars always strike me as magic unexpected
> > > behaviors.
> > > 
> > > # mkfs.xfs -c /my/fancy/path/to/config
> > > 
> > > seems much clearer than
> > > 
> > > # export MKFS_XFS_CONFIG=/my/fancy/path/to/
> > > # mkfs.xfs -c config
> > > 
> > > i.e. if a full path is specified use it, else use the config directory.
> > > 
> > > Thoughts?
> > 
> > In this case your choices are:
> > MKFS_XFS_CONFIG=/my/fancy/path/to/config mkfs.xfs
> > 
> > or:
> > cp /my/fancy/path/to/config /etc/mkfs.xfs.d/hoogah
> > mkfs.xfs -c hooga
> 
> Sorry, why do we need to copy it to /etc/mkfs.xfs.d/?

No particular reason, just showing off relative pathname interpretation.
That could have been

mkfs.xfs -c ../../my/fancy/path/to/config

But that's kinda ugly.  $sysconfdir seems to get set to /usr on my
local builds, though I think dpkg overrides that back to /... :)

> > <shrug> Bikeshedding more, what if either option accepted either an
> > absolute path, or a file in $sysconfdir/etc/mkfs.xfs.d/ ? 
> 
> I kinda assumed that config files could be located anywhere, but we
> only searched the sysconfig path if it didn't point at a local
> file...

<shrug> openat() semantics are fine enough with me, I think.

--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
