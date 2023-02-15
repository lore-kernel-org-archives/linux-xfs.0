Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3794EC61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjBOBpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBOBpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B2D3344E;
        Tue, 14 Feb 2023 17:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCFB1B81F80;
        Wed, 15 Feb 2023 01:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2AC433D2;
        Wed, 15 Feb 2023 01:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425539;
        bh=rrKsDdhYLteWwUyeZrY2ndBfO2M07qB9mUlzyVu4PLM=;
        h=Subject:From:To:Cc:Date:From;
        b=ElP9pn4yhMnGkiuJSjq+oS04XE9T8wzggKCj65RHZAloFUpqWaY+2vlChz77HP0nx
         u0MEmpJR0dacjbB5MYyrgiXt86Q6D+tPQnyCaa7cKY84PmCGcJb3mN1JMQ2H/7GWUf
         nnaShrDkbKFCi7LmvefJStzBjZD3yZi03T1cZNdfI0I+4/kFgkCYQuPV8KZHyVqI6u
         21iCbUeD8yWJX+8Km16HruEHyFE8UER1JHmXbLGy1CSMTeeiLGyq1QKQvSvVbDXt8C
         hAQ0oqZYB2eFEEQOnHUIDkEAmPvT6kGtmd6idgGXnQxQSB8mU4IoNBH7vVzSCW6vjE
         KaFLUaDaTOCyw==
Subject: [PATCHSET v2 00/14] fstests: improve junit xml reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Qu Wenruo <wqu@suse.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com,
        quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:45:38 -0800
Message-ID: <167642553879.2118945.15448815976865210889.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series improves the fstests reporting code in several ways.  First,
change the ./check code to generate the report after every test, so that
a cluster-based fstest scheduler can reschedule tests after a VM crash.
Personally, I was using it to get live status on my tests dashboard.

The bulk of the patches in here improve the junit xml reporting so that
we (a) actually declare which xml schema we're trying to emit and (b)
capture a lot more information about what was being tested.

v2: shorten indenting in the schema file, record .dmesg files as a
separate kernel-log tag, clarify what the timestamp attribute means,
record the test suite start time and report generation time as separate
attributes, make it possible to pass in a list of report variables,
encode cdata correctly

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xunit-reporting-improvements
---
 README        |    3 +
 check         |   11 +++
 common/ext4   |    5 +
 common/report |  119 +++++++++++++++++++++++-----
 common/xfs    |   10 ++
 doc/xunit.xsd |  246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 374 insertions(+), 20 deletions(-)
 create mode 100644 doc/xunit.xsd

