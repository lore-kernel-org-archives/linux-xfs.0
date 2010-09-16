Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GAD70J247067 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 05:13:07 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FBC41E68049
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 03:13:54 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id Ge3FYYDZd6XCaqna for
	<xfs@oss.sgi.com>; Thu, 16 Sep 2010 03:13:54 -0700 (PDT)
Date: Thu, 16 Sep 2010 12:13:50 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
Message-ID: <20100916121350.3ab30ca5@harpe.intellique.com>
In-Reply-To: <201008191312.49346@zmi.at>
References: <201008191312.49346@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Le Thu, 19 Aug 2010 13:12:45 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> The subject is a bit harsh, but overall the article says:
> XFS is slowest on creating and deleting a billion files
> XFS fsck needs 30GB RAM to fsck that 100TB filesystem.
> =

> http://lwn.net/SubscriberLink/400629/3fb4bc34d6223b32/

So We've made a test with 1KB files (space, space...) and a production
kernel : 2.6.32.11 (yeah I know, 2.6.38 should be faster but you know,
we upgrade our production kernels prudently :). =


mk1BFiles will create and delete 1000000000 files with 32 threads
Version: v0.2.4-10-gf6decd3, build: Sep  7 2010 13:39:34

Creating 1000000000 files, started at 2010-09-07 13:45:16...
Done, time spent: 89:35:12.262

Doing `ls -R`, started at 2010-09-11 07:20:28...
Stat: ls (pid: 18844) status: ok, returned value: 0
Cpu usage: user: 1:27:47.242, system: 20:18:21.689
Max rss: 229.01 MBytes, page fault: major: 4, minor: 58694

Compute size used by 1000000000 files, started at 2010-09-12 09:30:52...
Size used by files: 11.1759 TBytes
Size used by directory: 32.897 GBytes
Size used (total): 11.2080 TBytes
Done, time spent: 25:50:32.355

Deleting 1000000000 files, started at 2010-09-13 11:21:24...
Done, time spent: 68:37:38.117

Test run on a dual Opteron quad core, 16 GB RAM, kernel 2.6.32.11
x86_64...

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
