Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18211 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdARAh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2017 19:37:57 -0500
From: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Subject: RE: [LSF/MM TOPIC] online filesystem repair
Date: Wed, 18 Jan 2017 00:37:02 +0000
Message-ID: <SN2PR04MB2191A5D379B5C1A1BA0AB9A0887F0@SN2PR04MB2191.namprd04.prod.outlook.com>
References: <20170114075452.GJ14033@birch.djwong.org>
 <1484524890.27533.16.camel@dubeyko.com>
 <20170117062453.GJ14038@birch.djwong.org>
In-Reply-To: <20170117062453.GJ14038@birch.djwong.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Viacheslav Dubeyko <slava@dubeyko.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>


-----Original Message-----
From: Darrick J. Wong [mailto:darrick.wong@oracle.com]=20
Sent: Monday, January 16, 2017 10:25 PM
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: lsf-pc@lists.linux-foundation.org; linux-fsdevel@vger.kernel.org; linux=
-xfs@vger.kernel.org; Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Subject: Re: [LSF/MM TOPIC] online filesystem repair
=20
> > How do you imagine a generic way to support repairs for different file=
=20
> > systems? From one point of view, to have generic way of the online=20
> > file system repairing could be the really great subsystem.
>
> I don't, sadly.  There's not even a way to /check/ all fs metadata
> in a "generic" manner -- we can use the standard VFS interfaces to read
> all metadata, but this is fraught.  Even if we assume the fs can spot che=
ck obviously
> garbage values, that's still not the appropriate place for a full scan.

Let's try to imagine a possible way of generalization. I can see such criti=
cal points:
(1) mount operation;
(2) unmount/fsync operation;
(3) readpage;
(4) writepage;
(5) read metadata block/node;
(6) write/flush metadata block/node.
(7) metadata's item modification/access.

Let's imagine that file system will register every metadata structure in ge=
neric
online file checking subsystem. Then the file system will need to register =
some
set of checking methods or checking events for every registered metadata
structure. For example:
(1) check_access_metadata();
(2) check_metadata_modification();
(3) check_metadata_node();
(4) check_metadata_node_flush();
(5) check_metadata_nodes_relation().

I think that it is possible to consider several possible level of generic o=
nline
file system checking subsystem's activity: (1) light check mode;
(2) regular check mode; (3) strict check mode.

The "light check mode" can  be resulted in "fast" metadata nodes' check on =
write operation with
generation of error messages in the syslog with the request to check/recove=
r
file system volume by means of fsck tool.

The "regular check mode" can be resulted in: (1) the checking of any metada=
ta modification
with trying to correct the operation in the modification place; (2) metadat=
a nodes' check
on write operation with generation of error messages in the syslog.=20

The "strict check mode" can be resulted in: (1) check mount operation with =
trying to recover
the affected metadata structures; (2) the checking of any metadata modifica=
tion
with trying to correct the operation in the modification place; (3) check a=
nd recover
metadata nodes on flush operation; (4) check/recover during unmount operati=
on.

What do you like to expose to VFS level as generalized methods for your imp=
lementation?

> > But, from another point of view, every file system has own=20
> > architecture, own set of metadata and own way to do fsck=20
> > check/recovering.
>
> Yes, and this wouldn't change.  The particular mechanism of fixing a piec=
e of
> metadata will always be fs-dependent, but the thing that I'm interested i=
n
> discussing is how do we avoid having these kinds of things interact badly=
 with the VFS?

Let's start from the simplest case. You have the current implementation.
How do you see the way to delegate to VFS some activity in your implementat=
ion
in the form of generalized methods? Let's imagine that VFS will have some c=
allbacks
from file system side. What could it be?

> > As far as I can judge, there are significant amount of research=20
> > efforts in this direction (Recon [1], [2], for example).
>
> Yes, I remember Recon.  I appreciated the insight that while it's impossi=
ble
> to block everything for a full scan, it /is/ possible to check a single o=
bject and
> its relation to other metadata items.  The xfs scrubber also takes an inc=
remental
> approach to verifying a filesystem; we'll lock each metadata object and v=
erify that
> its relationships with the other metadata make sense.  So long as we aren=
't bombarding
> the fs with heavy metadata update workloads, of course.
>
> On the repair side of things xfs added reverse-mapping records, which the=
 repair code
> uses to regenerate damaged primary metadata.  After we land inode parent =
pointers
> we'll be able to do the same reconstructions that we can now do for block=
 allocations...
>
> ...but there are some sticky problems with repairing the reverse mappings=
.
> The normal locking order for that part of xfs is sb_writers
> -> inode -> ag header -> rmap btree blocks, but to repair we have to
> freeze the filesystem against writes so that we can scan all the inodes.

Yes, the necessary freezing of file system is really tricky point. From one=
 point of view,
it is possible to use "light checking mode" that will simply check and comp=
lain
about possible troubles at proper time (maybe with remount in RO mode).
Otherwise, from another point of view, we need in special file system archi=
tecture
or/and special way of VFS functioning. Let's imagine that file system volum=
e will
be split on some groups/aggregations/objects with dedicated metadata. Then,=
 theoretically,
VFS is able to freeze such group/aggregation/object for check and recoverin=
g
without affection the availability of the whole file system volume. It mean=
s that
file system operations should be redirected into active (not frozen) groups=
/aggregations/objects.
=20
Thanks,
Vyacheslav Dubeyko.

