Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4O02mug032535 for <xfs@oss.sgi.com>; Mon, 23 May 2011 19:02:49 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C1C8476D7D
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 17:02:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xJtF6itgEQPQdKur for <xfs@oss.sgi.com>;
	Mon, 23 May 2011 17:02:46 -0700 (PDT)
Date: Tue, 24 May 2011 10:02:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS umount issue
Message-ID: <20110524000243.GB32466@dastard>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
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
To: Nuno Subtil <subtil@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, May 23, 2011 at 02:39:39PM -0700, Nuno Subtil wrote:
> I have an MD RAID-1 array with two SATA drives, formatted as XFS.

Hi Nuno. it is probably best to say this at the start, too:

> This is on an ARM system running kernel 2.6.39.

So we know what platform this is occurring on.

> Occasionally, doing an umount followed by a mount causes the mount to
> fail with errors that strongly suggest some sort of filesystem
> corruption (usually 'bad clientid' with a seemingly arbitrary ID, but
> occasionally invalid log errors as well).

So reading back the journal is getting bad data?
> 
> The one thing in common among all these failures is that they require
> xfs_repair -L to recover from. This has already caused a few
> lost+found entries (and data loss on recently written files). I
> originally noticed this bug because of mount failures at boot, but
> I've managed to repro it reliably with this script:

Yup, that's normal with recovery errors.

> while true; do
> 	mount /store
> 	(cd /store && tar xf test.tar)
> 	umount /store
> 	mount /store
> 	rm -rf /store/test-data
> 	umount /store
> done

Ok, so there's nothing here that actually says it's an unmount
error. More likely it is a vmap problem in log recovery resulting in
aliasing or some other stale data appearing in the buffer pages.

Can you add a 'xfs_logprint -t <device>' after the umount? You
should always see something like this telling you the log is clean:

$ xfs_logprint -t /dev/vdb
xfs_logprint:
    data device: 0xfd10
    log device: 0xfd10 daddr: 11534368 length: 20480

    log tail: 51 head: 51 state: <CLEAN>

If the log is not clean on an unmount, then you may have an unmount
problem. If it is clean when the recovery error occurs, then it's
almost certainly a problem with you platform not implementing vmap
cache flushing correctly, not an XFS problem.

> I'm not entirely sure that this is XFS-specific, but the same script
> does run successfully overnight on the same MD array with ext3 on it.

ext3 doesn't use vmapped buffers at all, so won't show such a
proble,.

> Has something like this been seen before?

Every so often on ARM, MIPS, etc platforms that have virtually
indexed caches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
