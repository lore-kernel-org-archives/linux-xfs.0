Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42525 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdCIDOC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 22:14:02 -0500
Date: Thu, 9 Mar 2017 01:51:30 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170309005130.GC14437@wotan.suse.de>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Wed, Mar 08, 2017 at 06:16:57PM -0600, Eric Sandeen wrote:
> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
> > This series adds mkfs.xfs.conf support, so that options can now be
> > shoved into a configuration file. This enables certain defaults to be
> > saved for folks sticking to certain values, but more importantly it
> > also enables distributions to override certain defaults so that new
> > filesystems remain compatible with older distributions.
> > 
> > This has been based on top of xfsprogs-dev v4.9.0-rc1.
> > 
> > Given we already have an existinsg infrastructure to validate argument
> > values this reuses that infrastructure by first adding helpers and porting
> > over the argument parsing suppor to use these helpers.
> 
> Hm, one functional problem with this, aside from Dave's concerns and
> suggestions, is that many options in the config file can't actually
> be overridden on the commandline because they are treated as having
> been respecified, which is not allowed:
> 
> # mkfs.xfs -m crc=1 -m crc=0 -f fsfile
> -m crc option respecified
> Usage: mkfs.xfs

This was dealt by enabling the last option taken to override, and
this mechanism was also taken to enable the config file to take
the first value but let the command line to override. Refer to
usage of reset_opt(). Granted I had only done this on B_LOG but
this can easily be made to enable us to reset for all options.

If we don't want to enable subsequent command line entries to
override (to keep old behaviour) but still allow at least the
command line to override the config file options, that's also
doable.

  Luis
