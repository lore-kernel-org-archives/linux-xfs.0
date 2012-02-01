Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11MKl61012838 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 16:20:48 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	ATY7eHAvDO2eUPNX for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 14:20:41 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647400D09C73 for xfs@oss.sgi.com; Wed, 1 Feb 2012 22:20:39 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RsiXU-0001GS-5j
	for <xfs@oss.sgi.com>; Wed, 01 Feb 2012 22:20:28 +0000
MIME-Version: 1.0
Message-ID: <20265.47788.31216.173521@tree.ty.sabi.co.UK>
Date: Wed, 1 Feb 2012 22:20:28 +0000
Subject: Re: File system remain unresponsive until the system is rebooted.
In-Reply-To: <20120201153100.41d1586d@harpe.intellique.com>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131120859.1f1d6a17@harpe.intellique.com>
	<20265.12473.715630.925704@tree.ty.sabi.co.UK>
	<20120201153100.41d1586d@harpe.intellique.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

>>> [ ... ] my impression is that EC2 is fine for whatever
>>> doesn't need any QoS. Prototyping, for instance. [ ... ]

>> [ ... ] *performance* (or the *reliability*) of a single
>> element is less important, at least compared to the ability
>> to throw a lot of cheap ones at a problem.

BTW, here I am not implying that EC2 allows one to =ABthrow a lot
of cheap ones at a problem=BB, because the published "retail" price
list is fairly expensive. But I guess that if one wants to buy =ABa
lot=BB of VMs as bulk purchase Amazon can do a deal.

>> In that case I eliminated all but the root filetree VM disks
>> and replaced them with filetrees exported via NFS from XFS on
>> the underlying VM host itself (that is not over the network).
>> [ ... ] because I could run check/repair and the backups *on
>> the real machine*, where XFS performed a lot better without
>> the VM overheads and "skewed" latencies.

> [ ... ] iSCSI to export lvm LVs to VMs from the host, and it
> works fine. Exporting files living on an XFS works well
> enough, too, though slightly slower.

iSCSI is a good alternative because it uses the better NIC
emulation in most VM layers, but I think that NFS is really a
better alternative overall, if suitable, because it gives the
inestimable option of running all the heavy hitting "maintenance"
stuff on the server itself, without any overheads, while
otherwise you must run it inside each VM.

Even if NFS has three problems that iSCSI does not have:

* It is a bit of a not awesome network filesystem, with a number
  of limitations, but NFSv4 seems Oki-ish.

* It has a reputation of not playing that well with NFS, but
  IIRC the stack issues happen only on 32b systems.

* While the server side is fairly good performance in Linux,
  the NFS client in Linux has some non trivial performance
  issues.

The problem is that there aren't much better network filesystems
around. Samba/SMB have a particularly rich and well done Linux
implementation, and are fully POSIX compatible, but performance
can be disappointing with the client in older kernels. A number
of sires have been discovering Gluster, and now that it is a Red
Hat product I guess we will here more of it especially in
relation to XFS.

BTW an attractive alternative to my usual favorite filesystems,
JFS and XFS, is the somewhat underestimated OCFS2, which is
well-maintained, and which can work pretty well in standalone
more, but also in share-disk mode, and that might be useful with
iSCSI to do backups etc. on another system than the client VM,
for example the server itself.

Also, an alternative to VMs is often using the pretty good
Linux-VServer.org "containers" (extended 'chroot's in effect),
which have zero overheads and where the only limitation is that
all "containers" must share the same running kernel, and can
share the same filesystem like exporting from NFS but without the
networking overhead. Xen (or UML) style paravirtualization is
next best (no need to emulate complicated "real" devices).

> It can be useful particularly for windows VM, because many
> windows app really behave poorly with network shares (or
> refuse to use them altogether).

That's a good point, and then one can also use the iSCSI daemon
on Linux to turn into a SAN server, but I guess you been there
and done that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
