Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35878 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751824AbdIASjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 14:39:15 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Date: Fri, 1 Sep 2017 18:39:09 +0000
Message-ID: <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
In-Reply-To: <20170901043151.GZ10621@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5190B9F99EE52D45AB8C00DD2F0DC383@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Thanks for the quick feedback Dave!  My comments are in-line below.


> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> Hi Richard,
>=20
> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
>> Hello all,=20
>>=20
>> It turns out, XFS real-time volumes are actually a very
>> useful/cool feature, I am wondering if there is support in the
>> community to make this feature a bit more user friendly, easier to
>> operate and interact with. To kick things off I bring patches
>> table :).
>>=20
>> For those who aren't familiar with real-time XFS volumes, they are
>> basically a method of storing the data blocks of some files on a
>> separate device. In our specific application, are using real-time
>> devices to store large files (>256KB) on HDDS, while all metadata
>> & journal updates goto an SSD of suitable endurance & capacity.
>=20
> Well that's interesting. How widely deployed is this? We don't do a
> whole lot of upstream testing on the rt device, so I'm curious to
> know about what problems you've had to fix to get it to wrok
> reliably....

So far we have a modest deployment of 13 machines, we are going to step thi=
s up to 30 pretty soon.  As for problems, actually only 1 really.  I origin=
ally started my experiments on Kernel 4.0.9 and ran into a kernel panic (I =
can't recall the exact bug) but after consulting the mailing list there was=
 a patch in a later kernel version (4.6) which resolved the problem.  Since=
 then I've moved my work to 4.11.

Our use-case is pretty straight forward, we open -> fallocate -> write and =
never again write to the files.  From there is just reads and unlinks.  Mul=
ti-threading IO is kept to a minimum (typically a single thread but perhaps=
 3-4 under high load), which probably avoids tempting fate on hard to track=
 down race bugs.


>=20
>> We
>> also see use-cases for this for distributed storage systems such
>> as GlusterFS which are heavy in metadata operations (80%+ of
>> IOPs). By using real-time devices to tier your XFS filesystem
>> storage, you can dramatically reduce HDD IOPs (50% in our case)
>> and dramatically improve metadata and small file latency (HDD->SSD
>> like reductions).
>=20
> IMO, this isn't really what I'd call "tiered" storage - it's just a
> data/metadata separation. Same as putting your log on an external
> device to separate the journal IO from user IO isn't tiering.... :)

The tiering comes into play with the rtfallocmin, because we always falloca=
te to "declare" our intention to write data XFS can automatically direct th=
e data to the correct tier of storage (SSD for small files <=3D 256k & HDD =
for larger ones); in our distributed storage system this has the ultimatel =
effect of making the IO path files <=3D ~2MB SSD backed.  Storage systems s=
uch as GlusterFS can leverage this as well (and where I plan to focus my at=
tention once I'm done with my present use-case).

>=20
> FWIW, using an external log for fsync heavy workloads reduces data
> device IOPS by roughly 50%, and that seems to match what you are
> saying occurs in your workloads by moving data IO to a separate
> device from the log.  So now I'm wondering - is the reduction in
> IOPS on your HDDs reflecting the impact of separating journal
> commits from data writes? If not, where is the 50% of the IOPS that
> aren't data and aren't journal going in your workloads?
>=20


>> Here are the features in the proposed patch set:
>>=20
>> 1. rtdefault  - Defaulting block allocations to the real-time
>> device via a mount flag rtdefault, vs using an inheritance flag or
>> ioctl's. This options gives users tier'ing of their metadata out
>> of the box with ease,
>=20
> As you've stated, we already have per-inode flags for this, but from
> what you've said I'm not sure you realise that we don't need a mount
> option for "out of the box" data-on-rtdev support. i.e.  mkfs
> already provides "out of the box" data-on-rtdev support:
>=20
> # mkfs.xfs -r rtdev=3D/dev/rt -d rtinherit=3D1 /dev/data
>=20
>> and in a manner more users are familiar with
>> (mount flags), vs having to set inheritance bits or use ioctls
>> (many distributed storage developers are resistant to including FS
>> specific code into their stacks).
>=20
> Even with a rtdefault mount option, admins would still have to use
> 'chattr -R -r' to turn off use of the rt device by default because
> removing the mount option doesn't get rid of the on-disk inode flags
> that control this behaviour.
>=20
> Maybe I'm missing something, but I don't see what this mount option
> makes simpler or easier for users....

You are correct, I wasn't aware of the "rtinherit" mkfs time option :).  Ho=
wever, it functions much the same as setting the inheritance bit on the dir=
ectory manually, which is subtly different (and less intuitive as I hope to=
 convince you).  Inheritance bits are problematic for a couple reasons, fir=
st it's not super obvious (by common mechanisms such as xfs_info or /proc/m=
ounts) to the admin this is in place.  Imagine you are taking over an exist=
ing setup, it might take you many moons to discover the action by which fil=
es are defaulting to the real-time device.

Second, you bring up a really good point that the rtdefault flag would stil=
l require users to strip the inheritance bits from the directories, but thi=
s actually points out the second problem with the inheritance bits: you hav=
e them all over your FS, and stripping them would require a FS walk (as a u=
ser).  I think the change here I can make is to simply not set the director=
y inheritance bits on the directories since rtdefault takes over this funct=
ion, this way when you remove the mount flag, the behavior is intuitive: fi=
les no longer default to the RT device.  This way users get the added benef=
it of not having to walk the entire FS to strip the inheritance bits from t=
he directories, and a more intuitive behavior.


>=20
>> 2. rtstatfs  - Returning real-time block device free space instead
>> of the non-realtime device via the "rtstatfs" flag. This creates
>> an experience/semantics which is a bit more familiar to users if
>> they use real-time in a tiering configuration. "df" reports the
>> space on your HDDs, and the metadata space can be returned by a
>> tool like xfs_info (I have patches for this too if there is
>> interest) or xfs_io. I think this might be a bit more intuitive
>> for the masses than the reverse (having to goto xfs_io for the HDD
>> space, and df for the SSD metadata).
>=20
> Yep, useful idea. We already have a mechanism for reporting
> different information to statfs depending on what is passed to it.
> We use that to report directory tree quota information instead of
> filesystem wide information. See the project id inode flag hooks at
> the end of xfs_fs_statfs().
>=20
> Similar could be done here - if statfs is pointed at a RT
> file/directory, report rt device usage. If it's pointed at a the
> root directory, report data device information.
>=20

I'll re-work the patch to fix this.

>> 3. rtfallocmin - This option can be combined with either rtdefault
>> or standalone. When combined with rtdefault, it uses fallocate as
>> "signal" to *exempt* storage on the real-time device,
>> automatically promoting small fallocations to the SSD, while
>> directing larger ones (or fallocation-less creations) to the HDD.
>=20
> Hmmmm. Abusing fallocate to control allocation policy is kinda
> nasty. I'd much prefer we work towards a usable allocation policy
> framework rather than encode one-off hacks like this into the
> filesystem behaviour.
>=20

I'm completely open to suggestions here, though it's been amazingly useful =
to have fallocate as the signal here as there's a pile of user land tools w=
hich use fallocate prior to writing data (.  You can use these without any =
modification to do all sorts of operational tasks (e.g. file promotion to n=
on-RT device, restoration of backups with/without sending small files to SS=
D, shell scripts which use "fallocate" utility etc).  This really puts the =
control in the hands in the administrator, who can then use their imaginati=
on to come up with all sorts of utilities & scripts which make their life e=
asier.  Contrast this with having to patch xfs_fsr or another xfs tool whic=
h would be daunting for most admins.


>> This option also works really well with tools like "rsync" which
>> support fallocate (--preallocate flag) so users can easily
>> promote/demote files to/from the SSD.
>=20
> That's a neat hack, but it's not a viable adminisitration policy
> interface :/
>=20
>> Ideally, I'd like to help build-out more tiering features into XFS
>> if there is interest in the community, but figured I'd start with
>> these patches first.  Other ideas/improvements: automatic eviction
>> from SSD once file grows beyond rtfallocmin,
>=20
> You could probably already do that right now with fanotify +
> userspace-based atomic data mover (i.e. xfs_fsr).
>=20
> Keep in mind any time you say "move data around when ..." I'll
> probably reply "you can use xfs_fsr for that". "fsr" =3D "file system
> reorganiser" and it's sole purpose in life is to transparently move
> data around the filesystem....

Agreed, but not really tenable to add piles of use-cases to xfs_fsr vs. lev=
eraging the existing utilities out there.  I really want to unlock the pote=
ntial for admins to dream up or leverage existing utilities for their opera=
tional needs.

>=20
>> automatic fall-back
>> to real-time device if non-RT device (SSD) is out of blocks,
>=20
> If you run the data device out of blocks, you can't allocate blocks
> for the new metadata that has to be allocated to track the data held
> in the RT device.  i.e.  running the data device out of space is
> a filesystem wide ENOSPC condition even if there's still space
> in the rt device for the data.
>=20

Wrt metadata, my plan here was to reserve (or does inode reservation handle=
 this?) some percentage of non-RT blocks for metadata.  This way data would=
 over-flow reliably.  I'm still tweaking this patch so nothing to show yet.

>> add
>> support for the more sophisticated AG based block allocator to RT
>> (bitmapped version works well for us, but multi-threaded use-cases
>> might not do as well).
>=20
> That's a great big can of worms - not sure we want to open it. The
> simplicity of the rt allocator is one of it's major benefits to
> workloads that require deterministic allocation behaviour...

Agreed, I took a quick look at what it might take and came to a similar con=
clusion, but I can dream :).

>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

