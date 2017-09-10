Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50372 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750789AbdIJTnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Sep 2017 15:43:52 -0400
Date: Sun, 10 Sep 2017 21:43:51 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Testing dm-integrity (WAS: Re: Support for data CRC)
Message-ID: <20170910194350.v5fzbgrzihpjg2pv@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
 <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
 <20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
 <CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dm-devel@redhat.com
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>

On 2017-08-22 16:37:07 [-0600], Chris Murphy wrote:
> Documentation says either crc or hash is possible, including crc32.
> https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.txt
> > My idea was that if the "normal" path is faulty (and noticed by the crc
> > check) it (xfs or the dm layer) would try to read the data via an
> > alternative path if possible (say on RAID1/5/6).
> 
> Yes you have to build each layer you want separately with this method.

So I tried this:

dmsetup create test-raid1 --table '0 4194304 raid raid1 3 0 region_size 1024 2 - /dev/vdc - /dev/vdd'

# creating the target (size 1)
provided_data_sectors=1
table="0 $provided_data_sectors integrity /dev/mapper/test-raid1 4096 - D 1 internal_hash:crc32c"
dmsetup create dm-int --table "$table"
dmsetup remove /dev/mapper/dm-int

# hexdumped. is there a tool for that?
provided_data_sectors=4125208
table="0 $provided_data_sectors integrity /dev/mapper/test-raid1 4096 - D 1 internal_hash:crc32c"
dmsetup create dm-int --table "$table"

# without that cat, I get checksum errors errors
cat < /dev/zero > /dev/mapper/dm-int
#
mkfs.xfs /dev/mapper/dm-int
mount /dev/mapper/dm-int
echo asdfghjkl > /mnt/1234567890
umount /mnt/
dmsetup remove /dev/mapper/dm-int
dmsetup remove /dev/mapper/dm-raid1

#looking for data
hexdump -C /dev/vdc |grep asdfghjkl
 01226000  61 73 64 66 67 68 6a 6b  6c 0a 00 00 00 00 00 00  |asdfghjkl.......|

echo A > A
dd if=A of=/dev/vdc bs=1 seek=19030016 count=1
 1+0 records in
 1+0 records out
 1 byte copied, 0.00152606 s, 0.7 kB/s

#check
hexdump -C /dev/vdc |grep ^01226000
 01226000  41 62 64 66 67 68 6a 6b  6c 0a 00 00 00 00 00 00  |Abdfghjkl.......|

#and now
dmsetup create test-raid1 --table '0 4194304 raid raid1 3 0 region_size 1024 2 - /dev/vdc - /dev/vdd'
table="0 $provided_data_sectors integrity /dev/mapper/test-raid1 4096 - D 1 internal_hash:crc32c"
dmsetup create dm-int --table "$table"

mount /dev/mapper/dm-int /mnt
cat /mnt/1234567890 
 cat: /mnt/1234567890: Input/output error

# and the kernel says
dmesg
 md/raid1:mdX: active with 2 out of 2 mirrors
 device-mapper: integrity: Checksum failed at sector 0x48
 XFS (dm-1): Mounting V5 Filesystem
 XFS (dm-1): Ending clean mount
 device-mapper: integrity: Checksum failed at sector 0x48
 device-mapper: integrity: Checksum failed at sector 0x48

at some point I expected dm-integrity to check the other disk in RAID.
Isn't this possible or is my setup wrong at some point? If it is not
possible, could it be made possible?

Sebastian
