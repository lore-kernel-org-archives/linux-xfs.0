Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C70DC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 14:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D9864E58
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 14:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhBWOln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 09:41:43 -0500
Received: from sandeen.net ([63.231.237.45]:58832 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhBWOli (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 09:41:38 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7DA41611F0F;
        Tue, 23 Feb 2021 08:40:43 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia> <20180326124649.GD34912@bfoster.bfoster>
 <20180327211728.GP18129@dastard>
 <20210223134256.GA1327978@xiangao.remote.csb>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <a3a02b9b-656a-7284-d1b1-befbafc3e9f9@sandeen.net>
Date:   Tue, 23 Feb 2021 08:40:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223134256.GA1327978@xiangao.remote.csb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/21 7:42 AM, Gao Xiang wrote:
> Hi folks,
> 
> On Wed, Mar 28, 2018 at 08:17:28AM +1100, Dave Chinner wrote:
>> On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
>>> On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
>>>> On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
>>>>> Now that unlinked inode recovery is done outside of
>>>>> log recovery, there is no need to dirty the log on
>>>>> snapshots just to handle unlinked inodes.  This means
>>>>> that readonly snapshots can be mounted without requiring
>>>>> -o ro,norecovery to avoid the log replay that can't happen
>>>>> on a readonly block device.
>>>>>
>>>>> (unlinked inodes will just hang out in the agi buckets until
>>>>> the next writable mount)
>>>>
>>>> FWIW I put these two in a test kernel to see what would happen and
>>>> generic/311 failures popped up.  It looked like the _check_scratch_fs
>>>> found incorrect block counts on the snapshot(?)
>>>>
>>>
>>> Interesting. Just a wild guess, but perhaps it has something to do with
>>> lazy sb accounting..? I see we call xfs_initialize_perag_data() when
>>> mounting an unclean fs.
>>
>> The freeze is calls xfs_log_sbcount() which should update the
>> superblock counters from the in-memory counters and write them to
>> disk.
>>
>> If they are out, I'm guessing it's because the in-memory per-ag
>> reservations are not being returned to the global pool before the
>> in-memory counters are summed during a freeze....
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
> 
> I spend some time on tracking this problem. I've made a quick
> modification with per-AG reservation and tested with generic/311
> it seems fine. My current question is that how such fsfreezed
> images (with clean mount) work with old kernels without [PATCH 1/1]?
> I'm afraid orphan inodes won't be freed with such old kernels....
> Am I missing something?

It's true, a snapshot created with these patches will not have their unlinked
inodes processed if mounted on an older kernel. I'm not sure how much of a
problem that is; the filesystem is not inconsistent, but some space is lost,
I guess. I'm not sure it's common to take a snapshot of a frozen filesystem on
one kernel and then move it back to an older kernel.  Maybe others have
thoughts on this.

-Eric
