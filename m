Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4669EC001DB
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 05:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjHDFwn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 01:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjHDFwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 01:52:42 -0400
X-Greylist: delayed 486 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Aug 2023 22:52:41 PDT
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7630D7
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 22:52:39 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id A9A27401DF
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 22:44:31 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 80A11402C9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 22:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:from:subject:to:content-type
        :content-transfer-encoding; s=dkim; bh=AXxCeSQfIBksm5j7Ad4FVCVrl
        6U=; b=QLcUYPG8IQspatKvFs+BP7DZhvaw8j5hyKvODEEIEZRxGP82/niEU5QN5
        Hqi8wJMiAEt/QeVPJxt0m0WnUv8BVdgyheiqzu6Zb3gBZQHWgU+KXnxTc70i2m/F
        Aljnw05imvUDRg5zTJsRIxpMNOxhFo0tIP7AYd4QMSfTqSWJTQ=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:from:subject:to:content-type
        :content-transfer-encoding; q=dns; s=dkim; b=kzCyJb3gw9LmKaeZOeG
        GlP/Zu7RlnzwU+rvJqr6jzk6ulyMh4I9223v6HznLpm0/DVhxHMhnl9oFBcuihEu
        WOubPSq1tktFQZ6tMMSXQffukTmvcVlj1ZDuxV9eHdA+dctyOxQwv6rLexRp2+RO
        RIxP8gSgc7IdpMX6rPJ4F9sk=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 73041401DF
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 22:44:31 -0700 (PDT)
Message-ID: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
Date:   Thu, 3 Aug 2023 22:44:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
From:   Corey Hickey <bugfood-ml@fatooh.org>
Subject: read-modify-write occurring for direct I/O on RAID-5
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I am having a problem with write performance via direct I/O. My setup is:
* Debian Sid
* Linux 6.3.0-2 (Debian Kernel)
* 3-disk MD RAID-5 of hard disks
* XFS

When I do large sequential writes via direct I/O, sometimes the writes 
are fast, but sometimes the RAID ends up doing RMW and performance gets 
slow.

If I use regular buffered I/O, then performance is better, presumably 
due to the MD stripe cache. I could just use buffered writes, of course, 
but I am really trying to make sure I get the alignment correct to start 
with.


I can reproduce the problem on a fresh RAID.
-----------------------------------------------------------------------
$ sudo mdadm --create /dev/md10 -n 3 -l 5 -z 30G /dev/sd[ghi]
mdadm: largest drive (/dev/sdg) exceeds size (31457280K) by more than 1%
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md10 started.
-----------------------------------------------------------------------
For testing, I'm using "-z 30G" to limit the duration of the initial 
RAID resync.


For XFS I can use default options:
-----------------------------------------------------------------------
$ sudo mkfs.xfs /dev/md10
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md10              isize=512    agcount=16, agsize=983040 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=1 inobtcount=1 
nrext64=0
data     =                       bsize=4096   blocks=15728640, imaxpct=25
          =                       sunit=128    swidth=68352 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount /dev/md10 /mnt/tmp
-----------------------------------------------------------------------


I am testing via dd:
-----------------------------------------------------------------------
$ sudo dd if=/dev/zero of=/mnt/tmp/test.bin iflag=fullblock oflag=direct 
bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB, 10 GiB) copied, 100.664 s, 107 MB/s
-----------------------------------------------------------------------

I can monitor performance with dstat (the I/O reported at the start 
seems to be an artifact of dstat's monitoring).
-----------------------------------------------------------------------
$ dstat -dD sdg,sdh,sdi 2
--dsk/sdg-----dsk/sdh-----dsk/sdi--
  read  writ: read  writ: read  writ
   16G 5673M:  16G 5673M: 537M   21G  # <--not a real reading
    0     0 :   0     0 :   0     0
    0     0 :   0     0 :   0     0
    0    29M:   0    29M:   0    29M  # <--test starts here
    0   126M:   0   126M:   0   126M
    0   134M:   0   134M:   0   134M
    0   145M:   0   145M:   0   144M
   16k  137M:   0   137M:   0   138M
    0   152M:   0   152M:   0   152M
    0   140M:   0   140M:   0   140M
5632k  110M:5376k  110M:5376k  111M  # <--RMW begins here
   12M   49M:  12M   49M:  12M   49M
   14M   53M:  13M   54M:  13M   53M
   12M   50M:  12M   50M:  12M   50M
   12M   49M:  12M   50M:  12M   49M
   12M   50M:  12M   49M:  12M   49M
   13M   50M:  13M   51M:  12M   51M
   12M   50M:  12M   50M:  12M   50M
   12M   48M:  12M   48M:  12M   48M
   13M   53M:  13M   52M:  13M   53M
   13M   50M:  12M   50M:  13M   50M
   13M   52M:  13M   52M:  13M   52M
   12M   47M:  12M   46M:  12M   46M
   13M   52M:  13M   52M:  13M   52M
-----------------------------------------------------------------------
(I truncated the output--the rest looks the same)

Note how the I/O starts out fully as writes, but then continues with 
many reads. I am fairly sure this is RAID-5 read-modify-write due to 
misaligned writes.


The default chunk size is 512K
-----------------------------------------------------------------------
$ sudo mdadm --detail /dev/md10 | grep Chunk
         Chunk Size : 512K
$ sudo blkid -i /dev/md10
/dev/md10: MINIMUM_IO_SIZE="524288" OPTIMAL_IO_SIZE="279969792" 
PHYSICAL_SECTOR_SIZE="512" LOGICAL_SECTOR_SIZE="512"
-----------------------------------------------------------------------
I don't know why blkid is reporting such a large OPTIMAL_IO_SIZE. I 
would expect this to be 1024K (due to two data disks in a three-disk 
RAID-5).

Translating into 512-byte sectors, I think the topology should be:
chunk size (sunit): 1024 sectors
stripe size (swidth): 2048 sectors


I can see the write alignment with blktrace.
-----------------------------------------------------------------------
$ sudo blktrace -d /dev/md10 -o - | blkparse -i - | grep ' Q '
   9,10  15        1     0.000000000 186548  Q  WS 3829760 + 2048 [dd]
   9,10  15        3     0.021087119 186548  Q  WS 3831808 + 2048 [dd]
   9,10  15        5     0.023605705 186548  Q  WS 3833856 + 2048 [dd]
   9,10  15        7     0.026093572 186548  Q  WS 3835904 + 2048 [dd]
   9,10  15        9     0.028595887 186548  Q  WS 3837952 + 2048 [dd]
   9,10  15       11     0.031171221 186548  Q  WS 3840000 + 2048 [dd]
[...]
   9,10   5      441    14.601942400 186608  Q  WS 8082432 + 2048 [dd]
   9,10   5      443    14.620316654 186608  Q  WS 8084480 + 2048 [dd]
   9,10   5      445    14.646707430 186608  Q  WS 8086528 + 2048 [dd]
   9,10   5      447    14.654519976 186608  Q  WS 8088576 + 2048 [dd]
   9,10   5      449    14.680901605 186608  Q  WS 8090624 + 2048 [dd]
   9,10   5      451    14.689156421 186608  Q  WS 8092672 + 2048 [dd]
   9,10   5      453    14.706529362 186608  Q  WS 8094720 + 2048 [dd]
   9,10   5      455    14.732451407 186608  Q  WS 8096768 + 2048 [dd]
-----------------------------------------------------------------------
In the beginning, writes queued are stripe-aligned. For example:
3829760 / 2048 == 1870

Later on, writes end up getting misaligned by half a stripe. For example:
8082432 / 2048 == 3946.5

I tried manually specifying '-d sunit=1024,swidth=2048' for mkfs.xfs, 
but that had pretty much the same behavior when writing (the RMW starts 
later, but it still starts).


Am I doing something wrong, or is there a bug, or are my expectations 
incorrect? I had expected that large sequential writes would be aligned 
with swidth.

Thank you,
Corey
