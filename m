Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A660C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6696B20825
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHZPjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:39:39 -0400
Received: from sandeen.net ([63.231.237.45]:45878 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgHZPj3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 11:39:29 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B3201324E4F;
        Wed, 26 Aug 2020 10:39:16 -0500 (CDT)
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <20200825224144.GS12131@dread.disaster.area>
 <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
 <20200826151300.GM6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d3066453-6cc6-020e-426e-96d7d1a24164@sandeen.net>
Date:   Wed, 26 Aug 2020 10:39:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826151300.GM6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/26/20 10:13 AM, Darrick J. Wong wrote:

...

> TBH I think this ought to be fixed by changing the declaration of
> xfs_attr_sf_entry.nameval to "uint8_t nameval[]" and using more modern
> fugly macros like struct_sizeof() to calculate the entry sizes without
> us all having to remember to subtract one from the struct size.

Fair, but I think that in the interest of time we should fix it up with a -1
which is consistent with the other bits of attr code first, then this can all
be cleaned up by making it a [] not [1], dropping the magical -1, turning
the macros into functions ala dir2, etc.

Sound ok?

>> No.  I should do that, good point.  Now I do wonder if
>>
>>                 /*
>>                  * Check that the variable-length part of the structure is
>>                  * within the data buffer.  The next entry starts after the
>>                  * name component, so nextentry is an acceptable test.
>>                  */
>>                 next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
>>                 if ((char *)next_sfep > endp)
>>                         return __this_address;
>>
>> should be >= but I'll have to unravel all the macros to see.  In that case
>> though the missing "=" makes it too lenient not too strict, at least.
> 
> *endp points to the first byte after the end of the buffer, because it
> is defined as (*sfp + size).  The end of the last *sfep in the sf attr
> struct is supposed to coincide with the end of the buffer, so changing
> this to >= is not correct.

Let me think on that a little more ;)

-Eric
