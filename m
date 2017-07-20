Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934676AbdGTJ3g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:29:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85327336F17
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:29:36 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/7] mkfs: save user input into opts table
Date: Thu, 20 Jul 2017 11:29:25 +0200
Message-Id: <20170720092932.32580-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys

This is a respin of https://www.spinics.net/lists/linux-xfs/msg06158.html, but
I decided to split that set in two smaller ones. This first one implements the
infrastructure, but does not replace standalone variables with the opts table
fields, that happens in the other set.

To reiterate: The main goal of this set is to save user input into the opts
struct, instead of various ad-hoc variables.  I'm adding the set and get
functions to do this and applying them where appropriate. Once all the values
are in a single place, we can expand the automated validation and use it e.g.
for loading up optional config file like Luis wants to do.

This set is now is based on for-next and not on my type-chaning set (which
will come some time later). Then there are some fixes in specific commits --
all issues you raised should be addressed.

You can see the tree for both sets at:
https://github.com/jtulak/xfsprogs-dev/tree/setters

Cheers,
Jan


Jan Tulak (7):
  mkfs: Save raw user input field to the opts struct
  mkfs: rename defaultval to flagval in opts
  mkfs: remove intermediate getstr followed by getnum
  mkfs: merge tables for opts parsing into one table
  mkfs: move getnum within the file
  mkfs: extend opt_params with a value field
  mkfs: save user input values into opts

 mkfs/xfs_mkfs.c | 1773 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 970 insertions(+), 803 deletions(-)

-- 
2.11.0

