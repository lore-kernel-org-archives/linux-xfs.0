Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6F2C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 20:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9882222202
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 20:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373346AbgJ0UxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 16:53:04 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48557 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373343AbgJ0UxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 16:53:03 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E798C58C440
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2020 07:52:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXVxi-004zyB-9m
        for linux-xfs@vger.kernel.org; Wed, 28 Oct 2020 07:52:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kXVxi-00Bqlx-2B
        for linux-xfs@vger.kernel.org; Wed, 28 Oct 2020 07:52:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/5] mkfs: Configuration file defined options
Date:   Wed, 28 Oct 2020 07:52:53 +1100
Message-Id: <20201027205258.2824424-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=VwQbUJbxAAAA:8 a=oiYcDx2ZSc9FvUAsWkkA:9
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Version 3:

- really do "-c file=xxx" > "-c options=xxx" everywhere
- update libinih parser error handling to be more robust
- ini_name -> ini_section and comment updates
- man page layout and grammar improvements
- Updated Darrick's old config file fstests to exercise the new
  code.

Version 2:

- "-c file=xxx" > "-c options=xxx"
- split out constification into new patch
- removed debug output
- fixed some comments
- added man page stuff

Hi Folks,

Because needing config files for mkfs came up yet again in
discussion, here is a simple implementation of INI format config
files. These config files behave identically to options specified on
the command line - the do not change defaults, they do not override
CLI options, they are not overridden by cli options.

Example:

$ echo -e "[metadata]\ncrc = 0" > foo
$ mkfs/mkfs.xfs -N -c options=foo -d file=1,size=100m blah
Parameters parsed from config file foo successfully
meta-data=blah                   isize=256    agcount=4, agsize=6400 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=25600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=853, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$

And there's a V4 filesystem as specified by the option defined
in the config file. If we do:

$ mkfs/mkfs.xfs -N -c options=foo -m crc=1 -d file=1,size=100m blah
-m crc option respecified
Usage: mkfs.xfs
.....
$

You can see it errors out because the CRC option was specified in
both the config file and on the CLI.

There's lots of stuff we can do to make the conflict and respec
error messages better, but that doesn't change the basic
functionality of config file based mkfs options. To allow for future
changes to the way we want to apply config files, I created a
full option subtype for config files. That means we can add another
option to say "apply config file as default values rather than as
options" if we decide that is functionality that we want to support.

However, policy decisions like that are completely separate to the
mechanism, so these patches don't try to address desires to ship
"tuned" configs, system wide option files, shipping distro specific
defaults in config files, etc. This is purely a mechanism to allow
users to specify options via files instead of on the CLI.  No more,
no less.

Git branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev.git mkfs-config-file

Cheers,

Dave.


Dave Chinner (5):
  build: add support for libinih for mkfs
  mkfs: add initial ini format config file parsing support
  mkfs: constify various strings
  mkfs: hook up suboption parsing to ini files
  mkfs: document config files in mkfs.xfs(8)

 configure.ac         |   3 +
 doc/INSTALL          |   5 +
 include/builddefs.in |   1 +
 include/linux.h      |   2 +-
 m4/package_inih.m4   |  20 ++++
 man/man8/mkfs.xfs.8  | 113 +++++++++++++++++++--
 mkfs/Makefile        |   2 +-
 mkfs/xfs_mkfs.c      | 231 ++++++++++++++++++++++++++++++++++++++-----
 8 files changed, 343 insertions(+), 34 deletions(-)
 create mode 100644 m4/package_inih.m4

-- 
2.28.0

