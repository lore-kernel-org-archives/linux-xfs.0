Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A45DEB64DA
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Jun 2023 03:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjFXD1A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 23:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjFXD07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 23:26:59 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 032699D
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 20:26:57 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2E28C55244F;
        Fri, 23 Jun 2023 22:26:57 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 2E28C55244F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687577217;
        bh=rJ+f0OScVut9AYPACdZ5k+jeLgpPoQ/8JW6bRhnREzU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ewg+H9sBjZJfSp7Jw81CdXrSalqsJrX7woPsXZCXJfalrmscIFqYF/Th/CPNh29s4
         MNp6gS7Qt6DF2sshEFZHrQ5jCA1/vZB2IQncgsNhMFVIDV+zfQ4oNRo3TbvlD1IDfK
         zj6JDA0CmdTpKJJBPfIiMnkuGxbVttYUyY20YKaMPJ+XmrBc/0HkYGkDiFLnGTCf0G
         cOcSkmWW0jXYn2GrVVbrYMavGSUmwiyH7uoXOaN0Wa7FecfBu8aroDz02wz7wDGYfA
         OYIYBr/Annk7a8HNRnHBCbckw2DDeQzc4MZ5rRJ3jeowGTEWpCT6qz/i2v20YgR2Ps
         YF4JTZw/CkglA==
Message-ID: <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
Date:   Fri, 23 Jun 2023 22:26:56 -0500
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
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/23 6:26 PM, Fernando CMK wrote:
> On Fri, Jun 23, 2023 at 6:14 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 6/23/23 3:25 PM, Fernando CMK wrote:
>>> Scenario
>>>
>>> opensuse 15.5, the fs was originally created on an earlier opensuse
>>> release. The failed file system is on top of a mdadm raid 5, where
>>> other xfs file systems were also created, but only this one is having
>>> issues. The others are doing fine.
>>>
>>> xfs_repair and xfs_repair -L both fail:
>>
>> Full logs please, not the truncated version.
> 
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - 16:14:46: zeroing log - 128000 of 128000 blocks done
>         - scan filesystem freespace and inode maps...
> stripe width (17591899783168) is too large
> Metadata corruption detected at 0x55f819658658, xfs_sb block 0xfa00000/0x1000
> stripe width (17591899783168) is too large

<repeated many times>

It seems that the only problem w/ the filesystem detected by repair is a 
ridiculously large stripe width, and that's found on every superblock.

dmesg (expectedly) finds the same error when mounting.

Pretty weird, I've never seen this before. And, xfs_repair seems unable 
to fix this type of corruption.

can you do:

dd if=<filesystem device or image> bs=512 count=1 | hexdump -C

and paste that here?

I'd also like to see what xfs_ifo says about other filesystems on the md 
raid.

-Eric

