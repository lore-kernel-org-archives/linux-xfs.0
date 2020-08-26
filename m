Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069B2C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23FB208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHZOcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:32:47 -0400
Received: from sandeen.net ([63.231.237.45]:42462 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgHZOcb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 10:32:31 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8D19348C6E5;
        Wed, 26 Aug 2020 09:32:03 -0500 (CDT)
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <20200825224144.GS12131@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2210dced-9196-b42e-9205-4b9da3832553@sandeen.net>
Date:   Wed, 26 Aug 2020 09:32:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200825224144.GS12131@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 5:41 PM, Dave Chinner wrote:
> On Tue, Aug 25, 2020 at 03:25:29PM -0500, Eric Sandeen wrote:
>> The boundary test for the fixed-offset parts of xfs_attr_sf_entry
>> in xfs_attr_shortform_verify is off by one.  endp is the address
>> just past the end of the valid data; to check the last byte of
>> a structure at offset of size "size" we must subtract one.
>> (i.e. for an object at offset 10, size 4, last byte is 13 not 14).
>>
>> This can be shown by:
>>
>> # touch file
>> # setfattr -n root.a file
>>
>> and subsequent verifications will fail when it's reread from disk.
>>
>> This only matters for a last attribute which has a single-byte name
>> and no value, otherwise the combination of namelen & valuelen will
>> push endp out and this test won't fail.
>>
>> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 8623c815164a..a0cf22f0c904 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1037,7 +1037,7 @@ xfs_attr_shortform_verify(
>>  		 * Check the fixed-offset parts of the structure are
>>  		 * within the data buffer.
>>  		 */
>> -		if (((char *)sfep + sizeof(*sfep)) >= endp)
>> +		if (((char *)sfep + sizeof(*sfep)-1) >= endp)
> 
> whitespace? And a comment explaining the magic "- 1" would be nice.

I was following the whitespace example in the various similar macros
i.e. XFS_ATTR_SF_ENTSIZE but if people want spaces that's fine by me.  :)

ditto for degree of commenting on magical -1's; on the one hand it's a
common usage.  On the other hand, we often get it wrong so a comment
probably would help.

> Did you audit the code for other occurrences of this same problem?

No.  I should do that, good point.  Now I do wonder if

                /*
                 * Check that the variable-length part of the structure is
                 * within the data buffer.  The next entry starts after the
                 * name component, so nextentry is an acceptable test.
                 */
                next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
                if ((char *)next_sfep > endp)
                        return __this_address;

should be >= but I'll have to unravel all the macros to see.  In that case
though the missing "=" makes it too lenient not too strict, at least.

In general though, auditing for proper "offset + length [-1] >[=] $THING"

where $THING may be last byte or one-past-last-byte is a few days of work, because
we have no real consistency about how we do these things and it requires lots of
code-reading to get all the context and knowledge of how we're counting.

Not really trying to make excuses but I did want to get the demonstrable
flaw fixed fairly quickly.	

Thanks though, these are good points.

-Eric

> Cheers,
> 
> Dave.
> 
