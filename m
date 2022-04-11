Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000B5C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbiDKAeI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbiDKAeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FD1A11C09
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7332453AAAC
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMO-3R
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pii-22
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/17] xfs: unsigned flags conversion for c11
Date:   Mon, 11 Apr 2022 10:31:30 +1000
Message-Id: <20220411003147.2104423-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=1rflaFJlgFbsL_7T2tgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

With the addition of C11 compiler specs to 5.18-rc1, some compilers
are generating warnings about our use of signed flag values being
placed into unsigned fields.

The initial warning is caused by the trace event infrastructure
using __print_flags(). The array structure used internally that we
use macros to initialise defines the flags field as an unsigned
long. This causes signed int flags that set the high bit to be sign
extended and not be correct. gcc-5 then fails to detect this value
as a constant and it throws errors.

The fix for this is to just define the flag values as unsigned ints.
While we only need to convert the buffer flags to avoid the build
error for merge into 5.18-rcX, this series converts all the flags
fields that are used to initialise trace event __print_flags()
arrays. Most of these flags are stored in unsigned int variables, we
really should be declaring them as unsigned values anyway.

Hence this patch set cleans up all these flag values to use unsigned
values, use unsigned storage variables, and convert all the places
that pass them around to use unsigned varaibles. I've converted
all the value definitions to use consistent (1u << x) definitions so
it is clear they are intended to be one bit per value flags.

There are other flags values and fields in XFS that I have not
converted - these can be cleaned up over time as they currently do
not have non-obvious build-breaking potential.

This is based on 5.18-rc2.

Cheers,

Dave.


