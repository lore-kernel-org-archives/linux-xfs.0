Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbeEQT1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 15:27:03 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 0/5] xfsprogs: add mkfs.xfs configuration file parsing support
Date: Thu, 17 May 2018 12:26:55 -0700
Message-Id: <20180517192700.23457-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

Eric,

This v2 series addresses the feedback from the last single patch. The
syntax is kept from what we last discussed, I think we're done bikeshedding
there. As a compromise we keep the bools to start off with as recently
discussed on the mailing list.

This is also availabe in git form on my git.kernel.org xfsprogs-dev tree on
the 20180517-own-parser branch [0].

Lemme know what you'all think.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180517-own-parser

  Luis

Chnages from v1:

- Stayed with our own parser as its the smallest and we're willing to
  maintain it as its simple and clear.

- Use -c for the configuration file, and drop the "type" nomenclature to
  avoid confusion on the interwebs.

- Start to split files off

- Duplicate a bit of items as suggested at LSFMM for the configuration
  parser structures. We can later consolidate if we think its really
  needed, however we want the freedom to change these as we see fit and
  most importantly keep the code apart.

- Conflict resolution and validation is managed now by piggy backing off of
  the idea of using the defaults to instantiate CLI parameters. CLI
  always overrides.

Luis R. Rodriguez (5):
  mkfs: distinguish between struct sb_feat_args and struct cli_params
  mkfs: move shared structs and cli params into their own headers
  mkfs: replace defaults source with an enum
  mkfs: add helpers to process defaults
  mkfs.xfs: add configuration file parsing support using our own parser

 include/builddefs.in   |   2 +
 man/man5/mkfs.xfs.d.5  | 121 ++++++++++
 man/man8/mkfs.xfs.8    |  26 +++
 mkfs/Makefile          |   2 +-
 mkfs/xfs_mkfs.c        | 235 ++++++++------------
 mkfs/xfs_mkfs_cli.h    |  65 ++++++
 mkfs/xfs_mkfs_common.h |  87 ++++++++
 mkfs/xfs_mkfs_config.c | 591 +++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs_config.h |  11 +
 9 files changed, 1002 insertions(+), 138 deletions(-)
 create mode 100644 man/man5/mkfs.xfs.d.5
 create mode 100644 mkfs/xfs_mkfs_cli.h
 create mode 100644 mkfs/xfs_mkfs_common.h
 create mode 100644 mkfs/xfs_mkfs_config.c
 create mode 100644 mkfs/xfs_mkfs_config.h

-- 
2.16.3

