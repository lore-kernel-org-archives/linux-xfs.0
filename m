Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2709 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdA0WGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2017 17:06:37 -0500
From: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Subject: RE: [LSF/MM TOPIC] online filesystem repair
Date: Fri, 27 Jan 2017 22:06:32 +0000
Message-ID: <SN2PR04MB2191780E898A5439D7F1585B88760@SN2PR04MB2191.namprd04.prod.outlook.com>
References: <20170114075452.GJ14033@birch.djwong.org>
 <1484524890.27533.16.camel@dubeyko.com>
 <20170117062453.GJ14038@birch.djwong.org>
 <SN2PR04MB2191A5D379B5C1A1BA0AB9A0887F0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170125084133.GC5726@birch.djwong.org>
In-Reply-To: <20170125084133.GC5726@birch.djwong.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


-----Original Message-----
From: Darrick J. Wong [mailto:darrick.wong@oracle.com]=20
Sent: Wednesday, January 25, 2017 12:42 AM
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>; lsf-pc@lists.linux-foundation.o=
rg; linux-fsdevel@vger.kernel.org; linux-xfs@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] online filesystem repair
=20
> > Let's imagine that file system will register every metadata structure=20
> > in generic online file checking subsystem. Then the file system will
>
> That sounds pretty harsh.  XFS (and ext4) hide quite a /lot/ of metadata.=
=20
> We don't expose the superblocks, the free space header, the inode header,
> the free space btrees, the inode btrees, the reverse mapping btrees,
> the refcount btrees, the journal, or the rtdev space data.  I don't think
> we ought to expose any of that except to xfsprogs.
> For another thing, there are dependencies between those pieces of metadat=
a,
> (e.g. the AGI has to work before we can check the inobt) and one has to t=
ake
> those into account when scrubbing.
>
> ext4 has a different set of internal metadata, but the same applies there=
 too.

I didn't suggest to expose the metadata in pure sense of this word. The key=
 point of this
discussion is the elaboration of a vision how the generic online file syste=
m checking/recovery
can be done. It means that VFS has to represent a file system like some gen=
eric set of
items (for example, like sequence of iterators). The VFS is the layer of ge=
neralized
management of any file system. And VFS interacts with concrete file systems=
 by means of
specialized callbacks (file_operations, inode_operations and so on) that pr=
ovides opportunity
to implement some special way of file system volume management. So, as far =
as I can see,
the online file system check/recovery subsystem has to looks like in the sa=
me way. It needs to work
in generalized manner but specialized callbacks will realize specialized el=
ementary operations.
And concrete file system driver should provide the specialization of such m=
ethods.

The really important point is the possible mode(s) of the online file syste=
m
check/recovery subsystem. I see the two principal cases: (1) post-corruptio=
n check/recovery;
(2) preventive check.=20

We could consider mount and/or unmount operations like the main point(s) of=
 the online
file system check/recovery subsystem activity for the post-corruption case.=
 In this case
struct super_operations could contain check_method() and recovery_method() =
that will
realize all specialized logic of checking/recovery a file system volume. Al=
l file system's peculiarities
in metadata implementation and checking/recovering algorithm will be hidden=
 in these
specialized method. So, it is possible to see such possible cases when onli=
ne file system check/recovery
subsystem could be possibly used for the post-corruption case:
(1) mount operation -> we discover the file system corruption here, usually=
;
(2) remount in RO mode -> if we had some internal error in file system driv=
er;
(3) special set of file system errors that initiate check/recovery subsyste=
m activity;
(4) unmount operation -> check file system volume consistency at the end of=
 unmount operation.=20

Also it is possible to consider the opportunity to check a file system volu=
me's state or the state of
some metadata structure in mounted state of file system volume. But, as far=
 as I can see, we need
to introduce new syscalls or special ioctl commands for such case. And I am=
 not sure that
it will be easy to implement support of such requests.

Another possible mode could be a preventive mode of checking file system vo=
lume's state
before flush operation. In this case, VFS should consider a file system vol=
ume as some abstract
sequence of metadata structures. It means that VFS needs to use some specia=
lized methods
(registered by file system driver) in generic way. Let's imagine that VFS w=
ill have some generic
method of preventive checking of flush operations. I mean here that, anyway=
, every metadata
structure is split between nodes, logical blocks and so on. Usually, such n=
ode could contain some
header and file system driver is able to check consistency of such node bef=
ore flush operation.
Of course, such check operation can degrade the performance of flush operat=
ion. But it could
be the decision of a user to use or not to use the preventive mode. Also we=
 cannot check the
relations between different nodes. The complete check can be done during po=
st-corruption
check/recovery mode.

> > need to register some set of checking methods or checking events for=20
> > every registered metadata structure. For example:
> >
> > (1) check_access_metadata();
> > (2) check_metadata_modification();
> > (3) check_metadata_node();
> > (4) check_metadata_node_flush();
> > (5) check_metadata_nodes_relation().
>=20
> How does the VFS know to invoke these methods on a piece of internal meta=
data that
> the FS owns and updates at its pleasure?  The only place we encode all th=
e relationships
> between pieces of metadata is in the fs driver itself, and that's where s=
crubbing needs
> to take place.  The VFS only serves to multiplex the subset of operations=
 that are common
> across all filesystems; everything else take the form of (semi-private) i=
octls.

First of all, it's clear that we discover a file system volume's corrupted =
state during
mount operation. So, VFS can easily invoke the method of check/recovery a f=
ile
system volume in generic manner during mount operation. Also file system vo=
lume
is unable for any file system operations till the finishing of mount operat=
ion. So, file
system driver can do anything with metadata of file system volume with comp=
lete
pleasure. Secondly, the unmount operation can be used easily in generic man=
ner
with the same purpose.

Secondly, VFS represents a file system's hierarchy by means of inodes, dent=
ries, page
cache and so on. It is abstraction that VFS is using in memory on OS side. =
But file system
volume could not contain such items at all. For example, HFS+ hasn't inodes=
 or dentries
in the file system volume. It uses btrees that contains file records, folde=
r records.
And it needs to convert HFS+ representation of metadata into VFS internal r=
epresentation=20
during any operations with retrieving or storing metadata in the file syste=
m volume.
When I am talking about some check/recovery methods (check_metadata_node(),
for example) I mean that could have some abstract representation of any met=
adata
in the file system volume. It could be the simple sequence of metadata node=
s, for example.
And if it was requested the sync operation then it means that the whole met=
adata
structure should be consistent for the flush operation. So, if VFS is tryin=
g to execute
the sync_fs() operation then it is possible to pass through the all abstrac=
t sequences of
metadata nodes and to apply the check_metadata_node() callbacks that will b=
e
executed by concrete file system driver. So, the real check/recovery operat=
ion will be
done by the fs driver itself but in general manner.

> > I think that it is possible to consider several possible level of=20
> > generic online file system checking subsystem's activity: (1) light=20
> > check mode; (2) regular check mode; (3) strict check mode.
> >
> > The "light check mode" can  be resulted in "fast" metadata nodes'
> > check on write operation with generation of error messages in the=20
> > syslog with the request to check/recover file system volume by means=20
> > of fsck tool.
> >=20
> > The "regular check mode" can be resulted in: (1) the checking of any=20
> > metadata modification with trying to correct the operation in the=20
> > modification place; (2) metadata nodes' check on write operation with=20
> > generation of error messages in the syslog.
> >
> > The "strict check mode" can be resulted in: (1) check mount operation=20
> > with trying to recover the affected metadata structures; (2) the=20
> > checking of any metadata modification with trying to correct the=20
> > operation in the modification place; (3) check and recover metadata=20
> > nodes on flush operation; (4) check/recover during unmount operation.
>
> I'm a little unclear about where you're going with all three of these thi=
ngs;
> the XFS metadata verifiers already do limited spot-checking of all metada=
ta
> reads and writes without the VFS being directly involved.
> The ioctl performs more intense checking and cross-checking of metadata
> that would be too expensive to do on every access.

We are trying to talk not about XFS only. If we talk about a generic online
check/recovery subsystem then it has to be good for all other file systems =
too.
Again, if you believe that all check/recovering activity should be hidden f=
rom
VFS then it's not clear for me why did you raise this topic?

XFS and other file systems do some metadata verification in the background =
of
VFS activity. Excellent... It sounds for me that we simply need to generali=
ze
this activity on VFS level. As minimum, we could consider mount/unmount
operation for the case of online check/recovery subsystem. Also VFS is able
to be involved into some preventive metadata checking on generalized basis.

When I am talking about different checking modes I mean that a user should
have opportunity to select the different possible modes of online check/rec=
overy
subsystem with different overheads. It is not necessary to be set of modes =
that
I mentioned. But different users have different priorities. Some users need=
 in
performance, another ones need in reliability. Now we cannot manage what
file system does with metadata checking in the background. But a user will =
be
able to opt a proper way of online check/recovery subsystem activity if the=
 VFS
supports generalized way of metadata checking with different modes.

> > What do you like to expose to VFS level as generalized methods for=20
> > your implementation?
>=20
> Nothing.  A theoretical ext4 interface could look similar to XFS's,
> but the metadata-type codes would be different.  btrfs seems so much
> different structurally there's little point in trying.

So, why did you raise this topic? If nothing then no topic. :)

> I also looked at ocfs2's online filecheck.  It's pretty clear they had
> different goals and ended up with a much different interface.

If we would like to talk about generic VFS-based online check/recovery
subsystem then we need to find some common points. I think it's possible.
Do you mean that you don't see the way of generalization? What's the point
of this discussion in such case?

Thanks,
Vyacheslav Dubeyko.
=20
