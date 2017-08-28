Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33178 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdH1SJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <20170828175229.GF4757@magnolia>
References: <CAOQ4uxg7FJ6sLRuRcV_AYRx_crZyVzVMzPgkZb8msLxtZvL12A@mail.gmail.com>
 <CAOQ4uxj4LRj=B8aHwPTGWkOmg9b-W6bJb7U9V76z4dMV3c4MOA@mail.gmail.com> <20170828175229.GF4757@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 Aug 2017 21:09:36 +0300
Message-ID: <CAOQ4uxi-oVGCtg9jSF31SE8-T_Pdw4GpkO7ox_65FzZLKqv-KQ@mail.gmail.com>
Subject: Re: XFS bug discovered by crash tests?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Josef Bacik <jbacik@fb.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Aug 28, 2017 at 8:52 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Aug 28, 2017 at 11:36:38AM +0300, Amir Goldstein wrote:
>> On Mon, Aug 28, 2017 at 11:33 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > Christoph, Darrick,
>> >
>> > As I reported last week, I started running Josef's log-writes crash
>> > tests and immediately got reports on data checksum errors when
>> > running the tests on xfs.
>> >
>> > Unlike ext4 and btrfs, xfs tests seemed to fail arbitrarily for any
>> > value of random seed I tried. Unlike xfs, I never observed data
>> > checksum errors on ext4 and btrfs (only fsck errors).
>> >
>> > It's quite easy to reproduce the reported checksum errors when
>> > running the test currently on my xfstests branch:
>> > https://github.com/amir73il/xfstests/commits/dm-log-writes
>> >
>> > Looking closer at the reported checksum errors, in all cases
>> > I examined, the problem was, that after a sequence of
>> > PUNCH_HOLE+FSYNC on a test file, a partially zeroed block,
>> > both at beginning and end of zero range is not zeroed after
>> > crash.
>> >
>> > For example, the following file does not have zeroes after crash
>> > at end of logical block #11:
>>
>> Block #10 that is... #11 is unmapped.
>>
>> >
>> > ---------------------
>> > Filesystem type is: 58465342
>> > File size of /mnt/scratch/testfile2 is 248338 (61 blocks of 4096 bytes)
>> >  ext:     logical_offset:        physical_offset: length:   expected: flags:
>> >    0:        1..       3:         33..        35:      3:             unwritten
>> >    1:       10..      10:         93..        93:      1:         36:
>> >    2:       20..      23:        147..       150:      4:         94: unwritten
>> >    3:       24..      31:        158..       165:      8:        151: unwritten
>> >    4:       34..      34:        146..       146:      1:        166: unwritten
>> >    5:       35..      38:        151..       154:      4:        147: unwritten
>> >    6:       41..      44:        167..       170:      4:        155: unwritten
>> >    7:       46..      46:        166..       166:      1:        171:
>> >    8:       47..      50:         89..        92:      4:        167:
>> >    9:       51..      60:        171..       180:     10:         93: last,eof
>> > /mnt/scratch/testfile2: 10 extents found
>> >
>> > /mnt/scratch/testfile2 (bad):
>> > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 000a510 5858 5858 5858 5858 5858 5858 5858 5858
>> > *
>> > 000b000 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 002e280 0000 0000 0000 0000 0000 0000 5858 5858
>> > 002e290 5858 5858 5858 5858 5858 5858 5858 5858
>> > *
>> > 0038720 5858 5858 0000 0000 0000 0000 0000 0000
>> > 0038730 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 003ca12
>> > ------------------
>> >
>> > However, this crash checkpoint (testfile2.mark1) was taken
>> > after punch+fsync that should have zeroed the end of block #11
>> > (0xa988..000b000):
>> > -------------------
>> > ...
>> > 2: 16 punch     from 0xa988 to 0xf126, (0x479e bytes)
>> > 2: 17 read      0x12420 thru    0x1aa08 (0x85e9 bytes)
>> > 2: 18 write     0x30d11 thru    0x3a723 (0x9a13 bytes)
>> > 2: 19 punch     from 0x27988 to 0x2aaed, (0x3165 bytes)
>> > 2: 20 write     0x2d6ff thru    0x369f3 (0x92f5 bytes)
>> > 2: 21 zero      from 0x22882 to 0x22e14, (0x592 bytes)
>> > 2: 22 zero      from 0x14655 to 0x1e636, (0x9fe1 bytes)
>> > 2: 23 zero      from 0x17c91 to 0x1fb75, (0x7ee4 bytes)
>> > 2: 24 punch     from 0x273eb to 0x3028c, (0x8ea1 bytes)
>> > 2: 25 zero      from 0x29eb2 to 0x2c692, (0x27e0 bytes)
>> > 2: 26 zero      from 0x11ac to 0x3910, (0x2764 bytes)
>> > 2: truncating to largest ever: 0x3ea12
>> > 2: 27 trunc     from 0x3a724 to 0x3ea12
>> > 2: 28 collapse  from 0x2d000 to 0x2f000, (0x2000 bytes)
>> > 2: 29 falloc    from 0x22cf2 to 0x2733b (0x4649 bytes)
>> > 2: 30 mapread   0x3466a thru    0x3ca11 (0x83a8 bytes)
>> > 2: 31 fsync
>> > 2: Dumped fsync buffer to testfile2.mark1
>> >
>> > /mnt/test/fsxtests/testfile2.mark1 (good):
>> > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 000a510 5858 5858 5858 5858 5858 5858 5858 5858
>> > *
>> > 000a980 5858 5858 5858 5858 0000 0000 0000 0000
>> > 000a990 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 002e280 0000 0000 0000 0000 0000 0000 5858 5858
>> > 002e290 5858 5858 5858 5858 5858 5858 5858 5858
>> > *
>> > 0038720 5858 5858 0000 0000 0000 0000 0000 0000
>> > 0038730 0000 0000 0000 0000 0000 0000 0000 0000
>> > *
>> > 003ca12
>> >
>> > --------------------------
>> >
>> > Anyway, I went to look at xfs_zero_range() and while I admit
>> > it was hard for me to follow down all the actors into block
>> > layer, I couldn't find where partial zeroed page is marked dirty.
>> >
>> > Can you please have a look and say what you make of this?
>
> <shrug> /me would have thought the page gets dirty via:
>
> xfs_zero_range -> iomap_zero_range -> iomap_zero_range_actor ->
> iomap_zero -> iomap_write_end -> generic_write_end -> block_write_end ->
> __block_commit_write -> mark_buffer_dirty -> __set_page_dirty
>
> But maybe that doesn't happen?
>

Yap, that looks right. Will try to come up with a less random reproducer.
Any ideas where to look would be welcome.

Thanks,
Amir.
