Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754957AbeEYDTp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 23:19:45 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 0/4] xfsprogs: add mkfs.xfs configuration file parsing support
Date: Thu, 24 May 2018 20:19:39 -0700
Message-Id: <20180525031943.29440-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This is v3 series should address all prior feedback from the last
iteration. If I forgot something please let me know. The changes that
went into this v3 and prior are listed below. You can fetch the goods on
my kernel.org xfsprogs-dev 20180524-own-parser branch [0].

Lemme know what ya'll think.

  Luis

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180524-own-parser

Changes on v3:

- Prefix errors on the configuration parsing with config file used and
  exact line.

- Use uint64_t throughout all parsers as requested.

- Parse the CLI early for -c as I originally had implemented this on v1
  but now platform_getoptreset() to reset the opts.

- Drop the enum for the source type for the configuration file type,
  note that since we rely on the stack to set the variables we should
  then always set the dft.src on main().

- Use getline() for fetching lines as requested

- Add a special iscomment() and isempty() to handle all space and
  comment parsing. Now when PARSE_INVALID issued we really mean it.

- Embrace latest bikeshed preferences:
	config.c, config.h, random function names

- Add man pages to be parsed via configure so that @sysconfigdir@ gets
  properly parsed

- get_confopts() now iterates over the known sections tab and gives you
  the right struct right away.

- Add respecification checks for a section.

- Add respecification checks for -c, -c is only allowed once.

- Add --sysconfigdir to debian/rules, note that if you *don't* set
  --sysconfigdir your man pages will end up with ${prefix}. We could
  add a secondary target parsing just in case, or we can do some hacks
  with autoconf for this, but I don't think its worth it. Other packages
  deal with this by having ./configure always run with --sysconfigdir
  set (see systemd for instance).

- Reduced the number of declared enums, only enums for the config
  subparams which are currently supported for parsing are declared.

- mkfs.xfs -c foo now will search for $PWD/foo and if that fails the
  sysconfigdir/mkfs.xfs.d/foo.

- mkfs.xfs -c ../foo works and so should ./foo, etc.

- The MKFS_XFS_CONFIG variable support was dropped in favor or just
  allowing the user to specify the full path now.

- Embraces xfsprogs coding style, c'est la vie.

Changes on v2:

- Stayed with our own parser as its the smallest and we're willing to
  maintain it as its simple and clear.

- Use -c for the configuration file, and drop the "type" nomenclature to
  avoid confusion on the interwebs.

- Start to split files off

- Duplicate a bit of items as suggested at LSFMM for the configuration
  parser structures. We can later consolidate if we think its really
  needed, however we want the freedom to change these as we see fit and
  most importantly keep the code apart.
                                                                                                                                                                                              
- Conflict resolution and validation is managed now by piggy backing off
  of the idea of using the defaults to instantiate CLI parameters. CLI
  always overrides.

Luis R. Rodriguez (4):
  mkfs: distinguish between struct sb_feat_args and struct cli_params
  mkfs: move shared config structs and into their own headers
  mkfs.xfs: add configuration file parsing support using our own parser
  debian/rules: use the new sysconfdir configuration setting

 configure.ac                           |   6 +-
 debian/rules                           |   4 +-
 include/builddefs.in                   |   2 +
 man/man5/Makefile                      |   2 +
 man/man5/mkfs.xfs.d.5.in               | 153 ++++++++
 man/man8/Makefile                      |   2 +
 man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} |  27 ++
 mkfs/Makefile                          |   2 +-
 mkfs/config.c                          | 644 +++++++++++++++++++++++++++++++++
 mkfs/config.h                          |  86 +++++
 mkfs/xfs_mkfs.c                        | 130 ++++---
 11 files changed, 995 insertions(+), 63 deletions(-)
 create mode 100644 man/man5/mkfs.xfs.d.5.in
 rename man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} (96%)
 create mode 100644 mkfs/config.c
 create mode 100644 mkfs/config.h

-- 
2.16.3

