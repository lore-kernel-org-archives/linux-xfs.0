Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30196 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753220AbeC1W16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 18:27:58 -0400
Date: Thu, 29 Mar 2018 09:27:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180328222754.GC18129@dastard>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180322230450.GT1150@dastard>
 <20180328151959.GA6247@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328151959.GA6247@onthe.net.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Dunlop <chris@onthe.net.au>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 29, 2018 at 02:20:00AM +1100, Chris Dunlop wrote:
> On Fri, Mar 23, 2018 at 10:04:50AM +1100, Dave Chinner wrote:
> >On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
> >>On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
> >>>Eyeballing the corrupted blocks and matching good blocks doesn't show
> >>>any obvious pattern. The files themselves contain compressed data so
> >>>it's all highly random at the block level, and the corruptions
> >>>themselves similarly look like random bytes.
> >>>
> >>>The corrupt blocks are not a copy of other data in the file within the
> >>>surrounding 256k of the corrupt block.
> 
> >>>XFS on LVM on 6 x PVs, each PV is md raid-6, each with 11 x hdd.
> >
> >Are these all on the one raid controller? i.e. what's the physical
> >layout of all these disks?
> 
> Yep, one controller. Physical layout:
> 
> c0 LSI 9211-8i (SAS2008)
> |
> + SAS expander w/ SATA HDD x 12
> |   + SAS expander w/ SATA HDD x 24
> |       + SAS expander w/ SATA HDD x 24
> |
> + SAS expander w/ SATA HDD x 24
>     + SAS expander w/ SATA HDD x 24

Ok, that's good to know. I've seen misdirected writes in a past life
because a controller had a firmware bug when it hit it's maximum CTQ
depth of 2048 (controller max, not per-lun max) and the 2049th
queued write got written to a random lun on the controller. That
causes random, unpredicatble data corruptions in a similar manner to
what you are seeing.

So don't rule out a hardware problem yet.

> >Basically, the only steps now are a methodical, layer by layer
> >checking of the IO path to isolate where the corruption is being
> >introduced. First you need a somewhat reliable reproducer that can
> >be used for debugging.
> 
> The "reliable reproducer" at this point seems to be to simply let
> the box keep doing it's thing - at least being able to detect the
> problem and having the luxury of being able to repair the damage or
> re-get files from remote means we're not looking at irretrievable
> data loss.

Yup, same as what I saw in the past - check if it's controller load
related.

> But I'll take a look at that checkstream stuff you've mentioned to
> see if I can get a more methodical reproducer.

genstream/checkstream was what we used back then :P

> >Write patterned files (e.g. encode a file id, file offset and 16 bit
> >cksum in every 8 byte chunk) and then verify them. When you get a
> >corruption, the corrupted data will tell you where the corruption
> >came from. It'll either be silent bit flips, some other files' data,
> >or it will be stale data.i See if the corruption pattern is
> >consistent. See if the locations correlate to a single disk, a
> >single raid controller, a single backplane, etc. i.e. try to find
> >some pattern to the corruption.
> 
> Generating an md5 checksum for every 256b block in each of the
> corrupted files reveals that, a significant proportion of the time
> (16 out of 23 corruptions, in 20 files), the corrupt 256b block is
> apparently a copy of a block from a whole number of 4KB blocks prior
> in the file (the "source" block). In fact, 14 of those source blocks
> are a whole number of 128KB blocks prior to corrupt block, and 11 of
> the 16 source blocks are a whole number of 1MB blocks prior to the
> corrupt blocks.
> 
> As previously noted by Brian, all the corruptions are the last 256b
> in a 4KB block (but not the last 256b in the first 4KB block of an
> 8KB block as I later erronously claimed). That also means that all
> the "source" blocks are also the last 256b in a 4KB block.
> 
> Those nice round numbers are seem highly suspicious, but I don't
> know what they might be telling me.
> In table form, with 'source' being the 256b offset to the apparent
> source block, i.e. the block with the same contents in the same file
> as the corrupt block (or '-' where the source block wasn't found),
> 'corrupt' being the 256b offset to the corrupt block, and the
> remaining columns showing the whole number of 4KB, 128KB or 1MB
> blocks between the 'source' and 'corrupt' blocks (or n/w where it's
> not a whole number):
> 
> file       source    corrupt    4KB  128KB   1MB
> ------   --------   -------- ------  -----  ----
> file01    4222991    4243471   1280     40     5
> file01   57753615   57794575   2560     80    10
> file02          -   18018367      -      -     -
> file03     249359     310799   3840    120    15
> file04    6208015    6267919   3744    117   n/w
> file05  226989503  227067839   4896    153   n/w
> file06          -   22609935      -      -     -
> file07   10151439   10212879   3840    120    15
> file08   16097295   16179215   5120    160    20
> file08   20273167   20355087   5120    160    20
> file09          -    1676815      -      -     -
> file10          -   82352143      -      -     -
> file11   69171215   69212175   2560     80    10
> file12    4716671    4919311  12665    n/w   n/w
> file13  165115871  165136351   1280     40     5
> file14    1338895    1400335   3840    120    15
> file15          -  107812863      -      -     -
> file16          -    3516271      -      -     -
> file17   11499535   11520527   1312     41   n/w
> file17          -   11842175      -      -     -
> file18     815119     876559   3840    120    15
> file19   45234191   45314111   4995    n/w   n/w
> file20   51324943   51365903   2560     80    10

that recurrent 1280/40/5 factoring is highly suspicious. Also, the
distance between the source and the corruption location:

file01 20480		= 2^14 + 2^12
file01 40960		= 2^15 + 2^13
file03 61440		= 2^16 + 2^14 + 2^13 + 2^12
file04 59904		= 2^16 + 2^14 + 2^13 + 2^11 + 2^9
file05 78336
file07 61440
file08 81920
file08 81920
file11 40960
file12 202640
file13 20480
file14 61440
file17 20992
file18 61440
file19 79920
file20 40960


Such a round number for the offset to be wrong by makes me wonder.
These all have the smell of LBA bit errors (i.e. misdirected writes)
but the partial sector overwrite has me a bit baffled. The bit
pattern points at hardware, but the partial sector overwrite
shouldn't ever occur at the hardware level.

This bit offset pattern smells of a hardware problem at the
controller level, but I'm not yet convinced that it is. We still
need to rule out filesystem level issues.

[...]

> md to disks, with corruption counts after the colons:
> 
> md0:5 : sdbg:1 sdbh   sdcd sdcc:2  sds:1  sdh   sdbj    sdy    sdt  sdr  sdd:1
> md1   :  sdc    sdj    sdg  sdi    sdo    sdx   sdax   sdaz   sdba sdbb  sdn
> md3   : sdby   sdbl   sdbo sdbz   sdbp   sdbq   sdbs   sdbt   sdbr sdbi sdbx
> md4:10: sdbn   sdbm:1 sdbv sdbc:1 sdbu   sdbf:2 sdbd:4  sde:2  sdk  sdw  sdf
> md5:5 : sdce:2 sdaq   sdar sdas   sdat   sdau   sdav:1 sdao   sdcx sdcn sdaw:2
> md9:3 : sdcg   sdcj:2 sdck sdcl   sdcm   sdco   sdcp:1 sdcq   sdcr sdcs sdcv
> 
> Physical layout of disks with corruptions:
> 
> /sys/devices/pci0000:00/0000:00:05.0/0000:03:00.0/host0/...
>  port-0:0/exp-0:0/port-0:0:0/exp-0:1/port-0:1:23/sdav
>  port-0:0/exp-0:0/port-0:0:4/sde
>  port-0:0/exp-0:0/port-0:0:5/sdd
>  port-0:0/exp-0:0/port-0:0:19/sds
>  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:0/exp-0:4/port-0:4:3/sdcj
>  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:0/exp-0:4/port-0:4:9/sdcp
>  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:5/sdbm
>  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:21/sdcc
>  port-0:1/exp-0:2/port-0:2:0/exp-0:3/port-0:3:23/sdce
>  port-0:1/exp-0:2/port-0:2:1/sdaw
>  port-0:1/exp-0:2/port-0:2:7/sdbc
>  port-0:1/exp-0:2/port-0:2:8/sdbd
>  port-0:1/exp-0:2/port-0:2:10/sdbf
>  port-0:1/exp-0:2/port-0:2:11/sdbg
> 
> I.e. corrupt blocks appear on disks attached to every expander in
> the system.

Ok, thank you for digging deep enough to demonstrate the corruption
spread. It certainly helps on my end to know it's spread across
several disks and expanders and isn't obviously a single bad
disk, cable or expander. It doesn't rule out the controller as the
problem, though.

> Whilst that hardware side of things is interesting, and that md4
> could bear some more investigation, as previously suggested, and now
> with more evidence (older files checked clean), it's looking like
> this issue really started with the upgrade from v3.18.25 to v4.9.76
> on 2018-01-15. I.e. less likely to be hardware related - unless the
> new kernel is stressing the hardware in new exciting ways.

Right, that's entirely possible the new kernel is doing something
the old kernel didn't, like loading it up with more concurrent IO
across more disks. Do you have the latest firmware on the
controller?

The next steps are to validate the data is getting through each
layer of the OS intact. This really needs a more predictable test
case - can you reproduce and detect this corruption using
genstream/checkstream?

If so, the first step is to move to direct IO to rule out a page
cache related data corruption. If direct IO still shows the
corruption, we need to rule out things like file extension and
zeroing causing issues. e.g. preallocate the entire files, then
write via direct IO. If that still generates corruption then we need
to add code into the bottom of the filesystem IO path to validate
the data being sent by the filesystem is not corrupt.

If we get that far with correct write data, but still get
corruptions on read, it's not a filesystem created data corruption.
Let's see if we can get to that point first...

> I'm also wondering whether I should just try v4.14.latest, and see
> if the problem goes away (there's always hope!). But that would
> leave a lingering bad taste that maybe there's something not quite
> right in v4.9.whatever land. Not everyone has checksums that can
> tell them their data is going just /slightly/ out of whack...

Yeah, though if there was a general problem I'd have expected to
hear about it from several sources by now. What you are doing is not
a one-off sort of workload....

> Amazing stuff on that COW work for XFS by the way - new tricks for
> old dogs indeed!

Thank Darrick for all the COW work, not me :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
