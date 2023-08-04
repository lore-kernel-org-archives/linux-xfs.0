Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743E4C001DB
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 19:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjHDT0a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjHDT03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 15:26:29 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE4810EA
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 12:26:23 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id 91A86402C9;
        Fri,  4 Aug 2023 12:26:22 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 6387440369;
        Fri,  4 Aug 2023 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=LR14mn2CW1QD
        JGqOhaMHPAO97Qc=; b=gQRB8jLF52cQPwJu2G/natyXJixUWyKxlg3Nh8xO+l8G
        QAoQScUELbXwiIIFd9mqY0YdGCgh8p1axGfIkefNoq78OSJGZ5LnHrOFh3TkV3Jm
        jPw/nWKk0amQY9C9g/amAS6/+UCAqPVMCWWlVz6waBwS8dDwVOWLYcjyAxcATuc=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=HC7fcx
        J0QYEYnkEX8UqyNMVLXOEBJKjSUbJpH/ME+FLZNui9axYzOkBZOcAKHCzA9pAxEM
        7MsL6sX52udewZmPhTPF6vOWbBFma1W1YKQXotJ3ULggR+S6exGFWKZkOG0gfFRO
        Jq0VBtKyYUtUkwat1qxbQwFRswrClOJnegzww=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 55269402C9;
        Fri,  4 Aug 2023 12:26:22 -0700 (PDT)
Message-ID: <db157228-3687-57bf-d090-10517847404d@fatooh.org>
Date:   Fri, 4 Aug 2023 12:26:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <ZMyxp/Udved6l9F/@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-04 01:07, Dave Chinner wrote:
>>           =                       sunit=128    swidth=68352 blks
>                                                  ^^^^^^^^^^^^^^^^^
> 
> Something is badly broken in MD land.
> 
> .....
> 
>> The default chunk size is 512K
>> -----------------------------------------------------------------------
>> $ sudo mdadm --detail /dev/md10 | grep Chunk
>>          Chunk Size : 512K
>> $ sudo blkid -i /dev/md10
>> /dev/md10: MINIMUM_IO_SIZE="524288" OPTIMAL_IO_SIZE="279969792"
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Yup, that's definitely broken.
> 
>> PHYSICAL_SECTOR_SIZE="512" LOGICAL_SECTOR_SIZE="512"
>> -----------------------------------------------------------------------
>> I don't know why blkid is reporting such a large OPTIMAL_IO_SIZE. I would
>> expect this to be 1024K (due to two data disks in a three-disk RAID-5).
> 
> Yup, it's broken. :/

For what it's worth, this test was on older disks:
* 2 TB Seagate constellation ES.2
* running in an external USB enclosure

If I use newer disks:
* 12 TB Toshiba N300
* hooked up via internal SATA

...then I see the expected OPTIMAL_IO_SIZE. Maybe the issue is due to 
the USB enclosure or due to the older disks having 512-byte physical 
sectors. I don't know what other differences could be relevant.

>> Later on, writes end up getting misaligned by half a stripe. For example:
>> 8082432 / 2048 == 3946.5
> 
> So it's aligned to sunit, not swidth. That will match up with a
> discontiguity in the file layout. i.e. an extent boundary.
> 
> And given this is at just under 4GB written, and the AG size is
> just under 2GB, this discontiguity is going to occur as writing
> fills AG 1 and allocation switches to AG 2.

Thanks. I figured I was seeing something like that, but I didn't know 
the details.

>> I tried manually specifying '-d sunit=1024,swidth=2048' for mkfs.xfs, but
>> that had pretty much the same behavior when writing (the RMW starts later,
>> but it still starts).
> 
> It won't change anything, actually. The first allocation in an AG
> will determine which stripe unit the new extent starts on, and then
> for the entire AG the write will be aligned to that choice.
> 
> If you do IOs much larger than the stripe width (e.g. 16MB at a
> time) the impact of the head/tail RMW will largely go away. The
> problem is that you are doing exactly stripe width sized IOs and so
> is the worse case for any allocation misalignment that might occur.

Thank you, yes, I have seen that behavior in testing.

>> Am I doing something wrong, or is there a bug, or are my expectations
>> incorrect? I had expected that large sequential writes would be aligned with
>> swidth.
> 
> Expectations are wrong. Large allocations are aligned to stripe unit
> in XFS by default.
> 
> THis is because XFS was tuned for *large* multi-layer RAID setups
> like RAID-50 that had hardware RAID 5 luns stripe together via
> RAID-0 in the volume manager.

> In these setups, the stripe unit is the hardware RAID-5 lun stripe
> width (the minimum size that avoids RMW) and the stripe width is the
> RAID-0 width.
> 
> Hence for performance, it didn't matter which sunit allocation
> aligned to as long as writes spanned the entire stripe width. That
> way they would hit every lun.

That is very interesting and definitely makes sense.

> In general, we don't want stripe width aligned allocation, because
> that hot-spots the first stripe unit in the stripe as all file data
> first writes to that unit. A raid stripe is only as fast as it's
> slowest disk, and so having a hot stripe unit slows everything down.
> Hence by default we move the initial allocation around the stripe
> units, and that largely removes the hotspots in the RAID luns...

That makes sense. So the data allocation alignment controls the 
alignment of the writes. I wasn't quite making that connection before.

> So, yeah, there are good reasons for stripe unit aligned allocation
> rather than stripe width aligned.
> 
> The problem is that MD has never behaved this way - it has always
> exposed it's individual disk chunk size as the minimum IO size (i.e.
> the stripe unit) and the stripe width as the optimal IO size to
> avoid RMW cycles.
> 
> If you want to force XFS to do stripe width aligned allocation for
> large files to match with how MD exposes it's topology to
> filesytsems, use the 'swalloc' mount option. The down side is that
> you'll hotspot the first disk in the MD array....

If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any 
unaligned writes.

If I manually specify the (I think) correct values, I do still get 
writes aligned to sunit but not swidth, as before.

-----------------------------------------------------------------------
$ sudo mkfs.xfs -f -d sunit=1024,swidth=2048 /dev/md10
mkfs.xfs: Specified data stripe width 2048 is not the same as the volume 
stripe width 546816
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md10              isize=512    agcount=16, agsize=982912 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=1 inobtcount=1 
nrext64=0
data     =                       bsize=4096   blocks=15726592, imaxpct=25
          =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ sudo mount -o swalloc /dev/md10 /mnt/tmp
-----------------------------------------------------------------------


There's probably something else I'm doing wrong there.

Still, I'll heed your advice about not making a hotspot disk and allow 
XFS to allocate as default.

Now that I understand that XFS is behaving as intended and I 
can't/shouldn't necessarily aim for further alignment, I'll try 
recreating my real RAID, trust in buffered writes and the MD stripe 
cache, and see how that goes.

Thank you very much for your detailed answers; I learned a lot.

-Corey
