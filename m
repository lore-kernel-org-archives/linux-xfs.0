Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE047CA0
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 19:39:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62F66304048
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 17:39:24 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kTysB9hPDTMxYAq9 for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2016 17:39:21 -0700 (PDT)
Date: Sat, 3 Sep 2016 10:39:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
	detected
Message-ID: <20160903003919.GI30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
	<1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Fri, Sep 02, 2016 at 01:02:16PM -0400, CAI Qian wrote:
> Spice seems start to deadlock using the reproducer,
> 
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/splice/splice01.c
> 
> This seems introduced recently after v4.8-rc3 or -rc4, so suspect this xfs update was one to blame,
> 
> 7d1ce606a37922879cbe40a6122047827105a332

Nope, this goes back to the splice rework back around ~3.16, IIRC.

> [ 1749.956818] 
> [ 1749.958492] ======================================================
> [ 1749.965386] [ INFO: possible circular locking dependency detected ]
> [ 1749.972381] 4.8.0-rc4+ #34 Not tainted
> [ 1749.976560] -------------------------------------------------------
> [ 1749.983554] splice01/35921 is trying to acquire lock:
> [ 1749.989188]  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffffa083c1f7>] xfs_file_buffered_aio_write+0x127/0x840 [xfs]
> [ 1750.001644] 
> [ 1750.001644] but task is already holding lock:
> [ 1750.008151]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8169e7c1>] pipe_lock+0x51/0x60
> [ 1750.016753] 
> [ 1750.016753] which lock already depends on the new lock.
> [ 1750.016753] 
> [ 1750.025880] 
> [ 1750.025880] the existing dependency chain (in reverse order) is:
> [ 1750.034229] 
> -> #2 (&pipe->mutex/1){+.+.+.}:
> [ 1750.039139]        [<ffffffff812af52a>] lock_acquire+0x1fa/0x440
> [ 1750.045857]        [<ffffffff8266448d>] mutex_lock_nested+0xdd/0x850
> [ 1750.052963]        [<ffffffff8169e7c1>] pipe_lock+0x51/0x60
> [ 1750.059190]        [<ffffffff8171ee25>] splice_to_pipe+0x75/0x9e0
> [ 1750.066001]        [<ffffffff81723991>] __generic_file_splice_read+0xa71/0xe90
> [ 1750.074071]        [<ffffffff81723e71>] generic_file_splice_read+0xc1/0x1f0
> [ 1750.081849]        [<ffffffffa0838628>] xfs_file_splice_read+0x368/0x7b0 [xfs]
> [ 1750.089940]        [<ffffffff8171fa7e>] do_splice_to+0xee/0x150
> [ 1750.096555]        [<ffffffff817262f4>] SyS_splice+0x1144/0x1c10
> [ 1750.103269]        [<ffffffff81007b66>] do_syscall_64+0x1a6/0x500
> [ 1750.110084]        [<ffffffff8266ea7f>] return_from_SYSCALL_64+0x0/0x7a

pipe_lock taken below the filesystem IO path, filesystem holds locks
to protect against racing hole punch, etc...

> [ 1750.188328] 
> -> #0 (&sb->s_type->i_mutex_key#14){+.+.+.}:
> [ 1750.194508]        [<ffffffff812adbc3>] __lock_acquire+0x3043/0x3dd0
> [ 1750.201609]        [<ffffffff812af52a>] lock_acquire+0x1fa/0x440
> [ 1750.208321]        [<ffffffff82668cda>] down_write+0x5a/0xe0
> [ 1750.214645]        [<ffffffffa083c1f7>] xfs_file_buffered_aio_write+0x127/0x840 [xfs]
> [ 1750.223421]        [<ffffffffa083cb7d>] xfs_file_write_iter+0x26d/0x6d0 [xfs]
> [ 1750.231423]        [<ffffffff816859be>] vfs_iter_write+0x29e/0x550
> [ 1750.238330]        [<ffffffff81722729>] iter_file_splice_write+0x529/0xb70
> [ 1750.246012]        [<ffffffff817258d4>] SyS_splice+0x724/0x1c10
> [ 1750.252627]        [<ffffffff81007b66>] do_syscall_64+0x1a6/0x500
> [ 1750.259438]        [<ffffffff8266ea7f>] return_from_SYSCALL_64+0x0/0x7a

pipe_lock taken above the filesystem IO path, filesystem tries to
take locks to protect against racing hole punch, etc, lockdep goes
boom.

Fundamentally a splice infrastructure problem. If we let splice race
with hole punch and other fallocate() based extent manipulations to
avoid this lockdep warning, we allow potential for read or write to
regions of the file that have been freed. We can live with having
lockdep complain about this potential deadlock as it is unlikely to
ever occur in practice. The other option is simply not an acceptible
solution....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
