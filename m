Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43G1Wk0020062 for <xfs@oss.sgi.com>; Tue, 3 May 2011 11:01:32 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7538F4290B1
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 09:05:08 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id 8k0odv3gMPsIiJzg
	for <xfs@oss.sgi.com>; Tue, 03 May 2011 09:05:08 -0700 (PDT)
Received: by qwb7 with SMTP id 7so138627qwb.26
	for <xfs@oss.sgi.com>; Tue, 03 May 2011 09:05:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110503031856.GA9114@dastard>
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
	<20110503031856.GA9114@dastard>
Date: Tue, 3 May 2011 12:05:08 -0400
Message-ID: <BANLkTikNkErCS4q41ajTLa2yJnD8uehY-w@mail.gmail.com>
Subject: Re: XFS/Linux Sanity check
From: Paul Anderson <pha@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave, thanks for your feedback - comments below - possibly of interest
to others.

Several underlying assumptions strongly influence my choices that I've
made here.

Sequential I/O is of paramount importance - all else is nearly
insignificant (not entirely true, but a reasonable plan for the coming
year or two).

Highly I/O intensive work can/should be done locally to avoid
networking (NFS and 10 GigE just add more delays - later, research
could be done to saturate a 10GigE link in a variety of other ways,
but is of secondary concern to me today).

Compute intensive workloads will start looking more random because
we'll send those out to the grid and large numbers of incoming
requests makes the I/O stream less predictable.  Mind you, I envision
eliminating NFS or any other network filesystem in favor of straight
TCP/IP or even something like RoCE from Redhat.  With proper
buffering, even serving data like this can look sequential by and
large.

The team here favors large filesystems because from the user
perspective it is simply easier than having to juggle space among
distinct partitions.  The easy admninistrative solution of splitting
204TiB into say 7 mounted volumes really imposes a big barrier to how
work is organized, and further wastes storage.

I believe that typical working file sizes will exceed 100GiB within a
year or two - for example, one project is generating 250 sequencing
sample files each of which is 250 GiB in size, which we need to pull,
reprocess, and analyze.  This is fallout from the fact that there is a
very rapid drop in the cost of genome sequencing that is still
underway.

On Mon, May 2, 2011 at 11:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, May 02, 2011 at 11:47:48AM -0400, Paul Anderson wrote:
>> Our genetic sequencing research group is growing our file storage from
>> 1PB to 2PB.
> .....
>> We are deploying five Dell 810s, 192GiB RAM, 12 core, each with three
>> LSI 9200-8E SAS controllers, and three SuperMicro 847 45 drive bay
>> cabinets with enterprise grade 2TB drives.
>
> So roughly 250TB raw capacity per box.
>
>> We're running Ubuntu 10.04 LTS, and have tried either the stock kernel
>> (2.6.32-30) or 2.6.35 from linux.org.
>
> (OT: why do people install a desktop OS on their servers?)

Our end users want many GUI based apps running on the compute head
nodes, ergo we wind up installing most of the desktop anyway, so it is
just easier to install it and add whatever server related packages we
may need.  I'm not fond of that situation myself.

>
>> We organize the storage as one
>> software (MD) RAID 0 composed of 7 software RAID (MD) 6s, each with 18
>> drives, giving 204 TiB usable (9 drives of the 135 are unused).
>
> That's adventurous. I would serious consider rethinking this -
> hardware RAID-6 with controllers that have ia significant amount of
> BBWC is much more appropriate for this scale of storage. You get an
> unclean shutdown (e.g. power loss) and MD is going to take _weeks_
> to resync those RAID6 arrays. Background scrubbing is likely to
> never cease, either....

18 hours from start - remember the sync is proceeding at over
4GiBytes/sec (14.5 hours if exactly 4 GiBytes/second).

The big problem with my setup is lack of BBWC.  They are running in
JBOD mode, and I can disable per drive write cache and still maintain
decent performance across the array.

That said, there are few if any cases where we care about loss of
in-flight data - we care a great deal about static data that is
corrupted or lost due to metadata corruption, so this is still
probably an open issue (ideas welcome).

> Also, knowing how you spread out the disks in each RAID-6 group
> between controllers, trays, etc as that has important performance
> and failure implications.

You bet!

> e.g. I'm guessing that you are taking 6 drives from each enclosure
> for each 18-drive raid-6 group, which would split the RAID-6 group
> across all three SAS controllers and enclosures. That means if you
> lose a SAS controller or enclosure you lose all RAID-6 groups at
> once which is effectively catastrophic from a recovery point of view.
> It also means that one slow controller slows down everything so load
> balancing is difficult.

Each of the three enclosures has a pair of SAS expanders, and each LSI
9200-8e controller has two SAS cables, so I actually ordered the
RAID-6 drive sets as subsets of three, each from successive distinct
controller cards in a round robin fashion until you have a full set of
18 drives.

A wrinkle is that the SAS expanders have differing numbers of drives -
24 front, 21 rear (the other 3 on the rear are taken by the power
supplies).  So to finding a good match of RAID size versus available
channels and splitting I/O across those channels is a bit challenging.

> Large stripes might look like a good idea, buti when you get to this
> scale concatenation of high throughput LUNs provides better
> throughput because of less contention through the storage
> controllers and enclosures.

I don't disagree, but what I need to do is run a scripted test varying
stripe size, stripe units, chunk size (md parameter), etc - this gets
cumbersome with the 135 drives, as trying to get good balances across
the available resources is tedious and not automatic.

Basically, I found a combo (described immediately below) that works
pretty well, and started working on other problems than performance.
I have sufficient hardware to test other combinations, but time to run
them is an issue for me.  (ie set them up precisely right, babysit
them, wait for parity to build, then test - yes, I tested on various
subsets of the full 126 drive array, but getting those configs right
and then knowing you can extrapolate to the full size set is confusing
and hurts my poor little head)

>
>> XFS
>> is set up properly (as far as I know) with respect to stripe and chunk
>> sizes.
>
> Any details? You might be wrong ;)

Oh yes indeedy, I could be wrong!

Each of the 126 in use drives show something like this:

/dev/sdbc1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : f3c44896:ecdcadca:153ee6d1:1770781f
           Name : louie:5  (local to host louie)
  Creation Time : Fri Apr  8 15:01:16 2011
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 3907026856 (1863.02 GiB 2000.40 GB)
     Array Size : 62512429056 (29808.25 GiB 32006.36 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : adbd8716:94ebf4a2:ea753ee0:418b7bd8

    Update Time : Tue May  3 11:18:45 2011
       Checksum : 44d36ef7 - correct
         Events : 187

     Chunk Size : 64K

There are 7 RAID-6 arrays, each of which look like this:

/dev/md0:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : cbb4b32e:afc7126a:922e501d:9404011e
           Name : louie:8  (local to host louie)
  Creation Time : Fri Apr  8 15:02:20 2011
     Raid Level : raid0
   Raid Devices : 7

 Avail Dev Size : 62512429048 (29808.25 GiB 32006.36 GB)
  Used Dev Size : 0
    Data Offset : 8 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 94bfd084:138f8ca5:2938df2e:1ef0b76d

    Update Time : Fri Apr  8 15:02:20 2011
       Checksum : d733d87a - correct
         Events : 0

     Chunk Size : 1024K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6)
   Array State : Uuuuuuu

The seven RAID 6 devices are concatenated into a RAID 0:

/dev/md8:
        Version : 01.01
  Creation Time : Fri Apr  8 15:02:20 2011
     Raid Level : raid0
     Array Size : 218793494528 (208657.74 GiB 224044.54 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 8
    Persistence : Superblock is persistent

    Update Time : Fri Apr  8 15:02:20 2011
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 1024K

           Name : louie:8  (local to host louie)
           UUID : cbb4b32e:afc7126a:922e501d:9404011e
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       9        0        0      active sync   /dev/block/9:0
       1       9        1        1      active sync   /dev/block/9:1
       2       9        2        2      active sync   /dev/block/9:2
       3       9        3        3      active sync   /dev/block/9:3
       4       9        4        4      active sync   /dev/block/9:4
       5       9        5        5      active sync   /dev/block/9:5
       6       9        6        6      active sync   /dev/block/9:6

The xfs_info for the mounted volume is:

meta-data=3D/dev/md8               isize=3D256    agcount=3D204, agsize=3D2=
68435440 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D54698373632, ima=
xpct=3D1
         =3D                       sunit=3D16     swidth=3D256 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

The sunit/swidth parameters are chosen to exactly match the RAID-6
device, not the RAID-0.

Mount options are negligible, although I will be trying this:

UUID=3D0a675b55-d68a-41f2-8bb7-063e33123531 /exports        xfs
inode64,largeio,logbufs=3D8,noatime        0       2

All disk drives (almost a thousand here now) are Hitachi HUA72202 2TB
enterprise drives.  We did a failed experiment awhile back with
desktop drives... never again.

>
>> Allocation groups are 1TiB in size, which seems sane for the
>> size of files we expect to work with.
>
> Any filesystem over 16TB will use 1TB AGs.
>
>> In isolated testing, I see around 5GiBytes/second raw (135 parallel dd
>> reads), and with a benchmark test of 10 simultaneous 64GiByte dd
>> commands, I can see just shy of 2 GiBytes/second reading, and around
>> 1.4GiBytes/second writing through XFS. =A0 The benchmark is crude, but
>> fairly representative of our expected use.
>
> If you want insightful comments, then you'll need to provide
> intimate details of the tests your ran and the results (e.g. command
> lines, raw results, etc).

To test RAW read rates, I do this:

for i in  /dev/sd[b-z] /dev/sd[a-z][a-z] ; do dd if=3D$i of=3D/dev/null
bs=3D1024k & done

killall dd gets rid of them.  I use "dstat 1" to check what the kernel
thinks is happening.

For filesystems test (configured and mounted as I described above with
the mdadm commands and xfs_info), I do this:

for load in 0 1 2 3 4 5 6 7 8 9 ; do
        dd if=3D/dev/zero of=3D/exports/load_$load$step bs=3D1024k count=3D=
32768 &
done

Later to test read, I do:

for load in 0 1 2 3 4 5 6 7 8 9 ; do
        dd of=3D/dev/null if=3D/exports/load_$load bs=3D1024 &
done

In both cases, I watch I/O rates after the buffers overflow - with
192GB of RAM, this takes a few seconds.

For giggles, I've allowed the read commands to cache 20-100GB in RAM,
then rerun the read test to see what a cached read rate looks like -
interestingly, the aggregate dd reported I/O rate in that case is
around 5GiBytes/second, indicating that is approaching something of an
upper limit for this particular chassis.

I am fully aware that this is a simplified test.  I'm also quite
familiar with the workload, and know this is a reasonable facsimile of
what we do.

Better real world benchmarking for us now comprises of end user jobs -
day long jobs on a single sequencing run using a bunch of home grown
software.


>
>> md apparently does not support barriers, so we are badly exposed in
>> that manner, I know. =A0As a test, I disabled write cache on all drives,
>> performance dropped by 30% or so, but since md is apparently the
>> problem, barriers still didn't work.
>
> Doesn't matter if you have BBWC on your hardware RAID
> controllers. Seriously, if you want to sustain high throughput, you
> want a large amount of BBWC in front your disks....

Here we talk performance expectations and goals - from my testing so
far, I can reasonably say I'm happy with the performance of the
software RAID with XFS running on top of that.  What I need now are
stability and robustness in the face of crashes.

I'm still perfectly willing to buy good HW RAID cards, don't get me
wrong, but their main benefit to me will be the battery backed cache,
not the performance.

Keep in mind that it is hard to balance a HW RAID card across multiple
SAS expanders - you can certainly get a -16e card of some sort, but
then it does ALL of the I/O to those 4 expanders ALL of the time.  I'm
not sure that is a win, either.  Cheaper cards, one per expander might
work, though (but with six 8x slots available, probably a HW RAID card
with 8e would be the best - run two expanders per card as I do now).

>
>> Nonetheless, what we need, but don't have, is stability.
>>
>> With 2.6.32-30, we get reliable kernel panics after 2 days of
>> sustained rsync to the machine (around 150-250MiBytes/second for the
>> entire time - the source machines are slow),
>
> Stack traces from the crash?

Mostly a non-responsive console and kgdb was not set up at the time -
I am trying to get this set up now.   Here's the one stack trace I
wrote down from the console (again from a 2.6.32-30 kernel):

RSP 0018:ffff880dcce39e48
E FLAGS 287

_spin_lock+0xe/0x20
futex_wake+0x7d/0x130
handle_nm_fault+0x1a8/0x3c0
do_futex+0x68/0x1b0
sys_futex+0x7b/0x170
do_page_fault+0x158/0x3b0
system_call_fastpath+0x16/0x1b

All other info lost - other crashes result in a locked console that
we've not been able to revive.

The load on the system at the time of the crash was simply 3-4 rsync's
copying data via 'ssh -c arcfour' over to the XFS filesystem
(basically loading up the test server with user data for further
testing).  Sustained I/O rates were moderate - 200-400MiBytes/second.
No swap, CPU load of significance or user jobs.

Obviously, this is an old kernel and of less interest, but nonetheless
answers your question.

>
>> and with 2.6.35, we get a
>> bad resource contention problem fairly quickly - much less than 24
>> hours (in this instance, we start getting XFS kernel thread timeouts
>> similar to what I've seen posted here recently, but it isn't clear
>> whether it is only XFS or also ext3 boot drives that are starved for
>> I/O - suspending or killing all I/O load doesn't solve the problem -
>> only a reboot does).
>
> Details of the timeout messages?

Here are some typical ones from yesterday when I was trying to run the
sync command on a relatively lightly loaded 2.6.35 machine (sustained
100MiByte/second copies onto the server in question):

178602.197456] INFO: task sync:2787 blocked for more than 120 seconds.
[178602.203933] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[178602.211863] sync          D 0000000000000000     0  2787   2691 0x00000=
000
[178602.211867]  ffff880d2dc51cd8 0000000000000086 ffff880d2dc51cc8
0000000000015880
[178602.211870]  ffff880d2dc51fd8 0000000000015880 ffff880d2dc51fd8
ffff8817fb725d40
[178602.211872]  0000000000015880 0000000000015880 ffff880d2dc51fd8
0000000000015880
[178602.211875] Call Trace:
[178602.211887]  [<ffffffff81050641>] ? select_task_rq_fair+0x561/0x8e0
[178602.211893]  [<ffffffff8156436d>] schedule_timeout+0x22d/0x310
[178602.211896]  [<ffffffff8104af33>] ? enqueue_task_fair+0x43/0x90
[178602.211898]  [<ffffffff8104e609>] ? enqueue_task+0x79/0x90
[178602.211900]  [<ffffffff81563606>] wait_for_common+0xd6/0x180
[178602.211904]  [<ffffffff81053310>] ? default_wake_function+0x0/0x20
[178602.211910]  [<ffffffff81167570>] ? sync_one_sb+0x0/0x30
[178602.211912]  [<ffffffff8156378d>] wait_for_completion+0x1d/0x20
[178602.211915]  [<ffffffff81162b19>] sync_inodes_sb+0x89/0x180
[178602.211955]  [<ffffffffa032c0f1>] ? xfs_quiesce_data+0x71/0xc0 [xfs]
[178602.211958]  [<ffffffff81167570>] ? sync_one_sb+0x0/0x30
[178602.211960]  [<ffffffff81167558>] __sync_filesystem+0x88/0xa0
[178602.211962]  [<ffffffff81167590>] sync_one_sb+0x20/0x30
[178602.211966]  [<ffffffff81142afb>] iterate_supers+0x8b/0xd0
[178602.211968]  [<ffffffff811675e5>] sys_sync+0x45/0x70
[178602.211973]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b


>
>> Ideally, I'd firstly be able to find informed opinions about how I can
>> improve this arrangement - we are mildly flexible on RAID controllers,
>> very flexible on versions of Linux, etc, and can try other OS's as a
>> last resort (but the leading contender here would be "something"
>> running ZFS, and though I love ZFS, it really didn't seem to work well
>> for our needs).
>>
>> Secondly, I welcome suggestions about which version of the linux
>> kernel you'd prefer to hear bug reports about, as well as what kinds
>> of output is most useful (we're getting all chassis set up with serial
>> console so we can do kgdb and also full kernel panic output results).
>
> If you want to stay on mainline kernels with best-effort community
> support, I'd suggest 2.6.38 or more recent kernels are the only ones
> we're going to debug. If you want fixes, then running the curent -rc
> kernels is probably a good idea. It's unlikely you'll get anyone
> backporting fixes for you to older kernels.

I will be doing that today.  We can backport if it were crucial to do
so, but I'm not aware of any local reasons why this would be so.

>
> Alternatively, you can switch to something like RHEL (or SLES) where
> XFS is fully supported (and in the RHEL case, pays my bills :). The
> advantage of this is that once the bug is fixed in mainline, it will
> get backported to the supported kernel you are running.

We're buying a RHEL support license today - hooray!

My rationale for doing that is that I'm not convinced I will be seeing
just XFS issues in the kernel - the stack trace I reported is more
generic than XFS...

Paul

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
