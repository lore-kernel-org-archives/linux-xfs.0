Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CA4C3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 04:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B053A2080F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 04:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbfH1EYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 00:24:00 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40890 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbfH1EYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 00:24:00 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D7F6E361337
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 14:23:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0004w1-EF
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0001h8-BU
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3 v2] xfs: allocate xattr buffer on demand
Date:   Wed, 28 Aug 2019 14:23:47 +1000
Message-Id: <20190828042350.6062-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=FmdZ9Uzk2mMA:10 a=QMgGOOtMyRA8HtHMK4QA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ok, this one works on v4 format filesystems with 256 byte inodes.

Three patches now, the first cleans up the error returns from
the shortform, leaf and node for attritbute value retrieval. The
existing code conflates the lookup function return values with the
return values needed for retreiving the attribute values.

That is, shortform returns -EEXIST to indicate that the attribute
exists and was retrieved, and returns -ENOATTR is it didn't exist.

Leaf and node form return zero if it was retrieved, -ENOATTR is it
didn't exist, and some other negative error if something else went
wrong. And some of the return values are hidden several layers deep
in the remote attribute read code.

SO the first patch cleans this all up and makes it consistent, and
cleans up some of the error checking and remote attribute retrieval
for leaf/node format code.

The second patch folds the remote attr retreival into the
xfs_attr_leaf_getvalue() function, rather than doing it on return
and having to check all over again whether the attr was a remote
attr.

The thrid patch what remains of the original single patch - it
factors out the copying of the attribute value from the shortform
and leaf code, making them all use the same code for buffer
allocation and remote value retrieval. The high level code is
modified to allow the retrieval code to allocate the buffer on
demand.

The previous patch failed because ACLs in leaf format attributes are
only covered by the xfstests "attr" group when using 256 byte
inodes.  generic/318 creates an acl that doesn't fit in line in a
256 byte inode, so it was tripping over the return value
inconsistency that the first patch in this series fixes up.

Cheers,

Dave.

