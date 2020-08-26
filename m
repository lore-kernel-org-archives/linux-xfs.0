Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D197BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5284206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHZB4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:56:38 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:39104 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbgHZB4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 21:56:38 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7643B1AAB40
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 11:56:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-0000zV-En
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfy-00Gg2A-Tw
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] mkfs: Configuration file defined options
Date:   Wed, 26 Aug 2020 11:56:31 +1000
Message-Id: <20200826015634.3974785-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=y4yBn9ojGxQA:10 a=fQT_pJ0R_GJRKqMx_sYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Folks,

Because needing config files for mkfs came up yet again in
discussion, here is a simple implementation of INI format config
files. These config files behave identically to options specified on
the command line - the do not change defaults, they do not override
CLI options, they are not overridden by cli options.

Example:

$ echo -e "[metadata]\ncrc = 0" > foo
$ mkfs/mkfs.xfs -N -c file=foo -d file=1,size=100m blah
Ini debug: file foo, section metadata, name crc, value 0
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

$ mkfs/mkfs.xfs -N -c file=foo -m crc=1 -d file=1,size=100m blah
Ini debug: file foo, section metadata, name crc, value 0
-m crc option respecified
Usage: mkfs.xfs
.....
$

You can see it errors out because the CRC option was specified in
both the config file and on the CLI.

There's lots of stuff we can do to make the conflict and respec
error messages better, but that doesn't change the basic
functionality of config file based mkfs options. To allow for future
changes to the way we want to apply the config file, I created a
full option subtype for config files. That means we can add another
option to say "apply config file as default values rather than as
options" if we decide that is functionality that we want to support.

But policy decisions like that are completely separate to the
mechanism, so these patches don't try to address desires to ship
"tuned" configs, system wide option files, shipping distro specific
defaults in config files, etc. This is purely a mechanism to allow
users to specify options via files instead of on the CLI.  No more,
no less.

So to preempt the endless bikeshedding from derailing getting this
functionality merged, all I'm going to say is "no". No feature
creep, no "but I want to ...", "can you make it pink...", nothing.
All I care about is providing a mechanism that people are still
asking for, and that's all I'm going to provide here.

I'm happy to fix bugs and code stuff that people want fixed to get
it merged, but in terms of functionality being provided I'm
essentially saying "take it or leave it" because I'm not going to
waste time bikeshedding this whole thing again.

This has only been given a basic smoke test right now (see above!
:).  I need to get Darrick's tests from the previous round of config
file bikeshedding working in my test environment to do more
substantial testing of this....

Cheers,

Dave.


Dave Chinner (3):
  build: add support for libinih for mkfs
  mkfs: add initial ini format config file parsing support
  mkfs: hook up suboption parsing to ini files

 configure.ac         |   3 +
 include/builddefs.in |   1 +
 include/linux.h      |   2 +-
 m4/package_inih.m4   |  20 ++++
 mkfs/Makefile        |   2 +-
 mkfs/xfs_mkfs.c      | 218 +++++++++++++++++++++++++++++++++++++------
 6 files changed, 218 insertions(+), 28 deletions(-)
 create mode 100644 m4/package_inih.m4

-- 
2.28.0

