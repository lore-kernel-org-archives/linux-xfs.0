Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AF1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 05:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhLAFOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 00:14:17 -0500
Received: from sandeen.net ([63.231.237.45]:39638 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232102AbhLAFOR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Dec 2021 00:14:17 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 64A584872CD;
        Tue, 30 Nov 2021 23:10:22 -0600 (CST)
Message-ID: <fc04dc16-0ea4-5618-632f-668d5585d0a9@sandeen.net>
Date:   Tue, 30 Nov 2021 23:10:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: XFS: Assertion failed: !(flags & (RENAME_NOREPLACE |
 RENAME_EXCHANGE))
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <473f18c6-dc0c-caa4-26d6-2b76ae0d3b35@redhat.com>
 <6502995c-2586-2cea-3ae6-01babb63034b@sandeen.net>
 <CAOQ4uxhkFYZ-TpEooEr_A0_ADdZ8nCff-4NZS8gCU9dd0b2ixQ@mail.gmail.com>
 <CAJfpegtjYuAhkpoz5DHD2ZYVd8m+rSWMs6wwA+iXYo=CeJF6Qg@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAJfpegtjYuAhkpoz5DHD2ZYVd8m+rSWMs6wwA+iXYo=CeJF6Qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/30/21 4:37 AM, Miklos Szeredi wrote:
> On Tue, 30 Nov 2021 at 06:21, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Mon, Nov 29, 2021 at 11:33 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>>
>>> On 11/26/21 9:56 AM, Paolo Bonzini wrote:
>>>> Hi all,
>>>>
>>>> I have reached the following ASSERT today running a kernel from
>>>> git commit 5d9f4cf36721:
>>>>
>>>>           /*
>>>>            * If we are doing a whiteout operation, allocate the whiteout inode
>>>>            * we will be placing at the target and ensure the type is set
>>>>            * appropriately.
>>>>            */
>>>>           if (flags & RENAME_WHITEOUT) {
>>>>                   ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>>>>                   error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>>>>                   if (error)
>>>>                           return error;
>>>>
>>>>                   /* setup target dirent info as whiteout */
>>>>                   src_name->type = XFS_DIR3_FT_CHRDEV;
>>>>           }
>>>
>>>
>>> Hmm.  Is our ASSERT correct?  rename(2) says:
>>>
>>> RENAME_NOREPLACE can't be employed together with RENAME_EXCHANGE.
>>> RENAME_WHITEOUT  can't be employed together with RENAME_EXCHANGE.
>>>
>>> do_renameat2() does enforce this:
>>>
>>>           if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
>>>               (flags & RENAME_EXCHANGE))
>>>                   goto put_names;
>>>
>>> but our assert seems to check for something different: that neither
>>> NOREPLACE nor EXCHANGE is employed with WHITEOUT. Is that a thinko?
>>
>> Probably.
>>
>> RENAME_NOREPLACE and RENAME_WHITEOUT are independent -
>> The former has to do with the target and enforced by generic vfs.
>> The latter has to do with the source and is implemented by specific fs.
>>
>> Overlayfs adds RENAME_WHITEOUT flag is some cases to a rename
>> before performing it on underlying fs (i.e. xfs) to leave a whiteout instead
>> of the renamed path, so renameat2(NOREPLACE) on overlayfs could
>> end up with (RENAME_NOREPLACE | RENAME_WHITEOUT) to xfs.
> 
> Agreed, the assert makes no sense.
> 
> Thanks,
> Miklos


Miklos, Amir - thanks for the confirmation. I'll send a patch.

-Eric
