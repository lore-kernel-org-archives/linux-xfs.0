Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750955AbdIAXho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 19:37:44 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH 1/3] xfs: Add rtdefault mount option
Date: Fri, 1 Sep 2017 23:37:37 +0000
Message-ID: <67F62657-D116-4B85-9452-5BAB52EC7041@fb.com>
References: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
 <20170901043151.GZ10621@dastard>
 <C6F6823D-65D7-4B73-9AC7-CBA4125F2429@fb.com>
 <20170901193237.GF29225@bfoster.bfoster>
 <BF1D2F17-045E-4BF7-839D-FF7D0643329E@fb.com>
 <20170901225539.GC10621@dastard>
In-Reply-To: <20170901225539.GC10621@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8200194695A25441A6AD4B7F1232FFA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


> On Sep 1, 2017, at 3:55 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> [satuday morning here, so just a quick comment]
>=20
> On Fri, Sep 01, 2017 at 08:36:53PM +0000, Richard Wareing wrote:
>>> On Sep 1, 2017, at 12:32 PM, Brian Foster <bfoster@redhat.com> wrote:
>>>=20
>>> On Fri, Sep 01, 2017 at 06:39:09PM +0000, Richard Wareing wrote:
>>>> Thanks for the quick feedback Dave!  My comments are in-line below.
>>>>=20
>>>>=20
>>>>> On Aug 31, 2017, at 9:31 PM, Dave Chinner <david@fromorbit.com> wrote=
:
>>>>>=20
>>>>> Hi Richard,
>>>>>=20
>>>>> On Thu, Aug 31, 2017 at 06:00:21PM -0700, Richard Wareing wrote:
>>> ...
>>>>>> add
>>>>>> support for the more sophisticated AG based block allocator to RT
>>>>>> (bitmapped version works well for us, but multi-threaded use-cases
>>>>>> might not do as well).
>>>>>=20
>>>>> That's a great big can of worms - not sure we want to open it. The
>>>>> simplicity of the rt allocator is one of it's major benefits to
>>>>> workloads that require deterministic allocation behaviour...
>>>>=20
>>>> Agreed, I took a quick look at what it might take and came to a simila=
r conclusion, but I can dream :).
>>>>=20
>>>=20
>>> Just a side point based on the discussion so far... I kind of get the
>>> impression that the primary reason for using realtime support here is
>>> for the simple fact that it's a separate physical device. That provides
>>> a basic mechanism to split files across fast and slow physical storage
>>> based on some up-front heuristic. The fact that the realtime feature
>>> uses a separate allocation algorithm is actually irrelevant (and
>>> possibly a problem in the future).
>>>=20
>>> Is that an accurate assessment? If so, it makes me wonder whether it's
>>> worth thinking about if there are ways to get the same behavior using
>>> traditional functionality. This ignores Dave's question about how much
>>> of the performance actually comes from simply separating out the log,
>>> but for example suppose we had a JBOD block device made up of a
>>> combination of spinning and solid state disks via device-mapper with th=
e
>>> requirement that a boundary from fast -> slow and vice versa was always
>>> at something like a 100GB alignment. Then if you formatted that device
>>> with XFS using 100GB AGs (or whatever to make them line up), and could
>>> somehow tag each AG as "fast" or "slow" based on the known underlying
>>> device mapping,
>=20
> Not a new idea. :)
>=20
> I've got old xfs_spaceman patches sitting around somewhere for
> ioctls to add such information to individual AGs. I think I called
> them "concat groups" to allow multiple AGs to sit inside a single
> concatenation, and they added a policy layer over the top of AGs
> to control things like metadata placement....
>=20
>>> could you potentially get the same results by using the
>>> same heuristics to direct files to particular sets of AGs rather than
>>> between two physical devices?
>=20
> That's pretty much what I was working on back at SGI in 2007. i.e.
> providing a method for configuring AGs with difference
> characteristics and a userspace policy interface to configure and
> make use of it....
>=20
> https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__oss.sgi.com_archive=
s_xfs_2009-2D02_msg00250.html&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DqJ8=
Lp7ySfpQklq3QZr44Iw&m=3D2aGIpGJVnKOtPKDQQRfM52Rv5NTAwoK15WHcQIodIG4&s=3DbAO=
VWOrDuWm92j4tTCxZnZOQxhUP1EVlj-JSHpC1yoA&e=3D=20
>=20
>=20
>>> Obviously there are some differences like
>>> metadata being spread across the fast/slow devices (though I think we
>>> had such a thing as metadata only AGs), etc.
>=20
> We have "metadata preferred" AGs, and that is what the inode32
> policy uses to place all the inodes and directory/atribute metadata
> in the 32bit inode address space. It doesn't get used for data
> unless the rest of the filesystem is ENOSPC.
>=20
>>> I'm just handwaving here to
>>> try and better understand the goal.
>=20
> We've been down these paths many times - the problem has always been
> that the people who want complex, configurable allocation policies
> for their workload have never provided the resources needed to
> implement past "here's a mount option hack that works for us".....
>=20
>> Sorry I forgot to clarify the origins of the performance wins
>> here.   This is obviously very workload dependent (e.g.
>> write/flush/inode updatey workloads benefit the most) but for our
>> use case about ~65% of the IOP savings (~1/3 journal + slightly
>> less than 1/3 sync of metadata from journal, slightly less as some
>> journal entries get canceled), the remainder 1/3 of the win comes
>> from reading small files from the SSD vs. HDDs (about 25-30% of
>> our file population is <=3D256k; depending on the cluster).  To be
>> clear, we don't split files, we store all data blocks of the files
>> either entirely on the SSD (e.g. small files <=3D256k) and the rest
>> on the real-time HDD device.  The basic principal here being that,
>> larger files MIGHT have small IOPs to them (in our use-case this
>> happens to be rare, but not impossible), but small files always
>> do, and when 25-30% of your population is small...that's a big
>> chunk of your IOPs.
>=20
> So here's a test for you. Make a device with a SSD as the first 1TB,
> and you HDD as the rest (use dm to do this). Then use the inode32
> allocator (mount option) to split metadata from data. The filesysetm
> will keep inodes/directories on the SSD and file data on the HDD
> automatically.
>=20
> Better yet: have data allocations smaller than stripe units target
> metadata prefferred AGs (i.e. the SSD region) and allocations larger
> than stripe unit target the data-preferred AGs. Set the stripe unit
> to match your SSD/HDD threshold....
>=20
> [snip]
>=20
>> The AG based could work, though it's going to be a very hard sell
>> to use dm mapper, this isn't code we have ever used in our storage
>> stack.  At our scale, there are important operational reasons we
>> need to keep the storage stack simple (less bugs to hit), so
>> keeping the solution contained within XFS is a necessary
>> requirement for us.
>=20
> Modifying the filesysetm on-disk format is far more complex than
> adding dm to your stack. Filesystem modifications are difficult and
> time consuming because if we screw up, users lose all their data.
>=20
> If you can solve the problem with DM and a little bit of additional
> in-memory kernel code to categorise and select which AG to use for
> what (i.e. policy stuff that can be held in userspace), then that is
> the pretty much the only answer that makes sense from a filesystem
> developer's point of view....
>=20
> Start by thinking about exposing AG behaviour controls through sysfs
> objects and configuring them at mount time through udev event
> notifications.
>=20

Very cool idea.  A detail which I left out which might complicate this, is =
we only use 17GB of SSD for each ~8-10TB HDD (we share just a small 256G SS=
D for about 15 drives), and even then we don't even use 50% of the SSD for =
these partitions.  We also want to be very selective about what data we let=
 touch the SSD, we don't want folks who write large files by doing small IO=
 to touch the SSD, only IO to small files (which are immutable in our use-c=
ase).

On an unrelated note, after talking to Omar Sandoval & Chris Mason over her=
e, I'm reworking rtdefault to change it to "rtdisable" which gives the same=
 operational outcome vs. rtdefault w/o setting inheritance bits (see prior =
e-mail).  This way folks have a kill switch of sorts, yet otherwise maintai=
ns the existing "persistent" behavior.


> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

