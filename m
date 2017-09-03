Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752827AbdICDcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 23:32:22 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Date: Sun, 3 Sep 2017 03:31:55 +0000
Message-ID: <48FAC1A6-43D6-4A14-AC68-42CE80F2AE0A@fb.com>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
 <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
 <20170901225539.GC10621@dastard>
 <67F62657-D116-4B85-9452-5BAB52EC7041@fb.com>
 <20170902115545.GA36492@bfoster.bfoster>
 <E62CB1B9-AB21-4880-A9CF-88297C4051B8@fb.com>
In-Reply-To: <E62CB1B9-AB21-4880-A9CF-88297C4051B8@fb.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C7F688272BF23942ADD5100A58A0CBCD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Quick correction, should be >100k hours on the RT code, not > 1M (maths is =
hard); we=B9ll get to 1M soon, but not there yet ;) .

Richard


On 9/2/17, 5:44 PM, "linux-xfs-owner@vger.kernel.org on behalf of Richard W=
areing" <linux-xfs-owner@vger.kernel.org on behalf of rwareing@fb.com> wrot=
e:

   =20
   =20
    On 9/2/17, 4:55 AM, "Brian Foster" <bfoster@redhat.com> wrote:
   =20
        On Fri, Sep 01, 2017 at 11:37:37PM +0000, Richard Wareing wrote:
        >=20
        > > On Sep 1, 2017, at 3:55 PM, Dave Chinner <david@fromorbit.com> =
wrote:
        > >=20
        > > [satuday morning here, so just a quick comment]
        > >=20
        > > On Fri, Sep 01, 2017 at 08:36:53PM +0000, Richard Wareing wrote=
:
        > >>> On Sep 1, 2017, at 12:32 PM, Brian Foster <bfoster@redhat.com=
> wrote:
        > >>>=20
        > >>> On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wro=
te:
        > >>>> Thanks for the quick feedback Dave!  My comments are in-line=
 below.
        > >>>>=20
        > >>>>=20
        > >>>>> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.=
com> wrote:
        > >>>>>=20
        > >>>>> Hi Richard,
        > >>>>>=20
        > >>>>> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing w=
rote:
        > >>> ...
        > >>>>>> add
        > >>>>>> support for the more sophisticated AG based block allocato=
r to RT
        > >>>>>> (bitmapped version works well for us, but multi-threaded u=
se-cases
        > >>>>>> might not do as well).
        > >>>>>=20
        > >>>>> That's a great big can of worms - not sure we want to open =
it. The
        > >>>>> simplicity of the rt allocator is one of it's major benefit=
s to
        > >>>>> workloads that require deterministic allocation behaviour..=
.
        > >>>>=20
        > >>>> Agreed, I took a quick look at what it might take and came t=
o a similar conclusion, but I can dream :).
        > >>>>=20
        > >>>=20
        > >>> Just a side point based on the discussion so far... I kind of=
 get the
        > >>> impression that the primary reason for using realtime support=
 here is
        > >>> for the simple fact that it's a separate physical device. Tha=
t provides
        > >>> a basic mechanism to split files across fast and slow physica=
l storage
        > >>> based on some up-front heuristic. The fact that the realtime =
feature
        > >>> uses a separate allocation algorithm is actually irrelevant (=
and
        > >>> possibly a problem in the future).
        > >>>=20
        > >>> Is that an accurate assessment? If so, it makes me wonder whe=
ther it's
        > >>> worth thinking about if there are ways to get the same behavi=
or using
        > >>> traditional functionality. This ignores Dave's question about=
 how much
        > >>> of the performance actually comes from simply separating out =
the log,
        > >>> but for example suppose we had a JBOD block device made up of=
 a
        > >>> combination of spinning and solid state disks via device-mapp=
er with the
        > >>> requirement that a boundary from fast -> slow and vice versa =
was always
        > >>> at something like a 100GB alignment. Then if you formatted th=
at device
        > >>> with XFS using 100GB AGs (or whatever to make them line up), =
and could
        > >>> somehow tag each AG as "fast" or "slow" based on the known un=
derlying
        > >>> device mapping,
        > >=20
        > > Not a new idea. :)
        > >=20
       =20
        Yeah (what ever is? :P).. I know we've discussed having more contro=
ls or
        attributes of AGs for various things in the past. I'm not trying to
        propose a particular design here, but rather trying to step back fr=
om
        the focus on RT and understand what the general requirements are
        (multi-device, tiering, etc.). I've not seen the pluggable allocati=
on
        stuff before, but it sounds like that could suit this use case perf=
ectly.
       =20
        > > I've got old xfs_spaceman patches sitting around somewhere for
        > > ioctls to add such information to individual AGs. I think I cal=
led
        > > them "concat groups" to allow multiple AGs to sit inside a sing=
le
        > > concatenation, and they added a policy layer over the top of AG=
s
        > > to control things like metadata placement....
        > >=20
       =20
        Yeah, the alignment thing is just the first thing that popped in my=
 head
        for a thought experiment. Programmatic knobs on AGs via ioctl() or =
sysfs
        is certainly a more legitimate solution.
       =20
        > >>> could you potentially get the same results by using the
        > >>> same heuristics to direct files to particular sets of AGs rat=
her than
        > >>> between two physical devices?
        > >=20
        > > That's pretty much what I was working on back at SGI in 2007. i=
.e.
        > > providing a method for configuring AGs with difference
        > > characteristics and a userspace policy interface to configure a=
nd
        > > make use of it....
        > >=20
        > > https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__oss.sgi.c=
om_archives_xfs_2009-2D02_msg00250.html&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3M=
Uw&r=3DqJ8Lp7ySfpQklq3QZr44Iw&m=3D2aGIpGJVnKOtPKDQQRfM52Rv5NTAwoK15WHcQIodI=
G4&s=3DbAOVWOrDuWm92j4tTCxZnZOQxhUP1EVlj-JSHpC1yoA&e=3D=20
        > >=20
        > >=20
        > >>> Obviously there are some differences like
        > >>> metadata being spread across the fast/slow devices (though I =
think we
        > >>> had such a thing as metadata only AGs), etc.
        > >=20
        > > We have "metadata preferred" AGs, and that is what the inode32
        > > policy uses to place all the inodes and directory/atribute meta=
data
        > > in the 32bit inode address space. It doesn't get used for data
        > > unless the rest of the filesystem is ENOSPC.
        > >=20
       =20
        Ah, right. Thanks.
       =20
        > >>> I'm just handwaving here to
        > >>> try and better understand the goal.
        > >=20
        > > We've been down these paths many times - the problem has always=
 been
        > > that the people who want complex, configurable allocation polic=
ies
        > > for their workload have never provided the resources needed to
        > > implement past "here's a mount option hack that works for us"..=
...
        > >=20
       =20
        Yep. To be fair, I think what Richard is doing is an interesting an=
d
        useful experiment. If one wants to determine whether there's value =
in
        directing files across separate devices via file size in a constrai=
ned
        workload, it makes sense to hack up things like RT and fallocate()
        because they provide the basic mechanisms you'd want to take advant=
age
        of without having to reimplement that stuff just to prove a concept=
.
       =20
        The challenge of course is then realizing when you're done that thi=
s is
        not a generic solution. It abuses features/interfaces in ways they =
were
        not designed for, disrupts traditional functionality, makes assumpt=
ions
        that may not be valid for all users (i.e., file size based filterin=
g,
        number of devices, device to device ratios), etc. So we have to ste=
p
        back and try to piece together a more generic, upstream-worthy appr=
oach.
        To your point, it would be nice if those exploring these kind of ha=
cks
        would contribute more to that upstream process rather than settle o=
n
        running the "custom fit" hack until upstream comes around with some=
thing
        better on its own. ;) (Though sending it out is still better than n=
ot,
        so thanks for that. :)
       =20
        > >> Sorry I forgot to clarify the origins of the performance wins
        > >> here.   This is obviously very workload dependent (e.g.
        > >> write/flush/inode updatey workloads benefit the most) but for =
our
        > >> use case about ~65% of the IOP savings (~1/3 journal + slightl=
y
        > >> less than 1/3 sync of metadata from journal, slightly less as =
some
        > >> journal entries get canceled), the remainder 1/3 of the win co=
mes
        > >> from reading small files from the SSD vs. HDDs (about 25-30% o=
f
        > >> our file population is <=3D256k; depending on the cluster).  T=
o be
        > >> clear, we don't split files, we store all data blocks of the f=
iles
        > >> either entirely on the SSD (e.g. small files <=3D256k) and the=
 rest
        > >> on the real-time HDD device.  The basic principal here being t=
hat,
        > >> larger files MIGHT have small IOPs to them (in our use-case th=
is
        > >> happens to be rare, but not impossible), but small files alway=
s
        > >> do, and when 25-30% of your population is small...that's a big
        > >> chunk of your IOPs.
        > >=20
        > > So here's a test for you. Make a device with a SSD as the first=
 1TB,
        > > and you HDD as the rest (use dm to do this). Then use the inode=
32
        > > allocator (mount option) to split metadata from data. The files=
ysetm
        > > will keep inodes/directories on the SSD and file data on the HD=
D
        > > automatically.
        > >=20
        > > Better yet: have data allocations smaller than stripe units tar=
get
        > > metadata prefferred AGs (i.e. the SSD region) and allocations l=
arger
        > > than stripe unit target the data-preferred AGs. Set the stripe =
unit
        > > to match your SSD/HDD threshold....
        > >=20
        > > [snip]
        > >=20
        > >> The AG based could work, though it's going to be a very hard s=
ell
        > >> to use dm mapper, this isn't code we have ever used in our sto=
rage
        > >> stack.  At our scale, there are important operational reasons =
we
        > >> need to keep the storage stack simple (less bugs to hit), so
        > >> keeping the solution contained within XFS is a necessary
        > >> requirement for us.
        > >=20
       =20
        I am obviously not at all familiar with your storage stack and the
        requirements of your environment and whatnoat. It's certainly possi=
ble
        that there's some technical reason you can't use dm, but I find it =
very
        hard to believe that reason is "there might be bugs" if you're inst=
ead
        willing to hack up and deploy a barely tested feature such as XFS R=
T.
        Using dm for basic linear mapping (i.e., partitioning) seems pretty=
 much
        ubiquitous in the Linux world these days.
       =20
    Bugs aren=B9t the only reason of course, but we=B9ve been working on th=
is for a number of months, we also have thousands of production hours (* >1=
0 FSes per system =3D=3D >1M hours on the real-time code) on this setup, I=
=B9m also doing more testing with dm-flaky + dm-log w/ xfs-tests along with=
 this.  In any event, large deviations (or starting over from scratch) on o=
ur setup isn=B9t something we=B9d like to do.  At this point I trust the RT=
 allocator a good amount, and its sheer simplicity is something of an asset=
 for us.
   =20
    To be honest, if an AG allocator solution were available, I=B9d have to=
 think carefully if it would make sense for us (though I=B9d be willing to =
help test/create it).  Once you have the small files filtered out to an SSD=
, you can dramatically increase the extent sizes on the RT FS (you don=B9t =
waste space for small allocations), yielding very dependable/contiguous rea=
ds/write IOs (we want multi-MB ave IOs), and the dependable latencies mesh =
well with the needs of a distributed FS.  I=B9d need to make sure these cha=
racteristics were achievable with the more AG allocator (yes there is =B3al=
locsize=B2 option but it=B9s more of a suggestion than the hard guarantee o=
f the RT extents), it=B9s complexity also makes developers prone to treatin=
g it as a =B3black box=B2 and ending up with less than stellar IO efficienc=
ies.
   =20
        > > Modifying the filesysetm on-disk format is far more complex tha=
n
        > > adding dm to your stack. Filesystem modifications are difficult=
 and
        > > time consuming because if we screw up, users lose all their dat=
a.
        > >=20
        > > If you can solve the problem with DM and a little bit of additi=
onal
        > > in-memory kernel code to categorise and select which AG to use =
for
        > > what (i.e. policy stuff that can be held in userspace), then th=
at is
        > > the pretty much the only answer that makes sense from a filesys=
tem
        > > developer's point of view....
        > >=20
       =20
        Yep, agreed.
       =20
        > > Start by thinking about exposing AG behaviour controls through =
sysfs
        > > objects and configuring them at mount time through udev event
        > > notifications.
        > >=20
        >=20
        > Very cool idea.  A detail which I left out which might complicate=
 this, is we only use 17GB of SSD for each ~8-10TB HDD (we share just a sma=
ll 256G SSD for about 15 drives), and even then we don't even use 50% of th=
e SSD for these partitions.  We also want to be very selective about what d=
ata we let touch the SSD, we don't want folks who write large files by doin=
g small IO to touch the SSD, only IO to small files (which are immutable in=
 our use-case).
        >=20
       =20
        I think Dave's more after the data point of how much basic metadata=
/data
        separation helps your workload. This is an experiment you can run t=
o get
        that behavior without having to write any code (maybe a little for =
the
        stripe unit thing ;). If there's a physical device size limitation,
        perhaps you can do something crazy like create a sparse 1TB file on=
 the
        SSD, map that to a block device over loop or something and proceed =
from
        there.
   =20
    We have a very good idea on this already, we also have data for a 7 day=
 period when we simply did MD offload to SSD alone.  Prior to even doing th=
is setup, we used blktrace and examined all the metadata IO requests (e.g. =
per the RWBS field).  It=B9s about 60-65% of the IO savings, the remaining =
~35% is from the small file IO.  For us, it=B9s worth saving.
   =20
    Wrt to performance, we observe average 50%+ drops in latency for nearly=
 all IO requests, the smaller IO requests should be quite a bit more but we=
 need to change our threading model to handle a bit to take advantage of th=
e fact the small files are on the SSDs (and therefore don=B9t need to wait =
behind other requests coming from the HDDs).
       =20
        Though I guess that since this is a performance experiment, a bette=
r
        idea may be to find a bigger SSD or concat 4 of the 256GB devices i=
nto
        1TB and use that, assuming you're able to procure enough devices to=
 run
        an informative test.
       =20
        Brian
       =20
        > On an unrelated note, after talking to Omar Sandoval & Chris Maso=
n over here, I'm reworking rtdefault to change it to "rtdisable" which give=
s the same operational outcome vs. rtdefault w/o setting inheritance bits (=
see prior e-mail).  This way folks have a kill switch of sorts, yet otherwi=
se maintains the existing "persistent" behavior.
        >=20
        >=20
        > > Cheers,
        > >=20
        > > Dave.
        > > --=20
        > > Dave Chinner
        > > david@fromorbit.com
        >=20
        > --
        > To unsubscribe from this list: send the line "unsubscribe linux-x=
fs" in
        > the body of a message to majordomo@vger.kernel.org
        > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
       =20
   =20


