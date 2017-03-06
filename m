Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43173 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753266AbdCFKCq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 05:02:46 -0500
Date: Mon, 6 Mar 2017 09:50:01 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170306085001.GB14932@quack2.suse.cz>
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Fri 03-03-17 21:49:58, Eric Sandeen wrote:
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
> I'm not necessarily the final word on this, but I have to say
> I'm not a huge fan of having mkfs config files.  I've lived 
> through that in mke2fs land, and my personal feeling is that
> it can lead to confusion when distros start shipping config
> files with different defaults than upstream ships in the
> code itself.
> 
> I guess I can see the argument for shipping old/compatible
> defaults with newer progs and older kernels, but by the
> time a distro ships a custom old default config file they could
> also patch out the new features just as easily... (which
> is also confusing, I guess ;) )

Yeah, patching sources is IMO more confusing than changing config files.
You can at least easily ask for the contents of the config file... Also
when analysing XFS issue, you ask for xfs_info output anyway as that is the
only way how to be *sure* which features the fs has enabled and mkfs config
file does not invalidate that.

> After 25+ years of no external config file, I'm concerned
> about principal of least surprise when the same xfsprogs version
> starts behaving differently on different boxes based on a new
> file that popped up in /etc ...
> 
> At the very least, I would like to /not/ ship or install any
> config file with xfsprogs by default; the code itself should
> be the canonical, single point of truth for defaults for a stock
> "make && make install" installation.

Agree with that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
