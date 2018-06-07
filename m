Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbeFGXzf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 19:55:35 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v5 0/4] xfsprogs: add mkfs.xfs configuration file parsing support
Date: Thu,  7 Jun 2018 16:55:29 -0700
Message-Id: <20180607235533.20391-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This is v5 series addresses the feedback from the last v4 series. Biggest
change is to drop the man pages for now and yield Sandeed to brush up
the final wording.

I threw back the enum for the source since I really did not like the
asprintf() approach to allocate a string for the source, the required
extra error handling for that was just not appealing to me and I think
the enum works much better for it. I also kept the enum work to ensure
the compiler warns on missing subopt parsing.

You can also get the code from my kernel.org xfsprogs-dev 20180607-own-parser-v5
branch [0].

Reviews, questions, or rants are greatly appreciated.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180607-own-parser-v5

Changes on v5:

- We no force sysconfdir=/etc if not set so we also drop the last patch
  for debian as its no longer needed

- We use config_check_bool() as during review on the last series we
  failed to pick up on the fact that we were *not* detecting if a value
  for a field was greater than 1, so we were allowing for instance crc=1
  although this was silently mapping to crc=1. Note that although this
  issue was present, the check for conflicts is still in effect and
  functional. The only reason the issue with bools existed is we cast
  down the uint64_t to bool and that resolves the issue. For now all
  subuopt parsers use config_check_bool(). When and if other values are
  introduced they can change this.

- Use fstat() and openat() as requested instead of the odd checks for
  first and second characters. This feels nicer.

- Use negative return values and fixate errno in better locations.

- Drop the man pages and yield to Sandeed for that.

- Re-introduce the source type enum

- Dealing with a config file is now split into an open call and a
  separate parse file. This does read much better now.

- Fix a missing free(line) on the switch for parsing when we don't have
  an error.

- Adjust random error messages to reflect a bit better what is issue
  creeped up.

Changes on v4:

- Tons of man page documentation enhancements from Darrick.

- Adjusted a few error code messages/ paths to make more sense as per
  Darrick's feedback.

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
  mkfs: replace defaults source with an enum
  mkfs.xfs: add configuration file parsing support using our own parser

 configure.ac         |   1 +
 include/builddefs.in |   2 +
 mkfs/Makefile        |   2 +-
 mkfs/config.c        | 664 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/config.h        | 121 ++++++++++
 mkfs/xfs_mkfs.c      | 126 +++++-----
 6 files changed, 855 insertions(+), 61 deletions(-)
 create mode 100644 mkfs/config.c
 create mode 100644 mkfs/config.h

-- 
2.16.3

