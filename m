Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163227AbdDWSzG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:06 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35CA780F9A
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:05 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/12] mkfs: save user input into opts table
Date: Sun, 23 Apr 2017 20:54:51 +0200
Message-Id: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys,

I decided to split my big patchset into more smaller ones. So, this is the
first set. It adds set/get functions similar to Dave's suggestion, to save and
retrieve user values to and from the big opts table and prepares the ground for
future patches.


It is a mix of patches I already submitted and new ones:
Patches 2, 3, 4, 5 are just slightly modified to fix their issues.
Other patches are new.

The last few patches could be merged into one, because it should only
substitute variables for get/set calls, but because there are so many
places where the changes occurs, I split them into smaller chunks,
making it (hopefully) easier for you to review.

This patchset requires my two previous uint patches.
Git tree: https://github.com/jtulak/xfsprogs-dev/tree/setters

Cheers,
Jan

P.S.:
As a side note, I thought about adding a verification mechanism to
the set_conf_val() function, which would guarantee that we never have
an invalid number even later in the code -- an attempt to catch for
bugs. However, it seems that in some cases, we convert the number
e.g. from number of 512 byte blocks to fs blocks in situ (L_SUNIT),
which means that in some occasions, we are getting out of the range
of allowed values on the input side. So, I'm not adding these checks now,
but it is an option that could give us a cheap way how to catch some bugs.
Another question though is, how useful it would be...


Jan Tulak (12):
  mkfs: Save raw user input field to the opts struct
  mkfs: rename defaultval to flagval in opts
  mkfs: remove intermediate getstr followed by getnum
  mkfs: merge tables for opts parsing into one table
  mkfs: extend opt_params with a value field
  mkfs: create get/set functions for opts table
  mkfs: save user input values into opts
  mkfs: replace variables with opts table: -b,d,s options
  mkfs: replace variables with opts table: -i options
  mkfs: replace variables with opts table: -l options
  mkfs: replace variables with opts table: -n options
  mkfs: replace variables with opts table: -r options

 mkfs/xfs_mkfs.c | 2457 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 1420 insertions(+), 1037 deletions(-)

-- 
2.1.4

