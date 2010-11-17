Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHBXoOw247799 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 05:33:51 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECF171860DE
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:35:21 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id aN6vORKSGZDNKo6f for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:35:21 -0800 (PST)
Date: Wed, 17 Nov 2010 12:35:17 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: I/O Error Detected / 2.6.27.39
Message-ID: <20101117123517.6964c335@harpe.intellique.com>
In-Reply-To: <4CE3B1C0.3060308@open-e.com>
References: <4CE282DB.8060200@open-e.com>
	<20101116214415.61ecb7cd@galadriel.home>
	<4CE3B1C0.3060308@open-e.com>
Mime-Version: 1.0
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
To: Piotr Kandziora <piotr.kandziora@open-e.com>
Cc: Janusz@oss.sgi.com, Artur Piechocki <artur.piechocki@open-e.com>, lukasz.wittig@open-e.com, Bak <jb@open-e.com>, xfs@oss.sgi.com

Le Wed, 17 Nov 2010 11:43:12 +0100
Piotr Kandziora <piotr.kandziora@open-e.com> =E9crivait:

> - debian based distribution with a lot of modification,
> - architecture x86_64,

So this isn't a case of 32 bits rsync running out of memory (case
seen...)

> - xfs tools version 2.10.1
> - mount options for this LV: =

> rw,noatime,nodiratime,attr2,nobarrier,usrquota,prjquota,grpquota
> - NFS share is exported with following options: =

> rw,no_root_squash,insecure,insecure_locks,async,anonuid=3D65534,anongid=
=3D65534,subtree_check
> =

> >> Unfortunately our system is freezing unexpectedly without reason.
> >>      =

> > What are the symptoms ? does the whole system freeze up? Or does it
> > crash with kernel panic, or otherwise "Oops" messages?
> >    =

> =

> Symptoms are different. One time we've got a few oom-killers:

This is abnormal, but kernel disk cache shouldn't interfere anyway.

> [kern.warning] kernel: load_average invoked oom-killer:

> [kern.warning] kernel: 3dm2 invoked oom-killer: gfp_mask=3D0xd0,

> 2010/11/11 10:56:21|Pid: 4324, comm: nfsd Not tainted =


> Filesystem "dm-37": xfs_log_force: error 5 returned.

This looks like an IO error, as Eric Sandeen said. =


> We've checked temperature on each disk using LSI/3ware CLI (tw_cli)
> and average is 35C.

It's the card itself that's overheating and fails, not the disks. I had
to replace quite a number of these on field after a year of use or two;
they work well for a while, but crash when heavily sollicited.

However this should cause a complete IO freeze. Did you try to run
something like "tw_cli alarms" right after the failure?

If tw_cli can't communicate with the controller anymore, than that's a
case of a fried card.

> This problem occurred two times in the past, we repaired fs using =

> xfs_repair (and it showed errors). We simulated it using dumping
> cache yesterday ...

I don't understand how or why dumping cache would cause the system to
fail... except that it may augment actual disk IOs.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
