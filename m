Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39620 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbeERPiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 11:38:10 -0400
Received: by mail-pl0-f67.google.com with SMTP id c19-v6so4798389pls.6
        for <linux-xfs@vger.kernel.org>; Fri, 18 May 2018 08:38:10 -0700 (PDT)
Date: Fri, 18 May 2018 08:38:05 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180518153805.GE24680@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518034600.GW23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
> On Thu, May 17, 2018 at 10:24:13PM -0500, Eric Sandeen wrote:
> > On 5/17/18 2:27 PM, Luis R. Rodriguez wrote:
> > > You may want to stick to specific set of configuration options when
> > > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > > reasons, but some other times to ensure systems remain compatible as
> > > new features are introduced with older kernels, or if you always want
> > > to take advantage of some new feature which would otherwise typically
> > > be disruptive.
> > > 
> > > This adds support for parsing a configuration file to override defaults
> > > parameters to be used for mkfs.xfs.
> > > 
> > > We define an XFS configuration directory,/etc/mkfs.xfs.d/  and allow for
> > > different configuration files, if none is specified we look for the
> > > default configuration file, /etc/mkfs.xfs.d/default. You can override
> > > with -c.  For instance, if you specify:
> > > 
> > > 	mkfs.xfs -c experimental -f /dev/loop0
> > > 
> > > The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> > > file. If you really need to override the full path of the configuration
> > > file you may use the MKFS_XFS_CONFIG environment variable.
> > 
> > I'm swamped under a deadline at work this week so just commenting at a
> > very high level for now, but I'm curious; why use an env var vs
> > providing a full path for -c ?  env vars always strike me as magic unexpected
> > behaviors.
> > 
> > # mkfs.xfs -c /my/fancy/path/to/config
> > 
> > seems much clearer than
> > 
> > # export MKFS_XFS_CONFIG=/my/fancy/path/to/
> > # mkfs.xfs -c config
> > 
> > i.e. if a full path is specified use it, else use the config directory.
> > 
> > Thoughts?
> 
> In this case your choices are:
> MKFS_XFS_CONFIG=/my/fancy/path/to/config mkfs.xfs
> 
> or:
> cp /my/fancy/path/to/config /etc/mkfs.xfs.d/hoogah
> mkfs.xfs -c hooga
> 
> <shrug> Bikeshedding more, what if either option accepted either an
> absolute path, or a file in $sysconfdir/etc/mkfs.xfs.d/ ?

Let us recall that the reason for -c set in stone on /@sysconfigdir@/mkfs.xfs.d/
was to allow clean simple code.

The MKFS_XFS_CONFIG is simply a comopromise to allow flexibility on a
full path in case you cannot use the /@sysconfigdir@/mkfs.xfs.d/
directory.

Supporting both remains simple.

If we wanted to support what you suggest, if a user specified -c hoogah
we'd have to treat multiple possibilities in code, increasing complexity:

  a) Did the user mean the hoogah in the present directory?
  b) Did the user mean hoogah in /@sysconfigdir@/mkfs.xfs.d/

Granted, if the user specified a -c /tmp/hoogah its clearer that the
full path would be desirable. So, I think what you suggest makes sense
provided we get rid of a) option and require only an alternative path
*iff* the first character in the path is '/'. Does this work for all
cases we wish to support a full path in?

> And the -c
> option can be specified once to override the environment variable /
> builtin detaults?

The -c option as-is in my patch series always overrides the environment
variable, but it is currently always tied to
/@sysconfigdir@/mkfs.xfs.d/. So if you specify both the -c wins. Its
also why I implemented the reset feature / mechanism.

  Luis
