Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 07:32:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8CEWi4p024402
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 07:32:47 -0700
Message-ID: <46E7F88B.4020805@sandeen.net>
Date: Wed, 12 Sep 2007 09:32:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E73BAD.4000906@sgi.com> <46E7424F.6030104@sandeen.net> <46E77E30.4000302@sgi.com>
In-Reply-To: <46E77E30.4000302@sgi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Just these ones... not a problem.
> 
> fs/xfs/xfs_mount.c: In function ‘xfs_icsb_cpu_notify’:
> fs/xfs/xfs_mount.c:1920: warning: unused variable ‘s’
> fs/xfs/xfs_mount.c: In function ‘xfs_icsb_sync_counters_flags’:
> fs/xfs/xfs_mount.c:2191: warning: unused variable ‘s’
> fs/xfs/xfs_mount.c: In function ‘xfs_icsb_balance_counter’:
> fs/xfs/xfs_mount.c:2249: warning: unused variable ‘s’
> fs/xfs/xfs_mount.c: In function ‘xfs_icsb_modify_counters’:
> fs/xfs/xfs_mount.c:2299: warning: unused variable ‘s’

Ah, I didn't build with CONFIG_HOTPLUG_CPU, whoops!

Ok, I'll let you tidy that up ;-) and add it to my default config I guess!

-Eric
