Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:59147 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753529AbeC1PUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 11:20:02 -0400
Date: Thu, 29 Mar 2018 02:20:00 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180328151959.GA6247@onthe.net.au>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180322230450.GT1150@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180322230450.GT1150@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Mar 23, 2018 at 10:04:50AM +1100, Dave Chinner wrote:
> On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
>> On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
>>> Eyeballing the corrupted blocks and matching good blocks doesn't show
>>> any obvious pattern. The files themselves contain compressed data so
>>> it's all highly random at the block level, and the corruptions
>>> themselves similarly look like random bytes.
>>>
>>> The corrupt blocks are not a copy of other data in the file within the
>>> surrounding 256k of the corrupt block.

>>> XFS on LVM on 6 x PVs, each PV is md raid-6, each with 11 x hdd.
>
> Are these all on the one raid controller? i.e. what's the physical
> layout of all these disks?

Yep, one controller. Physical layout:

c0 LSI 9211-8i (SAS2008)
 |
 + SAS expander w/ SATA HDD x 12
 |   + SAS expander w/ SATA HDD x 24
 |       + SAS expander w/ SATA HDD x 24
 |
 + SAS expander w/ SATA HDD x 24
     + SAS expander w/ SATA HDD x 24

>> OTOH, a 256b corruption seems quite unusual for a filesystem with 4k
>> blocks. I suppose that could suggest some kind of memory/cache
>> corruption as opposed to a bad page/extent state or something of that
>> nature.
>
> Especially with the data write mechanisms being used - e.g. NFS
> won't be doing partial sector reads and writes for data transfer -
> it'll all be done in blocks much larger that the filesystem block
> size (e.g. 1MB IOs).

Yep, that's one of the reasons 256b corruptions is so odd.

> Basically, the only steps now are a methodical, layer by layer
> checking of the IO path to isolate where the corruption is being
> introduced. First you need a somewhat reliable reproducer that can
> be used for debugging.

The "reliable reproducer" at this point seems to be to simply let the 
box keep doing it's thing - at least being able to detect the problem 
and having the luxury of being able to repair the damage or re-get files 
from remote means we're not looking at irretrievable data loss.

But I'll take a look at that checkstream stuff you've mentioned to see 
if I can get a more methodical reproducer.

> Write patterned files (e.g. encode a file id, file offset and 16 bit
> cksum in every 8 byte chunk) and then verify them. When you get a
> corruption, the corrupted data will tell you where the corruption
> came from. It'll either be silent bit flips, some other files' data,
> or it will be stale data.i See if the corruption pattern is
> consistent. See if the locations correlate to a single disk, a
> single raid controller, a single backplane, etc. i.e. try to find
> some pattern to the corruption.

Generating an md5 checksum for every 256b block in each of the corrupted 
files reveals that, a significant proportion of the time (16 out of 23 
corruptions, in 20 files), the corrupt 256b block is apparently a copy 
of a block from a whole number of 4KB blocks prior in the file (the 
"source" block). In fact, 14 of those source blocks are a whole number 
of 128KB blocks prior to corrupt block, and 11 of the 16 source blocks 
are a whole number of 1MB blocks prior to the corrupt blocks.

As previously noted by Brian, all the corruptions are the last 256b in a 
4KB block (but not the last 256b in the first 4KB block of an 8KB block 
as I later erronously claimed). That also means that all the "source" 
blocks are also the last 256b in a 4KB block.

Those nice round numbers are seem highly suspicious, but I don't know 
what they might be telling me.

In table form, with 'source' being the 256b offset to the apparent 
source block, i.e. the block with the same contents in the same file as 
the corrupt block (or '-' where the source block wasn't found), 
'corrupt' being the 256b offset to the corrupt block, and the remaining 
columns showing the whole number of 4KB, 128KB or 1MB blocks between the 
'source' and 'corrupt' blocks (or n/w where it's not a whole number):

file       source    corrupt    4KB  128KB   1MB
------   --------   -------- ------  -----  ----
file01    4222991    4243471   1280     40     5
file01   57753615   57794575   2560     80    10
file02          -   18018367      -      -     -
file03     249359     310799   3840    120    15
file04    6208015    6267919   3744    117   n/w
file05  226989503  227067839   4896    153   n/w
file06          -   22609935      -      -     -
file07   10151439   10212879   3840    120    15
file08   16097295   16179215   5120    160    20
file08   20273167   20355087   5120    160    20
file09          -    1676815      -      -     -
file10          -   82352143      -      -     -
file11   69171215   69212175   2560     80    10
file12    4716671    4919311  12665    n/w   n/w
file13  165115871  165136351   1280     40     5
file14    1338895    1400335   3840    120    15
file15          -  107812863      -      -     -
file16          -    3516271      -      -     -
file17   11499535   11520527   1312     41   n/w
file17          -   11842175      -      -     -
file18     815119     876559   3840    120    15
file19   45234191   45314111   4995    n/w   n/w
file20   51324943   51365903   2560     80    10

Corruption counts per AG:

      1 10
      1 15
      1 31
      1 52
      1 54
      1 74
      1 82
      1 83
      1 115
      1 116
      1 134
      1 168
      1 174
      1 187
      1 188
      1 190
      2 37
      2 93
      3 80

Corruption counts per md:

      0 /dev/md1
      0 /dev/md3
      3 /dev/md9
      5 /dev/md0
      5 /dev/md5
     10 /dev/md4

I don't know what's going on with md4 - maybe it's just that it has more 
free space so that's where files tend to get written so that's where the 
corruptions tend to show up? And similarly md1 and md3 may have almost 
no free space so they're not receiving files so not showing corruptions.

But I'm guessing about that free space, I don't know how to work out how 
much free space there is on a particular md (as part of an LV). Any 
hints, e.g. look at something in the AGs then somehow work out which AGs 
are landing on which mds?

Corruption counts per disk:

      1 md5:sdav
      1 md4:sdbc
      1 md0:sdbg
      1 md4:sdbm
      1 md9:sdcp
      1 md0:sdd 
      1 md0:sds 
      2 md5:sdaw
      2 md4:sdbf
      2 md0:sdcc
      2 md5:sdce
      2 md9:sdcj
      2 md4:sde 
      4 md4:sdbd

At first glance that looks like a random distribution. Although, with 66 
disks in total under the fs, that sdbd is a *bit* suspicious.

md to disks, with corruption counts after the colons:

md0:5 : sdbg:1 sdbh   sdcd sdcc:2  sds:1  sdh   sdbj    sdy    sdt  sdr  sdd:1
md1   :  sdc    sdj    sdg  sdi    sdo    sdx   sdax   sdaz   sdba sdbb  sdn
md3   : sdby   sdbl   sdbo sdbz   sdbp   sdbq   sdbs   sdbt   sdbr sdbi sdbx
md4:10: sdbn   sdbm:1 sdbv sdbc:1 sdbu   sdbf:2 sdbd:4  sde:2  sdk  sdw  sdf
md5:5 : sdce:2 sdaq   sdar sdas   sdat   sdau   sdav:1 sdao   sdcx sdcn sdaw:2
md9:3 : sdcg   sdcj:2 sdck sdcl   sdcm   sdco   sdcp:1 sdcq   sdcr sdcs sdcv

Physical layout of disks with corruptions:

/sys/devices/pci0000:00/0000:00:05.0/0000:03:00.0/host0/...
  port-0:0/exp-0:0/port-0:0:0/exp-0:1/port-0:1:23/sdav
  port-0:0/exp-0:0/port-0:0:4/sde
  port-0:0/exp-0:0/port-0:0:5/sdd
  port-0:0/exp-0:0/port-0:0:19/sds
  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:0/exp-0:4/port-0:4:3/sdcj
  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:0/exp-0:4/port-0:4:9/sdcp
  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:5/sdbm
  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:21/sdcc
  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:23/sdce
  port-0:1/exp-0:2/port-0:2:1/sdaw
  port-0:1/exp-0:2/port-0:2:7/sdbc
  port-0:1/exp-0:2/port-0:2:8/sdbd
  port-0:1/exp-0:2/port-0:2:10/sdbf
  port-0:1/exp-0:2/port-0:2:11/sdbg

I.e. corrupt blocks appear on disks attached to every expander in the 
system.

Whilst that hardware side of things is interesting, and that md4 could 
bear some more investigation, as previously suggested, and now with more 
evidence (older files checked clean), it's looking like this issue 
really started with the upgrade from v3.18.25 to v4.9.76 on 2018-01-15. 
I.e. less likely to be hardware related - unless the new kernel is 
stressing the hardware in new exciting ways.

I'm also wondering whether I should just try v4.14.latest, and see if 
the problem goes away (there's always hope!). But that would leave a 
lingering bad taste that maybe there's something not quite right in 
v4.9.whatever land. Not everyone has checksums that can tell them their 
data is going just /slightly/ out of whack...

> Unfortunately, I can't find the repository for the data checking
> tools that were developed years ago for doing exactly this sort of
> testing (genstream+checkstream) online anymore - they seem to
> have disappeared from the internet. (*) Shouldn't be too hard to
> write a quick tool to do this, though.
>
> Also worth testing is whether the same corruption occurs when you
> use direct IO to write and read the files. That would rule out a
> large chunk of the filesystem and OS code as the cause of the
> corruption.

Looks like the checkstream stuff can do O_DIRECT.

>>> The file is moved to "badfile", and the file regenerated from source
>>> data as "goodfile".
>
> What does "regenerated from source" mean?
>
> DOes that mean a new file is created, compressed and then copied
> across? Or is it just the original file being copied again?

New file recreated from source data using the same method used to create 
the original (now corrupt) file.

>>> Comparing our corrupt sector lv offset with the start sector of each md
>>> device, we can see the corrupt sector is within /dev/md9 and not at a
>>> boundary. The corrupt sector offset within the lv data on md9 is given
>>> by:
>
> Does, the problem always occur on /dev/md9?
>
> If so, does the location correlate to a single disk in /dev/md9?

No, per above, corruptions occur in various mds (and various disks 
within mds), and the disks are attached to differing points in the 
physical hierarchy.

> Cheers,
> 
> Dave.


Amazing stuff on that COW work for XFS by the way - new tricks for old 
dogs indeed!


Cheers,

Chris
