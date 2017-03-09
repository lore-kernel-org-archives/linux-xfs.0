Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751929AbdCIA0x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 19:26:53 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
Date: Wed, 8 Mar 2017 18:16:57 -0600
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

Hm, one functional problem with this, aside from Dave's concerns and
suggestions, is that many options in the config file can't actually
be overridden on the commandline because they are treated as having
been respecified, which is not allowed:

# mkfs.xfs -m crc=1 -m crc=0 -f fsfile
-m crc option respecified
Usage: mkfs.xfs
...

and:

# grep -B1 crc /etc/mkfs.xfs.conf 
[metadata_options]
crc = 1

# mkfs/mkfs.xfs -c /etc/mkfs.xfs.conf -m crc=0 -f fsfile
-m crc option respecified
Usage: mkfs.xfs
...

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
