Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07142C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E067120737
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 17:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHZRH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 13:07:26 -0400
Received: from sandeen.net ([63.231.237.45]:50290 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgHZRHZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 13:07:25 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5D652324E4F;
        Wed, 26 Aug 2020 12:07:13 -0500 (CDT)
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
 <20200826164420.GP6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aae7d7e5-956b-a5ba-a085-93da412895c4@sandeen.net>
Date:   Wed, 26 Aug 2020 12:07:23 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826164420.GP6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/26/20 11:44 AM, Darrick J. Wong wrote:
> On Wed, Aug 26, 2020 at 11:19:54AM -0500, Eric Sandeen wrote:
>> The boundary test for the fixed-offset parts of xfs_attr_sf_entry in
>> xfs_attr_shortform_verify is off by one, because the variable array
>> at the end is defined as nameval[1] not nameval[].
>> Hence we need to subtract 1 from the calculation.
>>
>> This can be shown by:
>>
>> # touch file
>> # setfattr -n root.a file
>>
>> and verifications will fail when it's written to disk.
>>
>> This only matters for a last attribute which has a single-byte name
>> and no value, otherwise the combination of namelen & valuelen will
>> push endp further out and this test won't fail.
>>
>> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks ok.

thanks
 
> From whom should I be expecting a test case?

from me or a TBD delegate.  Will follow up soon.

-Eric

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

