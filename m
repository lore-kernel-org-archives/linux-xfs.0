Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NGJvA5014453 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 11:19:58 -0500
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FC331CE1ACF
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 09:19:53 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	055BuGc6NYxmX6Ii for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 09:19:53 -0700 (PDT)
Message-ID: <49F09521.9000103@thebarn.com>
Date: Thu, 23 Apr 2009 11:19:45 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: fsck.xfs proposed improvements
References: <mailman.0.1240318659.128675.xfs@oss.sgi.com>	<20090421142333.GA5197@fysh.org>
	<49EE441E.6040606@thebarn.com>	<20090422094527.GA16600@fysh.org>	<87ws9cnz14.fsf@basil.nowhere.org>	<20090423084900.GB16600@fysh.org>
	<49F062E5.70800@sandeen.net>	<20090423141432.GC16600@fysh.org>
	<20090423143515.GA5878@fysh.org>
In-Reply-To: <20090423143515.GA5878@fysh.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Ashton <mike@fysh.org>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Mike Ashton wrote:
> On Thu, Apr 23, 2009 at 07:45:25AM -0500, Eric Sandeen wrote:
>
>> It certainly does sound like an interesting idea, but others'
>> concerns are relevant too.  The issues around how the root
>> filesystem gets mounted would need to be pretty clearly
>> addressed.  Maybe you can spell out your original proposal again,
>> with updates to handle that issue?
>>
>> (as an aside, there have been arguments in the past that readonly
>> mounts should not do recovery at all - i.e. "mount -o ro" doesn't
>> just mean that you can only read the filesystem, but that the
>> mount will only ever read the block device...)
>
> I propose firstly that that behaviour should be configurable by per
>  filesystem tuning, making it possible to set a root filesystem to
> default to norecovery on a read-only mount.  Then non-initrd
> mounting of / should always succeed, getting us access to fsck.xfs.
>
Traditional thinking with a journaled filesystem has been that if
there is a dirty log then
you do not want to risk mounting the filesystem in an inconsistent
state an thereby risking
a system crash or file system shutdown due to that inconsistent state.
By replaying the log
even on a read only mount the file system is brought back into a known
good state.

So there are risks of mounting without recovery but I'm leaning toward
it might be an acceptable risk in a single user state
that would allow access to the root file system.
>
> I secondly, and I'm going to broke here, propose that
> xfs_check/xfs_repair (as invocations, not the code!) should be
> deprecated and both programs should be called fsck.xfs. When called
>  with that name, they would have the following (familiar)
> semantics:
Well I wouldn't go that far xfs_check is already a wrapper around
xfs_db which is a very
different animal from xfs_repair.
>
> fsck.xfs: verify journal integrity. If it's good, return
> "filesystem is clean" and exit. If it's bad, invoke xfs_clean
> behaviour
>
> fsck.xfs -f:   invoke xfs_clean behaviour even with a good journal
>
> fsck.xfs -a: verify journal integrity If it's good, return
> "filesystem is clean" and exit. If it's bad, invoke xfs_repair -L
> behaviour
>
> (and so on)
Well again step back, most of the time at boot the mount of root
succeeds and the log has
been replayed and the fs is consistent. I don't think changing that to
a mount -norecovery all
the time is a good idea, that is risking every mount to a potentially
inconsistent state for the
rare case that the log is corrupted.

So even if we do a norecovery and then drop the system into single
user due to a corrupted log,
the only option at that point is xfs_repair -L, which is not a
recommended thing to do unless
some manual analysis  is done  and the inevitable data loss is understood.

It would be nice to eventually have an xfs_repair that could replay
the log from userspace
but that has not been implemented yet, that would allow for a clean
repair from userspace.
But again if the log is corrupted it may not be able to handle things
any better than the
kernel log recovery.

Also in the case of a mount -norecover with any subsequent repair
being done, it is probably
best to reboot at that point to ensure there is no bad FS data that
may be in cache.
>
> This makes fsck.xfs behave analogously to fsck.ext2 and friends,
> with it's clean and dirty flag.  The improvement xfs offers over
> ext2 in this area is that a filesystem is not only clean if shut
> down cleanly, but is also clean if shutdown unclearly but with a
> usable journal, but without behaving worse than ext2 by fsck.xfs
> thinking (incorrectly) that a filesystem repair will never be
> needed and giving a filesystem that won't mount a clean bill of
> health.
Given that xfs was suppose to be a fresh way of doing file systems
over the traditional UFS based
filesystems trying to make xfs behave like ext2/ext* is not really a
step forwards.

But I think there could be some improvement made to provide a less
painful way of
recovering a root fs that has a bad log.

>
> With both these proposals implemented, both initrd and non-initrd
> boot processes would correctly handle xfs filesystem checking,
> using the xfs journal to give the current excellent general case
> performance but provide a safe approach to corrupted journals,
> without the need for specific xfs-related care from distribution
> maintainers.
>
> Thanks, Mike.
>
> _______________________________________________ xfs mailing list
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJ8JUYNRmM+OaGhBgRAtllAJ9Ha2DGfoMalyjnfEggS0YhXL24BQCfZfuc
K5SglBMCSIIfzyjUsjFgTrE=
=fDCQ
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
