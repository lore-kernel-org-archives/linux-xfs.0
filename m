Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59852 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752932AbcLMQE2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Dec 2016 11:04:28 -0500
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <2626665.Hsx8YazNWY@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
Date: Tue, 13 Dec 2016 10:04:27 -0600
MIME-Version: 1.0
In-Reply-To: <2626665.Hsx8YazNWY@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 12/13/16 4:52 AM, Libor Klepáč wrote:
> Hello,
> should this patch possibly fix errors i reported in this thread?
> https://www.spinics.net/lists/linux-xfs/msg01728.html
> 
> Is it safe to test it? (i do have backups)

It should be safe, yes.

(you could always run xfs_repair -n first to be extra careful).

Were those errors during mount/replay, though, or was it when the
filesystem was up and running?

I ask because I also sent a patch to ignore these empty attributes
in the verifier during log replay.

FWIW, Only some of your reported buffers look "empty" though, the one
at 514098.682726 may have had something else wrong.

Anyway, yes, probably worth checking with xfs_repair (-n) with this
patch added.  Let us know what you find! :)

-Eric

 
> Thanks,
> Libor
> 
> On čtvrtek 8. prosince 2016 12:06:03 CET Eric Sandeen wrote:
>> We have recently seen a case where, during log replay, the
>> attr3 leaf verifier reported corruption when encountering a
>> leaf attribute with a count of 0 in the header.
>>
>> We chalked this up to a transient state when a shortform leaf
>> was created, the attribute didn't fit, and we promoted the
>> (empty) attribute to the larger leaf form.
>>
>> I've recently been given a metadump of unknown provenance which actually
>> contains a leaf attribute with count 0 on disk.  This causes the
>> verifier to fire every time xfs_repair is run:
>>
>>  Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
>>
>> If this 0-count state is detected, we should just junk the leaf, same
>> as we would do if the count was too high.  With this change, we now
>> remedy the problem:
>>
>>  Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
>>  bad attribute count 0 in attr block 0, inode 12587828
>>  problem with attribute contents in inode 12587828
>>  clearing inode 12587828 attributes
>>  correcting nblocks for inode 12587828, was 2 - counted 1
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
>> index 40cb5f7..b855a10 100644
>> --- a/repair/attr_repair.c
>> +++ b/repair/attr_repair.c
>> @@ -593,7 +593,8 @@ process_leaf_attr_block(
>>  	stop = xfs_attr3_leaf_hdr_size(leaf);
>>  
>>  	/* does the count look sorta valid? */
>> -	if (leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
>> +	if (!leafhdr.count ||
>> +	    leafhdr.count * sizeof(xfs_attr_leaf_entry_t) + stop >
>>  						mp->m_sb.sb_blocksize) {
>>  		do_warn(
>>  	_("bad attribute count %d in attr block %u, inode %" PRIu64 "\n"),
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
