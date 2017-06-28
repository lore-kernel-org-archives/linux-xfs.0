Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbdF1Vwr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 17:52:47 -0400
Subject: Re: non mountable xfs with 2 primary and 2 logical
References: <1498686205.13847.1.camel@versatel.nl>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f6ba654f-5d85-043d-f632-30d0b88226f7@sandeen.net>
Date: Wed, 28 Jun 2017 16:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <1498686205.13847.1.camel@versatel.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Waterbeek <richardwbb@versatel.nl>, linux-xfs@vger.kernel.org

On 6/28/17 4:43 PM, Richard Waterbeek wrote:
> Hi linux-xfs mailinglist,
> 
> I've recently subscribed to this list. I've seen many messages, but have
> little understading of the 'XFS' file system. I know about mkfs.xfs.
> I've benched my hardware. But, now my harddrive had a collision with the
> mbr somehow. [or something]
> 
> But, now I've 'hexdumped', the first 512 bytes, [because after a
> disaterous reboot, cfdisk is now saying; "/dev/sda empty".

If the xfs partition you lost was on extended partition sda5,
that's not at the front of the disk.  It sounds like something
overwrote your partition table. 

Honestly, recreating a partition table isn't an xfs issue.

> I'm aware of two primary and two logical partitions. I feel that I know
> the size of the first and second primary, but the xfs/ sda5 and, xfs
> sda6, are no longer appearing. I had to '#' the /etc/fstab, because it
> won't boot [long waiting].
> 
> Now I would like to restore the first 512 bytes which is the MBR.
> 
> I have absolutely no understanding of -where-, "the SuperBlock" [or how
> that should be called], happens to be.

The MBR is not the XFS superblock.  sda5's XFS superblock is somewhere
much further into the disk.

I don't think anyone here can tell you how to recreate the partitions,
because nobody knows what their exact size was.
 
The XFS superblock signature is "XFSB" so you could go hexdumping the
whole disk, look for eveny-spaced occurences of that pattern, and assume
that you've found some superblocks, and work backwards from there.

All this is essentially data recovery, getting well beyond the scope of
normal mailing-list help, though.

-Eric

> But, I feel that 512 bytes missing and no reason to believe a whole
> Terabyte would be "ones and/ or zero's", now, I wonder, how to restore
> this. I have not made backup of this harddrive, just an rsync, which is
> a little outdated and a bit incomplete, because difference in size of
> both drives.
> 
> I might be able to create a XFS-something [from /dev/sda, for example],
> and write that with dd. 
> 
> But, before I would 'try this out', I would like to gain some
> understanding, of what -should- be on the first 512 bytes of a
> harddrive, besides what I have now, cfdisk is saying empty.
> 
> Hoping to receive a reply, Richard, the Netherlands
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
