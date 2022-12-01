Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30856C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 13:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiLANBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 08:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiLANA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 08:00:58 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944128E58E
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 05:00:54 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 30B9D3200065;
        Thu,  1 Dec 2022 08:00:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 01 Dec 2022 08:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boo.tc; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1669899650; x=
        1669986050; bh=WBFZQEHnXVYj96TFOiSnFX11ZEmT89TcXKYJ8Qm2afQ=; b=X
        pK00UlL24/wzJKx0JiQkB7MGe99akqM4OJ6Rz5nRnEzI3WvTFKQqzXDdECO2W3w5
        7yisb2lGZhq3AG7s2vsnWo0ESV7jn+NANFs02MPEVxNziqRXc51dYZ38yI4A0tiB
        lpPESOGDLSelLXdz687lCXAF2rS6qKRkJoT0CrEmB9QKauzB9KIMqNj5sD/UgUAH
        xVIV9aB+N8Qwe9GkBUgTLgxyU30vMUL23Nahmovhe/lPLkXCWHTZkmkVYUBFdYg0
        0qsf7wNrfy6ikYqTzeLjV2Gm53itlCoRIBNF/eT349ZAhuWjmBKibANwXEp+CBuK
        f6iNw9LhdGn9EVnYbRhfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1669899650; x=
        1669986050; bh=WBFZQEHnXVYj96TFOiSnFX11ZEmT89TcXKYJ8Qm2afQ=; b=s
        BfHR/Z2f+WwxBxqEJELXEL7k3OkC6kWU3oWnPGZj9qX5O8o7MZhZaczQegFGaclF
        CExuzWRtQ/icwjM2YdaDeVLjt2mNEPguTd6JXYrstUTOa+cecEBaFsg1Stb/W3e3
        6PfcC040/izW7cxDxOa8/muDetmPTucTVOaK135ghxUqne6Lz8VkVNdTd/dJ+cL2
        LDvqCDgMqIWUmMDpfqUw1uQ2TgyGg5JeVmIAYHEepAyT6dmGCP/3R6nkAkOH+O98
        ck1ksnVv1uHk83WuOYHLPPn9wC08PPFY1vFllMhBxX3XPLzxMBlwD2Srrg8w3pup
        fbkppZbDOWY5Wpg6VU30A==
X-ME-Sender: <xms:gqWIY8wwwdBLX5_kZGOnvAwXpjOlJdkELgUI1vwKgllE6ZlL-VuyRA>
    <xme:gqWIYwQrH6CLyvKszo3YXJrm5BzEyKk--tcJzoxsH63WxqBYwRHAW4mZdZfUBNmsJ
    hhAERP0ajAush0ibw>
X-ME-Received: <xmr:gqWIY-VA-0TiKpz66kmDfEq6Dhu136hOG8inI7woPJx7Hc3rBquGENGKpbfaaLS_iPUeLj84xx4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtdehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdehtddmnecujfgurhepkfffgggfvfevfhfhufgjtgfgsehtjeertddt
    feejnecuhfhrohhmpeevhhhrihhsuceuohhothcuoehlihhsthhssegsohhothgtrdgsoh
    hordhttgeqnecuggftrfgrthhtvghrnhepieevfeffgefhvdfghfefueektefhjefgtdef
    veffveeikeeiueetfeetleevvedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheplhhishhtshessghoohhttgdrsghoohdrthgt
X-ME-Proxy: <xmx:gqWIY6jLR8nhjnhWIZVBdq6farqBbooib6APNsekrjLcGm3zEMqoAQ>
    <xmx:gqWIY-Bqrt-p5K4rU9XWRAKU23cYJ3Z-o-fY3hTTuf_3ii-9lbxazg>
    <xmx:gqWIY7JdrzhUhYxae4XQeNu7WIV65MfItKGe2PXhcPua39MQfCywAg>
    <xmx:gqWIYxP0B3lBx4qJ0cpiA8KqQt0INCeeivqNuGhjF3BBNHRDHM3Wkg>
Feedback-ID: i5869458d:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Dec 2022 08:00:49 -0500 (EST)
Message-ID: <a019db45-2f05-e2ec-5953-26e20aa9484b@bootc.boo.tc>
Date:   Thu, 1 Dec 2022 13:00:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Content-Language: en-GB
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
 <20221129220646.GI3600936@dread.disaster.area> <Y4gNntJTb1dZLejo@magnolia>
From:   Chris Boot <lists@bootc.boo.tc>
Subject: Re: XFS corruption help; xfs_repair isn't working
In-Reply-To: <Y4gNntJTb1dZLejo@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01/12/2022 02:12, Darrick J. Wong wrote:
> On Wed, Nov 30, 2022 at 09:06:46AM +1100, Dave Chinner wrote:
>> On Tue, Nov 29, 2022 at 08:49:27PM +0000, Chris Boot wrote:
>>> Hi all,
>>>
>>> Sorry, I'm mailing here as a last resort before declaring this filesystem
>>> done for. Following a string of unclean reboots and a dying hard disk I have
>>> this filesystem in a very poor state that xfs_repair can't make any progress
>>> on.
>>>
>>> It has been mounted on kernel 5.18.14-1~bpo11+1 (from Debian
>>> bullseye-backports). Most of the repairs were done using xfsprogs 5.10.0-4
>>> (from Debian bullseye stable), though I did also try with 6.0.0-1 (from
>>> Debian bookworm/testing re-built myself).
>>>
>>> I've attached the full log from xfs_repair, but the summary is it all starts
>>> with multiple instances of this in Phase 3:
>>>
>>> Metadata CRC error detected at 0x5609236ce178, xfs_dir3_block block
>>> 0xe101f32f8/0x1000
>>> bad directory block magic # 0x1859dc06 in block 0 for directory inode
>>> 64426557977
>>> bad bestfree table in block 0 in directory inode 64426557977: repairing
>>> table
>>
>> I think that the problem is that we are trying to repair garbage
>> without completely reinitialising the directory block header. We
>> don't bother checking the incoming directory block for sanity after
>> the CRC fails, and then we only warn that it has a bad magic number.
>>
>> We then go a process it as though it is a directory block,
>> essentially trusting that the directory block header is actually
>> sane. Which it clearly isn't because the magic number in the dir
>> block has been trashed.
>>
>> We then rescan parts of the directory block and rewrite parts of the
>> block header, but the next time we re-scan the block we find that
>> there are still bad parts in the header/directory block. Then we
>> rewrite the magic number to make it look like a directory block,
>> and when repair is finished it goes to write the recovered directory
>> block to disk and it fails the verifier check - it's still a corrupt
>> directory block because it's still full of garbage that doesn't pass
>> muster.
>>
>>  From a recovery persepective, I think that if we get a bad CRC and
>> an unrecognisable magic number, we have no idea what the block is
>> meant to contain - we cannot trust it to contain directory
>> information, so we should just trash the block rather than try to
>> rebuild it. If it was a valid directory block, this will result in
>> the files it pointed to being moved to lost+found so no data is
>> actually lost.
>>
>> If it wasn't a dir block at all, then simply trashing the data fork
>> of the inode and not touching the contents of the block at all is
>> right thing to do. Modifying something that may be cross-linked
>> before we've resolved all the cross-linked extents is a bad thing to
>> be doing, so if we cannot recognise the block as a directory block,
>> we shouldn't try to recover it as a directory block at all....
>>
>> Darrick, what are your thoughts on this?
> 
> I kinda want to see the metadump of this (possibly enormous) filesystem.

I've asked whether I can share this with you. The filesystem is indeed 
huge (35TiB) and I wouldn't be surprised if the metadata alone was 
rather large. What would be the most efficient way of sharing that with you?

It looks like there are exactly 7 unreadable directories scattered 
across the filesystem, most in data that has been there for weeks/months 
- but a couple in the most recent complete "snapshot" directory.

> Probably the best outcome is to figure out which blocks in each
> directory are corrupt, remove them from the data fork mapping, and see
> if repair can fix up the other things (e.g. bestfree data) and dump the
> unlinked files in /lost+found.  Hopefully rsnapshot can deal with the
> directory tree if we can at least get the bad dirblocks out of the way.

rsnapshot just runs an rsync with --link-dest= set, so it'll just 
duplicate files that are missing, but it aborts when it hits the 
corrupted directories as it can't look inside them.

> If reflink is turned on, repair can deal with crosslinked file data
> blocks, though anything other kind of block results in the usual
> scraping-till-its-clean behavior.

Sadly reflink is off:

meta-data=/dev/vg_data/rsnapshot isize=512    agcount=38, 
agsize=251658224 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=0, rmapbt=0
          =                       reflink=0    bigtime=0 inobtcount=0 
nrext64=0
data     =                       bsize=4096   blocks=9395240960, imaxpct=5
          =                       sunit=16     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

> I'm also kinda curious what started this corruption problem, and did any
> of it leak through to other files?

I wish we knew. This came to light when the machine had to be repeatedly 
rebooted because a large computation job was making the system run out 
of memory. Unfortunately it has a lot of swap configured so it wasn't 
just being OOM killed, which would have been much better. This all 
actually led to soft lockups and to our reboots. This happened 3-4 times 
before we noticed the corruption.

During the above the RAID controller (an LSI MegaRAID) marked one of the 
hard disks that makes up the array (a RAID-60 over 18x 8TB SAS disks, 2x 
9-disk RAID-6 spans) faulty.

During the recovery I know that xfs_repair was run with -L at some 
point; I'm not certain whether the person doing this actually tried 
mounting the filesystem first to replay the log, though. There was 
certainly a lot more corruption than just this, but it seems like that 
all got repaired away. /lost+found was full of 10s of thousands of 
displaced files (now removed).

Thanks,
Chris

-- 
Chris Boot
bootc@boo.tc

