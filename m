Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B19D7F6D
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 21:22:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 736D98F8052
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 19:22:36 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id KJrtUMzqmtGKmOC6
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 19:22:35 -0700 (PDT)
Message-ID: <514528EB.9010905@hardwarefreak.com>
Date: Sat, 16 Mar 2013 21:22:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
In-Reply-To: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: xfs@oss.sgi.com

On 3/16/2013 10:56 AM, Subranshu Patel wrote:
> This question is related to xfs_repair (recovery) and journalling.
> =

> I powered off (improper shut down) the system when the IO was
> undergoing on mounted XFS filesystem.
> =

> Then I tried to recover the inconsistent filesystem using xfs_repair,
> after powering on the same machine.

The whole point of a journaling filesystem is to recover automatically
after an unclean shutdown and put the filesystem in a consistent state.

> The XFS filesystem didn=92t get recovered which was not expected. =


This is because you short circuited the automatic recovery process.  The
journal is replayed and the filesystem made consistent at the next mount
after unclean shutdown.  You prevented this next mount.

> The output displayed by xfs_repair is as follows:
> =

> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs =
to
> be replayed.  Mount the filesystem to replay the log, and unmount it befo=
re
> re-running xfs_repair.  If you are unable to mount the filesystem, then u=
se
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mou=
nt
> of the filesystem before doing this.

XFS is telling you to do what you should have done in the first place:
mount the filesystem so it can perform log recovery and make the XFS
consistent once again.

> The question that arises here is that why xfs_repair should be re-run
> after mounting and unmounting the XFS filesystem. According to my
> understanding, when we perform mount operation, recovery is
> automatically done if the filesystem is in inconsistent state. Then
> what is the need of re-running xfs_repair after mount is being
> performed? Does xfs_repair recovers something indifferent from the one
> recovered on mount? What exactly happens when we mount and unmount XFS
> filesystem?

No, the question that arises here is why you are intentionally short
circuiting the recovery process and immediately trying to run
xfs_repair.  When a system is configured properly, write barriers or
BBWC are working properly, etc, one should never need to run xfs_repair
after an unclean shutdown, as recovery is automatic.

In fact, in general use, one should rarely, if ever, need to run
xfs_repair.  I've been using XFS on production servers for a little over
3 years and I've never needed to run xfs_repair, and yes, I've had at
least two unclean shutdowns in that time.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
