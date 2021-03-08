Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144D4C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E2E6518F
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 09:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCHJEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 04:04:52 -0500
Received: from corp-mailer.zoner.com ([217.198.120.77]:37247 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhCHJEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 04:04:25 -0500
Received: from [10.1.0.142] (gw-sady.zoner.com [217.198.112.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by corp-mailer.zoner.com (Postfix) with ESMTPSA id 6116E1F256;
        Mon,  8 Mar 2021 10:04:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zoner.cz;
        s=zcdkim1-3eaw24144jam11p; t=1615194258;
        bh=iWwi0HW762uE7SYyjfa30lUCFiO25YEqsxYQB1GnQR8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BuOfy+SwhKX4jQVn0u/rvpjc1b1H/PlpBZG+eAHYN90OUlYOPSAJLoZVLIcXz+Itn
         mdzeFmVd/gmxFzr7crzv1KjPKPGbyY6IcxPyKIO0mdfkdSAzARGn+MO1NtESc7L2yr
         EUxmF84MsNcfMOda/mgQwVp/JZHB1y4IMOxV7RwDT5Cq7eoiGy7WEYwAtfef4vnLSp
         xp4ubezP6hxfbd0a1ig7A7Vq3wFyLmUJs69mWkwHWOhYM+ApdXU2XsZI0h9Dm6QFcm
         BhblXjN+pSTHxxoDpEH4lNY5TwEVln4vTESEl7huuj1aBI7+0I+rwN8lTiatrOejI4
         cqcELYoi4IsvQ==
Subject: Re: Incorrect user quota handling in fallocate
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <c0e98a3b-35e3-ecfe-2393-c0325d70e62f@zoner.cz>
 <20210305214547.GV4662@dread.disaster.area>
From:   Martin Svec <martin.svec@zoner.cz>
Message-ID: <23073a06-f06f-8871-98f2-c6eab0910fc3@zoner.cz>
Date:   Mon, 8 Mar 2021 10:04:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305214547.GV4662@dread.disaster.area>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Content-Language: cs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dne 05.03.2021 v 22:45 Dave Chinner napsal(a):
> On Fri, Mar 05, 2021 at 11:14:32AM +0100, Martin Svec wrote:
>> Hi all,
>>
>> I've found a bug in XFS user quota handling in two subsequent fallocate() calls. This bug can be
>> easily reproduced by the following script:
>>
>> # assume empty XFS mounted on /mnt/testxfs with -o usrquota, grpquota
>>
>> FILE="/mnt/testxfs/test.file"
>> USER="testuser"
>>
>> setquota -u $USER $QUOTA $QUOTA 0 0 -a
>> touch $FILE
>> chown $USER:users $FILE
>> fallocate --keep-size -o 0 -l $FILESIZE $FILE
>> fallocate -o 0 -l $FILESIZE $FILE
>>
>> That is, we create an empty file, preallocate requested size while keeping zero file size and then
>> call fallocate again to set the file size. Assume that there's enaugh free quota to fit the
>> requested file size. In this case, both fallocate calls should succeed because the second one just
>> increases the file size but does not change the allocated space. However, I observed that the second
>> fallocate fails with EDQUOT if the free quota is less than _two times_ of the requested file size. I
> I'd call that expected behaviour. We enforce space restrictions
> (ENOSPC and EDQUOT) on the size being requested before the operation
> takes place and return the unused space reservation after the
> fallocate() completes and has allocated space.

Well, I would expect that allocation of an already allocated space won't account that space again so
it's a clear bug for me. But I'm not aware of XFS internals and understand that it can follow from
overall space allocation logic.

> We cannot overcommit space or quota in XFS - that way leads to
> deadlocks and data loss at ENOSPC because we can end up in
> situations where we cannot write back data that users have written.
> Hence we check up front, and if the worst case space requirement for
> a given operation cannot fit under the ENOSPC or EDQUOT limits, it
> is rejected with EDQUOT/ENOSPC.
>
> Yes, that means we get corner cases when near EDQUOT/ENOSPC where
> stuff like this happens, but that tends to be exceedingly rare in
> the rare world as few applications use the entire filesystem space
> or quota allowance in just 1-2 allocations.

If our customer pays for a disk quota and cannot upload it's favorite 16 GiB movie to Samba share
although he sees more than 30 GiB of space free, it's a bit hard to explain him that this is an
expected and exceedingly rare behavior. :-)

>
>> guess that the second fallocate ignores the fact that the space was already preallocated and
>> accounts the requested size for the second time. For example, if QUOTA=2GiB, file size FILESIZE=800
>> MiB succeeds but FILESIZE=1600 MiB triggers EDQUOT in second fallocate. The same test performed on
>> EXT4 always succeeds.
> Yup, filesystems behave differently at edge cases.
>
>> I've found this issue while investigating why Samba (ver. 4.9.5) returns disk full error although
>> there's still enaugh room for the copied file. Indeed, when Samba's "strict allocate" options is
>> turned on Samba uses the above described sequence of two fallocate() syscalls to create a new file.
> I'd say using fallocate to extend the file like this is .... not a
> very good idea. All you actually need is a ftruncate() to change the
> file size after the first fallocate (or use the first fallocate to
> extend the file, too). The second fallocate() is largely useless on
> most filesystems - internally they turn it into an extending
> truncate because no allocation is required, so you may as well just
> call ftruncate() and that way you will not trip over this space
> reservation issue at all..

I definitely agree that this is ... ehm, stupid way of file space reservation. I'll try to discuss
it on Samba mailing list too. Fortunately, turning off Samba's "string allocate" feature solves the
issue with minimal drawbacks.

> Cheers,
>
> Dave.

Thank you for your response,

Martin


