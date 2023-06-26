Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5409BEB64DC
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 02:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjFZCMq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 22:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFZCMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jun 2023 22:12:45 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59406FA
        for <linux-xfs@vger.kernel.org>; Sun, 25 Jun 2023 19:12:44 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4928F5CCFDF;
        Sun, 25 Jun 2023 21:12:43 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 4928F5CCFDF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687745563;
        bh=DQZjkglcVKEjNyTgUlwNEHGkx+3eGnKDDUUDOS9EYvw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WhGXz0iQSOBzDR8cpnyiyFD9gk+o8EK/NOpKwsBN5Jh58UtdRv9UzlWTbBIHLPbKf
         6gPKHtqBmHgXc6+Ikt6LyXkQI1fvlr2dUCsiXOlR+Yz6dmqQsqc2JNaMkdCoQ58Xht
         cKKVB8pzrg1GYPGOwRFVIjFOlSs/+0wFcP/3l9+k3vInhPX7IrHWnrE4udsUzqkpFW
         fGMkpre42NBc4nUtTukM9U5+Ok2h9Y49/sr3TSzIccla2GQmNO/wQ6gkMapnxNLyPG
         6UK92MJ63ziKhPyoPIAWTt2/GOOAx0BN5dOy5GwODLhQmBAt4SFO10I01ONSLn3/Yu
         +xyKmW20Jpk/g==
Message-ID: <f208cf3b-287a-5ac6-cd20-ce07b2c43704@sandeen.net>
Date:   Sun, 25 Jun 2023 21:12:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
Content-Language: en-US
To:     Fernando CMK <ferna.cmk@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net>
 <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
 <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
 <CAEBim7BZsCYxjucpN5R8HpP+BpFezSzZ1QiA1COqU3-MZ18eXQ@mail.gmail.com>
 <99544e27-0871-6d0e-0576-5f28bc736978@sandeen.net>
 <CAEBim7B1C3P=zzyBvNhis7=HmTb_NZrmKG8cie=F+qVVYENisg@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEBim7B1C3P=zzyBvNhis7=HmTb_NZrmKG8cie=F+qVVYENisg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/25/23 12:38 PM, Fernando CMK wrote:
> Ok, I'll try it on a new copy. BTW, are you sure it's "swidth"?

I erroneously replied to this off-list. (The field name is "width")

Fernando let me know that fixing the stripe units made things recoverable.

This is still an unexplainable situation though, to me. But glad it worked!

-Eric

> It's complaining as follows:
> 
> Metadata corruption detected at 0x5627b63fec08, xfs_sb block 0x98580000/0x1000
> field swidth not found
> 
> Thanks for your help.
> 
> 
> 
> On Sat, Jun 24, 2023 at 10:48 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 6/24/23 1:25 PM, Fernando CMK wrote:
>>>> It seems that the only problem w/ the filesystem detected by repair is a
>>>> ridiculously large stripe width, and that's found on every superblock.
>>> If that's the issue, is there a way to set the correct stripe width?
>>> Also... the md array involved has 3 disks, if that's of any help.
>>>
>>
>> Yes, you can rewrite each superblock (all 42) with xfs_db in -x mode.
>>
>> I would suggest trying it on a fresh copy of the image file in case
>> something goes wrong.
>>
>> for S in `seq 0 41`; do
>>    xfs_db -x -c "sb $S" -c "write swidth 256" <image_file>
>> done
>>
>> or something similar
>>
>> I'm really baffled about how your filesystem possibly got into this
>> shape, though.
> 

