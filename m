Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F73C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5792399A
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIXUmF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:42:05 -0400
Received: from sandeen.net ([63.231.237.45]:37172 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUmF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Sep 2020 16:42:05 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B79CEEF1;
        Thu, 24 Sep 2020 15:41:27 -0500 (CDT)
Subject: Re: [PATCH] generic: test reflinked file corruption after short COW
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
References: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
 <20200924201739.GJ7955@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2eac728e-99a0-bd64-ca6f-a62b4297708a@sandeen.net>
Date:   Thu, 24 Sep 2020 15:42:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200924201739.GJ7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/20 3:17 PM, Darrick J. Wong wrote:
> On Thu, Sep 24, 2020 at 01:19:49PM -0500, Eric Sandeen wrote:
>> This test essentially creates an existing COW extent which
>> covers the first 1M, and then does another IO that overlaps it,
>> but extends beyond it.  The bug was that we did not trim the
>> new IO to the end of the existing COW extent, and so the IO
>> extended past the COW blocks and corrupted the reflinked files(s).
>>
>> The bug came and went upstream; it will be hopefully fixed in the
>> 5.4.y stable series via:
>>
>> https://lore.kernel.org/stable/e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com/
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/tests/generic/612 b/tests/generic/612
>> new file mode 100755
>> index 00000000..5a765a0c
>> --- /dev/null
>> +++ b/tests/generic/612
>> @@ -0,0 +1,83 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 612
>> +#
>> +# Regression test for reflink corruption present as of:
>> +# 78f0cc9d55cb "xfs: don't use delalloc extents for COW on files with extsize hints"
>> +# and (inadvertently) fixed as of:
>> +# 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
> 
> This probably should list the name of the patch that fixes it for 5.4.
> 
> With that added,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Will have to wait for a merge for that, I guess.

Especially with the typo fixed (or not)

-Eric
