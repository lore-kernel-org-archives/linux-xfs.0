Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42194 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdCDDum (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 22:50:42 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
Date: Fri, 3 Mar 2017 21:49:58 -0600
MIME-Version: 1.0
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
> This series adds mkfs.xfs.conf support, so that options can now be
> shoved into a configuration file. This enables certain defaults to be
> saved for folks sticking to certain values, but more importantly it
> also enables distributions to override certain defaults so that new
> filesystems remain compatible with older distributions.
> 
> This has been based on top of xfsprogs-dev v4.9.0-rc1.
> 
> Given we already have an existinsg infrastructure to validate argument
> values this reuses that infrastructure by first adding helpers and porting
> over the argument parsing suppor to use these helpers.

I'm not necessarily the final word on this, but I have to say
I'm not a huge fan of having mkfs config files.  I've lived 
through that in mke2fs land, and my personal feeling is that
it can lead to confusion when distros start shipping config
files with different defaults than upstream ships in the
code itself.

I guess I can see the argument for shipping old/compatible
defaults with newer progs and older kernels, but by the
time a distro ships a custom old default config file they could
also patch out the new features just as easily... (which
is also confusing, I guess ;) )

After 25+ years of no external config file, I'm concerned
about principal of least surprise when the same xfsprogs version
starts behaving differently on different boxes based on a new
file that popped up in /etc ...

At the very least, I would like to /not/ ship or install any
config file with xfsprogs by default; the code itself should
be the canonical, single point of truth for defaults for a stock
"make && make install" installation.

-Eric

> Luis R. Rodriguez (9):
>   mkfs.xfs: add helper to parse command line options
>   mkfs.xfs: move dopts to struct mkfs_xfs_opts
>   mkfs.xfs: move iopts to to struct mkfs_xfs_opts
>   mkfs.xfs: move lopts to struct mkfs_xfs_opts
>   mkfs.xfs: move mopts to struct mkfs_xfs_opts
>   mkfs.xfs: move nopts to struct mkfs_xfs_opts
>   mkfs.xfs: move ropts to struct mkfs_xfs_opts
>   mkfs.xfs: use parse_subopts() to parse sopts
>   mkfs.xfs: add mkfs.xfs.conf parse support
> 
>  .gitignore             |    3 +
>  Makefile               |    2 +-
>  etc/Makefile           |   21 +
>  etc/mkfs.xfs.conf.in   |   58 ++
>  include/builddefs.in   |    2 +
>  include/buildmacros    |    6 +
>  man/man5/mkfs.xfs.conf |  113 +++
>  man/man8/mkfs.xfs.8    |   28 +
>  mkfs/xfs_mkfs.c        | 1788 ++++++++++++++++++++++++++----------------------
>  9 files changed, 1220 insertions(+), 801 deletions(-)
>  create mode 100644 etc/Makefile
>  create mode 100644 etc/mkfs.xfs.conf.in
>  create mode 100644 man/man5/mkfs.xfs.conf
> 
