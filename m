Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47310 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbeGXWva (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 18:51:30 -0400
Subject: Re: [PATCH 1/2 V3] xfs_repair: notify user if free inodes contain
 errors
From: Eric Sandeen <sandeen@sandeen.net>
References: <b6f745ab-3016-9a95-3085-8584f7200b64@redhat.com>
 <75f628bc-e8e7-b4fd-0bbb-fb3ca0fabac8@sandeen.net>
 <3a14c161-a476-58a9-1a13-c2225f5bbb51@sandeen.net>
Message-ID: <39c6e502-df2f-6b0f-839e-1ee36cd57131@sandeen.net>
Date: Tue, 24 Jul 2018 14:43:00 -0700
MIME-Version: 1.0
In-Reply-To: <3a14c161-a476-58a9-1a13-c2225f5bbb51@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 7/23/18 9:35 PM, Eric Sandeen wrote:
> On 7/23/18 7:34 PM, Eric Sandeen wrote:
>> xfs_repair checks allocated but unused (free) inodes in on-disk clusters,
>> and up until now silently repairs any errors, and as a result does not
>> alter exit status if errors are found.
>>     
>> The in-kernel verifiers will be noisy about these errors and instruct
>> the user to run repair, so it's best if repair is explicit about any
>> fixes it makes as a result.
>>
>> To ensure we catch anything the kernel would complain about, re-use
>> xfs_dinode_verify to determine whether we must clear a free inode.
>>
>> Note, however, that the verifier contains only a subset of the checks
>> currently in clear_dinode.  This should be ok; if it's not, the checks
>> should be added to the verifier in any case.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Ugh, dammit, pulled the trigger too soon, tests were looking fine until
> the last few.  Need to look at this more.

With the free inode extent validator fix I sent earlier today I think it's
safe to resume normal review activities for these 2 patches.  :)

Thanks,
-Eric
