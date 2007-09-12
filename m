Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 22:47:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8C5lm4p003691
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 22:47:51 -0700
Message-ID: <46E77E30.4000302@sgi.com>
Date: Wed, 12 Sep 2007 15:50:40 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E73BAD.4000906@sgi.com> <46E7424F.6030104@sandeen.net>
In-Reply-To: <46E7424F.6030104@sandeen.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Just these ones... not a problem.

fs/xfs/xfs_mount.c: In function ‘xfs_icsb_cpu_notify’:
fs/xfs/xfs_mount.c:1920: warning: unused variable ‘s’
fs/xfs/xfs_mount.c: In function ‘xfs_icsb_sync_counters_flags’:
fs/xfs/xfs_mount.c:2191: warning: unused variable ‘s’
fs/xfs/xfs_mount.c: In function ‘xfs_icsb_balance_counter’:
fs/xfs/xfs_mount.c:2249: warning: unused variable ‘s’
fs/xfs/xfs_mount.c: In function ‘xfs_icsb_modify_counters’:
fs/xfs/xfs_mount.c:2299: warning: unused variable ‘s’

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> They look good to me.  There's still a few unused variables left over
>> but nothing we can't fix up.
> 
> Great - and, weird - I don't see them in my tree... maybe I missed a
> quilt refresh, but I don't think so... odd.
> 
> -Eric
> 
> 
> 
