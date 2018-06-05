Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49426 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751386AbeFECnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 22:43:19 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ1wJ-0001le-Qe
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 12:43:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ1wJ-0004uu-Ne
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 12:43:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: more verifications!
Date: Tue,  5 Jun 2018 12:43:10 +1000
Message-Id: <20180605024313.18737-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This patchset addresses a series of corruptions noticed in an image
provided by Wen Xu. The patches only address detecting corruptions
before they can do damage - it does not address/fix the crash the
image caused but instead prevents the bad information from getting
to the point where it can cause a crash.

The third patch addresses a general btree record validation issue;
we should probably dirve this inwards to each btree implementation
with a ->verify_record() callout, as this patch does not address
all the places that btree records are traversed during searches. It
will catch any attempt to use a bad record that a search lands on,
however.

Comments?

-Dave.


