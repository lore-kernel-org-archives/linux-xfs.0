Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46565 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdLRPlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 10:41:53 -0500
Received: by mail-wr0-f194.google.com with SMTP id g17so5298887wrd.13
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2017 07:41:53 -0800 (PST)
Date: Mon, 18 Dec 2017 16:41:50 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: How to get disk-location from "metadata I/O error"?
Message-ID: <20171218154149.ijynq53b446vlmfm@odin.usersys.redhat.com>
References: <002e01d377f1$a986be00$fc943a00$@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01d377f1$a986be00$fc943a00$@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaughan <cxt9401@163.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 07:16:33PM +0800, Vaughan wrote:
> Hi All,
> 
> 
> I encounter the following output from time to time. Since xfs is built on
> our own virtual disk, it's more likely that our vdisk is buggy.
> Can anyone tell me how to figure out the on-disk location given the block
> number? Does it follow the following formula?
> On-disk location = <block number from metadata I/O error> * <bsize of data
> section of xfs_info>
> However, the result from the above formula suggests the metadata is out of
> range of my disk, confused...

No, your formula is not correct. XFS filesystem blocks are not exactly
sequentially arranged as your formula suggests. It depends on the number of
blocks in each Allocation Group, and the Log2 number used to make calculations
regarding disk addresses.

Easier answer: Use xfs_db to convert it:

xfs_db> fsblock 0x1e8ffa08
xfs_db> daddr
current daddr is 2639245888


Complete answer:

 The number of filesystem blocks inside each Allocation Group is always, the one
presented in xfs_info. As in your example:

agsize=10682336

But to make calculations a bit easier, XFS uses a 'rounded up' log2 number of
the number of blocks in the AG.

So, you can have a 'hole' of filesystem blocks between the end of one AG and the
start of the next AG.

According to the information you provided:

agsize=10682336
agcount=32,

XFS will use "24" as a Rounded up Log2 to keep track of AGs blocks:

In your Case, you have 10682336. So, next power of 2 number is "16777216", which
is 2**24.

But the amount of blocks you have in an AG is: 10682336, so you will have
10682336 valid block numbers + a 'hole' of 6094880 blocks on each AG. This is
just a way to make address translations easier in XFS.

So, to get the disk address of that specific block you first need to know:

- Which AG that FS block is
- The offset of that FS block in the AG

To decimal:
0x1e8ffa08 == 512752136

FSBLOCK	 / AG block count rounded up == AG where the block is
FSBLOCK % AG block count roudned up == Offset into the AG

So:
512752136 / 16777216 == 30 == AG where the block you mentioned is in
512752136 % 16777216 == 9435656 == The offset in that AG

Then you can convert the AG block to it's current disk address using:

AG * total fsblocks per AG + Offset into the AG:

30 * 10682336 + 9435656 = 329905736

Then convert to the current disk address:

329905736 << 3 = 2639245888

And again, the disk address you look for is: 2639245888

> 
> Another question is the corrupted metadata buffer always start with 8 bytes
> of '8' character. Does xfs use '8' as any magic label?

No.

You can use xfs_db to dump the content of that specific block and see if there
is anything else there that might give you a clue of what is going on.

Cheers

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
