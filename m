Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26148 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933535AbeCCWx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Mar 2018 17:53:28 -0500
Date: Sun, 4 Mar 2018 09:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2] mkfs.xfs: add mkfs.xfs.conf parse support using
 libini_config
Message-ID: <20180303225325.GZ30854@dastard>
References: <20180302203228.9622-1-mcgrof@kernel.org>
 <deaab496-f413-9f52-21a2-7d7a01da1a59@sandeen.net>
 <20180303174550.GB18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180303174550.GB18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Sat, Mar 03, 2018 at 09:45:50AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 02, 2018 at 11:01:40PM -0600, Eric Sandeen wrote:
> > On 3/2/18 2:32 PM, Luis R. Rodriguez wrote:
> > > You may want to stick to specific set of configuration options when
> > > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > > reasons, but some other times to ensure systems remain compatible as
> > > new features are introduced with older kernels, or if you always want
> > > to take advantage of some new feature which would otherwise typically
> > > be disruptive.
> > > 
> > > Although mkfs.xfs already uses sensible defaults this adds a configuration
> > > option for parsing defaults settings for mkfs.xfs parsed prior to processing
> > > input arguments from the command line.
> > > 
> > > We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> > > different types of configuration files, if none is specified we look for
> > > the default type, /etc/mkfs.xfs.d/default, and you can override with -t.
> > > For instance if you specify:
> > > 
> > > 	mkfs.xfs -t experimental -f /dev/loop0
> > > 
> > > The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> > > file. If you really need to override the full path of the configuration
> > > file you may use the MKFS_XFS_CONFIG enviornment variable.
> > > 
> > > To use /etc/ be sure to configure xfsprogs with:
> > > 
> > >  ./configure --sysconfdir=/etc/
> > > 
> > > To verify what configuration file is used on a system use the typical:
> > > 
> > >   mkfs.xfs -N
> > > 
> > > There is only a subset of options allowed to be set on the conifiguration
> > > file, and currently only 1 or 0 are acceptable values. They are:
> > > 
> > > [data]
> > > noalign=
> > > 
> > > [inode]
> > > align=
> > > attr=
> > > projid32bit=
> > > sparse=
> > 
> > Hey, can I ask a maybe ridiculous question ...
> > 
> > What's the advantage of haggling over ini file parsers and file formats, vs. just:
> > 
> > # echo "-m crc=0 -n ftype=0" > /etc/mkfs.xfs.d/default
> > 
> > and parse that into defaults exactly as if it had been on the commandline?

Please, no.

A clean, well structure config file is far more important than
trying to micro-optimise command line parsing code re-use.

Defaults are not command line parameters - they are what we use when
CLI parameters are not specified. Let's not confuse and complicate
the issue by causing problems like having to hack around
respecification failures because now the CLI parameters respecify
parameters in the defaults. Or have to deal with things like
specifying a log size default value that is too large for small
filesystems, and so mkfs just fails in certain configs. i.e. there
are defaults we /don't want/ users to be able to modify....

> Except for having to break that up into individual argv-like strings,
> I too was wondering if that would be the simplest answer.  Same syntax,
> same parsing of number-with-units, etc.
> 
> Should we run getopt ahead of time to pick out the -T arg so that we
> always load the settings file before we start processing the rest of the
> cli options?  So that:
> 
> # mkfs.xfs -m crc=1 -T default /dev/sda
> 
> actually formats a v5 fs?

It will already, without any special handling. i.e.  The
infrastructure I put in place in mkfs for supporting /defaults/ via
config files means this isn't a problem we need to care about.

Command line options get parsed into the CLI parameter structure.
Defaults are held in a *separate* mkfs_defaults structure. The
defaults are only used if the CLI parameters are not specified, but
neither are processed until all options and defaults have been
parsed into the relevant structures. Hence CLI order does not
matter.

IOWs, this problem has already been solved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
