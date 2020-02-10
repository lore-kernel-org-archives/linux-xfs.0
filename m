Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F64DC35254
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1117D208C4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgBJDrV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 22:47:21 -0500
Received: from sandeen.net ([63.231.237.45]:35398 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgBJDrV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 9 Feb 2020 22:47:21 -0500
Received: from Liberator.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 652E615D96;
        Sun,  9 Feb 2020 21:47:18 -0600 (CST)
Subject: Re: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruption
To:     John Jore <john@jore.no>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <186d30f217e645728ad1f34724cbe3e7@jore.no>
 <b2babb761ed24dc986abc3073c5c47fc@jore.no>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <74152f80-3a42-eab5-a95f-e29f03db46a9@sandeen.net>
Date:   Sun, 9 Feb 2020 21:47:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <b2babb761ed24dc986abc3073c5c47fc@jore.no>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/9/20 12:19 AM, John Jore wrote:
> Hi all,
> 
> Not sure if this is the appropriate forum to reports xfs_repair bugs? If wrong, please point me in the appropriate direction?

This is the place.

> I have a corrupted XFS volume which mounts fine, but xfs_repair is unable to repair it and volume eventually shuts down due to metadata corruption if writes are performed.

what does dmesg say when it shuts down?

> 
> Originally I used xfs_repair from CentOS 8.1.1911, but cloned latest xfs_repair from git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git (Today, Feb 9th, reports as version 5.4.0)
> 
> 
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - 16:08:04: scanning agi unlinked lists - 64 of 64 allocation groups done
>         - process known inodes and perform inode discovery...
>         - agno = 45
>         - agno = 15
>         - agno = 0
>         - agno = 30
>         - agno = 60
>         - agno = 46
>         - agno = 16
> Metadata corruption detected at 0x4330e3, xfs_inode block 0x17312a3f0/0x2000
>         - agno = 61
>         - agno = 31
>         - agno = 47
>         - agno = 62
>         - agno = 48
>         - agno = 49
>         - agno = 32
>         - agno = 33
>         - agno = 17
>         - agno = 1
> bad magic number 0x0 on inode 18253615584
> bad version number 0x0 on inode 18253615584
> bad magic number 0x0 on inode 18253615585
> bad version number 0x0 on inode 18253615585
> bad magic number 0x0 on inode 18253615586 
> .....
> bad magic number 0x0 on inode 18253615584, resetting magic number
> bad version number 0x0 on inode 18253615584, resetting version number
> bad magic number 0x0 on inode 18253615585, resetting magic number
> bad version number 0x0 on inode 18253615585, resetting version number
> bad magic number 0x0 on inode 18253615586, resetting magic number
> bad version number 0x0 on inode 18253615586, resetting version number

Looks like a whole chunk of inodes with at least 0 magic numbers.

> ....
>         - agno = 16
>         - agno = 17
> Metadata corruption detected at 0x4330e3, xfs_inode block 0x17312a3f0/0x2000
>         - agno = 18
>         - agno = 19
> ...   
> Phase 7 - verify and correct link counts...
>         - 16:10:41: verify and correct link counts - 64 of 64 allocation groups done
> Metadata corruption detected at 0x433385, xfs_inode block 0x17312a3f0/0x2000
> libxfs_writebufr: write verifier failed on xfs_inode bno 0x17312a3f0/0x2000

This bit seems problematic, I guess it's unable to write the updated inode buffer,
due to some corruption, which presumably is why you keep tripping over the same
corruption each time.

> releasing dirty buffer (bulk) to free list!
> 
>  
> 
> Does not matter how many times, I've lost count, I re-run xfs_repair, with, or without -d,

-d is for repairing a filesystem while mounted.  I hope you are not doing that, are you?

> it never does repair the volume.
> Volume is a ~12GB LV build using 4x 4TB disks in RAID 5 using a 3Ware 9690SA controller. 

Just to double check, are there any storage errors reported in dmesg?

> Any suggestions or additional data I can provide?

If you are willing to provide an xfs_metadump to me (off-list) I will see if I can
reproduce it from the metadump. 

# xfs_metadump /dev/$WHATEVER metadump.img
# bzip2 metadump.img

-Eric

> 
> John
> 
